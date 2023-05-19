//
//  QIOSearchResultsTableViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 7/4/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import UIKit

class QIOSearchResultsTableViewController: UITableViewController {

	var searchController: UISearchController!
	var searchResults: [SearchTransactionsQuery.Data.SearchTransaction]? {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
				self.tableView.hideUnusedCells()
			}
		}
	}
	var sections = [String]()
	var ai: UIActivityIndicatorView?

	// MARK: - View Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		self.ai = qSpinner()
		if let ai = self.ai {
			tableView.addSubview(ai)
			ai.translatesAutoresizingMaskIntoConstraints = false
			ai.anchorTopTo(tableView.topAnchor, constant: 24)
			ai.anchorCenterXToSuperview()
			ai.stopAnimating()
		}
	}

	// MARK: - Spinner
	
	func startSpinner() {
		ai?.startAnimating()
		ai?.isHidden = false
	}
	
	func stopSpinner() {
		ai?.stopAnimating()
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		if sections.count == 0 { return 1 }
		else { return sections.count }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchResults?.count ?? 0
    }

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.cellGenerator(style: .subtitle)
		cell.accessoryType = .disclosureIndicator
		var name: String = "", date: String = "", amount: Double = 0

		if let searchResults = searchResults {
			let tx = searchResults[indexPath.row]
			amount = tx.amount
			name = tx.name.prefixToLength(24)
			date = tx.date.YYYYMMDDtoFriendlyString()
		}

		cell.textLabel?.text = name
		cell.detailTextLabel?.text = date
		cell.addThirdLabelToCell(attributedText: amount.asAttributedCurrencyString(fontSize: 16, bold: false))

		return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let selection = searchResults?[indexPath.row] {
			print(selection)
			self.presentingViewController?.navigationController?.pushViewController(
				FIOTransactionDetailViewController(selection.transactionId),
				animated: true
			)
		}
		tableView.deselectRow(at: indexPath, animated: true)
//		searchController.dismiss(animated: false)
//		searchController.resignFirstResponder()
	}

}
