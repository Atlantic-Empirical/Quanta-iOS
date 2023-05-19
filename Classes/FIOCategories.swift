//
//  FIOSpendCategories.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 12/17/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOCategories: NSObject {

	var startDate: String = ""
	var endDate: String = ""
	var total: Double = 0
//	var amounts = [Double]()
//	var percentages = [Double]()
//	var names = [String]()
//	var descriptions = [String]()
//	var tids = [[String]]()
	var dayCount: Int = 0
	var cats: [QIOCat]?
	
	// MARK: - Lifecycle
	
	init(psc: QPeriod.PeriodSummary.Category, _startDate: String, _endDate: String) {
		super.init()
		startDate = _startDate
		endDate = _endDate
		total = psc.total
	}

	init(uhs: QSpending.Category) {
		super.init()
		startDate = uhs.startDate
		endDate = uhs.endDate
		total = uhs.total
//		tids = uhs.tids
		dayCount = uhs.lookbackDayCount
		cats = uhs.cats.map { QIOCat($0) }
	}
	
	// MARK: Custom
	
	func percentageFor(_ name: Names) -> Double {
		return cats?[name.rawValue].percentage ?? 0
	}

	public func percentageStringFor(_ name: Names) -> String {
		return (cats?[name.rawValue].percentage ?? 0).toStringPercent()
	}

	public func amountFor(_ name: Names) -> Double {
		return cats?[name.rawValue].amount ?? 0
	}

	public func amountFor(_ categoryId: FIOTransactionCategoryId) -> Double {
		return cats?[FIOCategories.indexForFIOCategoryId(categoryId.rawValue)].amount ?? 0
	}

	public func userFacingNameFor(_ name: Names) -> String {
		return cats?[name.rawValue].name ?? "Unknown category"
	}
	
	public func descriptionFor(_ name: Names) -> String {
		return cats?[name.rawValue].description ?? "Category description not found"
	}
	
	public static func indexForFIOCategoryId(_ fioCatId: Int) -> Int {
		let fioCategoryIds = [ 0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000 ]
		return fioCategoryIds.firstIndex(of: fioCatId) ?? -1
	}

	// MARK: Enum
	
	public enum Names: Int {
		case Mystery = 0
		case Fixed = 1
		case FriendsAndFamily = 2
		case HealthAndFitness = 3
		case AtHome = 4
		case OnTheTown = 5
		case Transpo = 6
		case Travel = 7
		case MoneyFire = 8
		case CareerProfessional = 9
		case Other = -1
	}
	
	public static func categoryNameForId(_ fioCategoryId: Int) -> String {
		switch (fioCategoryId) {
		case 0...99: return "Mystery"
		case 100...199: return "Transfers"
		case 200...299: return "Income"
		case 300...399: return "Refunds"
		case 400...499: return "Unidentified Deposit"
		case 500...599: return "Interest Earned"
		case 1000...1999: return "Shopping"
		case 2000...2999: return "Family & Friends"
		case 3000...3999: return "Health & Fitness"
		case 4000...4999: return "At Home"
		case 5000...5999: return "On the Town"
		case 6000...6999: return "Transportation"
		case 7000...7999: return "Travel"
		case 8000...8999: return "Money Fire"
		case 9000...9999: return "Career, Professional"
		default: return "*** NO CATEGORY ***"
		}
	}

}

class QIOCat {
	
	var name: String = ""
	var description: String = ""
	var amount: Double = 0
	var percentage: Double = 0
	var emoji: String = ""
	var id: Int = 0
	var tids: [String]?
	
	init(_ cat: GetUserHomeQuery.Data.GetUserHome.Spending.Category.Cat) {
		name = cat.name
		description = cat.description
		amount = cat.amount
		percentage = cat.percentage
		emoji = cat.emoji
		id = cat.id
		tids = cat.tids
	}
	
}

public enum FIOTransactionCategoryId: Int {
	case Mystery = 0
	case Transfers = 100
	case Transfers_CreditCardPayment = 101
	case RecognizedIncome = 200
	case Refunds = 300
	case UnidentifiedDeposits = 400
	case InterestEarned = 500
	case Fixed = 1000
	case FamilyAndFriends = 2000
	case HealthAndFitness = 3000
	case AtHome = 4000
	case OnTheTown = 5000
	case Transpo = 6000
	case Travel = 7000
	case MoneyFire = 8000
	case CareerProfessional = 9000
	case Income = 10000
	
	var asString: String {
		return "\(self)"
	}
	
	var asFriendlyString: String {
		switch self {
		case .AtHome: return "At Home"
		case .CareerProfessional: return "Professional"
		case .FamilyAndFriends: return "Family & Friends"
		case .Fixed: return "Fixed Fundamentals"
		case .HealthAndFitness: return "Health & Fitness"
		case .Income: return "Income"
		case .MoneyFire: return "Money Fire"
		case .Mystery: return "Mystery Money"
		case .OnTheTown: return "On The Town"
		case .Transpo: return "Transportation"
		case .Travel: return "Travel"
		case .Transfers: return "Transfers"
		case .Transfers_CreditCardPayment: return "Credit Card Payment"
		case .RecognizedIncome: return "Regular Income"
		case .Refunds: return "Refunds"
		case .UnidentifiedDeposits: return "Unidentified Deposits"
		case .InterestEarned: return "Interest Earned"
		}
	}
	
	static let count: Int = {
		var max: Int = 0
		while let _ = FIOTransactionCategoryId(rawValue: max) { max += 1 }
		return max
	}()
	
}
