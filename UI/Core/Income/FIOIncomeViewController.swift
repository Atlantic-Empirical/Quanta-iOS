//
//  FIOIncomeStreamList.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/1/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOIncomeViewController: QIOBaseViewController, IQIOBaseVC {

	// MARK: - Properties

	// MARK: - View Lifecycle
	
	override func loadView() {
		customTitle = "Income"
		super.loadView()
		QMix.track(.viewCoreDetail, ["v": "income"])
		setRightBarButton(.info, libraryItem: .Income)
	}
	
	// MARK: - Actions
	
	func disclosureAction(sender: UIButton) {
		//
	}

	@objc func streamDetailAction_active(_ sender: UIButton) {
		navigationController?.pushViewController(
			QIOIncomeStreamDetailViewController(QFlow.activeIncomeStreams[sender.tag]),
			animated: true
		)
	}
	
	@objc func streamDetailAction_other(_ sender: UIButton) {
		navigationController?.pushViewController(
			QIOIncomeStreamDetailViewController(QFlow.inactiveIncomeStreams[sender.tag]),
			animated: true
		)
	}
	
	// MARK: - Scroller
	
	override func buildUI() {
		addModuleNew(
			genLabel(QString.SectionHeader(.income), font: baseFont(size: 16, bold: false)),
			vSpace: 20
		)
		sectionActiveStreams()
		sectionInactiveStreams()
		buildComplete()
	}
	
	// MARK: - Modules
	
	func sectionActiveStreams() {
		genSectionHeader("Active Income Streams")
		if QFlow.activeIncomeStreams.count == 0 {
			addModuleNew(
				genLabel("None", font: baseFont(size: 16, bold: false)),
				vSpace: 10)
		} else {
			guard
				let uh = QFlow.userHome,
				let income = uh.income
			else { return }

			genMajorValue(
				amount: income.summary.activeDailyEstimate * daysInYear,
				suffix: "/yr")
			
			let summaryString = "\(appName) has analyzed the \(income.summary.analyzedDepositCount) deposits in the system across your \(income.summary.analyzedAccountMaids.count) linked checking " + "account".pluralize(income.summary.analyzedDepositCount) + " and has identified the following active income streams:"
			addModuleNew(
				genLabel(summaryString, font: baseFont(size: 16, bold: false)),
				vSpace: 10)
			
			QFlow.activeIncomeStreams.enumerated().forEach { idx, val in
				genSubSectionTitle(val.nameFriendly)
				genMajorValue(
					amount: val.amountDistribution.annualEstimate,
					addDisclosure: true,
					action: #selector(streamDetailAction_active(_:)),
					tag: idx)
				genSubvalueDisclosure("Per Year", vSpace: -5)
			}
			
			genSubSectionTitle("Making your net income:")
//			let daily = minorValue(value: ade.toCurrencyString(), title: "DAILY")
//			let weekly = minorValue(value: (ade * 7).toCurrencyString(), title: "WEEKLY")
//			let monthly = minorValue(value: (ade * averageDaysPerMonth).toCurrencyString(), title: "MONTHLY")
		}
	}

	func sectionInactiveStreams() {
		if QFlow.inactiveIncomeStreams.count == 0 { return }
		genSectionHeader("Inactive Income Streams")

		let summaryString = "In analyzing your income the following streams were excluded from your regular income because they seem to no longer be active:"
		addModuleNew(
			genLabel(summaryString, font: baseFont(size: 16, bold: false)),
			vSpace: 10
		)
		QFlow.inactiveIncomeStreams.enumerated().forEach { idx, val in
			genSubSectionTitle(val.nameFriendly)
			genMajorValue(
				amount: val.amountDistribution.annualEstimate,
				addDisclosure: true,
				action: #selector(streamDetailAction_other(_:)),
				tag: idx)
			genSubvalueDisclosure("Per Year", vSpace: -5)
		}
	}
	
}
