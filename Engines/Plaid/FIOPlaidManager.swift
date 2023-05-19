//
//  CIOPlaidManager.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/4/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import LinkKit

class FIOPlaidManager: NSObject {
	
    // MARK: - Properties
	
	private var _PLAID_ENV: PLKEnvironment = .production // THIS IS THE SETTING USED BY LINK CREATION
	private var presentingVC: UIViewController?
	private var setupCompleted: Bool = false
	private let WEB_HOOK_URL_DEV = "https://api-dev.chedda.io/fac/hook"
	private let PLAID_PUBLIC_KEY = "e44a4977074657eac38acd267e54d4"
	private let PLAID_PRODUCTS: PLKProduct = [.transactions]
	private var completion: QIOBoolCompletion?
	var isUpdateMode: Bool = false
	var linkFlowNC: UINavigationController?
	
	// MARK: - API
	
	public func enterItemLinkFlow(
		vc: UIViewController,
		completion: @escaping QIOBoolCompletion
	) {
		initializePlaidLink() { result in
			if (result) {
				self.isUpdateMode = false
				self.presentingVC = vc
				self.completion = completion
				let linkConfiguration = PLKConfiguration(key: self.PLAID_PUBLIC_KEY, env: self.PLAID_ENV, product: self.PLAID_PRODUCTS)
				linkConfiguration.clientName = appName
				linkConfiguration.webhook = URL(string: self.WEB_HOOK_URL_DEV)!
				let linkViewController = PLKPlaidLinkViewController(configuration: linkConfiguration, delegate: self)
				if (UI_USER_INTERFACE_IDIOM() == .pad) {
					linkViewController.modalPresentationStyle = .formSheet;
				}
				vc.present(linkViewController, animated: true)
			} else {
				AppDelegate.sharedInstance.presentAlertWithTitle("Connect Issue", message: "Problem setting up the data provider.")
				completion(false)
			}
		}
	}
	
	public func enterItemUpdateFlow(
		_ item: QItem,
		vc: UIViewController,
		completion: @escaping QIOBoolCompletion
	) {
		print(#function)
		let alertController = UIAlertController(
			title: "🏦\nRefresh Bank Link",
			message: "\nFor the security of your account(s) " + item.institutionName + " has requested that you refresh the link with \(appName).",
			preferredStyle: .alert
		)
		alertController.addAction(UIAlertAction(
			title: "Let's Do It",
			style: .default
		) { alertAction in
			self.isUpdateMode = true
			FIOAppSync.sharedInstance.getPublicTokenForItem(item.itemId) { (result, error) in
				if let publicToken = result {
					self.initializePlaidLink() { result in
						if result {
							self.presentingVC = vc
							self.completion = completion
							self._PLAID_ENV = self.envForToken(publicToken)
							let linkViewController = PLKPlaidLinkViewController(
								publicToken: publicToken,
								configuration: self.linkConfiguration,
								delegate: self
							)
							vc.present(linkViewController, animated: true)
						} else {
							self.isUpdateMode = false
							self.completion?(false)
						}
					}
				} else {
					self.isUpdateMode = false
					completion(false)
				}
			}
		})
		alertController.addAction(UIAlertAction(
			title: "Logout",
			style: .destructive
		) { action in
			QUser.signout()
		})
		vc.present(alertController, animated: true)
	}
	
	private func envForToken(_ token: String) -> PLKEnvironment {
		let t = token.lowercased()
		if t.contains("development") { return .development }
		else if t.contains("production") { return .production }
		else if t.contains("sandbox") { return .sandbox }
		else { return .production }
	}
	
	// MARK: - Custom
	
	private func initializePlaidLink(completion: @escaping QIOBoolCompletion = { _ in }) {
		print(self.className + " " + #function)
		if setupCompleted { completion(true) }
		PLKPlaidLink.setup(with: linkConfiguration) { (success, error) in
			if success {
				print("Plaid Link setup was successful")
				self.setupCompleted = true
				completion(true)
			}
			else if let error = error {
				print("Unable to setup Plaid Link due to: \(error.localizedDescription)")
				completion(false)
			}
			else {
				print("Unable to setup Plaid Link")
				completion(false)
			}
		}
	}

	private func storeRemotePlaidTokenForUser(
		newPlaidToken: String,
		metadata: [String : AnyObject],
		force: Bool = false,
		isUpdate: Bool = false,
		completion: @escaping QIOBoolErrorCompletion = { _,_  in }
	) {
		var inputMetadata = FIOPlaidItemInputMetadata(
			status: metadata["status"] as? String,
			requestId: metadata["request_id"] as? String
		)
		if let i = metadata["institution"] {
			inputMetadata.institution = FIOPlaidItemInputMetadataInstitution(
				name: i["name"] as? String,
				institutionId: i["institution_id"] as? String
			)
		}
		if let lsi = metadata["link_session_id"] as? String {
			FIOAppSync.sharedInstance.putPlaidItem(
				item: FIOPlaidItemInput(
					metadata: inputMetadata,
					linkSessionId: lsi,
					token: newPlaidToken),
				force: force,
				isUpdate: isUpdate
			) { res in
				switch res {
				case .failure(let err):
					completion(false, err)
				case .success(let succeeded):
					if succeeded {
						QMix.track(.eventItemLinked)
						completion(true, nil)
					} else {
						completion(false, nil)
					}
				}
			}
		}
    }
	
	// MARK: - Computed Properties
	
	public var currentEnvironmentString: String {
		switch PLAID_ENV {
		case .development: return "development"
		case .sandbox: return "sandbox"
		case .production: return "production"
		default: return ""
		}
	}

	public var PLAID_ENV: PLKEnvironment {
		get {
			return _PLAID_ENV
		}
		set(v) {
			_PLAID_ENV = v
			initializePlaidLink()
		}
	}
	
	private var linkConfiguration: PLKConfiguration {
		let out = PLKConfiguration(
			key: PLAID_PUBLIC_KEY,
			env: PLAID_ENV,
			product: PLAID_PRODUCTS
		)
		out.clientName = appName
		print("Plaid configuration:\n\(out)")
		return out
	}

}

// MARK: - PLKPlaidLinkViewDelegate

extension FIOPlaidManager: PLKPlaidLinkViewDelegate {
	
	internal func linkViewController(
		_ linkViewController: PLKPlaidLinkViewController,
		didSucceedWithPublicToken publicToken: String,
		metadata: [String : Any]?
	) {
		print(self.className + " " + #function)
		print("Plaid Link Success.\npublicToken: \(publicToken)\nmetadata: \(metadata ?? [:])")
		print("isUpdateMode = \(self.isUpdateMode)")
		if let pvc = presentingVC {
			pvc.dismiss(animated: true)
			guard let plaidMetadata = metadata else { return }
			let plaidMetadataConverted: [String: AnyObject] = plaidMetadata as [String: AnyObject]
			let md = FIOPlaidLinkMetadata(plaidMetadataConverted)
			NotifCenter.post(name: .FIOPlaidLinkSucceeded, object: md) // Show the linking view
			storeRemotePlaidTokenForUser(
				newPlaidToken: publicToken,
				metadata: plaidMetadataConverted,
				isUpdate: self.isUpdateMode
			) { (success, error) in

				if let e = error {
					self.isUpdateMode = false
					print("ERROR in didSucceedWithPublicToken() \(e.localizedDescription)")
					self.completion?(false)
				}
				else if !success {
					var name = "Bank"
					if let n = md.institution_name { name = n  }
					
					let alert = UIAlertController(
						title: name,
						message: "\(name) is already linked with your \(appName) account.\n\nDo you want to add another link to \(name)?",
						preferredStyle: .alert)
					alert.addAction(UIAlertAction(
						title: "Yes",
						style: .default
					) { action in
						self.storeRemotePlaidTokenForUser(
							newPlaidToken: publicToken,
							metadata: plaidMetadataConverted,
							force: true
						) { (success, error) in
							if let error = error {
								self.isUpdateMode = false
								print("FINAL ERROR: " + error.localizedDescription)
							}
							self.completion?(success)
						}
					})
					let oopsAction = UIAlertAction(title: "No", style: .cancel) {
						(alert: UIAlertAction!) in
						self.isUpdateMode = false
						self.linkFlowNC?.viewControllers.forEach { $0.dismiss(animated: false, completion: nil) }
						self.linkFlowNC?.dismiss(animated: true, completion: {
						})
					}
					alert.addAction(oopsAction)
					self.linkFlowNC?.present(alert, animated: true, completion: nil)
				}
				else {
					self.completion?(true)
				}
			}
		}
	}
	
	internal func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
		self.presentingVC?.dismiss(animated: true)
		if let error = error {
			print("Plaid Link Failure. Error: \(error.localizedDescription)\nMetadata: \(metadata ?? [:])")
			var passObj = [String: Any]()
			passObj["error"] = error
			passObj["metadata"] = metadata
			NotifCenter.post(name: .FIOPlaidLinkError, object: passObj)
		}
		else {
			print("Plaid Link Exit with Metadata: \(metadata ?? [:])")
			NotifCenter.post(name: .FIOPlaidLinkExit, object: metadata)
			AppDelegate.sharedInstance.checkQuantizingStatus()
		}
		self.completion?(false)
	}
	
	internal func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didHandleEvent event: String, metadata: [String : Any]?) {
		print("Plaid Link Event: \(event)\nmetadata: \(metadata ?? [:])")
	}

}

// MARK: - Singleton

extension FIOPlaidManager {
	
	struct Static {
		static var instance: FIOPlaidManager?
	}
	
	class var sharedInstance: FIOPlaidManager {
		if Static.instance == nil
		{
			Static.instance = FIOPlaidManager()
		}
		
		return Static.instance!
	}
	
	func dispose() {
		FIOPlaidManager.Static.instance = nil
		print("Disposed Singleton instance FIOPlaidManager")
	}
	
}

// MARK: - Structures

struct FIOPlaidLinkMetadata {
	
	var status: String? = ""
	var request_id: String? = ""
	var institution_name: String? = ""
	var institution_id: String? = ""
	var link_session_id: String? = ""
	var account_id: String? = ""
	
	var account: [String : AnyObject?]? = nil
	var account_name: String? = ""
	var account_mask: String? = ""
	var account_id_id: String? = ""
	var account_type: String? = ""
	var account_subtype: String? = ""
	
	var accounts: [[String : AnyObject?]]? = nil
	
	public init() {}
	
	public init(_ metadata: [String : AnyObject]) {
		
		print(metadata)
		
		status = metadata["status"] as? String
		request_id = metadata["request_id"] as? String
		institution_name = metadata["institution"]!["name"] as? String
		institution_id = metadata["institution"]!["institution_id"] as? String
		account_id = metadata["account_id"] as? String
		link_session_id = metadata["link_session_id"] as? String
		
		let account = metadata["account"] as? [String : AnyObject?]
		if (account != nil) {
			account_name = account!["name"] as? String
			account_id_id = account!["id"] as? String
			account_mask = account!["mask"] as? String
			account_type = account!["type"] as? String
			account_subtype = account!["subtype"] as? String
		}
		
		accounts = metadata["accounts"] as? [[String : AnyObject?]]
	}
	
}

// onExit
//{
//	"link_session_id": String,
//	"request_id": String,
//	"institution": {
//		"name": String,
//		"institution_id": String
//	},
//	"status": String
//}



// onSuccess
//{
//	"link_session_id": String,
//	"institution": {
//		"name": String,
//		"institution_id": String
//	},
//	"accounts": [
//	{
//	"id": String,
//	"name": String,
//	"mask": String,
//	"type": String,
//	"subtype": String
//	},
//	...
//	]
//}


