//
//  UIBarButtonItem+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/25/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

extension UIBarButtonItem {
	
	static func `nil`() -> UIBarButtonItem {
		return UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}

	convenience init(imageName: String, action: Selector, actionObj: AnyObject, hw: CGFloat) {
		let b = UIButton(
			frame: .zero,
			action:  action,
			actionObj: actionObj,
			img: UIImage(named: imageName)
		)
		self.init(customView: b)
		NSLayoutConstraint.activate(
			[
				(self.customView?.widthAnchor.constraint(equalToConstant: hw))!,
				(self.customView?.heightAnchor.constraint(equalToConstant: hw))!
			]
		)
	}
	
}
