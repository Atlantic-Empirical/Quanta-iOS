//
//  QIOBleOverviewViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 7/15/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import UIKit

class QIOBleOverviewViewController: QIOBaseViewController, IQIOBaseVC {
	
	// MARK: - Properties
	private var model: QSpending_Ble!
	private var tableView = UITableView()

	// MARK: - View Lifecycle
	
	override func loadView() {
		
		if
			let uh = QFlow.userHome,
			let spending = uh.spending
		{
			model = spending.basicLivingExpenses
		} else {
			print("⚠️ no model available \(className)")
			return
		}
		
		customTitle = "Base Living Expenses"
		super.loadView()
		setRightBarButton(.info, libraryItem: .BaseLivingExpenses)
	}

	// MARK: - Actions
	
	func disclosureAction(sender: UIButton) {
		//
	}

	// MARK: - UI Build
	
	override func buildUI() {
		sectionHeader()
		sectionSummary()
		sectionTable()
		buildComplete()
	}
	
	private func sectionHeader() {
		addModuleNew(genLabel(QString.SectionHeader(.ble)), vSpace: 20)
	}

	private func sectionSummary() {
		genSectionHeader("Overview", vSpace: 0)
		genSubSectionTitle("Daily Amount")
		genMajorValue(amount: model.estimatedDailyAmount)
		genSubSectionTitle("Monthly Amount")
		genMajorValue(amount: model.estimatedMonthlyAmount)
	}
	
	private func sectionTable() {
		genSectionHeader("Base Spend Areas", action: #selector(disclosureAction(sender:)), tag: 1)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorInset = .zero // Full width separators
		tableView.isScrollEnabled = false // Using the scroller in the parent view
		tableView.estimatedRowHeight = QIOBleOverviewViewController.rowHeight
		tableView.rowHeight = QIOBleOverviewViewController.rowHeight
		tableView.hideUnusedCells()
		genTableContainer(
			tableView,
			height: QIOBleOverviewViewController.rowHeight * 6)
	}
	
	// MARK: - Custom
	
}

extension QIOBleOverviewViewController: UITableViewDelegate, UITableViewDataSource {
	
	static var rowHeight: CGFloat = 50.0
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 6
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
		if cell == nil { cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier") }

		if let c = cell {
			c.quantaDefaultViz()
			let itm = model.summary[indexPath.row]
			c.textLabel?.text = itm.friendlyName
			c.textLabel?.w = 226.0
			c.selectionStyle = .default
			c.accessoryType = .disclosureIndicator
			let mas: NSMutableAttributedString = itm.average.asAttributedCurrencyString(fontSize: 16, bold: false)
			mas.append(NSAttributedString(string: " /mo"))
			c.addThirdLabelToCell(attributedText: mas)
		}

		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		navigationController?.pushViewController(
			QIOBleAreaDetailViewController(model.summary[indexPath.row].categoryId),
			animated: true)
	}
	
}
