//
//  FIOScrollViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 12/31/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOScrollViewController: UIViewController {

	// MARK: - Properties
	
 	var viewHeader: FIOPageHeaderView = .fromNib()
	var scroller = UIScrollView()
	var spinner = qSpinner(color: .q_brandGreen)
	var yCursor: CGFloat = 0
	let spaceBetweenModules: CGFloat = 26.0
	let decorativeBackgroundView = UIView()
	private var spinnerKilled: Bool = false
	private var renderedOnce: Bool = false

	override var moduleWidth: CGFloat {
		return view.w - (2 * spaceBetweenModules)
	}
	
	// MARK: - View Lifecycle
	
	override func loadView() {
		super.loadView()

		decorativeBackgroundView.frame = view.bounds
		view.insertSubview(decorativeBackgroundView, at: 0)
		NSLayoutConstraint.activate([
			decorativeBackgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
			decorativeBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor)
		])
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		modalPresentationStyle = .custom
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		if !renderedOnce {
			scroller.autoresizingMask = [.flexibleHeight, .flexibleBottomMargin] // Important for adjustible height header like largeNavBar
			scroller.backgroundColor = .clear
			scroller.frame = view.bounds
			scroller.contentInset = view.safeAreaInsets
			scroller.contentInsetAdjustmentBehavior = .never
			scroller.showsVerticalScrollIndicator = false
			scroller.clipsToBounds = false // important for bounce animation on view load from module
			view.addSubview(scroller)
			spinnerStart()
			renderedOnce = true
		}
	}

	// MARK: - Spinner
	
	private func spinnerStart() {
		if spinnerKilled { return }
		view.addSubview(spinner)
		spinner.anchorCenterToSuperview()
		spinner.startAnimating()
	}
	
	func spinnerStop() {
		spinnerKilled = true
		spinner.stopAnimating()
	}
	
	// MARK: - Custom

	func addModule(_ module: UIView?, isFirstUnderHeader: Bool = false) {
		guard let module = module else { return }
		if
			module.subviews.count == 0 &&
			!(module is UILabel) &&
			!(module is UIButton)
		{ return } // Do not add empty modules.
		if isFirstUnderHeader { yCursor -= 20 } // tuned 🔬
		module.y = yCursor
		module.center.x = scroller.w/2
		scroller.addSubview(module)
		yCursor += module.h + spaceBetweenModules
		scroller.contentSize = CGSize(width: view.w, height: yCursor)
	}
	
	func addScrollerHeight(_ h: CGFloat) {
		scroller.contentSize = CGSize(width: scroller.contentSize.w, height: scroller.contentSize.h + h)
	}

}
