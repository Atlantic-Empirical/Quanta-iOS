//
//  FIORainyDetailViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 11/9/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIORainyDetailViewController: QIOBaseViewController, IQIOBaseVC {

	// MARK: - Properties
	
	//

	// MARK: - View Lifecycle
	
	override func loadView() {
		customTitle = "Rainy Day Funds"
		super.loadView()
//		setRightBarButton(.info, libraryItem: .RainyDayFunds)
		QMix.track(.viewCoreDetail, ["v": "rainy"])
	}
		
	// MARK: - Actions
	
	func disclosureAction(sender: UIButton) {
		guard let which = QIORainyDisclosureActions(rawValue: sender.tag) else { return }
		print(which.asString)
		switch which {
		case .link: plaidLink()
		}
	}
	
	@objc func accountDetailAction(_ sender: UIButton) {
		print(self.className + " " + #function)
		navigationController?.setNavBarVisible()
		navigationController?.pushViewController(
			FIOAccountDetailViewController(QFlow.cushionAccounts[sender.tag]),
			animated: true
		)
	}
	
	// MARK: - Custom
	
	override func buildUI() {
		sectionDescription()
		sectionBuffer()
		sectionLiquidBalance()
		sectionAccounts()
		buildComplete()
	}
	
	// MARK: - Modules
	
	func sectionDescription() {
		addModuleNew(
			genLabel(QString.SectionHeader(.rainyDay), font: baseFont(size: 16, bold: false)),
			vSpace: 20)
	}
	
	func sectionBuffer() {
		genSectionHeader("Safety Net", description: "Months without income.")
		if
			let current = QFlow.cushionCurrent,
			let months = QFlow.cushionHistoricalMonths
		{
			genGauge(pct: current.monthsAsPercentage, greenToRed: false)
			genMajorValue(current.months.roundToDecimal(1).asString)
			genSubvalueDisclosure("Months")
			
//			var bufferVals =  months.map {
//				min(
//					($0.bufferAtStartOfMonth / QFlow.targetCushionMonths).roundToDecimal(1),
//					1
//				)
//			}
//			bufferVals = Array(bufferVals[1...12])
//			base.addModuleSubview(graphView(
//				normalizedValues: bufferVals,
//				title: "Buffer Over Time"
//			))
		}
	}

	func sectionLiquidBalance() {
		genSectionHeader("Liquid Capital", description: "Cash you can withdraw without penalty.")
		if
			let cushion = QFlow.cushion,
			let current = QFlow.cushionCurrent,
			let historical = cushion.historical,
			let dates = historical.dates
		{
			genMajorValue(current.balance.toCurrencyString())
//			let balances: [Double] = dates.map { $0.balance }
//			base.addModuleSubview(graphView(
//				nonNormalizedValues: balances,
//				title: "Daily Balance over Time"))
		}
	}

	func sectionAccounts() {
		genSectionHeader("Accounts")
		QFlow.cushionAccounts.enumerated().forEach { idx, val in
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

enum QIORainyDisclosureActions: Int {
	
	case link
	
	func asString() -> String {
		return "\(self)"
	}
}
