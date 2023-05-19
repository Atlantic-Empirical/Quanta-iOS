//
//  QStringEnums.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/10/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

struct QString {
	
	// MARK: - Section Headers
	
	static func SectionHeader(_ v: eSectionHeader) -> String {
		return ("sectionHeader_" + v.rawValue).localized()
	}

	enum eSectionHeader: String {
		case home
		case flow
		case income
		case spend
		case surplus
		case moneyRental
		case rainyDay
		case FI
		case ble
	}

}
