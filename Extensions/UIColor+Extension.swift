//
//  UIColor+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/6/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(_ hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) { scanner.scanLocation = 1 }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
	
	var hexString: String {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		
		let multiplier = CGFloat(255.999999)
		
		guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
			print("Failed to get color in hexString. Returned white.")
			return "#FFFFFF"
		}
		
		if alpha == 1.0 {
			return String(
				format: "#%02lX%02lX%02lX",
				Int(red * multiplier),
				Int(green * multiplier),
				Int(blue * multiplier)
			)
		}
		else {
			return String(
				format: "#%02lX%02lX%02lX%02lX",
				Int(red * multiplier),
				Int(green * multiplier),
				Int(blue * multiplier),
				Int(alpha * multiplier)
			)
		}
	}
	
	var desaturated: UIColor {
		var hue: CGFloat = 0
		var brightness: CGFloat = 0
		var alpha: CGFloat = 0
		var saturation: CGFloat = 0
		getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
		return type(of: self).init(hue: hue, saturation: 0, brightness: brightness, alpha: alpha)
	}
	
	var resaturated: UIColor {
		var hue: CGFloat = 0
		var brightness: CGFloat = 0
		var alpha: CGFloat = 0
		var saturation: CGFloat = 0
		getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
		return type(of: self).init(hue: hue, saturation: 1, brightness: brightness, alpha: alpha)
	}

	static var random: UIColor {
		return UIColor(
			red: .random(in: 0...1),
			green: .random(in: 0...1),
			blue: .random(in: 0...1),
			alpha: 1.0
		)
	}

	static var randomP3: UIColor { return UIColor.random.withAlphaComponent(0.3) }

}
