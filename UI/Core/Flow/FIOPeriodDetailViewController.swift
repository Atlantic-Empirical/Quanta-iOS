//
//  FIOPeriodDetailViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 10/13/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOPeriodDetailViewController: QIOBaseViewController, IQIOBaseVC {
	
	// MARK: - Properties
	
	private var model: QIOFlowPeriod!
	private var isProjection: Bool = false
	private var transactionTable = UITableView()
	private var transactionSummaries = [QIOFlowPeriodSummaryTransactionObjSummary]()
	private var tids = [String]()

	// MARK: Transaction Containers
	
	private var nonCCPaymentTransferSummaries: [QIOFlowPeriodSummaryTransactionObjSummary]?
	private var ccPayments: QIOFlowPeriodSummaryTransactionObj?
	private var ccPaymentSummaries: [QIOFlowPeriodSummaryTransactionObjSummary]?
	private var rdfTransactionSummaries: [QIOFlowPeriodSummaryTransactionObjSummary]?
	private var nonRegIncSummaries: [QIOFlowPeriodSummaryTransactionObjSummary]?
	
	// MARK: - Lifecycle
	
	convenience init(_ m: QPeriod) {
		self.init()
		model = QIOFlowPeriod(with: m)
	}

	convenience init(_ m: QYesterday) {
		self.init()
		model = QIOFlowPeriod(with: m)
	}

	convenience init(_ m: QThisMonth) {
		self.init()
		model = QIOFlowPeriod(with: m)
	}

	override func loadView() {
		guard let _ = model else { return }
		customTitle = ""
		super.loadView()
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
		isProjection = model.projection != nil
		setRightBarButton(.info, libraryItem: isProjection ? .ProjectedPeriod : .StandardPeriod)
		scroller.delegate = self
		extractTransactionSummaries()
	}
	
	func extractTransactionSummaries() {
		guard let tx = model.periodSummary.transactions else { return }
		if
			let transfers = tx.transfers,
			let trfSummaries = transfers.transactionSummaries
		{
			nonCCPaymentTransferSummaries = trfSummaries.filter { $0.fioCategoryId != 101 }
		}
		if
			let ccPayments = tx.creditCardPayments,
			let summaries = ccPayments.transactionSummaries
		{
			ccPaymentSummaries = summaries
		}
	}
	
	// MARK: - Actions
	
	@objc func disclosureAction(sender: UIButton) {
		guard let which = QIOPeriodDetailDisclosureActions(rawValue: sender.tag) else { return }
		print(which.asString)
		
		switch which {
			
		case .creditCardAccounts:
			let vc = FIOAccountListViewController()
			vc.accountsToInclude = QFlow.creditCardAccounts
			vc.customTitle = "Credit Cards"
			pushVC(vc)
			
		case .otherDepositTransactions:
			if let summaries = nonRegIncSummaries {
				pushTransactionListWithTids(
					summaries.map { $0.transaction_id },
					listType: .deposits,
					onNavigationController: navigationController)
			}

 		case .regularIncomeTransactions:
			if
				let tx = model.periodSummary.transactions,
				let deposits = tx.regularIncome
			{
				pushTransactionListWithTids(
					deposits.transactionIds,
					listType: .regularIncome,
					onNavigationController: navigationController)
			}

		case .spendTransactions:
			if
				let tx = model.periodSummary.transactions,
				let debits = tx.debits
			{
				pushTransactionListWithTids(debits.transactionIds, onNavigationController: navigationController)
			}
			
		case .transferTransactions:
			if let summaries = nonCCPaymentTransferSummaries {
				pushTransactionListWithTids(
					summaries.map { $0.transaction_id },
					listType: .transfers,
					onNavigationController: navigationController)
			}
			
		case .income: pushVC(FIOIncomeViewController())
		case .moneyRental: pushVC(FIOMoneyRentalViewController())
		case .spending: pushVC(QIOSpendingViewController())
		case .rainyDayFunds: pushVC(FIORainyDetailViewController())
		case .ble: pushVC(QIOBleOverviewViewController())

		case .rainyDayAccounts:
			let vc = FIOAccountListViewController()
			vc.accountsToInclude = QFlow.cushionAccounts
			vc.customTitle = "Rainy Day Funds"
			pushVC(vc)

		case .creditCardPaymentTransactions:
			if let pmts = ccPayments {
				pushVC(QIOCreditCardPaymentsViewController(paymentsIn: pmts))
			}
			
		case .net: break
		case .rainyDayTransactions: break
		case .creditCardTransactions: break
		}
	}

	func pushVC(_ vc: UIViewController) {
		navigationController?.pushViewController(vc, animated: true)
	}
	
	// MARK: - UI Build
	
	override func buildUI() {
		sectionPeriodNet()
		sectionIncome()
		sectionPeriodSpend()
		secBalances()
		secTransactions()
		super.buildComplete()
	}
	
	func sectionPeriodNet() {
//			description: isProjection ? "So Far" : nil)
		
		standardSectionHeader(model.title, addTickForValue: model.periodSummary.netAmount, isFirst: true)

		let out = UIView(frame: .zero)
		out.translatesAutoresizingMaskIntoConstraints = false
		addModuleNew(out)
		out.anchorSidesToSuperview()
		out.anchorCenterYToSuperview(constant: -30)
		out.anchorHeight(120)

		let resultLbl = genMoneyLabel(
			model.periodSummary.netAmount,
			baseTextSize: 90,
			lightFont: true)
		out.addSubview(resultLbl)
		resultLbl.anchorSidesToSuperview()
		resultLbl.anchorCenterYToSuperview()

		if model.periodSummary.netAmount != 0 {
			var imgStr: String
			if model.periodSummary.netAmount > 0 {
				imgStr = "Circle-Arrow-Up"
			} else {
				imgStr = "Circle-Arrow-Down"
			}
			let iv = genImage(imgStr, withTint: .black)
			iv.alpha = 0.06
			out.addSubview(iv)
			iv.anchorSizeConstantSquare(178)
			iv.anchorCenterYToSuperview()
			iv.anchorCenterXTo(out.trailingAnchor, constant: -30)
		}

		if let projection = model.projection {
			genSubvalueDisclosure("Projected: \(projection.net.toCurrencyString())")
		}
	}

	func sectionIncome() {
		
		standardSectionHeader("Money In")
		
		standardUnit(
			title: "Regular Income",
			value: model.periodSummary.income,
			description: "Your \"normal\" earnings for this period.",
			action: #selector(disclosureAction(sender:)),
			tag: QIOPeriodDetailDisclosureActions.income.rawValue,
			vSpace: 0)

		if
			let deposits = model.periodSummary.transactions?.deposits,
			let allSummaries = deposits.transactionSummaries
		{
			nonRegIncSummaries = allSummaries.filter { $0.fioCategoryId != 200 }
			if (nonRegIncSummaries?.count ?? 0) > 0 {
				let total = nonRegIncSummaries?.map { abs($0.amount) }.reduce(0, { x, y in x + y }) ?? 0
				standardUnit(
					title: "Other Income",
					value: total,
					description: "Deposits during this period that were not recognized as regular income.",
					action: #selector(disclosureAction(sender:)),
					tag: QIOPeriodDetailDisclosureActions.otherDepositTransactions.rawValue
				)
			}
		}

		if let projection = model.projection {
			genSubvalueDisclosure("Projected: \(projection.incomeTotal.toCurrencyString())")
		}
	}

	func sectionPeriodSpend() {
		standardSectionHeader("Money Out")

//		genSectionHeader(
//			"Money Out",
//			action: #selector(disclosureAction(sender:)),
//			tag: QIOPeriodDetailDisclosureActions.spending.rawValue,
//			description: isProjection ? "So Far" : nil)

		if
			let tx = model.periodSummary.transactions,
			let debits = tx.debits
		{
			let bleDaily = home.spending?.basicLivingExpenses.estimatedDailyAmount ?? 0
			standardUnit(
				title: "Base Living Expenses",
				value: bleDaily * model.daysInRange.asDouble,
				description: "The spending that comprises your core cost of living, amoritized over this period.",
				action: #selector(disclosureAction(sender:)),
				tag: QIOPeriodDetailDisclosureActions.ble.rawValue,
				vSpace: 0)

			standardUnit(
				title: "Discretionary Spending",
				value: debits.totalAmount,
				description: "You spent this much during the period outside of your base living expenses.",
				action: #selector(disclosureAction(sender:)),
//				tag: QIOPeriodDetailDisclosureActions.spending.rawValue,
				tag: QIOPeriodDetailDisclosureActions.spendTransactions.rawValue)

			if let projection = model.projection {
				genSubvalueDisclosure("Projected: \(projection.spendTotal.toCurrencyString())")
			}
		} else {
			addModuleNew(
				genLabel("No spending in period.", font: baseFont(size: 18, bold: false))
			)
		}
	}
	
	func secBalances() {
		standardSectionHeader("Balances")
		var isFirst = true
		
		if
			QFlow.creditCardAccounts.count > 0,
			let creditCardBalances = model.periodSummary.creditCardsBalance
		{
			isFirst = false
			let start = creditCardBalances.startingBalance
			let end = creditCardBalances.endingBalance
			let delta = end - start
			var str = delta > 0 ? "increased" : "decreased"
			if delta == 0 { str = "didn't change" }
			
			standardUnit(
				title: "Credit Card".pluralize(QFlow.creditCardAccounts.count),
				value: delta,
				description: "Your overall credit card balance \(str) during this period.",
				action: #selector(disclosureAction(sender:)),
				tag: QIOPeriodDetailDisclosureActions.moneyRental.rawValue,
				vSpace: 0,
				addPreTick: true,
				omitZeroValue: true)

			// CC Payments
			if
				let tx = model.periodSummary.transactions,
				let ccpmts = tx.creditCardPayments,
				let pmts = ccpmts.payments
			{
				ccPayments = ccpmts
				genSubvalueDisclosure(
					pmts.count.asString + " Payment".pluralize(pmts),
					vSpace: 5,
					action: #selector(disclosureAction(sender:)),
					tag: QIOPeriodDetailDisclosureActions.creditCardPaymentTransactions.rawValue)
			}
			
			// CC Accounts
			genSubvalueDisclosure(
				QFlow.creditCardAccounts.count.asString + " Credit Card Account".pluralize(QFlow.creditCardAccounts),
				vSpace: 5,
				action: #selector(disclosureAction(sender:)),
				tag: QIOPeriodDetailDisclosureActions.creditCardAccounts.rawValue)
		}

		if
			QFlow.cushionAccounts.count > 0,
			let savingsBalances = model.periodSummary.savingsBalance
		{
//			description: isProjection ? "So Far" : nil
//			let accts = QFlow.cushionAccounts
			let start = savingsBalances.startingBalance
			let end = savingsBalances.endingBalance
			let delta = end - start
			var str = delta > 0 ? "increased" : "decreased"
			if delta == 0 { str = "didn't change" }

			standardUnit(
				title: "Rainy Day Funds",
				value: delta,
				description: "Your rainy day funds balance \(str) during this period.",
				action: #selector(disclosureAction(sender:)),
				tag: QIOPeriodDetailDisclosureActions.rainyDayFunds.rawValue,
				vSpace: isFirst ? 0 : 20,
				addPreTick: true,
				omitZeroValue: true)

//			// RDF Transactions
//			genSubvalueDisclosure(
//				pmts.count.asString + " Transaction".pluralize(pmts),
//				vSpace: 5,
//				action: #selector(disclosureAction(sender:)),
//				tag: QIOPeriodDetailDisclosureActions.rainyDayTransactions.rawValue)

			// RDF Accounts
			genSubvalueDisclosure(
				QFlow.cushionAccounts.count.asString + " Rainy Day Account".pluralize(QFlow.cushionAccounts),
				vSpace: 5,
				action: #selector(disclosureAction(sender:)),
				tag: QIOPeriodDetailDisclosureActions.rainyDayAccounts.rawValue)
		}
	}

	func secTransactions() {
		guard let txs = model.periodSummary.transactions else { return }
		
		if
			let cctx = txs.creditCardPayments,
			let txs0 = cctx.transactionSummaries
		{ transactionSummaries.append(contentsOf: txs0) }
		
		if
			let debtx = txs.debits,
			let txs1 = debtx.transactionSummaries
		{ transactionSummaries.append(contentsOf: txs1) }
		
		if let deptx = txs.deposits, let txs2 = deptx.transactionSummaries { transactionSummaries.append(contentsOf: txs2) }
		if let ritx = txs.regularIncome, let txs3 = ritx.transactionSummaries { transactionSummaries.append(contentsOf: txs3) }
		if let txtx = txs.transfers, let txs4 = txtx.transactionSummaries { transactionSummaries.append(contentsOf: txs4) }
		
		standardSectionHeader("Transactions")
//		genSectionHeader("Transactions", description: "All transactions for the period, including transfers and deposits of regular income.")
		transactionTable.delegate = self
		transactionTable.dataSource = self
		transactionTable.separatorInset = .zero // Full width separators
		transactionTable.isScrollEnabled = false // Using the scroller in the parent view
		transactionTable.estimatedRowHeight = FIOCategoryDetailViewController.rowHeight
		transactionTable.rowHeight = FIOCategoryDetailViewController.rowHeight
		genTableContainer(
			transactionTable,
			height: FIOCategoryDetailViewController.rowHeight * transactionSummaries.count.asCGFloat,
			vSpace: 0)
	}
	
//	func otherTransactions() {
//		genSectionHeader(
//			"Other Transactions",
//			description: isProjection ? "So Far" : nil
//		)
//
//		// Transfers
//		if
//			let tx = model.periodSummary.transactions,
//			let transfers = tx.transfers,
//			let allSummaries = transfers.transactionSummaries
//		{
//			let summaries = allSummaries.filter { $0.fioCategoryId != 101 }
//			if summaries.count > 0 {
//				genSubvalueDisclosure(
//					summaries.count.asString + " Transfer".pluralize(summaries.count) + " and/or Refund".pluralize(summaries.count),
//					action: #selector(disclosureAction(sender:)),
//					tag: QIOPeriodDetailDisclosureActions.transferTransactions.rawValue)
//				self.nonCCPaymentTransferSummaries = summaries
//			}
//		}
//
//		// Deposits
//		if
//			let tx = model.periodSummary.transactions,
//			let deposits = tx.deposits,
//			deposits.transactionIds.count > 0
//		{
//			genSubvalueDisclosure(
//				deposits.transactionIds.count.asString + " Deposit".pluralize(deposits.transactionIds),
//				action: #selector(disclosureAction(sender:)),
//				tag: QIOPeriodDetailDisclosureActions.depositTransactions.rawValue)
//		}
//
//		// Regular Income
//		if
//			let tx = model.periodSummary.transactions,
//			let regularIncome = tx.regularIncome,
//			regularIncome.transactionIds.count > 0
//		{
//			genSubvalueDisclosure(
//				regularIncome.transactionIds.count.asString + " Regular Income",
//				action: #selector(disclosureAction(sender:)),
//				tag: QIOPeriodDetailDisclosureActions.regularIncomeTransactions.rawValue)
//		}
//	}

	// MARK: - UI Elements
	
	func standardUnit(
		title: String,
		value: Double,
		description: String,
		action: Selector? = nil,
		tag: Int = 0,
		vSpace: CGFloat = 20,
		addPreTick: Bool = false,
		omitZeroValue: Bool = false
	) {
		genSubSectionTitle(title, vSpace: vSpace)
		
		var descSpace: CGFloat = 0
		
		if omitZeroValue && value == 0 {
			// Leave it out
			descSpace = 10
		} else {
			genMajorAmountValue(
				amount: value,
				addDisclosure: true,
				action: action,
				tag: tag,
				vSpace: -2,
				addTick: addPreTick,
				baseTextSize: 52,
				tickBeforeValue: true)
		}
		genSubvalueDisclosure(
			description,
			vSpace: descSpace,
			font: baseFont(size: 16, bold: false))
	}
	
}

// MARK: - Transaction Table

extension FIOPeriodDetailViewController: UITableViewDelegate, UITableViewDataSource {
	
	static var rowHeight: CGFloat = 64.0
	
	// MARK: - Delegate
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return transactionSummaries.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
		if cell == nil {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
		}
		
		if let c = cell {
			c.quantaDefaultViz()
			let tx: QIOFlowPeriodSummaryTransactionObjSummary = transactionSummaries[indexPath.row]
			c.textLabel?.text = tx.name.capitalized.prefixToLength(28)
			c.textLabel?.w = 226.0
			c.detailTextLabel?.text = tx.date.YYYYMMDDtoFriendlyString()
			c.detailTextLabel?.w = 226.0
			c.detailTextLabel?.x = 0
			let l = c.addThirdLabelToCell("")
			l.text = nil
			l.attributedText = tx.amount.asAttributedCurrencyString(fontSize: 16, bold: false)
			c.accessoryType = .disclosureIndicator
		}
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		navigationController?.pushViewController(
			FIOTransactionDetailViewController(transactionSummaries[indexPath.row].transaction_id),
			animated: true
		)
	}
	
}

// MARK: - UIScrollViewDelegate

extension FIOPeriodDetailViewController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y <= 80 {
			title = ""
		} else if title == "" {
			title = model.title
		}
	}
	
}

enum QIOPeriodDetailDisclosureActions: Int {
	
	case net

	case income
	case regularIncomeTransactions
	case otherDepositTransactions

	case moneyRental
	case creditCardAccounts
	case creditCardPaymentTransactions
	case creditCardTransactions

	case spending
	case spendTransactions
	case ble

	case rainyDayFunds
	case rainyDayAccounts
	case rainyDayTransactions
	
	case transferTransactions

	func asString() -> String { return "\(self)" }
	
}
