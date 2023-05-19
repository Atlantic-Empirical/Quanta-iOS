//
//  QIOPayeeDetailViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/13/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOLinkDetailViewController: QIOBaseViewController, IQIOBaseVC {

	// MARK: - Properties
	
	private var item: QItem!
	private var accounts: [QAccount]!

	// MARK: - View Lifecycle
	
	convenience init(_ i: QItem) {
		self.init()
		self.item = i
		self.accounts = QFlow.accountsForItem(i.itemId)
	}

	override func loadView() {
		customTitle = "Link Details"
		super.loadView()
		setRightBarButton(.actionSheet, action: #selector(actionSheet(_:)), actionObj: self)
	}
	
	// MARK: - Actions

	func disclosureAction(sender: UIButton) {
		//
	}
	
	@objc func actionSheet(_ sender: UIButton) {
		let alertController = UIAlertController(
			title: "Link Options",
			message: nil,
			preferredStyle: .actionSheet)
		alertController.addAction(UIAlertAction(title: "Unlink", style: .destructive) { action in
			self.unlinkConfirmationAlert()
		})
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		navigationController?.present(alertController, animated: true)
	}
	
	@objc func accountDetailAction(_ sender: UIButton) {
		navigationController?.pushViewController(
			FIOAccountDetailViewController(accounts[sender.tag]),
			animated: true
		)
	}
	
	// MARK: - Custom
	
	override func buildUI() {
		sectionHeader()
		sectionSummary()
		sectionAccounts()
		buildComplete()
	}
	
	private func sectionHeader() {
		let iv = genImage(nil)
		item.logoImage() { img in
			iv.image = img.resize(CGSize(square: 36))
		}
		genMajorHeader(
			name: item.institutionName,
			imageView: iv,
			subtitle: "Link status:  " + (item.statusIsGood ? "✅" : "🆘"))
	}
	
	private func sectionSummary() {
		genSubSectionTitle("Last Sync")
		let d = Date(timeIntervalSince1970: item.lastTransactionPull/1000)
		genMajorValue("\(d.timeAgoDisplay())", baseTextSize: 28)

		genSubSectionTitle("First Linked")
		genMajorValue("\(item.createdDate.YYYYMMDDtoFriendlyString(.medium))", baseTextSize: 28)
	}
	
	private func sectionAccounts() {
		genSectionHeader("Accounts")
		accounts.enumerated().forEach { idx, val in
			if
				let balances = val.balances,
				let currentBalance = balances.current,
				let dn = val.displayName
			{
//				genSubSectionTitle("awefawe")
				addModuleNew(
					genLabel(dn.prefixToLength(28), font: baseFont(size: 16, bold: false), maxWidth: 290),
					vSpace: 10)
				genSubvalueDisclosure(
					"Balance: " + currentBalance.toCurrencyString(),
					action: #selector(accountDetailAction),
					tag: idx)
			}
		}
	}
	
	// MARK: - Custom
	
	@objc private func unlinkConfirmationAlert() {
		let alertController = UIAlertController(
			title: "Unlink",
			message: "Do you want to unlink " + item.institutionName + " from \(appName) and delete all associated data?\n\nJust an FYI: if you proceed it will take a couple minutes to securely remove all the \(item.institutionName) data then re-Quantize your finances.",
			preferredStyle: .alert
		)
		let removeAction = UIAlertAction(title: "Proceed", style: .destructive) { action in
			FIOControlFullscreenActivity.shared.presentOver(self.view, message: "")
			FIOAppSync.sharedInstance.removeItem(self.item.itemId) { (result, error) in
				if let error = error {
					AppDelegate.sharedInstance.presentAlertWithTitle("🤔",
						message: "Failed to remove the bank from Quanta.\n\n" + String(describing: error)
					) { _ in FIOControlFullscreenActivity.shared.hide() }
				} else {
					let nc = UINavigationController(rootViewController: QIOQuantizeProgressViewController())
					self.present(nc, animated: true) { FIOControlFullscreenActivity.shared.hide() }
				}
			}
		}
		alertController.addAction(removeAction)
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(alertController, animated: true, completion: nil)
	}

}
