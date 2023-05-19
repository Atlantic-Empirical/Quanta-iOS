//
//  QIOLinkTxImportViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/28/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import Splitflap

class QIOLinkTxImportViewController: UIViewController {

    // MARK: - Constants
	
    private let pollIntervalSeconds: Int = 3
	private let cellHeight: CGFloat = 30.0

    // MARK: - Properties
	
	private var linkMetadata: FIOPlaidLinkMetadata?
	private var institutionName = ""
	private var institutionId = ""
	private var webhookTransactionCount: Int = 0
	private var item_id: String = ""
	private var transactionCount: Int = 0
	private var flapWidthTxCount: Int = 1
	private var flapWidthDepositSum: Int = 1
	private var flapWidthDebitSum: Int = 1
	private var quantizeSucceeded: Bool = false
	private var bottomOffset: CGFloat = 0
	private var continueButton: UIButton?
	private var lastItemStatus: QItemStatus?
	private var transactions = [QItemStatus.TransactionSummary.Transaction]()
	private var haveBothWebhooks: Bool = false
	private var viewLinkAnother: QIOHaveMoreAccountsControl = .fromNib()
	
    // MARK: - IBOutlets
	
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var viewCentering: UIView!
	@IBOutlet weak var viewGradientParent: UIView!
	@IBOutlet weak var ivLinkLogo: UIImageView!
	@IBOutlet weak var viewSummary: UIView!
	@IBOutlet weak var sfTransactionCount: Splitflap!
	@IBOutlet weak var sfDepositSum: Splitflap!
	@IBOutlet weak var sfDebitSum: Splitflap!
	@IBOutlet weak var lblOldestDate: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var viewGradientBottom: UIView!
	
    // MARK: - View Lifecycle
	
	convenience init(linkMetadata: FIOPlaidLinkMetadata) {
		self.init()
		self.linkMetadata = linkMetadata
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		QMix.track(.viewLinkingTxImport)

		guard let m = linkMetadata else {
			print("Bouncing - NO MODEL. Must be set before showing the view. \n\n")
			return }
		guard let iid = m.institution_id else {
			print("Bouncing - NO INSTITUTION_ID. \n\n")
			return }
		guard let name = m.institution_name else {
			print("Bouncing - NO INSTITUTION_NAME. \n\n")
			return }

		title = "Importing Transactions"
		navigationItem.setHidesBackButton(true, animated: false)
		institutionId = iid
		institutionName = name
		edgesForExtendedLayout = []
		ivLinkLogo.image = QItem.logoImage(insId: institutionId)
		addGradient()
		sfDepositSum.backgroundColor = .clear
		sfDebitSum.backgroundColor = .clear

		sfTransactionCount.datasource = self
		sfTransactionCount.delegate   = self
		sfTransactionCount.setText("0", animated: false)

		sfDepositSum.datasource = self
		sfDepositSum.delegate   = self
		sfDepositSum.setText("0", animated: false)

		sfDebitSum.datasource = self
		sfDebitSum.delegate   = self
		sfDebitSum.setText("0", animated: false)

		tableView.delegate = self
		tableView.dataSource = self
		tableView.allowsSelection = false
		tableView.separatorStyle = .none
//		tableView.backgroundColor = .yellow
		tableView.estimatedRowHeight = cellHeight
		tableView.rowHeight = cellHeight
		tableView.showsVerticalScrollIndicator = false
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	
		if continueButton == nil {
			continueButton = addContinueButton(selector: #selector(continueAction), onObj: self, startDisabled: true)
			viewLinkAnother.setParentVC(self)
		}
		if let c = continueButton {
			bottomOffset = 134.0 + c.h + view.safeAreaInsets.bottom + viewLinkAnother.h // sets the table footer height
			viewSummary.y = c.y - 134.0 - viewLinkAnother.h // puts the summary view above both the linkAnother and continue buttons
			viewLinkAnother.y = c.y - viewLinkAnother.h // puts linkAnother above continue button
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		pullItemStatus()
	}
	
    // MARK: - Pull Status
	
	private func pullItemStatus() {
		FIOAppSync.sharedInstance.pullItemStatus(link_session_id: self.link_session_id, item_id: self.item_id) {
			(result: QItemStatus?) in
			if let r = result {
				print("*** GOT ITEM STATUS ***")
				//				print(r.description)
				self.item_id = r.itemId ?? ""
				self.renderItemStatus(r)
				if self.doneOnThisView {
					print("Bailing out of poll loop because doneOnThisView == true")
					self.spinner.stopAnimating()
					self.enableContinueButton()
					self.title = "Done Importing"
				} else {
					self.poll()
					print("doneImportingTransactions is FALSE. Going around again after a delay of \(self.pollIntervalSeconds) seconds.")
				}
			} else {
				print("No item status object returned. Going around again")
				self.poll()
			}
		}
	}
	
	private func poll() {
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(self.pollIntervalSeconds), execute: {
			self.pullItemStatus()
		})
	}

	// MARK: - Render Status
	
	private func renderItemStatus(_ i: QItemStatus) {
		lastItemStatus = i
		print("QUANTIZE STATUS = " + i.quantizeStatus)
		webhookSummary = i.webhookSummary
		if let txSummary = i.transactionSummary {
			oldestTransaction = txSummary.oldestTransaction
			transactionsInSystemForItem = txSummary.transactionCount
			addTransactions(txSummary.transactions)
		}
    }
	
	// MARK: - Property Observers
	
	private func addTransactions(_ txs: [QItemStatus.TransactionSummary.Transaction]) {
		let preLength = transactions.count
		let postLength = txs.count
		let newCount = postLength - preLength
		if newCount > 0 {
			for tx in txs {
				if !transactions.contains(where: { $0.transactionId == tx.transactionId }) {
					if let t = tx.qioTransactionType {
//						insertableTransactions.enqueue(tx)
//						print(tx.name! +  " " + tx.transactionId!)
//						print(t + " " + a.toCurrencyString(includeCents: true, includeMinusSign: true))
						switch t {
						case "deposit": depositsSum += Int(-1 * tx.amount)
						case "debit": debitsSum += Int(tx.amount)
						default: continue
							// print("Ignoring transaction with type: \(t)")
						}
					}
				}
			}
//			startInsertLoop()
			transactions = txs

			// add tx cell to table and animate it into view
			var ips = [IndexPath]()
			for i in preLength...(postLength - 1) {
				ips.append(IndexPath(row: i, section: 0))
			}
			tableView.performBatchUpdates({
				tableView.insertRows(at: ips, with: .top)
			}) { done in }
		}
	}
	
	private var webhookSummary: QItemStatus.WebhookSummary? {
		didSet {
			if let oldSummary = oldValue, let _ = oldSummary.historicalTransactionsHook, let _ = oldSummary.initialTransactionsHook {
				print("We already have both webhooks.") // Do nothing.
			} else if let newSummary = webhookSummary, let historicalHook = newSummary.historicalTransactionsHook, let initialHook = newSummary.initialTransactionsHook {
				print("NOW HAVE BOTH WEBHOOKS")
				haveBothWebhooks = true
				if let initialCount = initialHook.newTransactions, let historicalCount = historicalHook.newTransactions {
					webhookTransactionCount = initialCount + historicalCount
				}
			} else {
				print("We've received the FIRST WEBHOOK.")  // Keep waiting
			}
		}
	}
	
	private var oldestTransaction: String = "" {
		willSet {
			if oldestTransaction != newValue && newValue != "no transactions" {
				lblOldestDate.text = Date.YYYYMMDD_to_FriendlyString_long(newValue)
			}
		}
	}
	
	private var transactionsInSystemForItem: Int = 0 {
		didSet {
			if transactionsInSystemForItem != oldValue {
//				print(transactionsInSystemForItem)
				let str = transactionsInSystemForItem.asString
				if str.count > flapWidthTxCount {
//					print("widening splitflap")
					flapWidthTxCount = str.count
					sfTransactionCount.reload()
				}
				sfTransactionCount.setText(str, animated: true) {
//					print("Display finished!")
				}
			}
		}
	}

	private var depositsSum: Int = 0 {
		didSet {
			if depositsSum != oldValue {
//				print(depositsSum)
				let str = depositsSum.asString
				if str.count > flapWidthDepositSum {
//					print("widening splitflap")
					flapWidthDepositSum = str.count
					sfDepositSum.reload()
				}
				sfDepositSum.setText(str, animated: true) {
//					print("Display finished!")
				}
			}
		}
	}

	private var debitsSum: Int = 0 {
		didSet {
			if debitsSum != oldValue {
//				print(debitsSum)
				let str = debitsSum.asString
				if str.count > flapWidthDebitSum {
//					print("widening splitflap")
					flapWidthDebitSum = str.count
					sfDebitSum.reload()
				}
				sfDebitSum.setText(str, animated: true) {
//					print("Display finished!")
				}
			}
		}
	}
	
	// MARK: - Custom

	@objc func continueAction() {
		guard let i = lastItemStatus else { return }
		guard let nc = navigationController else { return }
		var vc: UIViewController
		if i.quantizeStatus == "RUNNING" {
			vc = QIOQuantizeProgressViewController()
		}
		else {
			vc = QIOLinkFinaleViewController()
		}
		nc.pushViewController(vc, animated: true)
	}
	
	private func addGradient() {
		let gradient = CAGradientLayer()
		gradient.frame = viewGradientParent.bounds
		gradient.colors = [UIColor.white.withAlphaComponent(0.8).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
		viewGradientParent.layer.addSublayer(gradient)
		
		let gradient2 = CAGradientLayer()
		gradient2.frame = viewGradientBottom.bounds
		gradient2.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0.9).cgColor]
		viewGradientBottom.layer.addSublayer(gradient2)
	}

	// MARK: - Computed Vars
	
	private var doneOnThisView: Bool {
		if (transactionsInSystemForItem == webhookTransactionCount) && haveBothWebhooks {
			print("All expected txs have been imported and regardless of whether quantize is still running, we're ready to move to the next view.")
			return true
		}
		else {
			guard let i = lastItemStatus else { return false }
			if i.quantizeStatus == "RUNNING" { return false } // We don't have all txs imported AND quantize is still running
			else if i.quantizeStatus == "SUCCEEDED" { // shouldn't happen on this view. But if it does...
				print("Quantize finished.")
				return true
			}
			else if i.quantizeStatus == "FAILED" { return false } // FIXME: race condition
			else {
				print("No quantize status yet, probably not running yet. Waiting for the HISTORICAL hook.")
				return false
			}
		}
	}
	
	private var link_session_id: String {
		if let md = linkMetadata, let lsi = md.link_session_id {
			return lsi
		} else {
			return ""
		}
	}
	
}

// MARK: - TableView

extension QIOLinkTxImportViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return transactions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
		if cell == nil {
			cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
		}
		
		let t = transactions[indexPath.row]
		if let c = cell {
			c.removeAllSubviews()
			c.quantaDefaultViz()

			let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.w, height: cellHeight))
			let f = baseFont(size: 15, bold: true)

			let date = UILabel(frame: CGRect(x: 10.0, y: 0, width: 60, height: v.h))
			date.text = t.date.YYYYMMDDtoFriendlyString(.short)
			date.font = f
//			date.backgroundColor = .blue
			v.addSubview(date)

			let name = UILabel(frame: CGRect(x: date.x_right + 6.0, y: 0, width: v.w - 80 - 60 - 10 - 10, height: v.h))
			name.text = t.name.prefixToLength(40)
			name.font = f
//			name.backgroundColor = .red
			v.addSubview(name)

			let amount = UILabel(frame: CGRect(x: v.w - 80, y: 0, width: 80, height: v.h))
			amount.text = t.amount.toCurrencyString(includeCents: true)
			amount.font = f
//			amount.backgroundColor = .purple
			v.addSubview(amount)

			c.addSubview(v)
		}
		return cell!
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 80.0
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return UIView()
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return bottomOffset
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
	
}

// MARK: - Splitflap DataSource and Delegate

extension QIOLinkTxImportViewController: SplitflapDataSource, SplitflapDelegate {
	
	func numberOfFlapsInSplitflap(_ splitflap: Splitflap) -> Int {
		if splitflap == sfTransactionCount { return flapWidthTxCount }
		else if splitflap == sfDepositSum { return flapWidthDepositSum }
		else if splitflap == sfDebitSum { return flapWidthDebitSum }
		else { return 0 }
	}
	
	func tokensInSplitflap(_ splitflap: Splitflap) -> [String] {
		return SplitflapTokens.Numeric
	}
	
	func splitflap(_ splitflap: Splitflap, rotationDurationForFlapAtIndex index: Int) -> Double {
		return 0.1
	}
	
	func splitflap(_ splitflap: Splitflap, builderForFlapAtIndex index: Int) -> FlapViewBuilder {
		return FlapViewBuilder { builder in
			builder.backgroundColor = .black
			builder.cornerRadius    = 5
			builder.font            = UIFont(name: "Courier", size: splitflap == sfTransactionCount ? 50.0 : 26.0)
			builder.textAlignment   = .center
			builder.textColor       = .white
			builder.lineColor       = .darkGray
			builder.flipPointHeightFactor = splitflap == sfTransactionCount ? 1.0 : 0.8
		}
	}
		
}
