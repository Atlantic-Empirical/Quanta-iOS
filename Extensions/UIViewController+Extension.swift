//
//  UIViewController+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 12/11/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

extension UIViewController {
	
	var isVisible: Bool {
		return  presentedViewController == nil && navigationController?.topViewController == self
	}
	
}

// MARK: - Nav Bar Stuff

extension UIViewController {

	func hideNavBar(_ animated: Bool = false) {
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}

	func setNavBarVisible(_ animated: Bool = false, withGradient: Bool = true, forConfigArea: Bool = false) {
		if forConfigArea {
			navigationController?.navigationBar.customize(withGradient: false)
		} else {
			navigationController?.navigationBar.customize(withGradient: withGradient)
		}
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}

	func addRightSideNavInfoButton(_ doc: QIOLibraryInventory) {
		let infoButton = UIButton(type: .infoLight)
		infoButton.tag = doc.rawValue
		infoButton.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
	}

	func addRightSideNavButton(title: String, action: Selector, selectorObj: AnyObject) {
//		let infoButton = UIButton(type: .infoLight)
//		infoButton.tag = doc.rawValue
//		infoButton.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
//		navigationItem.rightBarButtonItem = UIBarButtonItem(
//			barButtonSystemItem: .action,
//			target: #selector(action),
//			action: selectorObj)
	}
	
	@objc func infoButtonTapped(_ sender: UIButton) {
		guard let nc = navigationController else { return }
		guard let doc = QIOLibraryInventory(rawValue: sender.tag) else { return }
		nc.pushViewController(FIOGenericTextViewViewController(doc), animated: true)
	}
	
	internal func addNavBackButton() {
		if let i = UIImage(named: "CollapseCaret") {
			let bbb = UIBarButtonItem(
				image: i,
				style: .plain,
				target: self,
				action: #selector(doneAction))
			self.navigationItem.leftBarButtonItem = bbb
		}
	}
	
	internal func addDoneButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Done",
			style: .done,
			target: self,
			action: #selector(doneAction(sender:))
		)
	}
	
	@objc func doneAction(sender: AnyObject) {
		dismiss(animated: true)
	}
	
}

// MARK: - Module View & Elements

extension UIViewController {
	
	@objc var moduleWidth: CGFloat { return 320.0 }
	private var moduleInternalVerticalSpacing: CGFloat { return 14.0 }
	
//	func baseModuleView_mainNav(
//		emoji: String,
//		title: String
//	) -> QIOShadowView {
//		let base = baseModuleView(addShadow: false)
//		base.frame = CGRect(
//			x: 0, y: 0,
//			width: QIOCoreViewController.cellHeightWidth,
//			height: QIOCoreViewController.cellHeightWidth
//		)
//
//		let vh: FIOPageHeaderView = FIOPageHeaderView.fromNib()
//		vh.setup(title.capitalized, emoji: emoji)
//		vh.translatesAutoresizingMaskIntoConstraints = false
//		vh.y = 10
//		vh.center.x = base.w/2
//		vh.tag = 32778
//		base.addModuleSubview(vh)
//
//		QIODécor.applyGradientToView(base)
//
//		return base
//	}
	
	func baseModuleView(
		title: String? = nil,
		subtitle: String? = nil,
		condensedTitle: Bool = false,
		titleY: CGFloat = 24.0,
		uppercaseSubtitle: Bool = true,
		addShadow: Bool = true
	) -> QIOShadowView {
		let mod = QIOShadowView(
			frame: CGRect(w: moduleWidth, h: 1.0),
			addShadow: addShadow
		)
		if colorful { mod.backgroundColor = .randomP3 }
		mod.backgroundColor = .white
		if title != nil || subtitle != nil {
			mod.addModuleSubview(
				moduleTitleSubtitle(
					title, subtitle,
					condensedTitle: condensedTitle,
					titleY: titleY,
					uppercaseSubtitle: uppercaseSubtitle,
					width: moduleWidth - 40
				),
				atY: 0
			)
		}
		return mod
	}
	
	// MARK: - Continue Button
	     
	func addContinueButton(
		selector: Selector,
		onObj: AnyObject,
		title: String = "Continue",
		startDisabled: Bool = false,
		toView v: UIView? = nil
	) -> UIButton {
		let buttonHeight: CGFloat = 50.0
		var targetView: UIView = view
		if let passedView = v { targetView = passedView }

		let continueButton = UIButton(frame: .zero)
		continueButton.translatesAutoresizingMaskIntoConstraints = false
		continueButton.setTitle(title, for: .normal)
		continueButton.titleLabel?.font = baseFont(size: 22, bold: true)
		continueButton.addTarget(onObj, action: selector, for: .touchUpInside)
		continueButton.backgroundColor = UIColor("54ACFF")
		continueButton.setTitleColor(.darkGray, for: .disabled)
		continueButton.setBackgroundColor(color: .lightGray, forState: .disabled)
		continueButton.isEnabled = !startDisabled
		continueButton.tag = 5000
		targetView.insertSubview(continueButton, aboveSubview: view)
		continueButton.anchorSidesToSuperview()
		continueButton.anchorBottomTo(targetView.safeAreaLayoutGuide.bottomAnchor)
		continueButton.anchorHeight(buttonHeight)
		
		let extendedContinueButton = UIButton(frame: .zero)
		extendedContinueButton.translatesAutoresizingMaskIntoConstraints = false
		extendedContinueButton.backgroundColor = continueButton.backgroundColor
		extendedContinueButton.setBackgroundColor(color: .lightGray, forState: .disabled)
		extendedContinueButton.addTarget(onObj, action: selector, for: .touchUpInside)
		extendedContinueButton.isEnabled = !startDisabled
		extendedContinueButton.tag = 5001
		targetView.insertSubview(extendedContinueButton, aboveSubview: view)
		extendedContinueButton.anchorSidesToSuperview()
		extendedContinueButton.anchorTopTo(continueButton.bottomAnchor)

		return continueButton
	}
	
	func enableContinueButton() {
		if let cb = _continueButton { cb.isEnabled = true }
		if let ecb = _extendedContinueButton { ecb.isEnabled = true }
	}
	
	var _continueButton: UIButton? {
		var b = view.subviews.first(where: { $0.tag == 5000 })
		if let b = b as? UIButton {
			return b
		}
		else {
			b = view.superview?.subviews.first(where: { $0.tag == 5000 })
			if let b = b as? UIButton {
				return b
			} else {
				return nil
			}
		}
	}
	
	var _extendedContinueButton: UIButton? {
		var b = view.subviews.first(where: { $0.tag == 5001 })
		if let b = b as? UIButton {
			return b
		}
		else {
			b = view.superview?.subviews.first(where: { $0.tag == 5001 })
			if let b = b as? UIButton {
				return b
			} else {
				return nil
			}
		}
	}
	
}
