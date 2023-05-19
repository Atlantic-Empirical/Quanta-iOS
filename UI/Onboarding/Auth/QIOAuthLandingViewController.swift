//
//  QIOAuthLandingViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 4/17/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOAuthLandingViewController: UIViewController, UINavigationControllerDelegate {

	// MARK: - Properties
	
	var completion: QIOErrorCompletion?
	private var viewNumberEntryStartFrame: CGRect?
	private var enteredTextIsExistingUserPhoneNumber: Bool = false
	private var queryPending: Bool = false
	private var continueOnReturn: Bool = false
	private var spinner: UIActivityIndicatorView?
	private var rendered: Bool = false
	private var headerY: CGFloat = 0

	// MARK: - IBOutlets
	
	@IBOutlet weak var viewTextEntry: UIView!
	@IBOutlet weak var btnUnfocusTextField: UIButton!
	@IBOutlet weak var btnContinue: UIButton!
	@IBOutlet weak var txtMobileNumber: FPNTextField!
	@IBOutlet weak var viewHeader: UIView!
	
	// MARK: View Lifecycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		QMix.track(.viewAuthLanding)
		navigationItem.backBarButtonItem = UIBarButtonItem(
			title: "Try Again", style: .plain, target: nil, action: nil)
		disableCodeButton()
		txtMobileNumber.clearButtonMode = .whileEditing
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		initKeyboardBehavior()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		if let nc = AppDelegate.sharedInstance.navigationController {
			nc.setNavigationBarHidden(true, animated: false)
		}
	}

	override func viewDidDisappear(_ animated: Bool) {
		spinner?.stopAnimating()
		btnContinue.setTitle("Go", for: .normal)
	}
	
	// MARK: - Actions
	
	@IBAction func unfocusTextField(_ sender: Any) {
		txtMobileNumber.endEditing(true)
	}
	
	@IBAction func nextStep(_ sender: Any) {
		if queryPending {
			continueOnReturn = true // should set a spinner
			spinner = UIActivityIndicatorView(frame: btnContinue.bounds)
			spinner?.hidesWhenStopped = true
			spinner?.startAnimating()
			btnContinue.addSubview(spinner!)
			btnContinue.setTitle("", for: .normal)
		} else {
			submitPhoneNumber()
		}
	}
	
	@IBAction func showAboutPrivacy(_ sender: Any) {
		guard let nc = navigationController else { return }
		
		let vc = FIOAboutPrivacyViewController()
		vc.addDoneButton()
		let privacyNC = UINavigationController(rootViewController: vc)
		nc.present(privacyNC, animated: true, completion: nil)
	}
	
	@IBAction func mobileNumberTextChange(_ sender: UITextField) {
		let numberIsValid = phoneNumberIsValid()
		if (numberIsValid) {
			print("Number is VALID")
			enableCodeButton()
			queryPending = true
			let queryString = conformedTextEntryAsPhoneNumber()
			print(queryString)
			
			FIOAppSync.sharedInstance.userAuthExists(phoneNumber: queryString) {
				exists in
				
				self.queryPending = false
				self.enteredTextIsExistingUserPhoneNumber = exists
				if self.continueOnReturn {
					self.submitPhoneNumber()
				}
			}
		} else {
			print("Number is INVALID")
			disableCodeButton()
			self.enteredTextIsExistingUserPhoneNumber = false
		}
	}
	
	@IBAction func txtMobileNumber_PrimaryActionTriggered(_ sender: Any) {
		print(#function)
		
		if phoneNumberIsValid() {
			print("Number is valid")
			nextStep(self)
		} else {
			print("Number is not valid")
		}
	}

	@objc func userRequestedAnotherVerificationCode() {
		print(#function)
	}
	
	// MARK: Custom
	
	private func submitPhoneNumber() {
		continueOnReturn = false
		txtMobileNumber.endEditing(true)
		
		if enteredTextIsExistingUserPhoneNumber {
			signIn()
		} else {
			QUser.signup(phoneNumber: conformedTextEntryAsPhoneNumber()) {
				error in
				
				if let e = error {
					self.completionOnMainThread(e)
				} else {
					self.signIn()
				}
			}
		}
	}
	
	private func signIn() {
		QUser.signin(phoneNumber: conformedTextEntryAsPhoneNumber()) { error in
			print(#function + " in QIOAUthMobileEntryVC")
		}
	}
	
	private func completionOnMainThread(_ e: Error? = nil) {
		DispatchQueue.main.async {
			self.completion?(e)
		}
	}
	
	private func phoneNumberIsValid() -> Bool {
		var testString: String = txtMobileNumber.text!
		testString = testString.numbersOnly.withoutPrefix("1")
		if testString.count != 10 { return false }
		return true
	}
	
	private func conformedTextEntryAsPhoneNumber() -> String {
		print(self.className + " " + #function)
		if Thread.isMainThread {
			return innerConformedTextEntryAsPhoneNumber()
		} else {
			let hi = DispatchQueue.main.sync {
				return innerConformedTextEntryAsPhoneNumber()
			}
			return hi
		}
	}
	
	private func innerConformedTextEntryAsPhoneNumber() -> String {
		let enteredText = self.txtMobileNumber.text!
		var conformedPhoneNumber = enteredText.numbersOnly.withoutPrefix("1")
		if conformedPhoneNumber.count == 10 { // it is a full american / canadian phone number with area code
			conformedPhoneNumber = "+1\(conformedPhoneNumber)"
		} else {
			conformedPhoneNumber = ""
		}
		print("conformed phone number: " + conformedPhoneNumber)
		return conformedPhoneNumber
	}
	
	private func enableCodeButton() {
		btnContinue.isEnabled = true
		btnContinue.backgroundColor = UIColor("54ACFF")
	}
	
	private func disableCodeButton() {
		btnContinue.isEnabled = false
		btnContinue.backgroundColor = .darkGray
	}
	
}

// MARK: - Keyboard

extension QIOAuthLandingViewController {
	
	private func initKeyboardBehavior() {
		if rendered { return } else { rendered = true }

		txtMobileNumber.parentViewController = self
		txtMobileNumber.delegate = self
		txtMobileNumber.flagSize = CGSize(width: 30, height: 30)
		txtMobileNumber.flagButtonEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		txtMobileNumber.font = .systemFont(ofSize: 18)

		viewNumberEntryStartFrame = viewTextEntry.frame
		headerY = viewHeader.y
		NotifCenter.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotifCenter.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc func keyboardShow(notification: NSNotification) {
		print(self.className + " " + #function)
		if
			let userInfo = notification.userInfo,
			let keyboardFrame: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
		{
			let keyboardRectangle = keyboardFrame.cgRectValue
			let keyboardHeight = keyboardRectangle.height
			let newY: CGFloat = view.frame.height - keyboardHeight - viewTextEntry.frame.height - 10
			
			self.btnUnfocusTextField.isHidden = false
			UIView.animate(withDuration: 0.3) {
				self.viewTextEntry.frame = CGRect(origin: CGPoint(x: self.viewTextEntry.frame.origin.x, y: newY), size: self.viewTextEntry.frame.size)
				self.viewHeader.y -= UIScreen.main.bounds.h > 667 ? 0 : 40
			}
		}
	}
	
	@objc func keyboardHide(notification: NSNotification) {
		print(self.className + " " + #function)

		self.btnUnfocusTextField.isHidden = true
		UIView.animate(withDuration: 0.3) {
			self.viewTextEntry.frame = self.viewNumberEntryStartFrame!
			self.viewHeader.y = self.headerY
		}
	}
	
}

extension QIOAuthLandingViewController: FPNTextFieldDelegate {
	
	func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
		textField.rightViewMode = .always
		textField.rightView = UIImageView(image: isValid ? #imageLiteral(resourceName: "check-circle-1") : #imageLiteral(resourceName: "remove-circle"))
		textField.rightView?.alpha = 0.5
		if colorful { textField.backgroundColor = .randomP3 }
		if colorful { textField.rightView?.backgroundColor = .randomP3 }
		
		print(
			isValid,
			textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil",
			textField.getFormattedPhoneNumber(format: .International) ?? "International: nil",
			textField.getFormattedPhoneNumber(format: .National) ?? "National: nil",
			textField.getFormattedPhoneNumber(format: .RFC3966) ?? "RFC3966: nil",
			textField.getRawPhoneNumber() ?? "Raw: nil"
		)
	}
	
	func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
		print(name, dialCode, code)
	}
	
}
