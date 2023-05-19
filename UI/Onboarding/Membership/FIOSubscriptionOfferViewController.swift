//
//  FIOSubscriptionOfferViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 1/31/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class FIOSubscriptionOfferViewController: UIViewController {

	// MARK: - Properties
	public var completion: QIOSimpleCompletion?
	private let termsUrl = "quanta://terms"
	private let privacyUrl = "quanta://privacy"
	private var userTappedRestore: Bool = false
	private var userTappedStartTrial: Bool = false

	// MARK: - IBOutlet
	@IBOutlet weak var tvFinePrint: UITextView!
	
	// MARK: - View Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		QMix.track(.viewMembershipMerchInitial)
		NotifCenter.addObserver(self, selector: #selector(self.handleSubscriptionReceiptValidated), name: .FIOSubscriptionReceiptValidated, object: nil)
		NotifCenter.addObserver(self, selector: #selector(self.handleRestoreDidNotFindValidSubscription(_:)), name: .FIOSubscriptionRestoreDidNotFindValidSubscription, object: nil)
		NotifCenter.addObserver(self, selector: #selector(self.handleFailOrCancel(_:)), name: .FIOSubscriptionPurchaseFailedOrCancelled, object: nil)
		setup()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	// MARK: - IBActions
	
	@IBAction func whyWeChargeAction(_ sender: Any) {
		pushVC(FIOGenericTextViewViewController(.WhyWeCharge))
	}
	
	@IBAction func startFreeTrialAction(_ sender: Any) {
		userTappedStartTrial = true
		FIOSubscriptionEngine.shared.buySubscription()
		FIOControlFullscreenActivity.shared.presentOver(self.view, message: "Starting Subscription...")
	}
	
	@IBAction func restoreSubscriptionAction(_ sender: Any) {
		userTappedRestore = true
		FIOSubscriptionEngine.shared.restoreTransactions()
		FIOControlFullscreenActivity.shared.presentOver(self.view, message: "Restoring Subscription...")
	}
	
	@IBAction func enterPromoCodeAction(_ sender: Any) {
		FIOSubscriptionEngine.shared.collectAndAttemptApplyPromoCode() { res in
			switch res {
			case .success(let d):
				print(d.toFriendly_long())
				if let c = self.completion { c() } // We're done here.
			case .failure(let reason):
				print(reason)
			}
		}
	}
	
	@IBAction func signoutAction(_ sender: Any) {
		QUser.signOutActionSheet()
	}

	// MARK: - Custom
	
	private func setup() {
		FIOSubscriptionEngine.shared.prepForPitch() // Get the product object
		tvFinePrint.delegate = self
		let finePrint = NSMutableAttributedString(attributedString: tvFinePrint.attributedText)
		finePrint.setAsLink(textToFind: "Terms of Service", linkURL: termsUrl)
		finePrint.setAsLink(textToFind: "Privacy Policy", linkURL: privacyUrl)
		let font = tvFinePrint.font!
		finePrint.setTextFont("Recurring billing, cancel anytime.", font: UIFont.systemFont(ofSize: font.pointSize, weight: .semibold))
		finePrint.setKerning(-0.5)
		tvFinePrint.attributedText = finePrint
	}
	
	private func pushVC(_ vc: UIViewController) {
		navigationController?.pushViewController(vc, animated: true)
		navigationController?.setNavigationBarHidden(false, animated: false)
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		navigationController?.navigationBar.tintColor = .q_brandGold
	}
	
	@objc private func handleSubscriptionReceiptValidated(_ notif: Notification) {
		print(self.className + " " + #function)
		FIOControlFullscreenActivity.shared.hide()
		if let O = notif.object, let ss = O as? FIOSubscriptionState {
			if ss.isValid {
				let msg = "Membership success! \(ss.expiresDateStr)"
				print(msg)
				if let c = self.completion { c() }
//				AppDelegate.sharedInstance.presentAlertWithTitle("Membership success!", message: ss.expiresDateStr, singleActionString: "Ok", nc: self.navigationController) { action in
//					if let c = self.completion {
//						c()
//					}
//				}
			} else {
				print("This receipt did not put the user into a valid state. Keep waiting")
			}
		}
	}
	
	@objc private func handleRestoreDidNotFindValidSubscription(_ notif: Notification) {
		print(self.className + " " + #function)
		if userTappedStartTrial {
		} else if userTappedRestore {
			AppDelegate.sharedInstance.presentAlertWithTitle("No Existing Subscription Found", message: "", singleActionString: "Ok", nc: self.navigationController) { action in
				FIOControlFullscreenActivity.shared.hide()
			}
		} else {
		}
	}

	@objc private func handleFailOrCancel(_ notif: Notification) {
		print(self.className + " " + #function)
		if userTappedStartTrial {
			AppDelegate.sharedInstance.presentAlertWithTitle("Membership Not Purchased", singleActionString: "Ok", nc: self.navigationController) { action in
				FIOControlFullscreenActivity.shared.hide()
			}
		} else if userTappedRestore {
		} else {
		}
	}
	
}

extension FIOSubscriptionOfferViewController: UITextViewDelegate {
	
	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
		let vc = FIOAboutPrivacyViewController()
		pushVC(vc)
		if (URL.absoluteString == termsUrl) {
			vc.preferredIndex = 2
		} else if (URL.absoluteString == privacyUrl) {
			vc.preferredIndex = 1
		}
		return false
	}

}
