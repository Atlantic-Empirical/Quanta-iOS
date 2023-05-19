//
//  FIOMapItemPeekViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 10/13/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOCategoryDetailViewController: QIOBaseViewController, IQIOBaseVC {

	// MARK: - Model
	
	var cat: QIOCat!
	var categories: FIOCategories!

	// MARK: - Properties
	
	private var categoryIndex: Int!
	private var categoryTids: [String]?
	private var transactionTable = UITableView()
	private var transactions: [FIOTransaction]?

	// MARK: - View Lifecycle
	
	convenience init(cat: QIOCat, fioCats: FIOCategories) {
		self.init()
		self.cat = cat
		customTitle = cat.name
		categories = fioCats
		categoryIndex = FIOCategories.indexForFIOCategoryId(cat.id)
		categoryTids = cat.tids
	}
	
	override func loadView() {
		super.loadView()
		setRightBarButton(.info, libraryItem: .Spending)
	}
	
	// MARK: - Actions
	
	func disclosureAction(sender: UIButton) {
		//
	}

	// MARK: - UI Build

	override func buildUI() {
		pullTransactions()
		sectionCatDescription()
		sectionCatOverview()
		if categoryTids?.count ?? 0 > 0 {
			sectionTransactions()
		}
		buildComplete()
	}
	
	private func sectionCatDescription() {
		addModuleNew(
			genLabel(
				cat.description,
				font: baseFont(size: 16, bold: false)),
			vSpace: 20
		)
		let summary: String = "In the past \(categories.dayCount.asString) days you've spent \(cat.amount.toCurrencyString()) in the \(cat.name) category. That is \(cat.percentage.toStringPercent()) of all your spending in that time."
		addModuleNew(
			genLabel(summary, font: baseFont(size: 16, bold: false)),
			vSpace: 5
		)
	}
	
	private func sectionCatOverview() {
		let dayCountStr = categories.dayCount.asString
		if categoryTids!.count > 0 {
			genSectionHeader("Summary")
			genSubSectionTitle("\(categories.dayCount.asString) Day Spending")
			genMajorValue(amount: cat.amount)
			genSubSectionTitle("Percent of Spending")
			genMajorValue(
				cat.percentage.toStringPercent(1, includePercentSign: false),
				suffix: "%")
		} else {
			let summary = "No \(cat.name) spending in the past \(dayCountStr) days. 🙌"
			addModuleNew(genLabel(summary, font: baseFont(size: 15, bold: false)))
		}
	}
	
	private func sectionTransactions() {
		genSectionHeader("Transactions", description: "\(cat.name) over past \(categories.dayCount.asString) days")
		transactionTable.delegate = self
		transactionTable.dataSource = self
		transactionTable.separatorInset = .zero // Full width separators
		transactionTable.isScrollEnabled = false // Using the scroller in the parent view
		transactionTable.estimatedRowHeight = FIOCategoryDetailViewController.rowHeight
		transactionTable.rowHeight = FIOCategoryDetailViewController.rowHeight
		genTableContainer(
			transactionTable,
			height: FIOCategoryDetailViewController.rowHeight * (categoryTids?.count ?? 0).asCGFloat)
	}

	// MARK: - Etc
	
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

extension FIOCategoryDetailViewController: UITableViewDelegate, UITableViewDataSource {

	static var rowHeight: CGFloat = 64.0
	
	private func pullTransactions() {
		#if targetEnvironment(simulator)
		// Useful for debugging in the Lambda
		print("transaction_ids: [")
		categoryTids!.forEach { print( "\"" + $0 + "\",") }
		print("]")
		#endif

		transactionTable.backgroundView = activityIndicator // start table spinner
		activityIndicator.anchorCenterXToSuperview()
		activityIndicator.anchorTopToSuperview(constant: 16)
		
		FIOAppSync.sharedInstance.pullTransactions(transaction_ids: categoryTids!) {
			(result: [QTransaction]?) in
			
			if let txs = result {
				self.transactions = txs.asFIOTransactionArray
				self.transactionTable.reloadData()
			}
			self.transactionTable.backgroundView = nil
		}
	}
	
	@objc func pushFullTransactionList() {
		guard let txs = transactions else { return }
		navigationController?.pushViewController(
			FIOTransactionListViewController(txs),
			animated: true
		)
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
				c.quantaDefaultViz()
				let tx: FIOTransaction = txs[indexPath.row]
				c.textLabel?.text = tx.friendlyName
				c.textLabel?.w = 226.0
				c.detailTextLabel?.text = tx.date.YYYYMMDDtoFriendlyString()
				c.detailTextLabel?.w = 226.0
				c.detailTextLabel?.x = 0
				let l = c.addThirdLabelToCell("")
				l.text = nil
				l.attributedText = tx.amount.asAttributedCurrencyString(fontSize: 16, bold: false)
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
			let summary: FIOTransaction = transactions![indexPath.row]
			navigationController?.pushViewController(
				FIOTransactionDetailViewController(summary.transaction_id),
				animated: true
			)
		} else {
			print(categoryTids![indexPath.row])
		}
	}

}
