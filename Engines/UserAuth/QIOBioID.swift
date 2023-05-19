//
//  QIOBioID.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 3/20/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import LocalAuthentication

class QIOBioID {

	// MARK: - Properties
	var bioContext = LAContext()
	var biometryTypeString: String = ""
	var bioIdSupported: Bool = false
	private var canEvaluateHasBeenCalled = false
	
	public var bioIdentificationSupported: Bool {
		if canEvaluateHasBeenCalled {
			return bioIdSupported
		} else {
			var error: NSError?
			bioIdSupported = bioContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
			canEvaluateHasBeenCalled = true
			if let e = error {
				print("ERROR in QIOBioID canEvaluatePolicy error: \(QIOBioID.evaluateAuthenticationPolicyMessageForLA(errorCode: e.code))")
				return false
			} else {
				switch bioContext.biometryType {
				case .faceID: biometryTypeString = "FaceID"
				case .touchID: biometryTypeString = "TouchID"
				case .none: biometryTypeString = ""
				default: biometryTypeString = ""
				}
			}
			return bioIdSupported
		}
	}
	
	// MARK: - API
	
	func offerSetup(completion: QIOSimpleCompletion? = {}) {
		print(#function)

		#if targetEnvironment(simulator) || DEBUG
		print("*** BIO ID IS DISABLED IN CODE FOR SIMULATOR OR DEBUG BUILD ***")
		if let c = completion { c() }
		return
		#endif

		DispatchQueue.main.async {
			if !self.bioIdentificationSupported {
				print("BioID not supported on this device.")
				completion?()
			}
			else {
				guard let nc = AppDelegate.sharedInstance.navigationController else { completion?(); return }
				guard let presentingVC = nc.visibleViewController else { completion?(); return }
				
				FIOControlFullscreenActivity.shared.presentOver(presentingVC.view, message: "")
				
				let alert = UIAlertController(
					title: "Enable \(self.biometryTypeString)?",
					message: "Add extra security to your Quanta account using Apple iOS \(self.biometryTypeString).",
					preferredStyle: .alert
				)
				alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
					self.performBioAuth() { bioIdSucceeded in
						QUser.userPrefSetBool(bioIdSucceeded, qPrefKey_bioIdIsEnabled)
						if bioIdSucceeded {
							QMix.track(.eventBioIdEnabled)
							AppDelegate.sharedInstance.presentAlertWithTitle(
								self.biometryTypeString,
								message: "Your Quanta account is now secured with \(self.biometryTypeString)."
							) { action in
								completion?()
							}
						} else {
							let alert = UIAlertController(title: self.biometryTypeString, message: "Seems that \(self.biometryTypeString) sign-in failed. Try again?", preferredStyle: .alert)
							alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
								self.offerSetup(completion: completion)
							})
							alert.addAction(UIAlertAction(title: "No", style: .destructive) { action in
								completion?()
							})
							presentingVC.present(alert, animated: true, completion: nil)
						}
					}
				})
				alert.addAction(UIAlertAction(title: "No", style: .destructive) { action in
					completion?()
				})
				presentingVC.present(alert, animated: true)
			}
		}
	}
	
	public func performBioAuth(_ completion: QIOBoolCompletion? = { _ in }) {
		print(#function)

		// Get a fresh context for each login. If you use the same context on multiple attempts
		//  (by commenting out the next line), then a previously successful authentication
		//  causes the next policy evaluation to succeed without testing biometry again.
		//  That's usually not what you want.
		let bioContext = LAContext()
		bioContext.touchIDAuthenticationAllowableReuseDuration = 10 // seconds
//		bioContext.localizedFallbackTitle = ""
//		bioContext.localizedCancelTitle = ""
		let reason = "Quanta account security."
		bioContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) {
			success, error in
			
			DispatchQueue.main.async {
				if let e = error {
					print("BioID evaluatePolicy error: \(QIOBioID.evaluateAuthenticationPolicyMessageForLA(errorCode: e.code))")
					completion?(false)
				} else {
					completion?(success)
				}
			}
		}
	}
	
	internal static func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
		print(#function)

		var message = ""
		if #available(iOS 11.0, macOS 10.13, *) {
			switch errorCode {
			case LAError.biometryNotAvailable.rawValue:
				message = "Authentication could not start because the device does not support biometric authentication."
				
			case LAError.biometryLockout.rawValue:
				message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
				
			case LAError.biometryNotEnrolled.rawValue:
				message = "Authentication could not start because the user has not enrolled in biometric authentication."
				
			default:
				message = "Did not find error code on LAError object"
			}
		} else {
			switch errorCode {
			case LAError.touchIDLockout.rawValue:
				message = "Too many failed attempts."
				
			case LAError.touchIDNotAvailable.rawValue:
				message = "TouchID is not available on the device"
				
			case LAError.touchIDNotEnrolled.rawValue:
				message = "TouchID is not enrolled on the device"
				
			default:
				message = "Did not find error code on LAError object"
			}
		}
		
		return message;
	}

	internal static func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
		print(#function)

		var message = ""
		
		switch errorCode {
			
		case LAError.authenticationFailed.rawValue:
			message = "The user failed to provide valid credentials"
			
		case LAError.appCancel.rawValue:
			message = "Authentication was cancelled by application"
			
		case LAError.invalidContext.rawValue:
			message = "The context is invalid"
			
		case LAError.notInteractive.rawValue:
			message = "Not interactive"
			
		case LAError.passcodeNotSet.rawValue:
			message = "Passcode is not set on the device"
			
		case LAError.systemCancel.rawValue:
			message = "Authentication was cancelled by the system"
			
		case LAError.userCancel.rawValue:
			message = "The user did cancel"
			
		case LAError.userFallback.rawValue:
			message = "The user chose to use the fallback"
			
		default:
			message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
		}
		
		return message
	}

}

// MARK: - Singleton

extension QIOBioID {
	
	struct Static {
		static var instance: QIOBioID?
	}
	
	class var sharedInstance: QIOBioID {
		if Static.instance == nil
		{
			Static.instance = QIOBioID()
		}
		return Static.instance!
	}
	
	private func dispose() {
		QIOBioID.Static.instance = nil
		print("Disposed Singleton instance QIOBioID")
	}
	
}
