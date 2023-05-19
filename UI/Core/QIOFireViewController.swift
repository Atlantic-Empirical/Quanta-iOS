//
//  FIORainyDayViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/4/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class QIOFireViewController: QIOBaseViewController, IQIOBaseVC {

    // MARK: - Properties
	
	// MARK: - View Lifecycle
	
	override func loadView() {
		customTitle = "Financial Freedom"
		super.loadView()
		QMix.track(.viewCoreDetail, ["v": "fire"])
//		setRightBarButton(.info, libraryItem: .FinancialIndependence)
	}
	
	// MARK: - Actions
	
	func disclosureAction(sender: UIButton) {
		guard let which = QIOFireViewActions(rawValue: sender.tag) else { return }
		print(which.asString)
		switch which {
		default: break
		}
//		navigationController?.pushViewController(FIORainyDetailViewController(), animated: true)
	}
	
	// MARK: - Build UI
	
	override func buildUI() {
		sectionDescription()
		sectionSafeWithdrawalRate()
		sectionSavingsRate()
		buildComplete()
    }

	func sectionDescription() {
		addModuleNew(
			genLabel(QString.SectionHeader(.FI), font: baseFont(size: 16, bold: false)),
			vSpace: 20)
	}

	func sectionSafeWithdrawalRate() {
		genSectionHeader(
			"Safe\nWithdrawal Rate",
			description: "Based on the 4% rule")
		if
			let uh = QFlow.userHome,
			let fi = uh.financialIndependence,
			let totalCapital = fi.totalCapital,
			let swr = fi.safeWithdrawal
		{
			genSubSectionTitle("Retire Today")
			genMajorValue(amount: swr, suffix: "/ yr")
			genSubvalueDisclosure("On \(totalCapital.toCurrencyString()) total capital", vSpace: 0)
		}
	}

	func sectionSavingsRate() {
		genSectionHeader("Savings Rate")
		if
			let uh = QFlow.userHome,
			let fi = uh.financialIndependence,
			let sr = fi.savingsRate
		{
			if QFlow.isProfitable {
				
				genSubSectionTitle("Actual 90d Savings Rate")
				genMajorHeader(name: sr.actualSavingsRate_90d.toStringPercent(1, includePercentSign: true))

				genSubSectionTitle("Potential 90d Savings Rate")
				genMajorHeader(name: sr.potentialSavingsRate_90d.toStringPercent(1, includePercentSign: true))

			} else {
				addModuleNew(
					genLabel("Once you're profitable, your savings rate info will appear here."),
					vSpace: 20)
			}
		}
	}
	
}

enum QIOFireViewActions: Int {
	
	case none
	
	func asString() -> String { return "\(self)" }
	
}
