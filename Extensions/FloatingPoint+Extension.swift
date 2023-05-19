//
//  FloatingPoint+Extention.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/9/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

extension FloatingPoint {
    
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }

	/// Source: https://forums.swift.org/t/why-no-signum-on-floating-point-types/15659/2
	@inlinable func signum( ) -> Self {
		if self < 0 { return -1 }
		if self > 0 { return 1 }
		return 0
	}
	
}

extension BinaryInteger {

    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }

}
