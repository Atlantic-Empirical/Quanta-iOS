//
//  Double+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/27/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

extension Double {
	
	func logForBase(forBase base: Double) -> Double {
		return log(self)/log(base)
	}
	
	/// Source: https://stackoverflow.com/questions/36691732/how-to-take-log2-of-a-matrix-having-negative-values-for-boxplot-in-r/36693478#36693478
	func logify() -> Double {
		return log2(pow(abs(self), self.signum()))
	}
	
	func delogify() -> Double {
		return
			pow(
				pow(2, self),
				self.signum()
			)
			* self.signum()
	}
	
	func round(nearest: Double) -> Double {
		let n = 1/nearest
		let numberToRound = self * n
		return numberToRound.rounded() / n
	}
	
	func floor(nearest: Double) -> Double {
		let intDiv = Double(Int(self / nearest))
		return intDiv * nearest
	}
	
	var asInt: Int {
		return Int(self)
	}
	
	var asCGFloat: CGFloat {
		return CGFloat(self)
    }

	func toStringPercent(_ decimalPlaces: Int = 1, includePercentSign: Bool = true) -> String {
		return String(format: "%." + decimalPlaces.asString + "f", self * 100) + (includePercentSign ? "%" : "")
	}

	func toStringDecimals(_ decimalPlaces: Int = 1) -> String {
		return String(format: "%." + decimalPlaces.asString + "f", self)
	}

	var asString: String {
		return String(describing: self)
    }

	func asAttributedPercentString(
		fontSize: CGFloat,
		smallTextSizeFactor: CGFloat = 3,
		places: Int = 1
	) -> NSMutableAttributedString {
		let minTextSize: CGFloat = 9
		let s = self.toStringPercent(places, includePercentSign: true)
		let out = NSMutableAttributedString(string: s)
		let percentFont = baseFont(size: max(fontSize/2, minTextSize))
		let mainFont = baseFont(size: fontSize)
		
		// Whole Number
		out.addAttribute(
			.font,
			value: mainFont,
			range: NSRange(location: 0, length: out.length - 1)
		)
		out.addAttribute(
			.kern,
			value: fontSize / 11, // add some space after the whole number figure, before cents
			range: NSRange(location: out.length - 2, length: 1)
		)
		
		// Percent Symbol
		out.addAttribute(
			.font,
			value: percentFont,
			range: NSRange(location: out.length-1, length: 1)
		)
		out.addAttribute(
			.baselineOffset,
			value: fontSize / 11,
			range: NSRange(location: out.length-1, length: 1)
		)
		
		return out
	}

	func asAttributedCurrencyString(
		fontSize: CGFloat,
		smallTextSizeFactor: CGFloat = 3,
		bold: Bool = true,
		light: Bool = false
	) -> NSMutableAttributedString {
		let minTextSize: CGFloat = 9
		var s = String.toLocaleCurrency(self, includeCents: true)
		s = s.remove(at: s.count - 3) // Remove the period or comma cents divider (currency locale dependent)
		let out = NSMutableAttributedString(string: s)

		var currencyFont: UIFont, dollarsFont: UIFont, centsFont: UIFont

		if light {
			currencyFont = baseFontLight(size: max(fontSize/3, minTextSize))
			dollarsFont = baseFontLight(size: fontSize)
			centsFont = baseFontLight(size: max(fontSize/smallTextSizeFactor, minTextSize))
		} else {
			currencyFont = baseFont(size: max(fontSize/2, minTextSize), bold: bold)
			dollarsFont = baseFont(size: fontSize, bold: bold)
			centsFont = baseFont(size: max(fontSize/smallTextSizeFactor, minTextSize), bold: bold)
		}
		
		// Currency Symbol
		let currencySymbolRange = NSRange(location: 0, length: 1)
		out.addAttribute(
			.font,
			value: currencyFont,
			range: currencySymbolRange
		)
//		out.addAttribute(
//			.foregroundColor,
//			value: UIColor.q_C0,
//			range: currencySymbolRange)
		out.addAttribute(
			.baselineOffset,
			value: fontSize / 11,
			range: currencySymbolRange
		)
		out.addAttribute(
			.kern,
			value: fontSize / 11, // add some space after the currency symbol
			range: currencySymbolRange
		)

		// Whole Number
		out.addAttribute(
			.font,
			value: dollarsFont,
			range: NSRange(location: 1, length: out.length - 2)
		)
		out.addAttribute(
			.kern,
			value: fontSize / 11, // add some space after the whole number figure, before cents
			range: NSRange(location: out.length - 3, length: 1)
		)
		
		// Cents
		out.addAttribute(
			.font,
			value: centsFont,
			range: NSRange(location: out.length - 2, length: 2)
		)
		out.addAttribute(
			.baselineOffset,
			value: dollarsFont.capHeight - centsFont.capHeight,
			range: NSRange(location: out.length - 2, length: 2)
		)
		return out
	}
	
	func toCurrencyString(includeCents: Bool = false, includeMinusSign: Bool = false, cutoffForCents: Double = 10) -> String {
		var _includeCents = false
		if cutoffForCents != 0 {
			_includeCents = abs(self) < cutoffForCents
		}
		if includeCents { // force it
			_includeCents = true
		}
		return String.toLocaleCurrency(self, includeCents: _includeCents, includeMinusSign: includeMinusSign)
	}
	
	func roundToDecimal(_ places: Int) -> Double {
		let multiplier = pow(10, Double(places))
		return Darwin.round(self * multiplier) / multiplier
	}
	
}
