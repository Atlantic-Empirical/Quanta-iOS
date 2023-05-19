//
//  QIORainbowView.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 7/14/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIORainbowView: UIView {
	
	let gradient = CAGradientLayer()
	var pctLabel: UILabel?
	var percentage: Double = 0
	var indicator: FIOTriangleView!
	var indicatorTop: FIOTriangleView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func setPercentageIndicator(_ percentageLbl: UILabel, _ pctVal: Double) {
		percentage = pctVal
		pctLabel = percentageLbl
		addSubview(pctLabel!)
		indicator = FIOTriangleView(frame: CGRect(w: 10, h: 8))
		indicator.backgroundColor = .clear
		indicator.fillColor = pctLabel?.textColor ?? .white
		addSubview(indicator)
		
		indicatorTop = FIOTriangleView(frame: CGRect(w: 10, h: 8))
		indicatorTop.backgroundColor = .clear
		indicatorTop.fillColor = pctLabel?.textColor ?? .white
		addSubview(indicatorTop)
		indicatorTop.transform = indicator.transform.rotated(by: 180.degreesToRadians)
	}
	
	private func commonInit() {
		gradient.colors = [
			UIColor("00A000").cgColor,
			UIColor("FFDA33").cgColor,
			UIColor.orange.cgColor,
			UIColor.red.cgColor
		]
		gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
		//			gradient.locations = [0.0, 0.4, 0.7, 1.0]
		layer.addSublayer(gradient)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let targetX: CGFloat = percentage.asCGFloat * w
		if let p = pctLabel {
			p.center.x = targetX
			if p.x < 0 { p.x = 12 }
			else if p.x > p.superview!.w { p.x = p.superview!.w - p.w - 12 }
		}
		pctLabel?.h = h
		indicator.center.x = targetX
		indicator.y = h - 6
		indicatorTop.center.x = targetX
		indicatorTop.y = 0
	}
	
	override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		gradient.frame = bounds
		gradient.cornerRadius = cornerRadius
	}
	
}
