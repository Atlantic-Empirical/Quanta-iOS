//
//  Array+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 9/19/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

extension Array {
	
	var countString: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .spellOut
		if let s = formatter.string(from: count.asNSNumber) {
			return s
		} else {
			return count.asString
		}
	}
	
	@inlinable func prefixToArray(_ len: Int) -> Array { return Array(prefix(len)) }
	
}

extension Array where Element == String {
    
    var asSentence: String {
        guard let last = last else { return "" }
        return count <= 2 ? joined(separator:" and ") :
            dropLast().joined(separator: ", ") + ", and " + last
    }

}

extension Array where Element == String? {
	
	var asSentence: String {
		return compactMap { $0 }.asSentence
	}
	
}

extension Array where Element == Int {
	
	var asSentence: String {
		return map { String($0) }.asSentence
	}
	
}

extension Array where Element == Double? {
	
	var asSentence: String {
		let c = compactMap { $0 }
		return c.map { String($0) }.asSentence
	}

	var asCurrencySentence: String {
		return compactMap { $0 }.map { $0.toCurrencyString() }.asSentence
	}

}

extension Array where Element == Double {

	func logify() -> Array {
		return self.map { $0.logify() }
	}
	
	func reverseLogify() -> Array {
		return self.map { $0.delogify() }
	}
	
}

extension ArraySlice where Element == AnyObject {

	@inlinable func toArray() -> Array<AnyObject> { return Array(self) }

}
