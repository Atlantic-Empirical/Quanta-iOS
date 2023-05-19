//
//  FIOConnectedAccounts.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/30/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOAccountListViewController: UITableViewController {

    // MARK: - Properties
	public var customTitle: String = "Accounts"
	private var item: QItem?
	public var accountsToInclude: [QAccount]?
	public var showAccountsOfType: QIOFinancialAccountType = .all
	private var model = [String: [QAccount]]()
	private var institutions = [String]()

    // MARK: - View Lifecycle
	
	convenience init(_ i: QItem) {
		self.init()
		item = i
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		title = customTitle
		tableView.hideUnusedCells()
		setupModelForTable()
	}

	// MARK: - Custom
	
	private func setupModelForTable() {
		var institutionSet = Set<String>()
		accounts.forEach {
			institutionSet.insert($0.institutionName)
		}
		for institution in institutionSet {
			model[institution] = accounts.filter { $0.institutionName == institution }
		}
		institutions = Array(institutionSet)
	}

	private func accountForIndexPath(_ ip: IndexPath) -> QAccount {
		return model[institutions[ip.section]]![ip.row]
	}
	
	// MARK: - Computed Vars
	
	private var accounts: [QAccount] {
		if let i = item {
			return QFlow.accountsForItem(i.itemId)
		} else if let a = accountsToInclude {
			return a
		} else {
			switch showAccountsOfType {
			case .all: return QFlow.allAccounts
			case .checking: return QFlow.creditCardAccounts
			case .creditCard: return QFlow.creditCardAccounts
			case .cushion: return QFlow.cushionAccounts
			default: return []
			}
		}
	}
	
}

extension FIOAccountListViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return institutions.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return model[institutions[section]]!.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if institutions.count > 1 {
			return institutions[section]
		} else {
			return nil
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
		if cell == nil {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
		}
		let account = accountForIndexPath(indexPath)
		var accountIsHidden = false
		if let isHidden = account.hidden, isHidden == true {
			accountIsHidden = true
		}

		if let c = cell {
			var cellTitle = ""
			if let dn = account.displayName {
				cellTitle = dn
			} else {
				if account.name != "" {
					cellTitle = account.name
				} else if let on = account.officialName {
					cellTitle = on
				} else {
					cellTitle = "?"
				}
			}
			c.textLabel?.text = (accountIsHidden ? "HIDDEN: " : "") + cellTitle.capitalized
			if let b = account.balances, let current = b.current {
				c.detailTextLabel?.text = "Balance: " + current.toCurrencyString(includeCents: true)
			}
			if accountIsHidden {
				c.accessoryType = .none
				c.backgroundColor = UIColor.red.withAlphaComponent(0.5)
			} else {
				c.accessoryType = .disclosureIndicator
				c.backgroundColor = .white
			}
		}
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		navigationController?.setNavBarVisible()
		navigationController?.pushViewController(
			FIOAccountDetailViewController(accountForIndexPath(indexPath)),
			animated: true
		)
	}
	
//	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//		return true
//	}
//
//	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//		if (editingStyle == UITableViewCellEditingStyle.delete) {
//			print("hide account")
//			// TODO: handle delete (by removing the data from your array and updating the tableview)
//		}
//	}
	
}
