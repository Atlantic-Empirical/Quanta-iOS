//
//  FIOTransactionDetailViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/1/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOTransactionDetailViewController: QIOBaseViewController, IQIOBaseVC {

    // MARK: - Properties
	
    private var transaction_id: String!
    private var transaction: FIOTransaction!
	private var account: QAccount!

    // MARK: - View Lifecycle

	convenience init(_ tx: FIOTransaction) {
		self.init()
		self.transaction = tx
		self.transaction_id = tx.transaction_id
	}

	convenience init(_ tid: String) {
		self.init()
		self.transaction_id = tid
	}
	
	override func loadView() {
		customTitle = "Transaction"
		super.loadView()
		navigationItem.backBarButtonItem = .nil()
	}

	// MARK: - Actions
	
	@objc func accountDetailAction() {
		navigationController?.pushViewController(
			FIOAccountDetailViewController(account),
			animated: true
		)
	}
	
	func disclosureAction(sender: UIButton) {
		//
	}

	// MARK: - UI
	
	override func buildUI() {
		print("Loading detail for transaction id: \(transaction_id!)")
		
		if let _ = transaction {
			renderTx()
		} else {
			FIOAppSync.sharedInstance.pullTransactions(transaction_ids: [transaction_id]) {
				result in
				if let transactionsReturned: [QTransaction] = result {
					if transactionsReturned.count == 0 { return }
					self.transaction = FIOTransaction(transactionsReturned[0])
					self.renderTx()
				}
			}
		}
	}
	
	private func renderTx() {
		sectionHeader()
		sectionAmount()
		sectionAccount()
		buildComplete()
	}
	
	private func sectionHeader() {
		let iv = genImage(withIconSearch: transaction.name.firstWord())
		genMajorHeader(
			name: transaction.name.prefixToLength(32),
			imageView: iv,
			subtitle: "Category: " + FIOCategories.categoryNameForId(transaction.fioCategoryId).uppercased()
		)
	}
	
	private func sectionAmount() {
		genSubSectionTitle(transaction.date.YYYYMMDDtoFriendlyString(.full))
		genMajorValue(amount: transaction.amount)
		if transaction.pending {
			addModuleNew(genLabel(
				"Transaction is pending.",
				font: baseFont(size: 14, bold: false)),
				vSpace: 5)
		}
	}
	
	private func sectionAccount() {
		if let a = QFlow.accountForMaid(transaction.masterAccountId) {
			account = a
			genSubSectionTitle("Account")
			addModuleNew(genLabel(
				(a.displayName ?? a.name) + "\n@ " + a.institutionName,
				font: baseFont(size: 18, bold: false)),
				vSpace: 5)
			genSubvalueDisclosure("See more", vSpace: 0, action: #selector(accountDetailAction))
		}
	}
	
    private func printTransactionObject() {
        AppDelegate.sharedInstance.presentAlertWithTitle("Transaction Detail", message: (self.transaction?.description)!)
        print((self.transaction?.description)!)
    }
    
}
