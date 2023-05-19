//
//  QIOPlaidViewControllerExtension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/28/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Foundation

extension UIViewController {
	
	@objc func plaidLink() {
		print(self.className + " " + #function)
		if let phone = QUser.userAttribute_phone_number {
			if phone.hasPrefix("+17263269") { // +1-726-326-9XXX == Sandbox accounts
				FIOPlaidManager.sharedInstance.PLAID_ENV = .sandbox
			}
		}
		FIOPlaidManager.sharedInstance.enterItemLinkFlow(vc: self) {
			newItemConnected in
			
		}
	}
	
	@objc func handlePlaidLinkSuccess(_ notification: NSNotification) {
		print(#function)
		guard let obj = notification.object else { return }
		QMix.track(.eventPlaidLinkSuccess)
		if QPlaid.isUpdateMode {
			QPlaid.linkFlowNC = UINavigationController(
				rootViewController:
				QIOQuantizeProgressViewController(updateQuantizeCompleted)
			)
		} else {
			QPlaid.linkFlowNC = UINavigationController(
				rootViewController: QIOLinkAccountSelectionViewController(
					linkMetadata: obj as! FIOPlaidLinkMetadata)
			)
		}
		present(QPlaid.linkFlowNC!, animated: true)
	}
	
	func updateQuantizeCompleted() {
		QPlaid.isUpdateMode = false
		QPlaid.linkFlowNC?.dismiss(animated: true)
	}
	
	@objc func handlePlaidLinkError(_ notification: NSNotification) {
		print(notification)
		QMix.track(.eventPlaidLinkFailed)
		guard
			let obj = notification.object,
			let d = obj as? [String : Any?]
			else { return }
		let error = d["error"] as! Error
		let metadata = d["metadata"] as! [String : Any]
		let msg = "Error: \(error.localizedDescription)\nMetadata: \(metadata)"
		Rollbar.info("handlePlaidLinkError: \(msg)")
		AppDelegate.sharedInstance.presentAlertWithTitle("Link Failure", message: msg)
	}
	
	@objc func handleExitWithMetadata(_ notification: NSNotification) {
		let msg = "Plaid Connect Exit Metadata: \(notification.object ?? [:])"
		print(msg)
		Rollbar.info(msg)
		AppDelegate.sharedInstance.checkQuantizingStatus()
	}
	
}
