//
//  FIOSliderScrollerSubclass.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 1/16/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class FIOSliderScrollerSubclass: UIScrollView {

	override func touchesShouldCancel(in view: UIView) -> Bool {
		if view is UIButton { return true }
		else { return super.touchesShouldCancel(in: view) }
	}

}
