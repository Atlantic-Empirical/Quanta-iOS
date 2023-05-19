//
//  UILabel+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/3/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

@IBDesignable
extension UILabel {

    @IBInspectable
	var kerning: CGFloat {
		get {
			var kerning:CGFloat = 0
			if let attributedText = self.attributedText {
				attributedText.enumerateAttribute(NSAttributedString.Key.kern,
												  in: NSMakeRange(0, attributedText.length),
												  options: .init(rawValue: 0)) { (value, range, stop) in
													kerning = value as? CGFloat ?? 0
				}
			}
			return kerning
		}
        set {
            if let currentAttibutedText = self.attributedText {
                let attribString = NSMutableAttributedString(attributedString: currentAttibutedText)
				attribString.addAttributes([NSAttributedString.Key.kern:newValue], range:NSMakeRange(0, currentAttibutedText.length))
                self.attributedText = attribString
            }
        }
    }
    
	var textRectSimple: CGRect {
		return textRect(forBounds: bounds, limitedToNumberOfLines: 1)
    }
	
	/// In points
	func setLineSpacing(_ val: CGFloat) {
		guard let s = text else { return }
		let attributedString = NSMutableAttributedString(string: s)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = val
		attributedString.addAttribute(
			NSAttributedString.Key.paragraphStyle,
			value: paragraphStyle,
			range: NSMakeRange(0, attributedString.length)
		)
		attributedText = attributedString
	}
	
}
