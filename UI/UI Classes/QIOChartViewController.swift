//
//  QIOChartViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 7/11/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Charts

class QIOChartViewController: UIViewController {

	let LABEL_TEXT_SIZE: CGFloat = 24
	
	var home: QHome!
	var which: QIOHomeCharts = .notSpecified
	var selectedValueLbl: UILabel!
	var titleLbl: UILabel!
	var minusSign: UILabel!
	var dateLbl: UILabel!
	var chart: LineChartView!
	
	// MARK: - View Lifecycle
	
	convenience init(_ whichChart: QIOHomeCharts) {
		self.init(nibName: nil, bundle: nil)
		self.which = whichChart
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		guard let h = QFlow.userHome else {
			fatalError("User home is nil in QIOHomeViewController.")
		}
		home = h

		switch self.which {
		case .flow: flowChart()
		default: break
		}
		
		addDone()
	}
	
	override var prefersHomeIndicatorAutoHidden: Bool {
		return true
	}
	
	// MARK: - Actions
	
	@objc func dismissAction(sender: UIButton) {
		dismiss(animated: false)
	}
	
	// MARK: - Chart Builders
	
	func flowChart() {
		guard let nets = home.financialIndependence?.savingsRate?.netsFor365d else { return }
		renderChart(nets.prefix(90).reversed().logify())
		addChartTitle("Profit History")
		addValueLabelsForFlowChart()
		
//		let line = UIView(frame: .zero)
//		line.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//		line.translatesAutoresizingMaskIntoConstraints = false
//		chart.insertSubview(line, at: 0)
//		line.anchorSidesToSuperview()
//		line.anchorHeight(1)
//		line.anchorCenterYToSuperview()
	}

	func addValueLabelsForFlowChart() {
		let lbl = genLabel(alignment: .center)
		view.addSubview(lbl)
		lbl.anchorTopTo(titleLbl.bottomAnchor, constant: 8)
		lbl.anchorCenterXTo(titleLbl.centerXAnchor)
		selectedValueLbl = lbl
		
		let lbl2 = genLabel()
		lbl2.font = baseFont(size: LABEL_TEXT_SIZE)
		lbl2.text = "-"
		lbl2.isHidden = true
		view.addSubview(lbl2)
		lbl2.anchorCenterYTo(lbl)
		lbl2.anchorTrailingTo(lbl.leadingAnchor, constant: -6)
		minusSign = lbl2
		
		let lbl3 = genLabel(alignment: .center)
		lbl3.font = baseFont(size: LABEL_TEXT_SIZE / 2, bold: false)
		lbl3.text = ""
		view.addSubview(lbl3)
		lbl3.anchorTopTo(lbl.bottomAnchor, constant: 0)
		lbl3.anchorCenterXTo(lbl.centerXAnchor)
		dateLbl = lbl3
	}
	
}

extension QIOChartViewController: ChartViewDelegate {
	
	func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
		switch which {
		case .flow:
			let amount = entry.y.delogify()
			selectedValueLbl.attributedText = amount.asAttributedCurrencyString(fontSize: LABEL_TEXT_SIZE)
			minusSign.isHidden = amount >= 0
			let d = Date().subtract((90 - entry.x).asInt, windowSize: .day)
			dateLbl.text = d.toFriendly(style: .long)
		default: break
		}
	}

	func renderChart(_ values: [Double]?) {
		guard let values = values else { return }
		let out = QIOChartContainer(frame: .zero)
		out.translatesAutoresizingMaskIntoConstraints = false
		out.backgroundColor = UIColor.q_brandGoldLight.withAlphaComponent(0.2)
		out.cornerRadius = 10
		out.clipsToBounds = true
		view.addSubview(out)
		out.anchorToSuperview()
		out.anchorHeight(view.h)
		out.size = CGSize(width: view.w, height: view.h) // This is needed to get the chart to layout initially
		if
			let chartView = buildLineAreaChart(values, which: self.which)
		{
//			chartView.backgroundColor = .randomP3
			chartView.delegate = self
			chartView.dragEnabled = true
			chartView.highlightPerDragEnabled = true
			chartView.highlightPerTapEnabled = true
			chartView.frame = out.bounds
			out.addSubview(chartView)
			chartView.animate(xAxisDuration: 1, yAxisDuration: 1)
			self.chart = chartView
		}
	}
	
}

// MARK: - Generic UI

extension QIOChartViewController {
	
	func addChartTitle(_ ct: String) {
		titleLbl = labelGenerator(
			ct,
			font: baseFont(size: LABEL_TEXT_SIZE),
			alignment: .center)
		titleLbl.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(titleLbl)
		titleLbl.anchorTopToSuperview(constant: 14)
		titleLbl.anchorCenterXToSuperview()
	}
	
	func genLabel(
		textColor: UIColor = .q_38,
		alignment: NSTextAlignment = .center
	) -> UILabel {
		let lbl = UILabel(frame: .zero) // Size is set below, origin must be set later
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.textColor = textColor
		lbl.textAlignment = alignment
		lbl.numberOfLines = 0
		lbl.lineBreakMode = .byWordWrapping
		lbl.sizeToFit()
		return lbl
	}
	
	func addDone() {
		let btn = UIButton(#selector(dismissAction(sender:)), title: "Done")
		btn.setTitleColor(.q_brandGold, for: .normal)
		btn.titleLabel?.font = btn.titleLabel?.font.bold
		view.addSubview(btn)
		btn.anchorTopToSuperview(constant: 20)
		btn.anchorTrailingToSuperview(constant: -20)
		btn.anchorSizeConstant(60, 32)
	}

}
