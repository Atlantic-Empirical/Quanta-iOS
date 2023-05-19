//
//  FIOCcAccountDetailViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 11/12/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOAccountDetailViewController: QIOBaseViewController, IQIOBaseVC {

	let transactionCount: CGFloat = 50
	
	// MARK: - Properties

	private var account: QAccount!
	private var item: QItem!
	private var transactions: [QTransaction_Account]!
	private var transactionTable = UITableView()
	
	// MARK: - View Lifecycle
	
	convenience init(_ a: QAccount) {
		self.init()
		self.account = a
		self.item = QFlow.itemById(itemId: a.itemId)
	}

	override func loadView() {
		customTitle = "Account Info"
		super.loadView()
//		setRightBarButton(.info, libraryItem: .AboutQuanta)
		pullTransactions()
	}
	
	// MARK: - Actions

	@objc func hideAccountActionToggle() {
		FIOControlFullscreenActivity.shared.presentOver(view, message: "Hiding \(account.name)")
		FIOAppSync.sharedInstance.setAccountsHidden(masterAccountIds: [account.masterAccountId]) { res in
			switch res {
			case .success(let suc):
				print("setAccountsHidden SUCCESS: \(suc)")
				AppDelegate.sharedInstance.hardStopAlert(
					title: "Success",
					message: "\(self.account.name) is now hidden within \(appName)")
			case .failure(let fail):
				print("setAccountsHidden FAILURE: \(fail)")
				AppDelegate.sharedInstance.hardStopAlert(
					title: "🤨",
					message: "Sorry about this, there was a problem while hiding \(self.account.name). The \(appName) engineering team has been notified and they will look into what went wrong.")
			}
		}
	}
	
	@objc func accountHideInfoAction() {
		AppDelegate.sharedInstance.nop(#function)
	}

	func disclosureAction(sender: UIButton) {
		switch sender.tag {
			
		case 1:
			navigationController?.pushViewController(
				FIOTransactionListViewController(
					transactions.asFIOTransactionArray,
					useCategorySections: false
				),
				animated: true
			)

		default: break
		}
	}

	// MARK: - Custom

	override func buildUI() {
		sectionHeader()
		sectionBalance()
		sectionTransactions()
		buildComplete()
	}

	private func sectionHeader() {
		let iv = genImage(nil)
		item.logoImage() { img in
			iv.image = img
		}
		var titleName: String = ""
		var subtitle: String? = nil
		let officialName = account.officialName ?? ""
		if account.name == "" && officialName != "" {
			titleName = officialName
		} else if account.name != "" && officialName != "" {
			titleName = account.name
			subtitle = officialName
		} else if account.name != "" && officialName == "" {
			titleName = account.name
		}
		genMajorHeader(name: titleName, imageView: iv, subtitle: subtitle)
	}

	private func sectionBalance() {
		if
			let balances = account.balances,
			let currentBalance = balances.current
		{
			genSubSectionTitle("Current Balance")
			genMajorValue(amount: currentBalance)

			if let limit = balances.limit {
				genSubSectionTitle("Credit Limit")
				genMajorValue(amount: limit)
			}

			if let avail = balances.available {
				genSubSectionTitle("Available Balance")
				genMajorValue(amount: avail)
			}
		}
	}

	private func sectionTransactions() {
		genSectionHeader(
			"Transactions",
			action: #selector(disclosureAction(sender:)),
			tag: 1)
		transactionTable.delegate = self
		transactionTable.dataSource = self
		transactionTable.separatorInset = .zero // Full width separators
		transactionTable.isScrollEnabled = false // Using the scroller in the parent view
		transactionTable.estimatedRowHeight = FIOCategoryDetailViewController.rowHeight
		transactionTable.rowHeight = FIOCategoryDetailViewController.rowHeight
		genTableContainer(
			transactionTable,
			height: FIOCategoryDetailViewController.rowHeight * transactionCount)
	}
	
	private func toggleHiddenModule() -> UIView {
		let v = UIView()
		v.w = moduleWidth
		var accountIsHidden: Bool = false
		if let b = account.hidden { accountIsHidden = b }
		let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 230.0, height: 44.0))
		btn.center.x = v.w/2
		btn.backgroundColor = .q_buttonBlue
		btn.setTitle(accountIsHidden ? "Unhide Account" : "Hide Account", for: .normal)
		btn.addTarget(self, action: #selector(hideAccountActionToggle), for: .touchUpInside)
		btn.cornerRadius = 8.0
		btn.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .semibold)
		v.addSubview(btn)
		v.setHeight()
		return v
	}

	// MARK: - Custom
	
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

extension FIOAccountDetailViewController: UITableViewDelegate, UITableViewDataSource {
	
	static var rowHeight: CGFloat = 64.0
	
	private func pullTransactions() {
		transactionTable.backgroundView = activityIndicator // start table spinner
		activityIndicator.anchorCenterXToSuperview()
		activityIndicator.anchorTopToSuperview(constant: 16)
		
		FIOAppSync.sharedInstance.transactionsForAccount(account.masterAccountId) { res in
			self.transactionTable.backgroundView = nil
			switch res {
			case .success(let transactions):
				self.transactions = transactions?.sorted(by: { $0.date > $1.date })
				self.transactionTable.reloadData()
			case .failure(let fail): print(fail.localizedDescription + " in " + #function)
			}
		}

	}

	// MARK: - Delegate
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return transactionCount.asInt
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
		if cell == nil {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
		}
		
		if let c = cell, let txs = transactions {
			if indexPath.row < txs.count {
				c.quantaDefaultViz()
				let tx: FIOTransaction = FIOTransaction(txs[indexPath.row])
				c.textLabel?.text = tx.name.capitalized.prefixToLength(32)
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
		
		if indexPath.row < transactions.count {
			navigationController?.pushViewController(
				FIOTransactionDetailViewController(transactions[indexPath.row].asFIOTransaction),
				animated: true
			)
		}
	}
	
}

extension QTransaction_Account {
	
	var asFIOTransaction: FIOTransaction {
		return FIOTransaction(self)
	}
	
}
