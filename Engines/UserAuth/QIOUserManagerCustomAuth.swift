//
//  QIOUserManagerCustomAuth.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 3/19/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import AWSCognitoIdentityProvider

class QIOUserManagerCustomAuth: NSObject, AWSCognitoIdentityCustomAuthentication {

	var phone_number: String = ""
	var navController: UINavigationController?
	private var codeEntryVC: FIOAuthCodeEntryViewController?
	private var authCompletion: AWSTaskCompletionSource<AWSCognitoIdentityCustomChallengeDetails>?
	private var inResend: Bool = false
	
	convenience init(_ nc: UINavigationController) {
		self.init()
		self.navController = nc
	}
	
	/**
	Obtain input for a custom challenge from the end user
	@param authenticationInput details the challenge including the challenge name and inputs
	@param customAuthCompletionSource set customAuthCompletionSource.result with the challenge answers from the end user
	*/
	func getCustomChallengeDetails(
		_ authenticationInput: AWSCognitoIdentityCustomAuthenticationInput,
		customAuthCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityCustomChallengeDetails>
	) {
		print(#function)
		print(String(describing: authenticationInput.challengeParameters))
		
		if authenticationInput.challengeParameters.count == 0 {
			let srpHelper = AWSCognitoIdentityProviderSrpHelper.beginUserAuthentication(
				phone_number,
				password: String.random(30)
			)
			customAuthCompletionSource.set(
				result: AWSCognitoIdentityCustomChallengeDetails(
					challengeResponses: [
						"SRP_A": srpHelper.clientState.publicA_stringValueWithRadix,
						"CHALLENGE_NAME": "SRP_A"
					]
				)
			)
		} else {
			self.authCompletion = customAuthCompletionSource
			self.presentCodeEntryUI()
		}
	}
	
	/**
	This step completed, usually either display an error to the end user or dismiss ui
	@param error the error if any that occured
	*/
	func didCompleteStepWithError(_ error: Error?) {
		print(#function)
		if let e = error, let ui = e._userInfo {
			print("ERROR")
			if let msg = ui["message"] as? String {
				print("###  Message:\t" + msg)
			}
			if let errorType = ui["__type"] as? String {
				print("###  Type:\t" + errorType)
				switch errorType {
				case "NotAuthorizedException":
					if !inResend {
						AppDelegate.sharedInstance.presentAlertWithTitle("Incorrect Code", message: "Please try again.")
					}
					inResend = false // always reset it
//				case "UserNotFoundException":
//				case "ResourceNotFoundException":
				default:
					print("Error type not handled")
				}
			}
		}
	}
	
	private func presentCodeEntryUI() {
		DispatchQueue.main.async {
			FIOControlFullscreenActivity.shared.hide() // Incase it is visible
			guard let ce = UIStoryboard(
				name: "FIOAuth",
				bundle: nil).instantiateViewController(
					withIdentifier: "AuthEnterCode")  as? FIOAuthCodeEntryViewController
				else { return }
			ce.phoneNumber = self.phone_number
			ce.completion = { code in
				print(code)
				if code == "RESEND" { self.inResend = true }
				self.authCompletion?.set(
					result: AWSCognitoIdentityCustomChallengeDetails(
						challengeResponses: [ "ANSWER" : code ]
					)
				)
			}
			self.codeEntryVC = ce
			self.navController?.setNavBarVisible()
			self.navController?.pushViewController(ce, animated: false)
		}
	}
	
}
