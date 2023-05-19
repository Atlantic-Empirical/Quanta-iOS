//
//  QIONotifPermissonViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/22/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import UIKit

class QIONotifPermissonViewController: UIViewController {

	// MARK: - Properties
	
	private var built: Bool = false
	private var completion: QIOSimpleCompletion?
	private var waitingForReturnFromIOSNotifSettings: Bool = false

	// MARK: - View Lifecycle
	
	convenience init(_ c: QIOSimpleCompletion?) {
		self.init()
		self.completion = c
	}
	
	override func loadView() {
		super.loadView()
		navigationController?.setNavigationBarHidden(true, animated: false)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		NotifCenter.addObserver(
			self,
			selector: #selector(applicationWillEnterForeground),
			name: .applicationWillEnterForeground,
			object: nil)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		build()
	}
	
	@objc private func applicationWillEnterForeground() {
		if waitingForReturnFromIOSNotifSettings {
			waitingForReturnFromIOSNotifSettings = false
			QNotifs.checkNotificationPermissionSetting() {
				if QNotifs.notifPermissionStatus == .authorized {
					QNotifs.propmtUserForNotificationPermission() { (b1, b2) in
						self.continueAction()
					}
				}
			}
		}
	}
	
	// MARK: - Actions
	
	@objc func getItAction() {
		QMix.track(.actionNotifsSoftApprove)
		QNotifs.propmtUserForNotificationPermission() {
			(hardPermissionRequired, openedSettings) in
			if hardPermissionRequired && openedSettings {
				self.waitingForReturnFromIOSNotifSettings = true
			} else if hardPermissionRequired && !openedSettings {
				// leave user on view
			} else {
				self.continueAction()
			}
		}
	}
	
	@objc func notNowAction() {
		QMix.track(.actionNotifsSoftDecline)
		QNotifs.requestStatus = .softAskDenied
		continueAction()
	}
	
	// MARK: - Custom
	
	private func continueAction() {
		DispatchQueue.main.async {
			AppDelegate.sharedInstance.setUserLooseIntoApp(false)
			self.dismiss(animated: true)
			if let c = self.completion { c() }
		}
	}
	
	// MARK: - UI Build
	
	private func build() {
		if built { return } else { built = true }
		
		view.backgroundColor = .white
		
		let base = UIView(frame: .zero)
		if colorful { base.backgroundColor = .randomP3 }
		base.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(base)
		base.anchorCenterToSuperview()
		base.anchorSizeToSuperview()

		let iv = UIImageView(image: UIImage(named: "DailyNotifMock"))
		iv.contentMode = .scaleAspectFill
		iv.translatesAutoresizingMaskIntoConstraints = false
		base.addSubview(iv)
		iv.anchorCenterToSuperview()

		let description = labelGenerator(
			"Building financial freedom starts with knowing your earning and spending every day - Quanta makes it easy.",
			font: baseFont(size: 18, bold: false),
			textColor: .q_38,
			maxWidth: 280)
		description.setLineSpacing(5)
		description.font = description.font.italic
		description.textAlignment = .center // this must happen after the above because they fiddle with the attributed string
		if colorful { description.backgroundColor = .randomP3 }
		description.translatesAutoresizingMaskIntoConstraints = false
		base.addSubview(description)
		description.anchorSizeConstant(280, 108)
		description.anchorCenterXToSuperview()
		description.anchorBottomTo(iv.topAnchor, constant: -24)

		let title = labelGenerator(
			"Daily Flow Notif",
			font: baseFont(size: 36, bold: false),
			textColor: .q_53,
			alignment: .center)
		title.font = title.font.italic
		title.translatesAutoresizingMaskIntoConstraints = false
		base.addSubview(title)
		title.anchorCenterXToSuperview()
		title.anchorBottomTo(description.topAnchor, constant: -24)

		let btnNotNow = UIButton(#selector(notNowAction), title: "Not Now")
		btnNotNow.titleLabel?.font = baseFont(size: 17, bold: false)
		base.addSubview(btnNotNow)
		btnNotNow.anchorSizeConstant(160, 44)
		btnNotNow.anchorCenterXToSuperview()
		btnNotNow.anchorBottomTo(base.safeAreaLayoutGuide.bottomAnchor, constant: -30)
		btnNotNow.backgroundColor = .clear
		btnNotNow.setTitleColor(.q_buttonLinkBlue, for: .normal)

		let btnGetIt = UIButton(#selector(getItAction), title: "I Want This")
		btnGetIt.titleLabel?.font = baseFont(size: 22, bold: true)
		base.addSubview(btnGetIt)
		btnGetIt.anchorSizeConstant(260, 60)
		btnGetIt.anchorCenterXToSuperview()
		btnGetIt.anchorBottomTo(btnNotNow.topAnchor, constant: -18)
		btnGetIt.backgroundColor = .q_buttonBlue
		btnGetIt.cornerRadius = 8
		
		let subtitle = labelGenerator(
			"<placeholder>",
			font: baseFont(size: 18, bold: false),
			textColor: .q_38,
			maxWidth: 300)
		if colorful { subtitle.backgroundColor = .randomP3 }
		subtitle.translatesAutoresizingMaskIntoConstraints = false
		base.addSubview(subtitle)
		subtitle.anchorSizeConstant(236, 54)
		subtitle.anchorCenterXToSuperview()
		subtitle.anchorTopTo(iv.bottomAnchor, constant: 24)
		let subtitleString = "The most valuable notification of your day."
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 5
		paragraphStyle.alignment = .center
		let subtitleAttributedString = NSMutableAttributedString(
			string: subtitleString,
			attributes: [
				NSAttributedString.Key.font: subtitle.font.italic,
				NSAttributedString.Key.paragraphStyle: paragraphStyle
			]
		)
		if let sRange = subtitleString.range(of: "valuable") {
			subtitleAttributedString.addAttributes(
				[
					NSAttributedString.Key.font: subtitle.font.boldItalic,
					NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
				],
				range: NSRange(sRange, in: subtitleString)
			)
			subtitle.attributedText = subtitleAttributedString
		} else {
			subtitle.text = subtitleString
		}
		
		base.setHeight()
		base.updateConstraints()
	}
	
}
