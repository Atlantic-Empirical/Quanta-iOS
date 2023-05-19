//
//  QIOCharting.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 7/12/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Charts

func buildLineAreaChart(
	_ valuesIn: [Double],
	which: QIOHomeCharts
) -> LineChartView? {
	guard
		valuesIn.count > 1,
		let minVal = valuesIn.min(),
		let maxVal = valuesIn.max()
		else { return nil }
	print("Building line area chart for: \(which.asString)")
	
	var drawZeroLine: Bool = false

	switch which {
	case .flow:
		drawZeroLine = true
	default: break
	}
	
	
//		maxVal = max(maxVal, 100)
//		minVal = min(minVal, 0)
//	print(valuesIn)
//	let dataLimits: (min: Double, max: Double) = (minVal, maxVal)
	let v = max(maxVal, abs(minVal))
//	print(dataLimits)
//	print(v)
	let axisMarginFactor: Double = 0.2
	let margin = (maxVal + abs(minVal)) * axisMarginFactor
	let axisLimits: (min: Double, max: Double) = (-v - margin, v + margin)
//	print(axisLimits)
	
	let chartView = LineChartView()
	chartView.backgroundColor = .clear
	chartView.chartDescription?.enabled = false
	chartView.dragEnabled = false
	chartView.setScaleEnabled(false)
	chartView.pinchZoomEnabled = false
	chartView.highlightPerDragEnabled = false
	chartView.legend.enabled = false
	chartView.drawBordersEnabled = false
	chartView.minOffset = 0
	chartView.highlightPerTapEnabled = false
	chartView.doubleTapToZoomEnabled = false
	chartView.highlightPerTapEnabled = false
	
	let xAxis = chartView.xAxis
	xAxis.drawGridLinesEnabled = false
	xAxis.drawAxisLineEnabled = false
	xAxis.centerAxisLabelsEnabled = false
	xAxis.drawLabelsEnabled = false
	
	let leftAxis = chartView.leftAxis
	leftAxis.drawGridLinesEnabled = false
	leftAxis.drawAxisLineEnabled = false
	leftAxis.drawLabelsEnabled = false
	leftAxis.axisMaximum = axisLimits.max
	leftAxis.axisMinimum = axisLimits.min
//		leftAxis.spaceTop = axisMarginFactor.asCGFloat // these don't seem to work
//		leftAxis.spaceBottom = axisMarginFactor.asCGFloat
	leftAxis.drawZeroLineEnabled = drawZeroLine
	leftAxis.zeroLineColor = UIColor.black.withAlphaComponent(0.2)
	leftAxis.zeroLineWidth = 1
	leftAxis.zeroLineDashPhase = 0
	leftAxis.zeroLineDashLengths = [8, 3]
	
	chartView.rightAxis.enabled = false
	chartView.legend.form = .line
	
	// Set data
	let values3 = valuesIn.enumerated().map { (index, element) -> ChartDataEntry in
		return ChartDataEntry(x: index.asDouble, y: element)
	}
	
	let set1 = LineChartDataSet(entries: values3, label: "")
	set1.axisDependency = .left
	set1.setColor(.q_brandGold)
	set1.lineWidth = 1.5
	set1.drawCirclesEnabled = false
	set1.drawValuesEnabled = false
	set1.fillAlpha = 0.33
	set1.fillColor = .q_brandGold
	set1.fillFormatter = QIOChartFillFormatter()
	set1.drawFilledEnabled = true
	set1.highlightColor = set1.fillColor
	set1.drawCircleHoleEnabled = false
	set1.mode = .horizontalBezier
	
	chartView.data = LineChartData(dataSet: set1)
	return chartView
}

class QIOChartContainer: UIView {
	
	/// This sets the frame of the ChartView to that of it's parent, as the parent's frame changes due to autolayout.
	override func layoutSubviews() {
		super.layoutSubviews()
		subviews.first?.frame = bounds
	}
	
}

enum QIOHomeCharts: Int {
	case flow
	case rainyDay
	case creditUtilization
	case notSpecified
	
	var asString: String {
		return "\(self)"
	}
}

/// Doc: https://weeklycoding.com/mpandroidchart-documentation/fillformatter/
class QIOChartFillFormatter: NSObject, IFillFormatter {
	
	typealias Block = (
		_ dataSet: ILineChartDataSet,
		_ dataProvider: LineChartDataProvider) -> CGFloat
	
	@objc var block: Block?
	
	override init() { }
	
	@objc init(block: @escaping Block) {
		self.block = block
	}
	
	@objc static func with(block: @escaping Block) -> QIOChartFillFormatter? {
		return QIOChartFillFormatter(block: block)
	}
	
	func getFillLinePosition(
		dataSet: ILineChartDataSet,
		dataProvider: LineChartDataProvider) -> CGFloat
	{
		// Tpf new version - probably only works for single line charts, doesn't matter for now
		guard block == nil else { return block!(dataSet, dataProvider) }
		if dataSet.yMax > 0.0 && dataSet.yMin < 0.0 {
			return 0
		} else {
			return dataProvider.chartYMin.asCGFloat
		}
		
		// Original
		//		guard block == nil else { return block!(dataSet, dataProvider) }
		//		var fillMin: CGFloat = 0.0
		//
		//		if dataSet.yMax > 0.0 && dataSet.yMin < 0.0
		//		{
		//			fillMin = 0.0
		//		}
		//		else if let data = dataProvider.data
		//		{
		//			let max = data.yMax > 0.0 ? 0.0 : dataProvider.chartYMax
		//			let min = data.yMin < 0.0 ? 0.0 : dataProvider.chartYMin
		//			fillMin = CGFloat(dataSet.yMin >= 0.0 ? min : max)
		//		}
		//
		//		print("fillMin = \(fillMin)")
		//		return fillMin
	}
	
}
