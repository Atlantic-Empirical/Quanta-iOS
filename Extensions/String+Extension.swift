//
//  String+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/15/18.
//  Copyright © 2018-2019 Flow Capital LLC. All rights reserved.
//

import Foundation
import UIKit

extension String: Error {}

extension String {
	
	/// Returns a string with a single character removed at the specified position
	func remove(at position: Int) -> String {
		if let index = self.index(self.startIndex, offsetBy: position, limitedBy: self.endIndex) {
			var out: String = self
			out.remove(at: index)
			return out
		} else {
			print("Invalid position for remove(at: )")
			return self
		}
	}
	
	func firstWord() -> String {
		return components(separatedBy: " ").first ?? self
	}
	
	func localized() -> String {
		return NSLocalizedString(self, tableName: "Localizable", value: "**\(self)**", comment: "")
	}
	
	func labelHeightForString(font: UIFont, constrainedWidth: CGFloat) -> CGFloat {
		let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: constrainedWidth, height: CGFloat.greatestFiniteMagnitude))
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.font = font
		label.text = self
		label.sizeToFit()
		return label.frame.height
	}
	
	func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
		let boundingBox = self.boundingRect(
			with: constraintRect,
			options: .usesLineFragmentOrigin,
			attributes: [.font: font],
			context: nil
		)
		return ceil(boundingBox.width)
	}
	
	func padding(leftTo paddedLength:Int, withPad pad:String=" ", startingAt padStart:Int=0) -> String {
		let rightPadded = self.padding(toLength:max(count,paddedLength), withPad:pad, startingAt:padStart)
		return "".padding(toLength:paddedLength, withPad:rightPadded, startingAt:count % paddedLength)
	}
	
	func padding(rightTo paddedLength:Int, withPad pad:String=" ", startingAt padStart:Int=0) -> String {
		return self.padding(toLength:paddedLength, withPad:pad, startingAt:padStart)
	}
	
	func padding(sidesTo paddedLength:Int, withPad pad:String=" ", startingAt padStart:Int=0) -> String {
		let rightPadded = self.padding(toLength:max(count,paddedLength), withPad:pad, startingAt:padStart)
		return "".padding(toLength:paddedLength, withPad:rightPadded, startingAt:(paddedLength+count)/2 % paddedLength)
	}
	
	static func random(_ n: Int) -> String
	{
		let a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_-!@#$%^&*()[]~"
		var s = ""
		for _ in 0..<n
		{
			let r = Int(arc4random_uniform(UInt32(a.count)))
			s += String(a[a.index(a.startIndex, offsetBy: r)])
		}
		return s
	}
	
	func prefixToLength(_ length: Int) -> String {
		return String(prefix(length))
	}
	
	var containsEmoji: Bool {
		for scalar in unicodeScalars {
			switch scalar.value {
			case
				0x1F600...0x1F64F, // Emoticons
				0x1F300...0x1F5FF, // Misc Symbols and Pictographs
				0x1F680...0x1F6FF, // Transport and Map
				0x2600...0x26FF,   // Misc symbols
				0x2700...0x27BF,   // Dingbats
				0xFE00...0xFE0F,   // Variation Selectors
				0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
				0x1F1E6...0x1F1FF: // Flags
				return true
			default:
				continue
			}
		}
		return false
	}
		
    static func toLocaleCurrency(_ number: Int) -> String {
        return toLocaleCurrency(Double(number))
    }

	static func toLocaleCurrency(_ number: Double, includeCents: Bool = false, includeMinusSign: Bool = false) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
		formatter.maximumFractionDigits = includeCents ? 2 : 0
		formatter.minusSign = includeMinusSign ? "-" : ""
//		formatter.currencySymbol = "$"
        if let formattedAmount = formatter.string(from: number as NSNumber) {
            return formattedAmount
        } else {
            return "Unable to format input"
        }
    }
    
    func asImage() -> UIImage {
        
        let attributes = [
			NSAttributedString.Key.foregroundColor: UIColor.black,
			NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32)
        ]
        let textSize = self.size(withAttributes: attributes)
        
        let renderer = UIGraphicsImageRenderer(size: textSize)
        let image = renderer.image(actions: {
            context in
            self.draw(at: CGPoint.zero, withAttributes: attributes)
        })
     
        return image
    }
	
	public func asInt() -> Int {
		if let i = Int(self) {
			return i
		} else {
			print("FAILED TO CONVERT STRING TO INT IN asInt()")
			return 0
		}
	}
	
	public func withoutPrefix(_ prefix: String) -> String {
		guard self.hasPrefix(prefix) else { return self }
		return String(self.dropFirst(prefix.count))
	}
	
	/// 1+ Uppercase, 1+ Lowercase, 1+ Special Characters, 1+ Number, and 8+ Total Characters.
	public func isValidPassword() -> Bool {
		do {
			let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\\$%\\^&\\*-])(?=.{8,})"
			let regex = try NSRegularExpression(pattern: passwordRegEx, options: .caseInsensitive)
			if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
				return true
			}
			
		} catch {
			debugPrint(error.localizedDescription)
			return false
		}
		
		return false
	}
	
	public func containsSpecialCharacter() -> Bool {
		do {
			let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
			if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
				return true
			}
			
		} catch {
			debugPrint(error.localizedDescription)
			return false
		}
		
		return false
	}
	
	public var numbersOnly: String {
		return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
	}
	
	public func containsNumber() -> Bool {
		let numbersRange = self.rangeOfCharacter(from: .decimalDigits)
		return (numbersRange != nil)
	}
	
	/// [Source]: https://stackoverflow.com/a/41668104/1449618
	public func formatAsPhoneNumber() -> String? {

		// Remove any character that is not a number
		let numbersOnly = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
		let length = numbersOnly.count
		let hasLeadingOne = numbersOnly.hasPrefix("1")
		
		// Check for supported phone number length
		guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
			return nil
		}
		
		let hasAreaCode = (length >= 10)
		var sourceIndex = 0
		
		// Leading 1
		var leadingOne = ""
		if hasLeadingOne {
			leadingOne = "1 "
			sourceIndex += 1
		}
		
		// Area code
		var areaCode = ""
		if hasAreaCode {
			let areaCodeLength = 3
			guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
				return nil
			}
			areaCode = String(format: "(%@) ", areaCodeSubstring)
			sourceIndex += areaCodeLength
		}
		
		// Prefix, 3 characters
		let prefixLength = 3
		guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
			return nil
		}
		sourceIndex += prefixLength
		
		// Suffix, 4 characters
		let suffixLength = 4
		guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
			return nil
		}
		
		return "+" + leadingOne + areaCode + prefix + "-" + suffix
	}
	
	/// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
	internal func substring(start: Int, offsetBy: Int) -> String? {
		
		guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
			return nil
		}
		
		guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
			return nil
		}
		
		return String(self[substringStartIndex ..< substringEndIndex])
	}

	public func pluralize(_ obj: Any) -> String {
		
		var isSingular = false
		
		if let set = obj as? Array<Any> {
			isSingular = set.count == 1
		} else if let num = obj as? Int {
			isSingular = num == 1
		} else if let num = obj as? Double {
			isSingular = num == 1
		} else if let num = obj as? Float {
			isSingular = num == 1
		} else if let num = obj as? CGFloat {
			isSingular = num == 1
		}
		return self + ( isSingular ? "" : "s" )
	}
	
	public func toPhoneNumber() -> String {
		return replacingOccurrences(
			of: "(\\d{1})(\\d{3})(\\d{3})(\\d+)",
			with: "$1 ($2) $3-$4",
			options: .regularExpression,
			range: nil)
	}
	
}

extension NSMutableAttributedString {
	
	public func setAsLink(textToFind: String, linkURL: String) {
		
		let foundRange = self.mutableString.range(of: textToFind)
		if foundRange.location != NSNotFound {
			self.addAttribute(.link, value: linkURL, range: foundRange)

			let font = self.attribute(.font, at: 0, effectiveRange: nil) as? UIFont
			self.addAttribute(.font, value: UIFont.systemFont(ofSize: font!.pointSize, weight: .semibold), range: foundRange)
		}
	}

	public func setTextFont(_ textToFind: String, font: UIFont) {
		let foundRange = self.mutableString.range(of: textToFind)
		if foundRange.location != NSNotFound {
			self.addAttribute(.font, value: font, range: foundRange)
		}
	}
	
	public func setKerning(_ val: Double) {
		self.addAttribute(.kern, value: val, range: NSMakeRange(0, self.length))
	}

}

extension String.SubSequence {
	
	public var asString: String { return String(self) }
	
}
