//
//  FIOAuthCodeEntryViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 12/3/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import AWSMobileClient

class FIOAuthCodeEntryViewController: UIViewController {

	// MARK: - Properties
	var completion: QIOStringCompletion?
	var phoneNumber: String?
	private var viewNumberEntryStartFrame: CGRect?
	private var submitted: Bool = false
	private var rendered: Bool = false
	private var headerY: CGFloat = 0

	// MARK: - IBOutlets
	
	@IBOutlet weak var btnSubmit: UIButton!
	@IBOutlet weak var txtVerfCode: UITextField!
	@IBOutlet weak var btnUnfocusTextField: UIButton!
	@IBOutlet weak var viewTextEntry: FIOPassthroughView!
	@IBOutlet weak var lblSentTo: UILabel!
	@IBOutlet weak var viewHeader: UIView!
	
	// MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		QMix.track(.viewEnterVerificationCode)
		disableSubmitButton()
		navigationController?.navigationBar.customize(withGradient: false)
		navigationController?.setNavigationBarHidden(false, animated: false)
		txtVerfCode.clearButtonMode = .whileEditing
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		initKeyboardBehavior()
	}

	override func viewWillAppear(_ animated: Bool) {
		if let pn = phoneNumber {
			if pn == "" {
				expiredRefreshTokenCase()
			} else {
				lblSentTo.text = "DELIVERED TO: " + pn.toPhoneNumber()
			}
		}
	}
	
	private func expiredRefreshTokenCase() {
		print("This is probably the refresh case.")
		lblSentTo.text = "Acct. Phone Number"
		let addButton = UIButton(type: .custom)
		addButton.frame = CGRect(x: 0.0, y: 0.0, width: 44, height: 44)
		addButton.setImage(UIImage(named:"GrayProfile_24pt"), for: .normal)
		addButton.addTarget(self, action: #selector(signOutAction), for: UIControl.Event.touchUpInside)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
		navigationItem.hidesBackButton = true // there is no back from here. only forward 🐒
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		hideNavBar()
	}
	
	// MARK: - Actions
	
	@IBAction func txtMobileNumber_PrimaryActionTriggered(_ sender: Any) {
		print(#function)
		
		if checkCode() {
			submitAction(self)
		} else {
			print("Number is bork")
		}
	}
	
	@objc func signOutAction() {
		let alert = UIAlertController(
			title: "Clear Credentials",
			message: "Would you like to clear your \(appName) credentials from this device and start totally fresh?",
			preferredStyle: .alert
		)
		alert.addAction(
			UIAlertAction(
				title: "Yes",
				style: .destructive
			) { action in
				QUser.signout()
				self.navigationController?.dismiss(animated: true)
			}
		)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		AppDelegate.sharedInstance.navigationController?.present(alert, animated: true)
	}

	@IBAction func unfocusTextField(_ sender: Any) {
		txtVerfCode.endEditing(true)
	}

	@IBAction func txtChanged(_ sender: Any) {
		if checkCode() {
			enableSubmitButton()
		} else {
			disableSubmitButton()
		}
	}
	
	@IBAction func submitAction(_ sender: Any) {
		if submitted { return } // Prevent multi-tapping.
		guard let code = txtVerfCode.text else { return }
		disableSubmitButton()
		FIOControlFullscreenActivity.shared.presentOver(view, message: "Signing in...")
		completion?(code)
	}
	
	@IBAction func sendAgainAction(_ sender: Any) {
		completion?("RESEND")
	}
	
	// MARK: - Custom
	
	public func badCodeEntered() {
		submitted = false
		txtVerfCode.text = ""
		disableSubmitButton()
	}
	
	private func checkCode() -> Bool {
		guard let code = txtVerfCode.text else { return false }
		if code == "" { return false }
		
		#if !DEBUG
		if let pn = phoneNumber {
			if
				pn != "+17263269000" && // Apple Review Account
				code == "0088"
			{
				print("DISALLOWING USE OF 0088 CODE")
				return false // Don't allow this code to be used in prod.
			}
		}
		#endif

		return true
	}
	
	private func enableSubmitButton() {
		btnSubmit.isEnabled = true
		btnSubmit.backgroundColor = .q_buttonBlue
	}
	
	private func disableSubmitButton() {
		btnSubmit.isEnabled = false
		btnSubmit.backgroundColor = .darkGray
	}
	
}

// MARK: - Keyboard

extension FIOAuthCodeEntryViewController {
	
	private func initKeyboardBehavior() {
		viewNumberEntryStartFrame = viewTextEntry.frame
		headerY = viewHeader.y
		NotifCenter.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotifCenter.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc func keyboardShow(notification: NSNotification) {
		print(self.className + " " + #function)
		
		if let userInfo = notification.userInfo, let keyboardFrame: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
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
