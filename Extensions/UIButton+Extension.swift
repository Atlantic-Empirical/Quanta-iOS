//
//  UIButton+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 4/21/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

extension UIButton {

	convenience init(frame: CGRect, action: Selector, actionObj: AnyObject? = nil, img: UIImage?) {
		self.init(frame: frame, action: action, actionObj: actionObj)
		if let i = img {
			setImage(i, for: .normal)
		}
	}

	convenience init(frame: CGRect, action: Selector, actionObj: AnyObject? = nil, title: String = "", tag: Int = 0, img: UIImage?) {
		self.init(frame: frame, action: action, actionObj: actionObj, title: title, tag: tag)
		if let i = img {
			setImage(i, for: .normal)
		}
	}

	/// When using constraints
	convenience init(_ action: Selector, actionObj: AnyObject? = nil, title: String = "", tag: Int = 0) {
		self.init(frame: .zero, action: action, actionObj: actionObj, title: title, tag: tag)
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	convenience init(frame: CGRect, action: Selector, actionObj: AnyObject? = nil, title: String = "", tag: Int = 0) {
		self.init(frame: frame)
		self.tag = tag
		setTitle(title, for: .normal)
		addTarget(actionObj, action: action, for: .touchUpInside)
	}
	
	func setBackgroundColor(color: UIColor, forState: UIControl.State) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
		UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let colorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.setBackgroundImage(colorImage, for: forState)
	}
	
}
