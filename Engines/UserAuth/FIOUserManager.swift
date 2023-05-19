//
//  CIOUserManager.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/4/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import AWSCognitoIdentityProvider
import AWSMobileClient
import AWSAppSync

class FIOUserManager: NSObject  {
	
	override init() {
		super.init()
		userStateListener()
	}
	
    // MARK: - Properties
	var userAttributes: [AWSCognitoIdentityProviderAttributeType]?
	private var completion: QIOErrorCompletion? // Wait for onLogin callback from AWSSignInDelegate below.
	private var customAuthManager: QIOUserManagerCustomAuth?
	
    // MARK: - User Hydrations
	
	/**
	Either initializes an already-authenticated user or puts user through authentication flow.
	- Parameters:
		- completion: optional Error
	- Returns: nil upon successful hydration of a user, Error upon total irretrevable failure.
	*/
    public func hydrateUser(completion: @escaping QIOErrorCompletion) {
        print("\n\n\(#function)\n\n")
		print("AWSMobileClient.sharedInstance().interceptApplication")

		// ! CRITICAL SETUP THE CUSTOM AUTH MANAGER !
		guard let nc = AppDelegate.sharedInstance.navigationController else {
			let e = FIOError.init("navigationController is required.")
			completion(e)
			return
		}
		self.completion = completion
		customAuthManager = QIOUserManagerCustomAuth(nc)
		if let cam = customAuthManager {
			AWSMobileClient.sharedInstance().setCustomAuthManager(cam)
		} else {
			print("🆘 FAILED TO INIT THE CUSTOM AUTH MANAGER")
			let e = FIOError.init("FAILED TO INIT THE CUSTOM AUTH MANAGER.")
			completion(e)
		}
		// END CRITICAL

		AWSMobileClient.sharedInstance().initialize {
			(userState, error) in
			
			if let e = error as NSError? {
				let err: Error? = e as Error
				Rollbar.error(String(describing: e), exception: err as? NSException, data: nil, context: "hydrateUser()")
				
				print("\n###\n###  INTERCEPT APPLICATION ERROR \n###")
				print("###  Domain:\t\t\t" + e.domain)
				print("###  Code:\t\t\t\t" + e.code.asString)
				
				if let localizedDescription = e.userInfo["NSLocalizedDescription"] as? String {
					print("###  Localized Description:\t\t" + localizedDescription)
					switch localizedDescription {
					case "The Internet connection appears to be offline.":
						if e.code == -1009 { print("IT SEEMS THAT -1009 IS THE CODE FOR OFFLINE") }
						completion(e)
						return // bounce hard, let the application delegate handle this
					case "Authentication delegate not set":
						if e.code == -1000 { print("IT SEEMS THAT THE USER HAS GOTTEN FOULED UP") }
						// Fall through
					default: break
					}
				}
				if let errorMessage = e.userInfo["message"] as? String {
					print("###  Error Message:\t\t" + errorMessage)
				}
				if let errorType = e.userInfo["__type"] as? String {
					print("###  Error Type:\t\t" + errorType)
//					switch errorType {
//					case "UserNotFoundException":
//						break
//					case "NotAuthorizedException":
//						break
//					case "ResourceNotFoundException":
//						break
//					default:
//						break
//					}
				}
				self.signout() // Clean up and start fresh, pass the completion deeper
				completion(nil) // started fresh.
			} else {
				print("No error in AWSMobileClient.sharedInstance().interceptApplication()")
				
				if let us = userState {
					print("UserState: \(us.rawValue)")
					
					switch (us) {
					case .signedIn:
						print("user is signed in.")
						self.finalizeUserAuth() { error in

							if let e = error {
								print("Error from finalizeUserAuth: \(String(describing: error?.localizedDescription)).")
								AppDelegate.sharedInstance.presentAlertWithTitle("⚠️", message: e.localizedDescription, singleActionString: "Ok") {
									action in
									self.signout()
									completion(nil)
								}
							} else {
								print("ALL'S WELL IN HYDRATE USER. READY TO ROCK.")
								completion(nil) // We're done!
							}
						}
					case .guest:
						print("user is in guest mode.")
						self.presentAuthUIAndWaitForSignIn(completion)
					case .signedOut:
						print("user signed out")
						self.presentAuthUIAndWaitForSignIn(completion)
					case .signedOutUserPoolsTokenInvalid:
						print("need to login again.")
						self.presentAuthUIAndWaitForSignIn(completion)
					case .signedOutFederatedTokensInvalid:
						print("user logged in via federation, but currently needs new tokens")
						self.presentAuthUIAndWaitForSignIn(completion)
					default:
						print("userState = default")
						self.presentAuthUIAndWaitForSignIn(completion)
					}
				}
			}
		}
    }
	
    // MARK: - User Lifecycle

	private func presentAuthUIAndWaitForSignIn(_ completion: @escaping QIOErrorCompletion) {
		print("\n\n\(#function)\n\n")

		FIOControlFullscreenActivity.shared.hide()

		guard let nc = AppDelegate.sharedInstance.navigationController else {
			let e = FIOError.init("navigationController is required.")
			completion(e)
			return
		}
		let authLandingVC: QIOAuthLandingViewController = UIStoryboard(name: "FIOAuth", bundle: nil).instantiateViewController(withIdentifier: "AuthLanding") as! QIOAuthLandingViewController
		authLandingVC.completion = completion
		nc.delegate = authLandingVC
		nc.viewControllers = [authLandingVC]
	}
	
	public func signin(phoneNumber: String, _ completion: @escaping QIOErrorCompletion) {
		print(self.className + " " + #function)
//		guard let nc = AppDelegate.sharedInstance.navigationController	else { return }
	
		customAuthManager?.phone_number = phoneNumber
		AWSMobileClient.sharedInstance().signIn(username: phoneNumber, password: "") {
			(signInResult, error) in
	
			DispatchQueue.main.async {
				if let e = error  {
					self.handleSigninErrorCases(e, phoneNumber: phoneNumber, completion)
				} else if let signInResult = signInResult {
					switch (signInResult.signInState) {
					case .signedIn:
						print("User is signed in now prompt for code verification.")
						completion(nil)
					default:
						print("🆘 FAILED SIGNIN RESULT: \(signInResult.signInState)")
						completion(nil)
					}
				}
			}
		}
	}

	private func finalizeUserAuth(completion: @escaping QIOErrorCompletion) {
		print(self.className + " " + #function)
		cognitoGetDetails() { error in
			if let e = error {
				print(e)
				completion(e)
			} else {
				DispatchQueue.main.async() {
					if let nc = AppDelegate.sharedInstance.navigationController {
						nc.setNavigationBarHidden(true, animated: true)
						completion(nil)
					}
				}
			}
		}
	}

	private func handleSigninErrorCases(_ error: Error, phoneNumber: String, _ completion: @escaping QIOErrorCompletion) {
		print("\n\n\(#function)")
		print("*** SIGN-IN ERROR *** : \(String(describing: error))");
		
		let _nserr: NSError = (error as NSError)
		let _type = _nserr.userInfo["__type"]
		let _msg = _nserr.userInfo["message"]
		
		if let t = _type, let m = _msg {
			if let errorType: String = t as? String, let message: String = m as? String {
				print(errorType + " :: " + message + "\n\n")
				switch errorType {
				case "UserNotConfirmedException":
					DispatchQueue.main.async(execute: {
						AppDelegate.sharedInstance.presentAlertWithTitle("1️⃣2️⃣3️⃣", message: "\nLooks like you've not verified your number yet.\nWe'll send a new code to " + phoneNumber + ".") {
							action in
							
							//							self.verifyPhoneNumberForUser(phoneNumber: phoneNumber, password: password, completion: completion)
						}
					})
					break
				case "UserNotFoundException": // Username not found - this won't happen because signup is only ever called with a phone number that has already been checked against udb
					AppDelegate.sharedInstance.presentAlertWithTitle("🤔", message: "\nIt seems that the mobile number \nand/or the password aren't right.")
					completion(nil)
					break
				case "NotAuthorizedException": // Probably bad password
					if message == "User is disabled" {
						AppDelegate.sharedInstance.presentAlertWithTitle("🛑", message: "\nYour account has been disabled.\nContact Flow: help@quantamoney.app")
					} else {
						AppDelegate.sharedInstance.presentAlertWithTitle("🤔", message: "\nIt seems that the mobile number \nand/or the password aren't right.")
					}
					completion(nil)
					break
				case "PasswordResetRequiredException": // User needs to reset their password (probably as a result of admin pressing "reset" button in Cognito console
					// TODO: handle this case better
					AppDelegate.sharedInstance.presentAlertWithTitle("Reset Password", message: "Need to set a new password.")
					completion(nil)
					break
				default:
					print("🆘 Unhandled sign-in error case")
					completion(nil)
					break
				}
			}
		}
	}
	
	public func signup(phoneNumber: String, _ completion: @escaping QIOErrorCompletion) {
		customAuthManager?.phone_number = phoneNumber
		AWSMobileClient.sharedInstance().signUp(username: phoneNumber, password: String.random(30)) {
			(signUpResult, error) in
			
			if let signUpResult = signUpResult {
				switch(signUpResult.signUpConfirmationState) {
				case .confirmed:
					print("User is signed up and confirmed. Now attempt signin and prompt for verification.")
					completion(nil)
				default:
					let msg = "Unexpected signup result case: \(signUpResult.signUpConfirmationState)"
					print(msg)
					AppDelegate.sharedInstance.presentAlertWithTitle("🆘 Signup Fail 🆘", message: msg)
				}
			} else if let e = error {
				print(e)
				if let ae = e as? AWSMobileClientError {
					self.handleSignupAWSErrorCases(ae, completion)
				} else {
					self.handleSignupErrorCases(e, completion)
				}
			}
		}
	}
	
	private func handleSignupAWSErrorCases(_ error: AWSMobileClientError, _ completion: @escaping QIOErrorCompletion) {
		print("\(error.localizedDescription)")
		Rollbar.error(#function + " " + error.localizedDescription)
		DispatchQueue.main.async {
			switch(error) {
			case .usernameExists(let message):
				Rollbar.warning("handleSignupAWSErrorCases() got usernameExists error and signed user in. Message: " + message)
				// note that this is already set: customAuthManager?.phone_number so a number doesn't need to be passed here.
				self.signin(phoneNumber: "", completion)
//				let msg = message.replacingOccurrences(of: "_", with: " ") + ".\n\nSign-in with this number?"
//				let alert = UIAlertController(title: "Account Exists", message: msg, preferredStyle: .alert)
//				let yesAction = UIAlertAction(title: "Yes", style: .default) { action in
//					self.signin(phoneNumber: "", completion)
//				}
//				alert.addAction(yesAction)
//				let noAction = UIAlertAction(title: "No", style: .cancel) { action in }
//				alert.addAction(noAction)
//				if let nc = AppDelegate.sharedInstance.navigationController {
//					nc.present(alert, animated: true, completion: nil)
//				}
			default:
				AppDelegate.sharedInstance.presentAlertWithTitle("🆘 Signup Error 🆘", message: error.localizedDescription)
			}
		}
	}
	
	private func handleSignupErrorCases(_ error: Error, _ completion: @escaping QIOErrorCompletion) {
		print("\(error.localizedDescription)")
		Rollbar.error(#function, exception: error as? NSException)
		DispatchQueue.main.async {
			AppDelegate.sharedInstance.presentAlertWithTitle("🆘 Signup Error 🆘", message: error.localizedDescription)
		}
	}

	public func signout() {
		print("\n\n\(#function)\n\n")
		AWSMobileClient.sharedInstance().signOut()
		QMix.track(.actionSignOut)
	}

	public func deleteUser() {
		print("\n\n\(#function)\n\n")
		QMix.track(.actionDeleteAccount)
		if let nc = AppDelegate.sharedInstance.navigationController {
			FIOControlFullscreenActivity.shared.presentOver(nc.view)
		}
		FIOAppSync.sharedInstance.deleteUser(self.userAttribute_sub!) {
			(result: Bool, error: Error?) in
			
			print("deleteRemoteUser: \(result)")
			self.signout()
		}
	}
	
	public func signOutActionSheet() {
		guard let nc = AppDelegate.sharedInstance.navigationController else { return }
		guard let vc = nc.visibleViewController else { return }
		
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let defaultAction = UIAlertAction(title: "Sign Out 👋", style: .destructive) { action in
			QUser.signout()
		}
		alertController.addAction(defaultAction)
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(cancel)
		
		vc.present(alertController, animated: true, completion: nil)
	}
	
    // MARK: - Cognito Stuff

    private func cognitoGetDetails(completion: @escaping QIOErrorCompletion ) {
        print(self.className + " " + #function)
		guard let cu = user else {
			completion(nil)
			return
		}
		cu.getDetails().continueOnSuccessWith(block: { task -> Void in
			if let error = task.error as NSError? {
				print("*** ERROR getting user attributes from Cognito: \(error)")
				completion(error)
			} else {
				if let r = task.result, let ua = r.userAttributes {
					self.userAttributes = ua
					print("\n\n### USER ATTRIBUTES ###\n")
					for attribute in ua {
						print(attribute.name! + ": " + attribute.value!)
					}
					print("\n### END USER ATTRIBUTES ###\n\n")
					if let sub = self.userAttribute_sub {
//						print("###\t\tSub: " + sub)
						FIOAppSync.sharedInstance.putSub(sub: sub) { success in
							print("finished putSub with success: \(success)")
							if success {
								completion(nil)
							} else {
								completion(FIOError.init("pubSub put failed."))
							}
						}
					}
				}
			}
		})
    }

	// MARK: - Computed Properties
	
	lazy var user: AWSCognitoIdentityUser? = {
		return pool?.currentUser()
	}()

	lazy var pool: AWSCognitoIdentityUserPool? = {
		return AWSCognitoIdentityUserPool.default()
	}()

	public var userIsInSandbox: Bool {
		get {
			if let phone = QUser.userAttribute_phone_number {
				 return phone.hasPrefix("+17263269") // +1-726-326-9XXX == Sandbox accounts
			}
			else {
				return false
			}
		}
	}
	
}

extension FIOUserManager {
	
	func userStateListener() {
		
		AWSMobileClient.sharedInstance().addUserStateListener(self) {
			(userState, info) in

			print("UPDATED USER STATE TO \(userState)")
			print(info)
			
			switch (userState) {
				
			case .guest:
				print("user is in guest mode.")
			case .signedOut:
				print("user signed out")
				FIOAppSync.sharedInstance.dispose()
				QFlow.dispose()
				AWSMobileClient.sharedInstance().clearCredentials()
				AWSMobileClient.sharedInstance().clearKeychain()
				self.clearUserPrefs()
				if let nc = AppDelegate.sharedInstance.navigationController {
					nc.navigationBar.prefersLargeTitles = true
					nc.isNavigationBarHidden = true // start with it hidden
					nc.viewControllers = [FIOAppLoadingViewController()]
				}
				self.dispose()
				AppDelegate.sharedInstance.freshStart()
				
			case .signedIn:
				print("user is signed in.")
				QBio.offerSetup() {
					self.finalizeUserAuth() { error in
						self.completion?(error)
					}
				}
				
			case .signedOutUserPoolsTokenInvalid:
				print("need to login again.")
			case .signedOutFederatedTokensInvalid:
				print("user logged in via federation, but currently needs new tokens")
			default:
				print("unsupported")
			}
		}
	}
	
}

// MARK: - User Defaults

extension FIOUserManager {
	
	public func clearUserPrefs() {
		Defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
		Defaults.synchronize()
	}
	
	public func userPrefSetString(_ str: String, _ forKey: String) {
		Defaults.set(str, forKey: forKey)
	}
	
	public func userPrefReadString(_ key: String) -> String {
		let out = Defaults.string(forKey: key)
		return out ?? ""
	}

	public func userPrefSetBool(_ val: Bool, _ forKey: String) {
		Defaults.set(val, forKey: forKey)
	}
	
	public func userPrefReadBool(_ key: String) -> Bool {
		let out = Defaults.bool(forKey: key)
		return out
	}

}

// MARK: - Singleton

extension FIOUserManager {
	
	struct Static {
		static var instance: FIOUserManager?
	}
	
	class var sharedInstance: FIOUserManager {
		if Static.instance == nil
		{
			Static.instance = FIOUserManager()
		}
		
		return Static.instance!
	}
	
	private func dispose() {
		print("\n\n\(#function)\n\n")
		FIOUserManager.Static.instance = nil
		print("Disposed Singleton instance FIOUserManager")
	}
	
}
