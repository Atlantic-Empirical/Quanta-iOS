//
//  UITableViewCell+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/23/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

extension UITableViewCell {
	
	@discardableResult
	func addThirdLabelToCell(_ text: String = "", attributedText: NSAttributedString? = nil) -> UILabel {
		var lbl: UILabel!
		subviews.forEach { // checking to see if this reused cell already has the lbl in it so they don't stack up.
			if $0.tag == 327 { lbl = $0 as? UILabel }
		}
		if lbl == nil { lbl = UILabel(frame: .zero) }
		if colorful { lbl.backgroundColor = .randomP3 }
		if let at = attributedText {
			lbl.attributedText = at
		} else {
			lbl.text = text
			lbl.font = baseFont(size: 16, bold: false)
			lbl.kerning = -0.5
		}
		lbl.textColor = .q_8C
		lbl.textAlignment = .right
		lbl.sizeToFit()
		lbl.h = h
		lbl.tag = 327
		addSubview(lbl!)
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34).activate()
		lbl.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2).activate()
		return lbl
	}
	
}
