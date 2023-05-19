//
//  FIOGenericTextViewViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 12/27/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import Down
import WebKit

class FIOGenericTextViewViewController: UIViewController {
	
	// MARK: - Properties
	private var didAppearOnce = false
	private var markdownView: DownView?
	private var which: QIOLibraryInventory?
	private var addBottomBarButton: Bool = false
	private var bottomButtonSelector: Selector?
	private var bottomButtonTitle: String = ""
	private var bottomButtonObject: Any?
	private var bottomBarButton: UIButton?

	// MARK: - View Lifecycle

	convenience init(_ forWhich: QIOLibraryInventory) {
		self.init()
		which = forWhich
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !didAppearOnce {
			didAppearOnce = true
			render()
		}
	}

	override func viewDidLayoutSubviews() {
		print(#function)
		if addBottomBarButton { _addBottomBarButton() }
	}

	// MARK: - IBActions
	
	@objc public func dismissSelf() {
		navigationController?.dismiss(animated: true)
	}
	
	// MARK: - Custom
	
//	public override func addDoneButton() {
//		navigationItem.rightBarButtonItem =
//			UIBarButtonItem(
//				title: "Done",
//				style: .done,
//				target: self,
//				action: #selector(dismissSelf)
//		)
//	}
	
	private func render() {
		guard let w = which else { return }

		switch w {
		case .WhatIsQuanta: title = "What Is \(appName)"
		case .WhyWeCharge: title = "Why We Charge"
		case .PrivacySecurity: title = "Privacy & Security"
		case .HowQuantaWorks: title = "How \(appName) Works"
		case .PrivacyPolicy: title = "Privacy Policy"
		case .TermsOfUse: title = "Terms of Use"
		case .CostOfADollar: title = "About Cost of a Dollar"
		case .Income: title = "About Income"
		case .MoneyRental: title = "About Money Rent"
		case .ProjectedPeriod: title = "About Quanta Flow"
		case .StandardPeriod: title = "About Standard Periods"
		case .CreditCards: title = "About Money Rental"
		case .Spending: title = "Spending"
//		case .Categories: title = "About Categories"
//		case .RecurringSpending: title = "Recurring Spending"
		case .AboutQuanta: title = "Why We Built Quanta"
		case .LivingProfitably: title = "Living Profitably"
		case .RainyDayFunds: title = "Rainy Day Funds"
		case .FinancialIndependence: title = "Financial Independence"
		case .BaseLivingExpenses: title = "Base Living Expenses"
		}

		var markdown = "Text is missing"
		if w == .CreditCards {
			let costOfADollar = QIOLibrary.stringFor(.CostOfADollar)
			let moneyRent = QIOLibrary.stringFor(.MoneyRental)
			markdown = "# Money Rental\n\n" + moneyRent + "\n\n# Cost of a Dollar\n\n" + costOfADollar
		} else {
			markdown = QIOLibrary.stringFor(w)
		}
		
		guard
			let bundle = Bundle(for: type(of: self)).url(forResource: "DownCSS", withExtension: "bundle"),
			let templateBundle = Bundle(url: bundle)
			else { return }

		markdownView = try? DownView(
			frame: view.bounds.insetBy(dx: 14, dy: 0),
			markdownString: markdown,
			templateBundle: templateBundle
		)
		
		markdownView?.navigationDelegate = self
		view.addSubview(markdownView!)
		adjustTextViewHeightIfNeeded()
		
//		print(self.view.safeAreaInsets)
//		print(self.view.safeAreaLayoutGuide)
//		print(self.view.layoutMarginsGuide)
		
//		NSLayoutConstraint.activate([
//			markdownView!.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
//		])
//		markdownView!.scrollView.contentInsetAdjustmentBehavior = .always
//		navigationItem.largeTitleDisplayMode = .always

//		markdownView!.topAnchor = self.safe
//		markdownView!.setNeedsLayout()
//		markdownView.scrollsToTop = true
//		markdownView.textContainerInset = .zero // reduce the space at the top of the text view (above text)
//		markdownView.setContentOffset(.zero, animated: false) // scroll back to the top
//		markdownView!.scrollView.scrollsToTop = true
//		markdownView!.scrollView.setContentOffset(.zero, animated: false)
	}
	
	private func adjustTextViewHeightIfNeeded() {
		if let b = bottomBarButton, let mdv = markdownView {
			mdv.h = view.h - b.h
		}
	}
	
	private func _addBottomBarButton() {
		let lg: UILayoutGuide = view.safeAreaLayoutGuide
		let buttonHeight: CGFloat = 50.0
		let startOfTheAction: CGFloat = lg.layoutFrame.h + lg.layoutFrame.y - buttonHeight
		bottomBarButton = UIButton(frame: CGRect(x: 0, y: startOfTheAction, width: lg.layoutFrame.w, height: buttonHeight))
		if let b = bottomBarButton {
			b.setTitle(bottomButtonTitle, for: .normal)
			b.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
			b.addTarget(bottomButtonObject!, action: bottomButtonSelector!, for: .touchUpInside)
			b.backgroundColor = UIColor("54ACFF")
			view.addSubview(b)
			adjustTextViewHeightIfNeeded()
			let r = UIView(frame: CGRect(x: 0, y: b.y_bottom, width: lg.layoutFrame.w, height: 1000))
			r.backgroundColor = b.backgroundColor
			view.addSubview(r)
		}
	}
	
	public func addBottomBarButton(_ title: String = "Continue", selector: Selector, onObject: Any) {
		addBottomBarButton = true
		bottomButtonSelector = selector
		bottomButtonTitle = title
		bottomButtonObject = onObject
	}
	
}

extension FIOGenericTextViewViewController: WKNavigationDelegate {
	
	func webView(
		_ webView: WKWebView,
		decidePolicyFor navigationAction: WKNavigationAction,
		decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
	) {
		if let url = navigationAction.request.url {
			if var h = url.host {
				print(h)
				h = h.lowercased()
				var vc: UIViewController?
				if h == "open.doc" {
					if let which = QIOLibraryInventory.fromString(string: url.lastPathComponent) {
						vc = FIOGenericTextViewViewController(which)
					}
				} else if h == "open.view" {
					switch url.lastPathComponent {
					case "RecurringIncome": vc = FIOIncomeViewController()
//					case "StandardSpending": vc = QIOTbd()
//					case "HelpImprove": vc = QIOTbd()
					default:
						decisionHandler(.cancel)
						return
					}
				} else if h == "contact.us" {
					AppDelegate.sharedInstance.contactActionSheet()
				} else if !url.isFileURL {
					vc = QIOWebKitViewController(url.absoluteURL)
				}
				if let nc = navigationController, let v = vc {
					decisionHandler(.cancel)
					nc.pushViewController(v, animated: true)
				} else {
					decisionHandler(.allow)
				}
			} else {
				decisionHandler(.allow)
			}
		} else {
			decisionHandler(.allow)
		}
	}

}
