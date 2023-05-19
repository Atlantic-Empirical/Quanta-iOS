//
//  QIOCreditCardPaymentsViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 4/1/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOCreditCardPaymentsViewController: QIOBaseViewController, IQIOBaseVC {

	// MARK: - Properties
	
	var tableView = UITableView()
	private var ccpayments: QPeriod.PeriodSummary.Transaction.CreditCardPayment!
	private var uniqueReceivingAccountNames = [String]()

	// MARK: - View Lifecycle
	
	convenience init(paymentsIn: QPeriod.PeriodSummary.Transaction.CreditCardPayment) {
		self.init()
		ccpayments = paymentsIn
	}

	convenience init(paymentsIn: QIOFlowPeriodSummaryTransactionObj) {
		self.init()
//		ccpayments = paymentsIn
	}

	override func loadView() {
		super.loadView()
		guard let _ = ccpayments else { fatalError(#function + " in QIOCreditCardPaymentsViewController") }
		customTitle = "Credit Card Payments"
		tableView.hideUnusedCells()
		tableView.allowsSelection = false // turning this off for now until it is more clear what the payment detail page should be
	}

	// MARK: - Actions
	
	func disclosureAction(sender: UIButton) {
		//
	}
	
	// MARK: - UI
	
	override func buildUI() {
//		genTableContainer(tableView, height: UITableView.estimatedHeight(tableView))
		tableView.reloadData()
		buildComplete()
	}

	// MARK: - Computed Vars

	private var sections: [String : [QPeriod.PeriodSummary.Transaction.CreditCardPayment.Payment]] {
		if _sections == nil {
			var out = [String : [QPeriod.PeriodSummary.Transaction.CreditCardPayment.Payment]]()

			if let ccp = ccpayments {
				out = Dictionary(grouping: ccp.payments, by: { itm  -> String in
					if let _to = itm.to, let a = _to.account, let dn = a.displayName {
						return a.institutionName + ": " + dn
					}
					else if let _from = itm.from, let _ = _from.account {
						return "Unidentified Destination Account"
					} else {
						return "🤷🏻‍♂️"
					}
				})
			}
			_sections = out
		}
		return _sections!
	}
	private var _sections: [String : [QPeriod.PeriodSummary.Transaction.CreditCardPayment.Payment]]?

	private var sectionNames: [String] {
		if _sectionNames == nil {
			_sectionNames = Array(sections.keys)
			_sectionNames = _sectionNames?.sorted()
		}
		return _sectionNames!
	}
	private var _sectionNames: [String]?
	
}

extension QIOCreditCardPaymentsViewController {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return sectionNames.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let section = sections[sectionNames[section]]
		if let s = section {
			return s.count
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sectionNames[section]
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if numberOfSections(in: tableView) == 1 {
			return 0
		} else {
			return 60
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
		if cell == nil {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
		}
		var title = ""
		var subtitle = ""
		if let section = sections[sectionNames[indexPath.section]] {
			let O = section[indexPath.row]
			title = O.amount.toCurrencyString(includeCents: true)
			if let F = O.from, let A = F.account, let DN = A.displayName {
				subtitle = Date.YYYYMMDD_to_FriendlyString(F.date) + " from " + DN
			}
		}
		cell?.textLabel?.text = title
		cell?.detailTextLabel?.text = subtitle
		return cell!
	}
	
}
