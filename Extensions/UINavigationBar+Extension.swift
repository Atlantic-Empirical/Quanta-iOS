//
//  UINavigationBar+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/10/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

extension UINavigationBar {

	func customize(
		tintColor tc: UIColor = .q_brandGold, // UIColor("FFBB33")
		bgColor: UIColor = .clear,
		withGradient: Bool = false,
		translucent: Bool = true,
		emptyBgImage: Bool = true
	) {
		let barBGCMaxAlpha: CGFloat = 0.5
		isTranslucent = translucent
		backgroundColor = bgColor
		tintColor = tc
		titleTextAttributes = [
			NSAttributedString.Key.foregroundColor: tc,
			NSAttributedString.Key.font: baseFont(size: 22)
		]
		setBackgroundImage(emptyBgImage ? UIImage() : nil, for: .default)
		setValue(true, forKey: "hidesShadow")  // Remove 1 pixel line
		prefersLargeTitles = false
		if withGradient { addGradient(barBGCMaxAlpha, bgColor) }
	}

	func setupForQuantaHome() {
		customize(bgColor: .white, withGradient: false, translucent: false, emptyBgImage: false)
	}
	
	func addGradient(_ toAlpha: CGFloat, _ color: UIColor) {
		let gradient = CAGradientLayer()
		gradient.colors = [
			color.withAlphaComponent(toAlpha).cgColor,
			color.withAlphaComponent(toAlpha).cgColor,
			color.withAlphaComponent(0).cgColor
		]
		gradient.locations = [0, 0.8, 1]
//		gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//		gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
		var frame = bounds
		frame.h += UIApplication.shared.statusBarFrame.size.height
		frame.y -= UIApplication.shared.statusBarFrame.size.height
		gradient.frame = frame
		layer.insertSublayer(gradient, at: 1)
	}
	
}
