//
//  FIOSubscriptionViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 1/31/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOMembershipViewController: QIOBaseViewController {

	var ss: FIOSubscriptionState!

	// MARK: - View Lifecycle
	
	override func loadView() {
		customTitle = "Membership"
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		NotifCenter.addObserver(self, selector: #selector(handleSubscriptionReceiptValidated), name: .FIOSubscriptionReceiptValidated, object: nil)
		NotifCenter.addObserver(self, selector: #selector(handleRestoreDidNotFindValidSubscription(_:)), name: .FIOSubscriptionRestoreDidNotFindValidSubscription, object: nil)
		NotifCenter.addObserver(self, selector: #selector(handleFailOrCancel(_:)), name: .FIOSubscriptionPurchaseFailedOrCancelled, object: nil)
		super.loadView()
	}
	
	// MARK: - Actions
	
	@objc func manageSubscriptionAction(_ sender: Any) {
		QMember.openSubscriptionManagement()
	}
	
	@objc func whyWeChargeAction(_ sender: Any) {
		navigationController?.pushViewController(FIOGenericTextViewViewController(.WhyWeCharge), animated: true)
	}
	
	@objc func contactUsAction(_ sender: Any) {
		AppDelegate.sharedInstance.contactActionSheet()
	}
	
//	@objc func promoCodeAction(_ sender: Any) {
//		FIOSubscriptionEngine.shared.collectAndAttemptApplyPromoCode() { res in
//			self.setSubscriptionDescription()
//		}
//	}

	@objc func restoreSubscriptionAction(_ sender: Any) {
		FIOSubscriptionEngine.shared.restoreTransactions()
		FIOControlFullscreenActivity.shared.presentOver(view, message: "Restoring Membership")
	}
	
	// MARK: - UI Build
	
	override func buildUI() {
		if let s123 = FIOSubscriptionEngine.shared.subscriptionState {
			self.ss = s123
			buildUI_inner()
		} else {
			FIOSubscriptionEngine.shared.checkSubscriptionState { (state, err) in
				if err != nil {
					fatalError("Failed to retrieve subscription state.")
				} else if state == nil {
					AppDelegate.sharedInstance.presentAlertWithTitle(
						"Membership Issue",
						message: "It seems there is no membership for your account."
					) { action in
						self.navigationController?.popViewController(animated: true)
					}
				} else {
					self.ss = state
					self.buildUI_inner()
				}
			}
		}
	}
	
	private func buildUI_inner() {
		addSubscriptionDescription()
		addNonRenewingNotice()
		addButtons()
		super.buildComplete()
	}

	// MARK: - Custom
	
	func addSubscriptionDescription() {
		var description = ""
		if ss.isInPromoCodePeriod {
			description = "You're currently in a promotional free trial period."
			if let d = ss.expiresDate {
				description.append(" The trial will end on \(d.toFriendly_long()).")
			}
		} else {
			if let startDate = ss.subscriptionStartDate, let expiresDate = ss.expiresDate {
				description = "Your membership began on "
				description.append(startDate.toFriendly())
				if ss.expirationIntent == .NotSet {
					description.append(" and the next renewal is on ")
					description.append(expiresDate.toFriendly())
				}
				description.append(".")
				
				if ss.isInTrial {
					description.append("\n\nYou're currently in a FREE TRIAL.")
				}
				
				if ss.expirationIntent == .NotSet {
					description.append("\n\nIf you'd like to cancel Quanta at any time you can do so by tapping Manage Subscription below.")
				}
			}
		}
		
		addModuleNew(genLabel(description), vSpace: 20)
	}
	
	func addNonRenewingNotice() {
		if
			let ss = FIOSubscriptionEngine.shared.subscriptionState,
			ss.expirationIntent == .VoluntaryChurn || ss.expirationIntent == .InvoluntaryChurn
		{
			var description = ""
			
			if ss.expirationIntent == .VoluntaryChurn {
				description = """
				⚠️ NOTE: Your subscription will not auto-renew upon expiration.

				Hi this is a message from Thomas, creator of Quanta -- I see that you recently cancelled your subscription. Your success is my top priority so I'm *really* interested in learning what went wrong. Please let me know:

				Text: +1 (415) 779-7976
				Email: t@quantamoney.app
				Or do this little survey: http://qgo.to/bye

				If you provide helpful feedback and want to give Quanta another chance I'd be happy to give you a free lifetime account -- Our small team is always working hard to make Quanta better for you.
				
				Either way thanks for giving Quanta a try 😎🙏
				"""
			} else { // .InvoluntaryChurn
				if ss.inBillingRetry {
					print("Is in billing retry")
				}
				
				description = """
				⚠️ NOTE: Your subscription will not auto-renew upon expiration.

				It seems there's a problem with your membership. Tap "Manage Subscription" below, resolve the issue and return to Quanta.
				
				You can *always* get in touch with us if you have any questions or need assistance.
				"""
			}
			addModuleNew(genTextView(description, maxWidth: contentWidth), vSpace: 20)
		}
	}
	
	func addButtons() {
		let b3 = UIButton(#selector(manageSubscriptionAction(_:)), title: "Manage Subscription")
		b3.backgroundColor = .q_buttonLinkBlue
		b3.titleLabel?.font = baseFont(size: 20, bold: true)
		addModuleNew(b3, vSpace: 30, anchorSides: false)
		b3.anchorHeight(44)
		b3.anchorWidth(260)
		b3.anchorCenterXToSuperview()
		
		let b2 = UIButton(#selector(whyWeChargeAction(_:)), title: "Why We Charge")
		b2.setTitleColor(.q_buttonLinkBlue, for: .normal)
		b2.titleLabel?.font = baseFont(size: 20, bold: false)
		addModuleNew(b2, vSpace: 20)
		
		let b1 = UIButton(#selector(contactUsAction(_:)), title: "Contact Us")
		b1.setTitleColor(.q_buttonLinkBlue, for: .normal)
		b1.titleLabel?.font = baseFont(size: 20, bold: false)
		addModuleNew(b1, vSpace: 10)

		if
			let ss = FIOSubscriptionEngine.shared.subscriptionState,
			ss.expirationIntent == .VoluntaryChurn || ss.expirationIntent == .InvoluntaryChurn
		{
			let b4 = UIButton(#selector(contactUsAction(_:)), title: "Restore Membership")
			b4.setTitleColor(.q_buttonLinkBlue, for: .normal)
			b4.titleLabel?.font = baseFont(size: 15, bold: false)
			addModuleNew(b4, vSpace: 10)
		}
	}

}

// MARK: - Subscription Engine Delegate

extension QIOMembershipViewController {
	
	@objc private func handleSubscriptionReceiptValidated(_ notif: Notification) {
		if
			let O = notif.object,
			let ss = O as? FIOSubscriptionState
		{
			if ss.isValid {
				AppDelegate.sharedInstance.presentAlertWithTitle("Membership success! \(ss.expiresDateStr)", nc: navigationController) { action in
					FIOControlFullscreenActivity.shared.hide()
				}
			} else {
				FIOControlFullscreenActivity.shared.hide()
				print("This receipt did not put the user into a valid state. Keep waiting")
			}
		} else {
			FIOControlFullscreenActivity.shared.hide()
		}
	}
	
	@objc private func handleRestoreDidNotFindValidSubscription(_ notif: Notification) {
		AppDelegate.sharedInstance.presentAlertWithTitle("No existing membership found.", message: "", singleActionString: "Ok", nc: navigationController) { action in
			FIOControlFullscreenActivity.shared.hide()
		}
	}
	
	@objc private func handleFailOrCancel(_ notif: Notification) {
		AppDelegate.sharedInstance.presentAlertWithTitle("Failed to restore membership.", message: "", singleActionString: "Ok", nc: navigationController) { action in
			FIOControlFullscreenActivity.shared.hide()
		}
	}
	
}
