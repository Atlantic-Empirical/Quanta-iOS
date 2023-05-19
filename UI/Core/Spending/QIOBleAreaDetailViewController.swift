//
//  QIOBleDetailViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/23/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOBleAreaDetailViewController: QIOBaseViewController, IQIOBaseVC {

	// MARK: - Properties
	
	private var catId: String!
	private var transactions: [FIOTransaction]!
	private var monthCatDetails: [QSpending_BleCategory]!
	private var allTidsForCat: [String]!
	private var catSummary: QSpending_BleSummary!
	private var tableView = UITableView()
	
	// MARK: - View Lifecycle
	
	convenience init(_ catId: String) {
		self.init()
		if
			let ble = ble,
			let cs = ble[catId]
		{
			catSummary = cs
			let flattenedCategoriesAcrossMonths = ble.months.flatMap { $0.byCategory ?? [] }
			monthCatDetails = flattenedCategoriesAcrossMonths.filter { $0.categoryId == catId }
			allTidsForCat = monthCatDetails.flatMap { $0.tids ?? [] }
		}
	}

	override func loadView() {
		customTitle = "Base Expenses"
		super.loadView()
		setRightBarButton(.info, libraryItem: .BaseLivingExpenses)
	}
	
	// MARK: - Actions
	
	func disclosureAction(sender: UIButton) {
		//
	}

	// MARK: - UI Build

	override func buildUI() {
		loadTransactions()
		sectionAreaDescription()
		sectionAreaSummary()
		if allTidsForCat.count > 0 {
			sectionTransactions()
		}
		buildComplete()
	}
	
	private func sectionAreaDescription() {
		genMajorHeader(
			name: catSummary.friendlyName,
			imageView: UIImageView(),
			vSpace: -20,
			subtitle: catSummary.description)
	}
	
	private func sectionAreaSummary() {
		genSubSectionTitle("Average Spending")
		genMajorValue(amount: catSummary.average)
		genSubvalueDisclosure("Per Month", vSpace: 0)
	}
	
	private func sectionTransactions() {
		genSectionHeader("Transactions")
		tableView.hideUnusedCells()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorInset = .zero // Full width separators
		tableView.isScrollEnabled = false // Using the scroller in the parent view
		tableView.estimatedRowHeight = FIOCategoryDetailViewController.rowHeight
		tableView.rowHeight = FIOCategoryDetailViewController.rowHeight
		tableView.sectionHeaderHeight = QIOBleAreaDetailViewController.headerHeight
		let sectionCount = numberOfSections(in: tableView).asCGFloat
		let heightNeededForHeaders: CGFloat = QIOBleAreaDetailViewController.headerHeight * sectionCount
		let rowCount = allTidsForCat.count.asCGFloat
		let heightNeededForRows: CGFloat = QIOBleAreaDetailViewController.rowHeight * rowCount
		genTableContainer(
			tableView,
			height: heightNeededForHeaders + heightNeededForRows)
	}
	
	// MARK: - Custom
	
	private func loadTransactions() {
		guard allTidsForCat.count > 0 else { return }
		let spinner = UIActivityIndicatorView(style: .gray)
		spinner.color = .q_brandGold
		spinner.startAnimating()
		tableView.backgroundView = spinner
		FIOAppSync.sharedInstance.pullTransactions(transaction_ids: allTidsForCat) { result in
			if let txs = result {
				self.transactions = txs.asFIOTransactionArray
			}
			spinner.stopAnimating()
			self.tableView.reloadData()
		}
	}
	
	private var ble: QSpending_Ble? {
		if
			let uh = QFlow.userHome,
			let spending = uh.spending
		{ return spending.basicLivingExpenses } else
		{ return nil }
	}
	
	private var bleMonths: [QSpending_BleMonth] {
		if
			let uh = QFlow.userHome,
			let spending = uh.spending
		{ return spending.basicLivingExpenses.months } else
		{ return [QSpending_BleMonth]() }
	}

}

extension QIOBleAreaDetailViewController: UITableViewDelegate, UITableViewDataSource {
	
	static let headerHeight: CGFloat = 64.0
	static let rowHeight: CGFloat = 80.0
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return monthCatDetails.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let t = monthCatDetails[section].tids { return t.count }
		else { return 0 }
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return QIOBleAreaDetailViewController.headerHeight
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let sectionHeaderView = UIView()
		sectionHeaderView.translatesAutoresizingMaskIntoConstraints = true
		sectionHeaderView.backgroundColor = UIColor("FAFAFA")
		
		let lblTitle = genLabel(
			bleMonths[section].monthStartDate.YYYYMMDDtoMonthYearString(omitCurrentYear: false),
			font: baseFont(size: 22, bold: true))
		sectionHeaderView.addSubview(lblTitle)
		lblTitle.anchorCenterYToSuperview()
		lblTitle.anchorLeadingToSuperview(constant: 14)
		
		let lblAmount = genLabel()
		lblAmount.textAlignment = .right
		lblAmount.attributedText = monthCatDetails[section].amount.asAttributedCurrencyString(fontSize: 16)
		sectionHeaderView.addSubview(lblAmount)
		lblAmount.anchorCenterYToSuperview()
		lblAmount.anchorTrailingToSuperview(constant: -14)

		return sectionHeaderView
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return QIOBleAreaDetailViewController.rowHeight
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
		if cell == nil { cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier") }
		if let monthTids = monthCatDetails[indexPath.section].tids {
			let tid = monthTids[indexPath.row]
			if
				let c = cell,
				let txs = transactions
			{
				guard let tx: FIOTransaction = txs.first(where: { $0.transaction_id == tid }) else { return c }
				c.quantaDefaultViz()
				c.textLabel?.text = tx.name.prefixToLength(24).lowercased().capitalized
				c.detailTextLabel?.text = tx.date.YYYYMMDDtoFriendlyString()
				c.addThirdLabelToCell(attributedText: tx.amount.asAttributedCurrencyString(fontSize: 16, bold: false))
				c.accessoryType = .disclosureIndicator
			}
		}
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.tableView.deselectRow(at: indexPath, animated: true)
		let tid = monthCatDetails[indexPath.section].tids![indexPath.row]
		navigationController?.pushViewController(
			FIOTransactionDetailViewController(tid),
			animated: true
		)
	}
	
}
