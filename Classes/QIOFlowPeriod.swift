//
//  QIOFlowPeriod.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 7/9/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import AWSAppSync

class QIOFlowPeriod {
	
	// MARK: - Properties

	var initializedSuccessfully: Bool = false
	var periodId: String = ""
	var windowSize: Int = 0
	var daysInRange: Int = 0
	var startDate: String = ""
	var endDate: String = ""
	var daysRemainingInPeriod: Int = 0
	var dayNets = [Double]()
	var includesEndOfData: Bool = false
	var projection: QIOFlowPeriodProjection?
	var periodSummary: QIOFlowPeriodSummary!

	// MARK: - Lifecycle
	
	init (with ss: GraphQLSelectionSet) {
		periodId = ss.snapshot["periodId"] as? String ?? "<>"
		windowSize = ss.snapshot["windowSize"] as? Int ?? -1
		daysInRange = ss.snapshot["daysInRange"] as? Int ?? -1
		startDate = ss.snapshot["startDate"] as? String ?? "<>"
		endDate = ss.snapshot["endDate"] as? String ?? "<>"
		daysRemainingInPeriod = ss.snapshot["daysRemainingInPeriod"] as? Int ?? -1
		if let dn = ss.snapshot["dayNets"] as? [Double] { dayNets = dn }
		includesEndOfData = ss.snapshot["includesEndOfData"] as? Bool ?? false
		if
			let ps = ss.snapshot["projection"],
			let pps: Dictionary<String, Any> = ps as? Dictionary<String, Any>
		{
			projection = QIOFlowPeriodProjection(with: pps)
		}
		if
			let ps = ss.snapshot["periodSummary"],
			let pps: Dictionary<String, Any> = ps as? Dictionary<String, Any>
		{
			periodSummary = QIOFlowPeriodSummary(with: pps)
		}
		initializedSuccessfully = true
	}
	
	// MARK: - Custom
	
	var description: String {
		var out: String = "========================================="
		
		out.append("\n\nPERIOD:\n")
		
		out.append("\tStart Date: " + startDate + "\n")
		out.append("\tEnd Date: " + endDate + "\n")
		out.append("\tDays In Range: " + daysInRange.asString + "\n")
		out.append("\tDays Remaining in Period: " + daysRemainingInPeriod.asString + "\n")
		out.append("\tIncludes End of Data: " + includesEndOfData.asString + "\n")
		out.append(periodSummary.description)
		
		if let val = projection { out.append("\tProjection: " + val.description + "\n") }
		//			if let val = dayNets { out.append("\tDay Nets: " + val.asSentence + "\n") }
		//			if let val = endOfDataDateString { out.append("\tEnd of Data Date: " + val + "\n") }
		
		out.append("\n^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
		out.append("\n\n")
		
		return out
	}
	
	var title: String {
		let t = titles()
		return t.mainTitle
	}
	
	var hoursInPeriod: Int {
		return daysInRange * 24
	}
	
	func titles() -> QIOPeriodTitles {
		var out = QIOPeriodTitles()
		
		if includesEndOfData {
			out.mainTitle = "🏁 " + out.mainTitle + " 🏁"
			out.subTitle = "End of data!"
			return out
		}
		
		let period = FIOFlowPeriod(withPeriod: self)
		let wz = FIOWindowSize.init(fuzzyDays: daysInRange)!
		
		switch wz {
			
		case .day :
			let date = Date.fromYYYYMMDD(startDate)
			let dateString = date.monthName + " " + String(date.day) + date.suffix
			
			if period == .yesterday {
				out.mainTitle = "Yesterday"
				out.subTitle = dateString.uppercased()
			} else {
				out.mainTitle = dateString
				out.subTitle = "tbd".uppercased()
			}
			
		case .week:
			let _startDate = Date.fromYYYYMMDD(startDate)
			let _endDate = Date.fromYYYYMMDD(endDate)
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .medium
			dateFormatter.timeStyle = .none
			dateFormatter.locale = Locale(identifier: "en_US")
			
			var startStr = ""
			var endStr = ""
			
			if (_startDate.month == _endDate.month) {
				// Week begins and ends in the same month
				dateFormatter.setLocalizedDateFormatFromTemplate("MMMd") // set template after setting locale
				startStr = dateFormatter.string(from: _startDate) + _startDate.suffix
				endStr = String(_endDate.day) + _endDate.suffix
				
			} else {
				// Different month (could cross year boundary, for now not showing year because it should be obvious
				dateFormatter.setLocalizedDateFormatFromTemplate("MMMd") // set template after setting locale
				startStr = dateFormatter.string(from: _startDate) + _startDate.suffix
				endStr = dateFormatter.string(from: _endDate) + _endDate.suffix
			}
			
			let lockup = startStr + " to " + endStr
			
			if period == .thisWeek {
				out.mainTitle = "This Week"
				out.subTitle = daysRemainingInPeriod.asString + " days left"
				
			} else if period == .lastWeek {
				out.mainTitle = "Last Week"
				out.subTitle = lockup.uppercased()
				
			} else {
				// Not this week or last week
				out.mainTitle = _startDate.weeksAgoDisplay().uppercased()
				out.subTitle = lockup.uppercased()
			}
			
		case .month:
			let _startDate = Date.fromYYYYMMDD(startDate)
			//			let ti = abs(_startDate.timeIntervalSinceNow)
			//			let monthsAgo = ti / secondsPerMonth
			let thisYear = Date().year
			
			if period == .thisMonth {
				out.mainTitle = "This Month"
				out.subTitle = "" // daysRemainingInPeriod.asString + " days left"
				
			} else if period == .lastMonth {
				out.mainTitle = "Last Month"
				out.subTitle = "" // lockup.uppercased()
				
			} else if _startDate.year == thisYear {
				// This year
				out.mainTitle = _startDate.monthName
				out.subTitle = "" // _startDate.timeAgoDisplay().uppercased()
				
			} else if _startDate.year == thisYear - 1 {
				// Last year
				out.mainTitle = "Last " + _startDate.monthName_abrv
				out.subTitle = "" // _startDate.timeAgoDisplay().uppercased()
				
			} else {
				// Not this year or last year
				let lockup = _startDate.monthName_abrv + " " + _startDate.year.asString
				out.mainTitle = lockup.uppercased()
				out.subTitle = ""
			}
			
		default: return out
			
		}
		
		return out
	}
	
}

struct QIOPeriodTitles {
	var mainTitle: String = ""
	var subTitle: String = ""
}

class QIOFlowPeriodSummary {
	
	var isFillerObject: Bool = false
	var netAmount: Double = 0
	var income: Double = 0
	var transactions: QIOFlowPeriodSummaryTransaction?
	var balances: [QIOFlowPeriodSummaryBalance]?
	var categories: QIOFlowPeriodSummaryCategory?
	var spending: QIOFlowPeriodSummarySpending?

	init (with ss: Dictionary<String, Any>) {
		
		isFillerObject = ss["isFillerObject"] as? Bool ?? false
		netAmount = ss["netAmount"] as? Double ?? -1
		income = ss["income"] as? Double ?? -1
		if let p = ss["transactions"] as? Dictionary<String, Any> {
			transactions = QIOFlowPeriodSummaryTransaction(with: p)
		}
		if let blerg = ss["balances"] as? [Dictionary<String, Any>] {
			balances = blerg.map { QIOFlowPeriodSummaryBalance(with: $0) }
		}
		spending = ss["spending"] as? QIOFlowPeriodSummarySpending? ?? nil
		categories = ss["categories"] as? QIOFlowPeriodSummaryCategory? ?? nil
	}

	// MARK: - Custom
	
	var description: String {
		var out: String = "\n\tPERIOD SUMMARY:\n"
		
		out.append("\t\tNet Amount: " + netAmount.asString + "\n")
		out.append("\t\tIncome: " + income.asString + "\n")
		out.append("\t\tisFillerObject: " + isFillerObject.asString + "\n")
		if let val = transactions { out.append(val.description) }
		
		return out
	}
	
	var savingsBalance: QIOFlowPeriodSummaryBalance? {
		if let bals = balances {
			return bals.first(where: { $0.accountSubtype == "savings" })
		} else {
			return nil
		}
	}
	
	var checkingBalance: QIOFlowPeriodSummaryBalance? {
		if let bals = balances {
			return bals.first(where: { $0.accountSubtype == "checking" })
		} else {
			return nil
		}
	}
	
	var creditCardsBalance: QIOFlowPeriodSummaryBalance? {
		if let bals = balances {
			return bals.first(where: { $0.accountSubtype == "credit card" })
		} else {
			return nil
		}
	}
	
}

class QIOFlowPeriodSummaryCategory {

	var total: Double = 0
	var names = [String]()
	var percentages = [Double]()
	var descriptions = [String]()
	var amounts = [Double]()
	
	init (with ss: Dictionary<String, Any>) {
		total = ss["total"] as? Double ?? -1
		names = ss["names"] as? [String] ?? [String]()
		percentages = ss["percentages"] as? [Double] ?? [Double]()
		descriptions = ss["descriptions"] as? [String] ?? [String]()
		amounts = ss["amounts"] as? [Double] ?? [Double]()
	}
	
}

class QIOFlowPeriodSummarySpending {

	var actual: Double = 0
	var target: Double = 0
	var projected: Double = 0

	init (with ss: Dictionary<String, Any>) {
		actual = ss["actual"] as? Double ?? -1
		target = ss["target"] as? Double ?? -1
		projected = ss["projected"] as? Double ?? -1
	}
	
	// the other version of spending from who knows where
//	GraphQLField("categories", type: .nonNull(.object(Category.selections))),
//	GraphQLField("basicLivingExpenses", type: .nonNull(.object(BasicLivingExpense.selections))),

//	var totalAmount: Double = 0
//	var monthsAnalyzed: Int = 0
//	var months: [QIOFlowPeriodSummarySpendingMonth]?
//	var vendorAnalysis: [QIOFlowPeriodSummarySpendingVendorAnalysis]?
//	var daily: [QIOFlowPeriodSummarySpendingDaily]?
//	var streams: [QIOFlowPeriodSummarySpendingStream]?
//
//	init (with ss: GraphQLSelectionSet) {
//		totalAmount = ss["totalAmount"] as? Double ?? -1
//		monthsAnalyzed = ss["monthsAnalyzed"] as? Int ?? -1
//		months = ss["months"] as? [QIOFlowPeriodSummarySpendingMonth]? ?? nil
//		vendorAnalysis = ss["vendorAnalysis"] as? [QIOFlowPeriodSummarySpendingVendorAnalysis]? ?? nil
//		daily = ss["daily"] as? [QIOFlowPeriodSummarySpendingDaily]? ?? nil
//		streams = ss["streams"] as? [QIOFlowPeriodSummarySpendingStream]? ?? nil
//
//	}
	
}

class QIOFlowPeriodSummarySpendingStream {

	var streamType: String = ""
	var periodSize: String = ""
	var nameFriendly: String = ""
	var tids: [String]?
	var periodsPerYear: Int = 0
	var fioCategoryId: Int = -1
	var transactionCount: Int = 0
	var dates: [String]?
	var amountDistribution: QIOFlowPeriodSummarySpendingStreamAmountDistribution?
	var dateDistribution: QIOFlowPeriodSummarySpendingStreamDateDistribution?
	
	init (with ss: Dictionary<String, Any>) {
		streamType = ss["streamType"] as? String ?? "<>"
		periodSize = ss["periodSize"] as? String ?? "<>"
		nameFriendly = ss["nameFriendly"] as? String ?? "<>"
		tids = ss["tids"] as? [String]? ?? nil
		periodsPerYear = ss["periodsPerYear"] as? Int ?? -1
		fioCategoryId = ss["fioCategoryId"] as? Int ?? -1
		transactionCount = ss["transactionCount"] as? Int ?? -1
		dates = ss["dates"] as? [String]? ?? nil
		amountDistribution = ss["amountDistribution"] as? QIOFlowPeriodSummarySpendingStreamAmountDistribution? ?? nil
		dateDistribution = ss["dateDistribution"] as? QIOFlowPeriodSummarySpendingStreamDateDistribution? ?? nil
	}
	
}

class QIOFlowPeriodSummarySpendingStreamDateDistribution {

	var avgDiffDays: Double = 0
	var daysUntilNext: Int = 0
	var duration: Int = 0
	var firstDate: String = ""
	var firstDaysAgo: Int = 0
	var lastDate: String = ""
	var lastDaysAgo: Int = 0
	var relativeStandardDeviationPct: Double = 0
	var standardDeviation: Double = 0

	init (with ss: Dictionary<String, Any>) {
		avgDiffDays = ss["avgDiffDays"] as? Double ?? -1
		daysUntilNext = ss["daysUntilNext"] as? Int ?? -1
		duration = ss["duration"] as? Int ?? -1
		firstDate = ss["firstDate"] as? String ?? "<>"
		firstDaysAgo = ss["firstDaysAgo"] as? Int ?? -1
		lastDate = ss["lastDate"] as? String ?? "<>"
		lastDaysAgo = ss["lastDaysAgo"] as? Int ?? -1
		relativeStandardDeviationPct = ss["relativeStandardDeviationPct"] as? Double ?? -1
		standardDeviation = ss["standardDeviation"] as? Double ?? -1
	}
	
}

class QIOFlowPeriodSummarySpendingStreamAmountDistribution {
	
	var annualEstimate: Double = 0
	var totalAmountEver: Double = 0
	var mean: Double = 0
	var relativeStandardDeviationPct: Double = 0
	var standardDeviation: Double = 0
	var dailyEstimate: Double = 0
	var monthlyEstimate: Double = 0
	var sum: Double = 0

	init (with ss: Dictionary<String, Any>) {
		annualEstimate = ss["annualEstimate"] as? Double ?? -1
		totalAmountEver = ss["totalAmountEver"] as? Double ?? -1
		mean = ss["mean"] as? Double ?? -1
		relativeStandardDeviationPct = ss["relativeStandardDeviationPct"] as? Double ?? -1
		standardDeviation = ss["standardDeviation"] as? Double ?? -1
		dailyEstimate = ss["dailyEstimate"] as? Double ?? -1
		monthlyEstimate = ss["monthlyEstimate"] as? Double ?? -1
		sum = ss["sum"] as? Double ?? -1
	}
	
}

class QIOFlowPeriodSummarySpendingDaily {
	
	var averageAmount: Double = 0
	var daysAnalyzed: Int = 0
	
	init (with ss: Dictionary<String, Any>) {
		averageAmount = ss["averageAmount"] as? Double ?? -1
		daysAnalyzed = ss["daysAnalyzed"] as? Int ?? -1
	}
	
}

//class QIOFlowPeriodSummarySpendingVendorAnalysis: Hashable {
//
//	var slug: String = ""
//	var name: String = ""
//	var dailyAvg: Double = 0
//	var historicalTwelveMonths: Double = 0
//	var historicalThreeMonths: Double = 0
//	var twelveMonthTids: [String]?
//	var threeMonthTids: [String]?
//
//	init (with ss: Dictionary<String, Any>) {
//		slug = ss["slug"] as? String ?? "<>"
//		name = ss["name"] as? String ?? "<>"
//		dailyAvg = ss["dailyAvg"] as? Double ?? -1
//		historicalTwelveMonths = ss["historicalTwelveMonths"] as? Double ?? -1
//		historicalThreeMonths = ss["historicalThreeMonths"] as? Double ?? -1
//		twelveMonthTids = ss["twelveMonthTids"] as? [String]? ?? nil
//		threeMonthTids = ss["threeMonthTids"] as? [String]? ?? nil
//	}
//
//	init(_ s: QSpending.VendorAnalysis) {
//		slug = s.slug
//		name = s.name
//		dailyAvg = s.dailyAvg
//		historicalTwelveMonths = s.historicalTwelveMonths
//		historicalThreeMonths = s.historicalThreeMonths
//		twelveMonthTids = s.twelveMonthTids
//		threeMonthTids = s.threeMonthTids
//	}
//
//	init(name: String, amount: Double, index: Int, isRecurring: Bool) {
//		self.name = name
//		self.amount = amount
//		self.index = index
//		self.isRecurring = isRecurring
//	}
//
//	// MARK: - Custom
//
//	var image: UIImage?
//	var amount: Double = 0
//	var index: Int = -1
//	var isRecurring: Bool = false
//
//	static func == (
//		lhs: QIOFlowPeriodSummarySpendingVendorAnalysis,
//		rhs: QIOFlowPeriodSummarySpendingVendorAnalysis
//	) -> Bool {
//		//			print(lhs.name + " vs. " + rhs.name)
//		let match = lhs.name == rhs.name
//		//			if match { print("MATCHED: \(lhs.name)") }
//		return match
//	}
//
//	func hash(into hasher: inout Hasher) {
//		hasher.combine(name)
//	}
//
//}

class QIOFlowPeriodSummarySpendingMonth {

	var amount: Double = 0
	var month: String = ""
	
	init (with ss: Dictionary<String, Any>) {
		amount = ss["amount"] as? Double ?? 0
		month = ss["month"] as? String ?? "<>"
	}
	
}

class QIOFlowPeriodSummaryBalance {
	
	var accountSubtype: String = ""
	var startingBalance: Double = 0
	var endingBalance: Double = 0
	
	init (with ss: Dictionary<String, Any>) {
		accountSubtype = ss["accountSubtype"] as? String ?? "<>"
		startingBalance = ss["startingBalance"] as? Double ?? -1
		endingBalance = ss["endingBalance"] as? Double ?? -1
	}
	
}

class QIOFlowPeriodSummaryTransaction {
	
	var totalAmount: Double = 0
	var deposits: QIOFlowPeriodSummaryTransactionObj?
	var debits: QIOFlowPeriodSummaryTransactionObj?
	var transfers: QIOFlowPeriodSummaryTransactionObj?
	var regularIncome: QIOFlowPeriodSummaryTransactionObj?
	var creditCardPayments: QIOFlowPeriodSummaryTransactionObj?

	init (with ss: Dictionary<String, Any>) {
		totalAmount = ss["totalAmount"] as? Double ?? -1
		if let p = ss["deposits"] as? Dictionary<String, Any>
		{
			deposits = QIOFlowPeriodSummaryTransactionObj(with: p)
		}
		if let p = ss["debits"] as? Dictionary<String, Any> {
			debits = QIOFlowPeriodSummaryTransactionObj(with: p)
		}
		if let p = ss["transfers"] as? Dictionary<String, Any> {
			transfers = QIOFlowPeriodSummaryTransactionObj(with: p)
		}
		if let p = ss["regularIncome"] as? Dictionary<String, Any> {
			regularIncome = QIOFlowPeriodSummaryTransactionObj(with: p)
		}
		if let p = ss["creditCardPayments"] as? Dictionary<String, Any> {
			creditCardPayments = QIOFlowPeriodSummaryTransactionObj(with: p)
		}
	}
	
	// MARK: - Custom
	
	var description: String {
		var out: String = "\n\t\tTRANSACTIONS:\n"
		out.append("\t\t\tTotal Amount: " + totalAmount.asString + "\n")
		out.append(debits?.description ?? "No debits")
		out.append(deposits?.description ?? "No deposits")
		out.append(transfers?.description ?? "No transfers")
		return out
	}

}

class QIOFlowPeriodSummaryTransactionObj {

	var totalAmount: Double = 0
	var transactionIds = [String]()
	var sourceAccountNames: [String]?
	var destinationAccountNames: [String]?
	var transactionSummaries: [QIOFlowPeriodSummaryTransactionObjSummary]?
	var payments: [QIOFlowPeriodSummaryTransactionObjPayment]?

	init (with ss: Dictionary<String, Any>) {
		totalAmount = ss["totalAmount"] as? Double ?? -1
		transactionIds = ss["transactionIds"] as? [String] ?? [String]()
		sourceAccountNames = ss["sourceAccountNames"] as? [String]? ?? nil
		destinationAccountNames = ss["destinationAccountNames"] as? [String]? ?? nil
		if let blerg = ss["transactions"] as? [Dictionary<String, Any>] {
			transactionSummaries = blerg.map { QIOFlowPeriodSummaryTransactionObjSummary(with: $0) }
		}
		payments = ss["payments"] as? [QIOFlowPeriodSummaryTransactionObjPayment]? ?? nil
	}

	// MARK: - Custom
	
	var description: String {
		var out: String = "\n\t\t\tDEBITS:\n"
		out.append("\t\t\t\tTotal Amount: " + totalAmount.asString + "\n")
		out.append("\t\t\t\tTransaction IDs: " + transactionIds.asSentence + "\n")
		return out
	}
	
}

class QIOFlowPeriodSummaryTransactionObjPayment {

	var amount: Double = 0
	var from: FIOTransaction?
	var to: FIOTransaction?
	
	init (with ss: Dictionary<String, Any>) {
		amount = ss["amount"] as? Double ?? -1
		from = ss["from"] as? FIOTransaction ?? nil
		to = ss["to"] as? FIOTransaction ?? nil
	}

}

class QIOFlowPeriodSummaryTransactionObjSummary {

	var transaction_id: String = ""
	var amount: Double = 0
	var fioCategoryId: Int = -1
	var masterAccountId: String = ""
	var date: String = ""
	var name: String = ""
	var pending: Bool = false
	
	init (with ss: Dictionary<String, Any>) {
		transaction_id = ss["transaction_id"] as? String ?? "<>"
		amount = ss["amount"] as? Double ?? -1
		fioCategoryId = ss["fioCategoryId"] as? Int ?? -1
		masterAccountId = ss["masterAccountId"] as? String ?? "<>"
		date = ss["date"] as? String ?? "<>"
		name = ss["name"] as? String ?? "<>"
		pending = ss["pending"] as? Bool ?? false
	}
	
}

class QIOFlowPeriodProjection {
	
	var net: Double = 0
	var incomeTotal: Double = 0
	var spendTotal: Double = 0

	init (with ss: Dictionary<String, Any>) {
		net = ss["net"] as? Double ?? -1
		incomeTotal = ss["incomeTotal"] as? Double ?? -1
		spendTotal = ss["spendTotal"] as? Double ?? -1
	}
	
	// MARK: - Custom
	
	var description: String {
		var out: String = "\n\tPROJECTION:\n"
		out.append("\t\tNet Amount: " + net.asString + "\n")
		out.append("\t\tiSpend Total: " + spendTotal.asString + "\n")
		out.append("\t\tIncome TOTAL: " + incomeTotal.asString + "\n")
		return out
	}

}
