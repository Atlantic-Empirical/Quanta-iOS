//
//  CGRect+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 1/2/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
	
	var center: CGPoint {
		get {
			return CGPoint(x: w/2, y: h/2)
		}
		set {
			x = newValue.x - (w/2)
			y = newValue.y - (h/2)
		}
	}
	
	var randomPointInRect: CGPoint {
		var point = CGPoint()
		point.x = CGFloat.random(between: origin.x, and: origin.x + width)
		point.y = CGFloat.random(between: origin.y, and: origin.y + height)
		return point
	}
	
	var randomRectInside: CGRect {
		return CGRect(
			o: randomPointInRect,
			wh: CGFloat.random(between: 5, and: min(w, h))
		)
	}

	init(square: CGFloat) {
		self.init(origin: .zero, size: CGSize(square: square))
	}

	init(x: CGFloat, y: CGFloat, size: CGSize) {
		self.init(origin: CGPoint(x: x, y: y), size: size)
	}

	init(o: CGPoint, w: CGFloat, h: CGFloat) {
		self.init(origin: o, size: CGSize(width: w, height: h))
	}
	
	init(o: CGPoint, wh: CGFloat) {
		self.init(origin: o, size: CGSize(width: wh, height: wh))
	}

	init(w: CGFloat, h: CGFloat) {
		self.init(origin: .zero, size: CGSize(width: w, height: h))
	}
	
	public var h: CGFloat {
		get {
			return height
		}
		set {
			self = CGRect(x: origin.x, y: origin.y, width: width, height: newValue)
		}
	}
	
	public var w: CGFloat {
		get {
			return width
		}
		set {
			self = CGRect(x: origin.x, y: origin.y, width: newValue, height: height)
		}
	}
	
	public var x: CGFloat {
		get {
			return origin.x
		}
		set {
			self = CGRect(x: newValue, y: origin.y, width: width, height: height)
		}
	}
	
	public var y: CGFloat {
		get {
			return origin.y
		}
		set {
			self = CGRect(x: origin.x, y: newValue, width: width, height: height)
		}
	}

	public var y_bottom: CGFloat {
		return y + h
	}
	
	public var x_right: CGFloat {
		return x + w
	}

}


