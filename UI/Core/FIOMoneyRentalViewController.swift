//
//  FIOCreditCardDebtViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/4/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOMoneyRentalViewController: QIOBaseViewController, IQIOBaseVC {

	// MARK: - Properties
	
	//
	
	// MARK: - View Lifecycle
	
	override func loadView() {
		customTitle = "Money Rental"
		super.loadView()
		setRightBarButton(.info, libraryItem: .MoneyRental)
		QMix.track(.viewCoreDetail, ["v": "moneyRental"])
	}
	
	// MARK: - Actions

	func disclosureAction(sender: UIButton) {
		guard let which = QIOMoneyRentalDisclosureActions(rawValue: sender.tag) else { return }
		print(which.asString)
		
		switch which {
			
		case .link: plaidLink()

		}
	}

	@objc func accountDetailAction(_ sender: UIButton) {
		print(self.className + " " + #function)
		navigationController?.pushViewController(
			FIOAccountDetailViewController(QFlow.creditCardAccounts[sender.tag]),
			animated: true
		)
	}
	
	@objc func openDetail(_ sender: Any) {
		navigationController?.setNavBarVisible()
	}
	
	// MARK: - Scroller
	
	override func buildUI() {
		sectionDescription()
		sectionBalance()
		sectionUtilization()
		sectionMoneyRent()
		sectionCostOfADollar()
		sectionAccounts()
		buildComplete()
	}
	
	func sectionDescription() {
		addModuleNew(
			genLabel(QString.SectionHeader(.moneyRental), font: baseFont(size: 16, bold: false)),
			vSpace: 20)
	}
	
	func sectionBalance() {
		genSectionHeader("Balance", description: "Across All Credit Card Accounts")
		if
			let creditCards = QFlow.creditCards
		{
			genSubSectionTitle("Current Balance")
			genMajorValue(
				amount: creditCards.balance.current.total,
				addDisclosure: false)

			genSubSectionTitle(creditCards.balance.historical.daysAnalyzed.asString + "d Average Balance")
			genMajorValue(
				amount: creditCards.balance.historical.avgBalance,
				addDisclosure: false)
			
			genSubSectionTitle("Average Monthly Carryover")
			genMajorValue(
				amount: creditCards.balance.historical.avgMmCarryOver,
				addDisclosure: false)
			
			let balances: [Double] = creditCards.balance.historical.dates.map { max($0.balance, 0) }
			let maxVal = balances.max()!
			let balancesAsPercentsOfMaxWithOverhead = balances.map { $0 / maxVal }
//			module.addModuleSubview(graphView(
//				normalizedValues: balancesAsPercentsOfMaxWithOverhead,
//				title: "Daily Balance"
//			))
		}
	}

	func sectionUtilization() {
		genSectionHeader("Utilization")
		if
			let creditCards = QFlow.creditCards
		{
			genGauge(
				pct: creditCards.balance.current.utilizationPercentage,
				greenToRed: true,
				vSpace: 20)
			genMajorValue(
				creditCards.balance.current.utilizationPercentage.toStringPercent(1, includePercentSign: false),
				suffix: "%")
			genSubvalueDisclosure("of total credit limit")

//			let utilizations: [Double] = creditCards.balance.historical.dates.map { return $0.utilization }
//			base.addModuleSubview(
//				graphView(
//					normalizedValues: utilizations,
//					title: "Utilization Over Time",
//					addGraphBorder: false
//				)
//			)
		}
	}

	func sectionMoneyRent() {
		genSectionHeader(
			"Money Rent",
			description: "How much are you spending to rent money?")
		if
			let creditCards = QFlow.creditCards
		{
			// DAILY
			genSubSectionTitle("Daily Rent Paid")
			genMajorValue(amount: creditCards.rent.averagePerDay)

			// RENT COST
//			let _ = base.addAndDistributeViewsHorizontally([
//				minorValue(
//					value: creditCards.rent.totalInAnalysisPeriod.toCurrencyString(),
//					title: "3mo Rent Paid",
//					minimumWidth: 130.0),
//				minorValue(
//					value: (creditCards.rent.percentOfDailyNet / 100).toStringPercent(includePercentSign: false),
//					title: "of net income",
//					minimumWidth: 130.0,
//					suffix: "%")],
//				spacing: 26
//			)
			
			// INTEREST RATES
//			base.addModuleSubview(minorValue(
//				value: (creditCards.rent.dailyPeriodicRate * daysInYear).toStringPercent(includePercentSign: false),
//				title: "Annual Interest Rate",
//				minimumWidth: 220.0,
//				suffix: "%"))
		}
	}

	func sectionCostOfADollar() {
		genSectionHeader(
			"Cost of Money",
			description: "\(appName)'s Magic Lens\nRevealing the Real Cost of Money")
		if
			let creditCards = QFlow.creditCards
		{
			genSubSectionTitle("Effective Total Balance")
			genMajorValue(amount: creditCards.balance.current.totalEffectiveBalance)

			genSubSectionTitle("You spend per $1.00")
			genMajorValue(amount: creditCards.costOfOneDollar)
		}
	}

	func sectionAccounts() {
		genSectionHeader("Accounts")
		QFlow.creditCardAccounts.enumerated().forEach { idx, val in
			if
				let balances = val.balances,
				let currentBalance = balances.current,
				let dn = val.displayName
			{
				genSubSectionTitle(val.institutionName)
				addModuleNew(
					genLabel(dn.prefixToLength(28), font: baseFont(size: 16, bold: false), maxWidth: 290),
					vSpace: 5)
				genSubvalueDisclosure(
					"Balance: " + currentBalance.toCurrencyString(),
					vSpace: 0,
					action: #selector(accountDetailAction),
					tag: idx)
			}
		}

		genSubvalueDisclosure(
			"Connect Another",
			vSpace: 20,
			action: #selector(disclosureAction(sender:)),
			tag: QIOMoneyRentalDisclosureActions.link.rawValue)
	}
	
}

enum QIOMoneyRentalDisclosureActions: Int {
	
	case link
	
	func asString() -> String {
		return "\(self)"
	}
}
