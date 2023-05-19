//
//  FIOAppHomeViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 12/9/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class QIOFlowViewController: FIOScrollViewController {

	// MARK: - Properties
	
	private var rendered: Bool = false
	private var dayScroller: FIOPeriodSliderView = .fromNib()
	private var weekScroller: FIOPeriodSliderView = .fromNib()
	private var monthScroller: FIOPeriodSliderView = .fromNib()
	
	// MARK: - View Lifecycle
	
	override func loadView() {
		super.loadView()
		QMix.track(.viewCoreDetail, ["v": "flow"])
		navigationItem.backBarButtonItem = .nil()
		view.backgroundColor = .white
		view.clipsToBounds = true
		dayScroller.navigationController = navigationController
		weekScroller.navigationController = navigationController
		monthScroller.navigationController = navigationController
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupScroller()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		QIOHaptic.s.prep(.select)
	}
	
	// MARK: - Custom
	
	private func setupScroller() {
		if rendered { return } else { rendered = true }
		viewHeader.setup(
			"Flow",
			subtitle: QString.SectionHeader(.flow),
			emoji: "📊")
		viewHeader.translatesAutoresizingMaskIntoConstraints = false
		addModule(viewHeader)
		addModule(sliderForWindowSize(.day), isFirstUnderHeader: true)
		addModule(sliderForWindowSize(.week))
		addModule(sliderForWindowSize(.month))
		spinnerStop()
	}
	
	private func sliderForWindowSize(_ wz: FIOWindowSize) -> UIView {
		var out: FIOPeriodSliderView
		switch wz {
		case .day: out = dayScroller
		case .week: out = weekScroller
		case .month: out = monthScroller
		default: return UIView()
		}
		QFlow.getThatFlow(windowSize: wz) {
			(result, nextToken) in
			out.windowSize = wz
			out.model = result
		}
		return out
	}

}
