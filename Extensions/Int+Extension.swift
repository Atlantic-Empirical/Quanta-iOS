//
//  Int+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/9/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

extension Int {

    static func random(min: Int = 0, max: Int = Int.max) -> Int {
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
    
    public var asDouble: Double {
		return Double(self)
    }

    public var asCGFloat: CGFloat {
		return CGFloat(self)
    }

	public var asNSNumber: NSNumber {
		return NSNumber(value: self)
	}

    public var asString: String {
		return String(describing: self)
    }
	
	public var asFormattedString: String? {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = NumberFormatter.Style.decimal
		return numberFormatter.string(from: NSNumber(value: self))
	}
    
    public var asCurrencyString: String {
		return String.toLocaleCurrency(self)
    }
    
}

extension UInt {

	public var asString: String {
		return String(describing: self)
	}

}
