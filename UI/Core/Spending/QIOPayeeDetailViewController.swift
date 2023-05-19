//
//  QIOPayeeDetailViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/13/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOPayeeDetailViewController: QIOBaseViewController, IQIOBaseVC {

	// MARK: - Properties
	
	private var payee: QSpending_QuantizedItem!
	private var transactionTable = UITableView()
	private var transactions: [FIOTransaction]!

	// MARK: - View Lifecycle
	
	convenience init(_ p: QSpending_QuantizedItem) {
		self.init()
		self.payee = p
	}

	override func loadView() {
		customTitle = "Payee Info"
		super.loadView()
//		setRightBarButton(.info, libraryItem: .Spending)
		pullTransactions()
	}
	
	// MARK: - Actions
	
	func disclosureAction(sender: UIButton) {
		switch sender.tag {
		case 1:
			navigationController?.pushViewController(
				FIOTransactionListViewController(transactions),
				animated: true
			)
		default: break
		}
	}

	// MARK: - Custom
	
	override func buildUI() {
		genMajorHeader(name: payee.nameFriendly.prefixToLength(32))
		sectionAmounts()
		if payee.isRecurring {
			sectionTiming()
		}
		sectionTransactions()
		buildComplete()
	}

	private func sectionAmounts() {
		genSubSectionTitle("Daily Spend")
		genMajorValue(amount: payee.dailyAvg)
		genSubvalueDisclosure((payee.dailyAvg * averageDaysPerMonth).toCurrencyString() + " per month", vSpace: 0)
		
		genSubSectionTitle("Three Month Total")
		genMajorValue(amount: payee.pastThreeMonths)

		genSubSectionTitle("Twelve Month Total")
		genMajorValue(amount: payee.pastTwelveMonths)
	}
	
	private func sectionTiming() {
		guard let rs = payee.recurringStream else { return }
		genSectionHeader("Timing")
		
		genSubSectionTitle("Frequency")
		let freq = rs.periodSize + (rs.periodSize.lowercased().hasSuffix("ly") ? "" : "ly")
		genMajorValue(freq.capitalized, vSpace: 10, baseTextSize: 40)
		
		genSubSectionTitle("Last Transaction Date")
		addModuleNew(
			genLabel(
				rs.dateDistribution.lastDate.YYYYMMDDtoFriendlyString(.medium),
				font: baseFont(size: 40, bold: true)),
			vSpace: 5)
		
		genSubSectionTitle("Days Until Next")
		genMajorValue("\(rs.dateDistribution.daysUntilNext)", baseTextSize: 40)
	}
	
	private func sectionTransactions() {
		genSectionHeader("Transactions", action: #selector(disclosureAction(sender:)), tag: 1)
		transactionTable.delegate = self
		transactionTable.dataSource = self
		transactionTable.separatorInset = .zero // Full width separators
		transactionTable.isScrollEnabled = false // Using the scroller in the parent view
		transactionTable.estimatedRowHeight = QIOPayeeDetailViewController.rowHeight
		transactionTable.rowHeight = QIOPayeeDetailViewController.rowHeight
		genTableContainer(
			transactionTable,
			height: QIOPayeeDetailViewController.rowHeight * payee.twelveMonthTids.count.asCGFloat)
	}
	
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

extension QIOPayeeDetailViewController: UITableViewDelegate, UITableViewDataSource {
	
	static var rowHeight: CGFloat = 64.0
	
	private func pullTransactions() {
		#if targetEnvironment(simulator)
		// Useful for debugging in the Lambda
		print("transaction_ids: [")
		payee.twelveMonthTids.forEach { print( "\"" + $0 + "\",") }
		print("]")
		#endif
		
		transactionTable.backgroundView = activityIndicator // start table spinner
		activityIndicator.anchorCenterXToSuperview()
		activityIndicator.anchorTopToSuperview(constant: 16)

		FIOAppSync.sharedInstance.pullTransactions(transaction_ids: payee.twelveMonthTids) {
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
				c.textLabel?.text = tx.date.YYYYMMDDtoFriendlyString()
				c.textLabel?.w = 226.0
				c.detailTextLabel?.text = tx.name.capitalized.prefixToLength(32)
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
			print(payee.twelveMonthTids[indexPath.row] as Any)
		}
	}
	
}

//	private func sectionAmountsUsingAmountDistribution() {
//		guard let ad = payee.recurringStream?.amountDistribution else { return }
//
//		genSubSectionTitle("Daily", vSpace: 10)
//		genMajorValue(amount: ad.dailyEstimate, vSpace: -5)
//
//		genSubSectionTitle("Monthly", vSpace: 10)
//		genMajorValue(amount: ad.monthlyEstimate, vSpace: -5)
//
//		genSubSectionTitle("Annually", vSpace: 10)
//		genMajorValue(amount: ad.annualEstimate, vSpace: -5)
//
//		//			genMajorValue(amount: ad.totalAmountEver)
//	}
