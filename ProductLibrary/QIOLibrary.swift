//
//  QIOMarkdown.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 4/8/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOLibrary {
	
	static func stringFor(_ which: QIOLibraryInventory) -> String {
		guard let path = Bundle.main.path(forResource: which.asString, ofType: "md") else {
			return "<File Not Found>"
		}
		do {
			return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
		} catch {
			return "<Failed to load file>"
		}
	}

	static func stringFor(_ fileName: String) -> String {
		guard let path = Bundle.main.path(forResource: fileName, ofType: "md") else {
			return "<File Not Found>"
		}
		do {
			return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
		} catch {
			return "<Failed to load file>"
		}
	}

	static var Sections: [String] = {
		var out = [String]()
		out.append("About Quanta")
		out.append("Financial Calculations")
		out.append("Legal Things")
		return out
	}()

	static func SectionContents(_ sec: QIOLibrarySections) -> [QIOLibraryInventory] {
		var out = [QIOLibraryInventory]()
		switch sec {
		case .About_Quanta:
			out.append(.WhatIsQuanta)
			out.append(.HowQuantaWorks)
			out.append(.PrivacySecurity)
			out.append(.AboutQuanta)
			out.append(.WhyWeCharge)
			return out
		case .Financial_Calculations:
			out.append(.ProjectedPeriod)
			out.append(.StandardPeriod)
			out.append(.Income)
//			out.append(.Categories)
//			out.append(.RecurringSpending)
			out.append(.Spending)
			out.append(.CreditCards)
			out.append(.LivingProfitably)
			out.append(.RainyDayFunds)
			out.append(.FinancialIndependence)
//			out.append(.CostOfADollar) // intentionally excluded because they're covered by .CC
//			out.append(.MoneyRent)
			out.append(.BaseLivingExpenses)
			return out
		case .Legal_Things:
			out.append(.PrivacyPolicy)
			out.append(.TermsOfUse)
			return out
		}
	}

}

public enum QIOLibrarySections: Int {
	case About_Quanta
	case Financial_Calculations
	case Legal_Things

	var asString: String { return "\(self)".replacingOccurrences(of: "_", with: " ") }
	
	static let count: Int = {
		var max: Int = 0
		while let _ = QIOLibrarySections(rawValue: max) { max += 1 }
		return max
	}()
}

enum QIOLibraryInventory: Int {
	case HowQuantaWorks
	case PrivacySecurity
	case WhyWeCharge
	case CostOfADollar
	case MoneyRental
	case ProjectedPeriod
	case StandardPeriod
	case Income
	case Spending
	case CreditCards
	case LivingProfitably
//	case Savings
//	case ReadingList
	case AboutQuanta
	case WhatIsQuanta
	case TermsOfUse
	case PrivacyPolicy
	case RainyDayFunds
	case FinancialIndependence
	case BaseLivingExpenses
	
	var asString: String { return "\(self)" }
	
	static func fromString(string: String) -> QIOLibraryInventory? {
		var i = 0
		while let item = QIOLibraryInventory(rawValue: i) {
			if item.asString.lowercased() == string.lowercased() { return item }
			i += 1
		}
		return nil
	}
	
	static let count: Int = {
		var max: Int = 0
		while let _ = QIOLibraryInventory(rawValue: max) { max += 1 }
		return max
	}()

}
