//
//  FIOSpendStreamDetailViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 1/23/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOIncomeStreamDetailViewController: QIOBaseViewController, IQIOBaseVC {

	// MARK: - Properties

	private var transactionTable = UITableView()
	private var stream: FIORecurringStream!
//	private var spendStream: QSpending.Stream?
	private var activeIncomeStream: QIncome.ActiveStream?
	private var inactiveIncomeStream: QIncome.InactiveStream?
	private var transactions: [FIOTransaction]!
	private var tids: [String]!
 
	// MARK: - View Lifecycle

//	convenience init(_ s: QSpending.Stream) {
//		self.init()
//		self.spendStream = s
//		self.stream = FIORecurringStream(s)
//	}

	convenience init(_ s: QIncome.ActiveStream) {
		self.init()
		self.activeIncomeStream = s
		self.stream = FIORecurringStream(s)
	}

	convenience init(_ s: QIncome.InactiveStream) {
		self.init()
		self.inactiveIncomeStream = s
		self.stream = FIORecurringStream(s)
	}
	
	override func loadView() {
		customTitle = "Money Stream"
		super.loadView()
		guard let _ = stream else { return }
		tids = stream.tids
		pullTransactions()
		setRightBarButton(.info, libraryItem: .Income)
	}
	
	// MARK: - Actions
	
	func disclosureAction(sender: UIButton) {
	}
	
	
	@objc func pushFullTransactionList() {
		navigationController?.pushViewController(
			FIOTransactionListViewController(transactions),
			animated: true
		)
	}
	
	// MARK: - UI
	
	override func buildUI() {
		genMajorHeader(name: stream.nameFriendly)
		sectionAmount()
		sectionTiming()
		sectionTransactions()
		buildComplete()
	}
	
	private func sectionAmount() {
		if let a = stream.amountDistribution {
			genSectionHeader("Amount", vSpace: -60, includeSpacer: false)
			
			genSubSectionTitle("Daily")
			genMajorValue(amount: a.dailyEstimate, vSpace: -5)

			genSubSectionTitle("Monthly", vSpace: 10)
			genMajorValue(amount: a.monthlyEstimate, vSpace: -5)

			genSubSectionTitle("Annually", vSpace: 10)
			genMajorValue(amount: a.annualEstimate, vSpace: -5)
			
//			genMajorValue(amount: a.totalAmountEver)
		}
	}
	
	private func sectionTiming() {
		genSectionHeader("Timing")

		genSubSectionTitle("Frequency")
		let freq = stream.periodSize + (stream.periodSize.lowercased().hasSuffix("ly") ? "" : "ly")
		genMajorValue(freq.capitalized, vSpace: 10, baseTextSize: 40)
		
		if let d = stream.dateDistribution {
			genSubSectionTitle("Last Transaction Date")
			addModuleNew(
				genLabel(
					d.lastDate.YYYYMMDDtoFriendlyString(.medium),
					font: baseFont(size: 40, bold: true)),
				vSpace: 5)

			genSubSectionTitle("Days Until Next")
			genMajorValue("\(d.daysUntilNext)", baseTextSize: 40)
		}
	}
	
	private func sectionTransactions() {
		genSectionHeader("Transactions")
		transactionTable.delegate = self
		transactionTable.dataSource = self
		transactionTable.separatorInset = .zero // Full width separators
		transactionTable.isScrollEnabled = false // Using the scroller in the parent view
		transactionTable.estimatedRowHeight = FIOCategoryDetailViewController.rowHeight
		transactionTable.rowHeight = FIOCategoryDetailViewController.rowHeight
		let tableHeight = (FIOCategoryDetailViewController.rowHeight * tids.count.asCGFloat)
			+ QIOIncomeStreamDetailViewController.headerHeight
		genTableContainer(transactionTable, height: tableHeight)
	}

	// MARK: - ETC
	
	lazy var activityIndicator: UIActivityIndicatorView = {
		let ai = UIActivityIndicatorView(frame: .zero)
		ai.translatesAutoresizingMaskIntoConstraints = false
		ai.hidesWhenStopped = true
		ai.style = .gray
		ai.color = .q_brandGold
		ai.startAnimating()
		return ai
	}()

}

// MARK: - Transaction Table

extension QIOIncomeStreamDetailViewController: UITableViewDelegate, UITableViewDataSource {
	
	static var rowHeight: CGFloat = 70.0
	static var headerHeight: CGFloat = 80.0
	
	private func pullTransactions() {
		#if targetEnvironment(simulator)
		// Useful for debugging in the Lambda
		print("transaction_ids: [")
		tids.forEach { print( "\"" + $0 + "\",") }
		print("]")
		#endif
		
		transactionTable.backgroundView = activityIndicator // start table spinner
		activityIndicator.anchorCenterXToSuperview()
		activityIndicator.anchorTopToSuperview(constant: 16)

		FIOAppSync.sharedInstance.pullTransactions(transaction_ids: tids) {
			(result: [QTransaction]?) in
			
			if let txs = result {
				self.transactions = txs.asFIOTransactionArray
				self.transactionTable.reloadData()
			}
			self.transactionTable.backgroundView = nil
		}
	}
	
	// MARK: - Delegate
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return transactions?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
		if cell == nil {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
		}
		
		if let c = cell, let txs = transactions {
			if indexPath.row < txs.count {
				let tx: FIOTransaction = txs[indexPath.row]
				c.quantaDefaultViz()
				c.textLabel?.text = tx.name.capitalized.prefixToLength(28)
				c.textLabel?.w = 226.0
				c.detailTextLabel?.text = tx.date.YYYYMMDDtoFriendlyString()
				c.detailTextLabel?.w = 226.0
				c.addThirdLabelToCell(attributedText: tx.amount.asAttributedCurrencyString(fontSize: 16, bold: false))
				c.accessoryType = .disclosureIndicator
			} else {
				// Server returned fewer transactions than expected. Put a cell in for now to help figure out when/why this is happening.
				c.textLabel?.text = "Missing Transaction"
				c.detailTextLabel?.text = ""
				c.addThirdLabelToCell("")
				c.accessoryType = .none
			}
		}
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if indexPath.row < transactions!.count {
			navigationController?.pushViewController(
				FIOTransactionDetailViewController(transactions[indexPath.row]),
				animated: true
			)
//			let summary: FIOTransaction =
		} else {
			print(tids[indexPath.row])
		}
	}
	
}
