//
//  QIOSpendingViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/4/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class QIOSpendingViewController: QIOBaseViewController, IQIOBaseVC {
	
    // MARK: - Properties

	var spendingQ: QSpending_Quantized?

    // MARK: - View Lifecycle

	override func loadView() {
		customTitle = "Spending"
		super.loadView()
		QMix.track(.viewCoreDetail, ["v": "spending"])
		addRightSideNavInfoButton(.Spending)
		setRightBarButton(.info, libraryItem: .Spending)
		
		guard let sq = home.spending?.quantized else { return }
		spendingQ = sq
	}
	
	// MARK: - Actions
	
	func disclosureAction(sender: UIButton) {
		print(#function + " \(sender.tag)")
		guard let si = spendingQ?[sender.tag] else { return }
//		si.image = si.image
		navigationController?.pushViewController(
			QIOPayeeDetailViewController(si),
			animated: true)
	}

	// MARK: - Build UI
	
	override func buildUI() {
		sectionHeader()
		sectionPayeeBars()
		buildComplete()
	}

	private func sectionHeader() {
		addModuleNew(genLabel(QString.SectionHeader(.spend)), vSpace: 20)
	}
	
	func sectionPayeeBars() {
		guard let sq = spendingQ else { return }
//		genSubSectionTitle("Significant Spending", vSpace: 30)
		sq.enumerated().forEach { (i, val) in
			genRecurringSpendBar(
				spendItem: val,
				action: #selector(disclosureAction(sender:)),
				tag: i,
				vSpace: (i == 0 ? 20 : 5))
		}
	}

}
