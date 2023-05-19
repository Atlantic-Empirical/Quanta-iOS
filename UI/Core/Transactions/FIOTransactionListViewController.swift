//
//  FIOTransactionListViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/1/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOTransactionListViewController: QIOBaseViewController, IQIOBaseVC {

    // MARK: - Properties
	
	let tableView = UITableView()
	var listType: QIOTransactionListType = .generic
	var titleProperty: QIOTransactionProperty = .name
	var subtitleProperty: QIOTransactionProperty = .date
	var thirdProperty: QIOTransactionProperty = .amount
    private var transaction_ids: [String]?
	private var transactions: [FIOTransaction]?
	private var byCategory = [String: Array<FIOTransaction>] ()
	private var useCategorySections: Bool = true
	private var sections = Array<String>()
	
    // MARK: - View Lifecycle

	convenience init(
		_ ts: [FIOTransaction],
		useCategorySections: Bool = true,
		titleProperty: QIOTransactionProperty = .name,
		subtitleProperty: QIOTransactionProperty = .date,
		thirdProperty: QIOTransactionProperty = .amount
	) {
		self.init()
		self.transactions = ts
		self.transaction_ids = ts.map { $0.transaction_id }
		self.useCategorySections = useCategorySections
		self.titleProperty = titleProperty
		self.subtitleProperty = subtitleProperty
		self.thirdProperty = thirdProperty
	}

	convenience init(_ tids: [String]) {
		self.init()
		self.transaction_ids = tids
	}

	override func loadView() {
		customTitle = "Transactions"
		super.loadView()
		navigationItem.backBarButtonItem = .nil()
//		setRightBarButton(.info, libraryItem: .TermsOfUse)
		showSearch = true
	}
	
	// MARK: - Actions
	
	func disclosureAction(sender: UIButton) {
		//
	}

	// MARK: - UI
	
	override func buildUI() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.delegate = self
		tableView.dataSource = self
		tableView.hideUnusedCells()
		tableView.rowHeight = 80
		tableView.frame = view.safeAreaLayoutGuide.layoutFrame
		view.addSubview(tableView)
		tableView.anchorCenterToSuperview()
		tableView.anchorHeight(view.safeAreaLayoutGuide.layoutFrame.h)
		tableView.anchorWidthToSuperview(constant: 0)

		if let _ = transactions {
			if useCategorySections { extractCategories() }
			tableView.reloadData()
			buildComplete()
		} else if let tids = transaction_ids {
			if transactions == nil && tids.count > 0 {
				loadTransactionsForTids(tids)
			} else {
				tableView.reloadData() // jdi
				buildComplete()
			}
		} else {
			// Load ALL transactions for user.
			loadTransactionsForTids(nil)
		}
	}
	
    // MARK: - Custom

	private func loadTransactionsForTids(_ tids: [String]?) {
		let tidsIsNil = tids == nil
		if tidsIsNil, let localAllTransactions = QFlow.allTransactions {
			// We already have fresh, local all transactions
			self.transactions = localAllTransactions.asFIOTransactionArray
		} else {

			tableView.backgroundView = activityIndicator // start table spinner
			activityIndicator.anchorCenterXToSuperview()
			activityIndicator.anchorTopToSuperview(constant: 16)

			FIOAppSync.sharedInstance.pullTransactions(transaction_ids: tids) {
				(result: [QTransaction]?) in
				
				if let txs = result {
					self.transactions = txs.asFIOTransactionArray
					if tidsIsNil {
						QFlow.allTransactions = txs // This result is *all* of the user's transactions
					}
				}
				self.activityIndicator.stopAnimating()
				if self.useCategorySections { self.extractCategories() }
				self.tableView.reloadData()
				self.buildComplete()
			}
		}
	}
	
    private func extractCategories() {
		guard let ts = transactions else { return }
        if (ts.count < 1) { return }
		
		let noCategoryString: String = "No Category"

		// map the 'category' property out of self.transactionSummaries
		let fioCategories = ts.compactMap { $0.fioCategoryId }
		var categorySet: Set<String> = Set()
		fioCategories.forEach {
			categorySet.insert(FIOCategories.categoryNameForId($0))
		}
		categorySet.insert(noCategoryString)
		
		sections = Array<String>(categorySet)
		sections = sections.sorted()
		
		// Init the transaction array for each category so that the arrays can be populated in the next step
		for c: String in self.sections {
			self.byCategory[c] = Array<FIOTransaction>()
		}
		
		// Insert each transaction into the array matching its fioCategory
		for t in ts {
			let name = FIOCategories.categoryNameForId(t.fioCategoryId)
			self.byCategory[name]!.append(t)
		}
		
		// Remove the No Category section if there are no transactions contained
		if (self.byCategory[noCategoryString]?.count == 0) {
			self.byCategory.removeValue(forKey: noCategoryString)
			self.sections.remove(at: self.sections.firstIndex(of: noCategoryString)!)
		}
    }

	private func sumOfSection(_ sectionNumber: Int) -> Double {
		if let a: [FIOTransaction] = self.byCategory[self.sections[sectionNumber]] {
			return a.map({$0.amount}).reduce(0, +)
		} else {
			return 0
		}
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

extension FIOTransactionListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func estimatedHeightForTable(_ tv: UITableView) -> CGFloat {
		var out: CGFloat = 0
		for section in 0...(self.numberOfSections(in: tv) - 1) {
			out += max(self.tableView(tv, heightForHeaderInSection: section), 0)
			out += (tv.rowHeight * self.tableView(tv, numberOfRowsInSection: section).asCGFloat)
			// self.tableView(tv, heightForRowAt: <#T##IndexPath#>)
		}
		return out
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		if useCategorySections { return self.byCategory.count }
		else { return 1 }
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if useCategorySections {
			if let _ = transactions {
				let a: [FIOTransaction] = self.byCategory[self.sections[section]]!
				return a.count
			} else {
				return 0
			}
		} else {
			return transactions?.count ?? 0
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if numberOfSections(in: tableView) == 1 {
			return 0
		} else {
			return 60
		}
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard useCategorySections else { return nil }
		let sectionHeaderView = UIView()
		sectionHeaderView.translatesAutoresizingMaskIntoConstraints = true
		sectionHeaderView.backgroundColor = UIColor("FAFAFA")
		
		let lblTitle = genLabel(self.sections[section].capitalized, font: baseFont(size: 22, bold: true))
		sectionHeaderView.addSubview(lblTitle)
		lblTitle.anchorCenterYToSuperview()
		lblTitle.anchorLeadingToSuperview(constant: 14)
		
		if  listType != .transfers {
			let lblAmount = genLabel()
			lblAmount.textAlignment = .right
			lblAmount.attributedText = sumOfSection(section).asAttributedCurrencyString(fontSize: 16)
			sectionHeaderView.addSubview(lblAmount)
			lblAmount.anchorCenterYToSuperview()
			lblAmount.anchorTrailingToSuperview(constant: -14)
		}
		return sectionHeaderView
	}
		
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.cellGenerator(style: .subtitle)
		cell.accessoryType = .disclosureIndicator
		var name: String = "", date: String = "", amount: Double = 0

		cell.quantaDefaultViz()
		cell.textLabel?.text = ""
		cell.textLabel?.attributedText = nil
		cell.detailTextLabel?.text = ""
		cell.detailTextLabel?.attributedText = nil
		
		let tx = useCategorySections ?
			byCategory[sections[indexPath.section]]![indexPath.row] :
			transactions![indexPath.row]
		amount = tx.amount
		name = tx.friendlyName // name.prefixToLength(24).capitalized
		date = tx.date.YYYYMMDDtoFriendlyString()
		
		switch titleProperty {
		case .name: cell.textLabel?.text = name
		case .date: cell.textLabel?.text = date
		case .amount: cell.textLabel?.attributedText = amount.asAttributedCurrencyString(fontSize: 16)
		case .none: break
		}
		switch subtitleProperty {
		case .name: cell.detailTextLabel?.text = name
		case .date: cell.detailTextLabel?.text = date
		case .amount: cell.detailTextLabel?.attributedText = amount.asAttributedCurrencyString(fontSize: 16)
		case .none: break
		}
		switch thirdProperty {
		case .name: cell.addThirdLabelToCell(name)
		case .date: cell.addThirdLabelToCell(date)
		case .amount: cell.addThirdLabelToCell(attributedText: amount.asAttributedCurrencyString(fontSize: 16, bold: false))
		case .none: break
		}

		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.tableView.deselectRow(at: indexPath, animated: true)
		var tid: String = ""
		if useCategorySections {
			let summary: FIOTransaction = self.byCategory[self.sections[indexPath.section]]![indexPath.row]
			tid = summary.transaction_id
			navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
		} else {
			tid = transactions![indexPath.row].transaction_id
		}
		navigationController?.pushViewController(
			FIOTransactionDetailViewController(tid),
			animated: true
		)
	}
	
}
