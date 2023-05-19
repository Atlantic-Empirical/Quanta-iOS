//
//  FIOFlow-Financials+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/3/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

extension QIOFlow {
	
	// MARK: - Financial Freedom & Independence Progress Metric© (“Quanta IPM©”)
	
	var ipm_SurplusLiving: Bool {
		guard let h = QFlow.userHome else { return false }
		let cpd = h.streaks?.months.periodCount ?? 0
		return cpd >= 2
	}
	
	var ipm_SurplusLivingDescription: String {
		guard let h = QFlow.userHome else { return "" } // no badge would be shown anyway
		let cpd = h.streaks?.months.periodCount ?? 0
		return "You've been profitable for the past \(cpd) months. Keep it up!"
	}
	
	var ipm_MoneyRental: Bool {
		if creditCardAccounts.count == 0 {
			return false // they don't have any connected accounts so no badge possible. (they might have non-connected accounts)
		} else if creditCardCurrentUtilization < creditCardTargetMaxUtilization {
			return true
		} else {
			guard creditCardsCarryOvers.count > 0 else { return true }
			let lastCarryOver = creditCardsCarryOvers[0]
			let latestCarryOverDelta = creditCardsCarryOvers[1] - creditCardsCarryOvers[0]
			return lastCarryOver == 0 || latestCarryOverDelta <= 0
		}
	}

	var ipm_MoneyRentalDescription: String {
		if creditCardCurrentUtilization < creditCardTargetMaxUtilization {
			return """
				You're keeping your credit card balance below the target of \(creditCardTargetMaxUtilization * 100)% utilization.
			
				Your current total balance is \(creditCardsTotalCurrentBalance.toCurrencyString())  which is \(creditCardCurrentUtilization * 100)% of your overall credit limit of \(creditCardTotalLimit.toCurrencyString()).
			"""
		} else {
			guard creditCardsCarryOvers.count > 0 else { return "" }
			let latestCarryOverDelta = creditCardsCarryOvers[1] - creditCardsCarryOvers[0]
			return "Your credit card balance is above the target of \((creditCardTargetMaxUtilization * 100).roundToDecimal(0))% utilization but you're headed in the right direction as the overall monthly balance went down \(abs(latestCarryOverDelta).toCurrencyString()) last month."
		}
	}

	var ipm_RainyDayMoney: Bool {
		return cashCushionIsAdequate
		// TODO: OR deposit(s) were made to Savings Buffer in the month
	}
	
	var ipm_RainyDayMoneyDescription: String {
		guard
			let uh = QFlow.userHome,
			let fi = uh.financialIndependence,
			let lc = fi.liquidCushion,
			let consts = lc.consts
			else { return "" }
		return "The target is to keep \(consts.targetSafetyMonths) months or more of cash for basic living expenses easily accessible, you currently have \(cashCushionMonths) months at hand."
	}

	/// Having enough capital that 4% of it could cover your base expenses for a year.
	var ipm_LongTermMoney: Bool {
		let yearOfBle = ble_monthlyTotalEst * 12
		let annualSafeWithdrawal = totalLTM * safeWithdrawalRatePercentage
		return annualSafeWithdrawal > yearOfBle
	}
	
	var ipm_LongTermMoneyDescription: String {
		let annualSafeWithdrawal = totalLTM * safeWithdrawalRatePercentage
		let v1 = annualSafeWithdrawal / 12
		return "Your current safe withdrawal rate income would be \(v1.toCurrencyString()) per month. Since this is greater than your base monthly living expenses (\(ble_monthlyTotalEst.toCurrencyString())) you could consider yourself financially free.\n\nIf you quit making money and cut your overall spending down to your base living expenses you could last a very long time*."
	}

	// MARK: - LONG-TERM MONEY
	
	var safeWithdrawalRatePercentage: Double {
		return 0.04
	}
	
	var totalLTM: Double {
		guard
			let uh = QFlow.userHome,
			let fi = uh.financialIndependence,
			let ltm = fi.totalCapital
			else { return 0 }
		return ltm
	}
	
	// MARK: - SAVINGS RATE
	
	var savingsRate: GetUserHomeQuery.Data.GetUserHome.FinancialIndependence.SavingsRate? {
		guard
			let uh = QFlow.userHome,
			let fi = uh.financialIndependence,
			let sr = fi.savingsRate
			else { return nil }
		return sr
	}
	
	// MARK: - Cushion
	
	var cushionAccounts: [QAccount] {
		guard
			let uh = userHome,
			let accts = uh.accounts
			else { return [] }
		return accts.filter {
			return cushion?.accountMaids?.contains($0.masterAccountId) ?? false
		}
	}
	
	var cushion: GetUserHomeQuery.Data.GetUserHome.FinancialIndependence.LiquidCushion? {
		guard
			let uh = QFlow.userHome,
			let fi = uh.financialIndependence,
			let lc = fi.liquidCushion
			else { return nil }
		return lc
	}
	
	var cushionCurrent: GetUserHomeQuery.Data.GetUserHome.FinancialIndependence.LiquidCushion.Current? {
		if let c = cushion?.current { return c }
		else { return nil }
	}
	
	var cushionHistoricalMonths: [GetUserHomeQuery.Data.GetUserHome.FinancialIndependence.LiquidCushion.Historical.Month]? {
		guard
			let historical = cushion?.historical,
			let months = historical.months
			else { return nil }
		return months
	}
	
	var targetCushionMonths: Double {
		if let c = cushion?.consts { return c.targetSafetyMonths }
		else { return 6 }
	}
	
	var cashCushionMonths: Double {
		guard
			let uh = QFlow.userHome,
			let fi = uh.financialIndependence,
			let lc = fi.liquidCushion,
			let currentCushion = lc.current
			else { return 0 }
		return currentCushion.months
	}
	
	var cashCushionIsAdequate: Bool {
		guard
			let uh = QFlow.userHome,
			let fi = uh.financialIndependence,
			let lc = fi.liquidCushion,
			let consts = lc.consts
			else { return false }
		return cashCushionMonths >= consts.targetSafetyMonths
	}
	
	// MARK: - Profitability
	
	var isProfitable: Bool {
		guard
			let uh = QFlow.userHome,
			let spending = uh.spending,
			let income = uh.income
			else { return false }
		return spending.daily.averageAmount < income.summary.activeDailyEstimate
	}
	
	var dailyProfit: Double {
		guard
			let uh = QFlow.userHome,
			let income = uh.income,
			let spending = uh.spending
			else { return 0 }
		return income.summary.activeDailyEstimate - spending.daily.averageAmount
	}
	
	var monthlyProfit: Double {
		return dailyProfit * averageDaysPerMonth
	}
	
	var monthProfitStreak: Int {
		guard
			let flowMonths = QFlow.flowMonths
			else { return 0 }
		var monthCounter: Int = 0
		for i in 1..<flowMonths.count {
			if flowMonths[i].periodSummary.netAmount >= 0 { monthCounter += 1 }
			else { return monthCounter }
		}
		return 0 // Fallthrough case
	}
	
	// MARK: - Earning
	
	var activeIncomeStreams: [QIncome.ActiveStream] {
		guard
			let uh = userHome,
			let income = uh.income,
			let streams = income.activeStreams
			else { return [QIncome.ActiveStream]() }
		return streams
	}
	
	var inactiveIncomeStreams: [QIncome.InactiveStream] {
		guard
			let uh = userHome,
			let income = uh.income,
			let streams = income.inactiveStreams
			else { return [QIncome.InactiveStream]() }
		return streams
	}
	
	var incomeIsNull: Bool {
		guard
			let uh = QFlow.userHome,
			let income = uh.income
			else { return true }
		return income.summary.activeDailyEstimate <= 0
	}
	
	/// This is the average monthly earning based on current activeDailyEstimate
	var monthlyEarning: Double {
		guard
			let uh = QFlow.userHome,
			let income = uh.income
			else { return 0 }
		return income.summary.activeDailyEstimate * averageDaysPerMonth
	}

	/// This is based on current activeDailyEstimate
	var dailyEarning: Double {
		guard
			let uh = QFlow.userHome,
			let income = uh.income
			else { return 0 }
		return income.summary.activeDailyEstimate
	}

	/// This is based on current activeDailyEstimate
	var weeklyEarning: Double {
		guard
			let uh = QFlow.userHome,
			let income = uh.income
			else { return 0 }
		return income.summary.activeDailyEstimate * 7
	}

	// MARK: - SPENDING
	
	var ble_monthlyTotalEst: Double {
		guard
			let uh = QFlow.userHome,
			let spending = uh.spending
			else { return  0}
		return spending.basicLivingExpenses.estimatedMonthlyAmount
	}
	
	/// This is the average monthly spending based on current daily.averageAmount
	var monthlySpending: Double {
		guard
			let uh = QFlow.userHome,
			let spending = uh.spending
			else { return 0 }
		return spending.daily.averageAmount * averageDaysPerMonth
	}

	/// This is based on current daily.averageAmount
	var dailySpending: Double {
		guard
			let uh = QFlow.userHome,
			let spending = uh.spending
			else { return 0 }
		return spending.daily.averageAmount
	}

	/// This is based on current daily.averageAmount
	var weeklySpending: Double {
		guard
			let uh = QFlow.userHome,
			let spending = uh.spending
			else { return 0 }
		return spending.daily.averageAmount * 7
	}

	// MARK: - MONEY RENTAL
	
	var creditCardsCarryOvers: [Double] {
		guard let cc = creditCards
			else { return [] }
		return cc.balance.historical.mmCarryOvers
	}
	
	var creditCardsAvgCarryOver: Double {
		guard let cc = creditCards
			else { return 0 }
		return cc.balance.historical.avgMmCarryOver
	}

	var creditCardsTotalCurrentBalance: Double {
		guard let cc = creditCards
			else { return 0 }
		return cc.balance.current.total
	}
	
	var creditCards: GetUserHomeQuery.Data.GetUserHome.MoneyRental.CreditCard? {
		guard
			let uh = QFlow.userHome,
			let moneyRental = uh.moneyRental,
			let creditCards = moneyRental.creditCards
			else { return nil }
		return creditCards
	}
	
	var creditCardCurrentUtilization: Double {
		guard
			let uh = QFlow.userHome,
			let moneyRental = uh.moneyRental,
			let creditCards = moneyRental.creditCards
			else { return 0 }
		return creditCards.balance.current.utilizationPercentage
	}

	var creditCardTargetMaxUtilization: Double {
		return 0.3
	}

	var creditCardTotalLimit: Double {
		guard
			let uh = QFlow.userHome,
			let moneyRental = uh.moneyRental,
			let creditCards = moneyRental.creditCards
			else { return 0 }
		return creditCards.balance.current.totalLimit
	}

	var moneyRentAsPercentOfNetIncome: Double {
		guard
			let uh = QFlow.userHome,
			let income = uh.income,
			let cc = creditCards
			else { return 0 }
		return incomeIsNull ? 0 :
			cc.rent.averagePerDay / income.summary.activeDailyEstimate
	}
	
	var moneyRentIsUnderTargetOrNullIncome: Bool {
		return incomeIsNull ?
			false :
			(moneyRentAsPercentOfNetIncome < 0.05)
	}
	
	// MARK: - Item Stuff
	
	var items: [QItem] {
		guard
			let uh = self.userHome,
			let items = uh.items
			else { return [QItem]() }
		return items
	}
	
	func itemById(itemId: String) -> QItem? {
		return items.first { $0.itemId == itemId }
	}
	
	var itemsInNeedOfUpdate: [QItem] {
		return items.filter {
			if let b = $0.needsUpdate
			{ return b } else
			{ return false }
		}
	}
	
	var itemsNeedUpdating: Bool {
		return itemsInNeedOfUpdate.count > 0
	}
	
	var allInstitutionNames: [String] {
		guard
			let uh = self.userHome,
			let accts = uh.accounts
			else { return [String]() }
		let institutionArray = accts.map { $0.institutionName }
		return Array(Set(institutionArray))
	}
	
	func itemId_for_institutionId(_ institutionId: String) -> String? {
		guard
			let uh = userHome,
			let accts = uh.accounts,
			let acct = accts.first(where: { $0.institutionId == institutionId })
			else { return nil }
		return acct.itemId
	}
	
	func itemId_for_institutionName(_ institutionName: String) -> String? {
		guard
			let uh = userHome,
			let accts = uh.accounts,
			let acct = accts.first(where: { $0.institutionName == institutionName })
			else { return nil }
		return acct.itemId
	}
	
	// MARK: - Account Stuff
	
	var institutionAccountDictionary: [String: [QAccount]] {
		var out = [String: [QAccount]]()
		if
			let uh = self.userHome,
			let accts = uh.accounts
		{
			for a in accts {
				let i = out.index(forKey: a.institutionName)
				if (i == nil) {
					out[a.institutionName] = [QAccount]()
				}
				out[a.institutionName]!.append(a)
			}
		}
		return out
	}
	
	var hasAccounts : Bool {
		guard
			let uh = self.userHome,
			let accts = uh.accounts
			else { return false }
		return accts.count > 0
	}
	
	func hasAccountsForInstitution(_ institution_id: String) -> Bool {
		guard
			let uh = self.userHome,
			let accts = uh.accounts,
			let _ = accts.first(where: { $0.institutionId == institution_id })
			else { return false }
		return true
	}
	
	func accountsForItem(_ itemId: String) -> [QAccount] {
		guard
			let uh = self.userHome,
			let accts = uh.accounts
			else { return [QAccount]() }
		return accts.filter { return $0.itemId == itemId }
	}
	
	func accountForMaid(_ maid: String) -> QAccount? {
		guard
			let uh = self.userHome,
			let accts = uh.accounts
			else { return nil }
		return accts.first { return $0.masterAccountId == maid }
	}
	
	var creditCardAccounts: [QAccount] {
		guard
			let uh = userHome,
			let accts = uh.accounts
			else { return [] }
		return accts.filter { $0.subtype == "credit card" }
	}
	
	var checkingAccounts: [QAccount] {
		guard
			let uh = userHome,
			let accts = uh.accounts
			else { return [] }
		return accts.filter { $0.subtype == "checking" }
	}
	
	var allAccounts: [QAccount] {
		guard
			let uh = userHome,
			let accts = uh.accounts
			else { return [] }
		return accts
	}
	
	// MARK: - Transaction Stuff
	
	func transactionsForAccount(_ maid: String) -> [QTransaction] {
		guard let at = allTransactions else { return [QTransaction]() }
		return at.filter { $0.masterAccountId == maid }
	}
	
}
