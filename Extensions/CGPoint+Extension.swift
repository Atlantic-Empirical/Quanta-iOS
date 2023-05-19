//
//  CGPoint+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/27/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
	
	public static func + (_ left: CGPoint, _ right: CGPoint) -> CGPoint {
		return CGPoint(x: left.x + right.x, y: left.y + right.y)
	}
	
	public static func += ( _ left: inout CGPoint, _ right: CGPoint) {
		left = left + right
	}
	
}
