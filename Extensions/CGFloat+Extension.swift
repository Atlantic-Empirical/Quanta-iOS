//
//  CGFloat+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/27/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {

	static var random: CGFloat { return CGFloat(arc4random()) / CGFloat(UInt32.max) }
	
	static func random(between x: CGFloat, and y: CGFloat) -> CGFloat {
		let (start, end) = x < y ? (x, y) : (y, x)
		return start + CGFloat.random * (end - start)
	}
	
	func round(nearest: CGFloat) -> CGFloat {
		let n = 1/nearest
		let numberToRound = self * n
		return numberToRound.rounded() / n
	}
	
	func floor(nearest: CGFloat) -> CGFloat {
		let intDiv = CGFloat(Int(self / nearest))
		return intDiv * nearest
	}

	public var asFloat: Float {
		return Float(self)
	}

    public var asDouble: Double {
		return Double(self)
    }

	public var asInt: Int {
		return Int(self)
	}

    public var asString: String {
		return String(describing: self)
    }
    
}
