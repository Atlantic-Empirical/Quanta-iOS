//
//  CGSize+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 9/30/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
	
	init(square: CGFloat) {
		self.init(width: square, height: square)
	}
	
	public func isSameSize(_ newSize: CGSize) -> Bool {
		return self == newSize
	}

	public var h: CGFloat {
		get {
			return height
		}
		set {
			self = CGSize(width: width, height: newValue)
		}
	}
	
	public var w: CGFloat {
		get {
			return width
		}
		set {
			self = CGSize(width: newValue, height: height)
		}
	}
	
}
