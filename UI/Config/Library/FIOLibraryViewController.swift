//
//  FIOAboutViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 12/11/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOLibraryViewController: UITableViewController {

	// MARK: - View Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Library"
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		tableView.hideUnusedCells()
		tableView.delegate = self
		tableView.dataSource = self
    }

}

// MARK: - UITableViewController

extension FIOLibraryViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return QIOLibrary.Sections.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return QIOLibrary.SectionContents(QIOLibrarySections(rawValue: section)!).count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let section = QIOLibrarySections(rawValue: section)
		if let s = section {
			return s.asString
		} else { return "" }
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60.0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
		if cell == nil {
			cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
		}
		if let c = cell {
			c.accessoryType = .disclosureIndicator
			var _title: String = ""
			let sectionContents = QIOLibrary.SectionContents(QIOLibrarySections(rawValue: indexPath.section)!)
			let e = sectionContents[indexPath.row]
			switch e {
			case .WhatIsQuanta: _title = "What Is Quanta"
			case .PrivacySecurity: _title = "Common Sense Privacy & Security"
			case .TermsOfUse: _title = "Terms of Use"
			case .PrivacyPolicy: _title = "Privacy Policy"
			case .HowQuantaWorks: _title = "How \(appName) Works"
			case .WhyWeCharge: _title = "Why We Charge"
			case .CostOfADollar: _title = "Cost of a Dollar"
			case .MoneyRental: _title = "Money Rental"
			case .ProjectedPeriod: _title = "Quanta Flow"
			case .StandardPeriod: _title = "Standard Period"
			case .Income: _title = "Income"
			case .CreditCards: _title = "Credit Cards"
			case .Spending: _title = "Spending"
//			case .Categories: _title = "Money Map / Categories"
//			case .RecurringSpending: _title = "Recurring Spending"
			case .AboutQuanta: _title = "Why We Built \(appName)"
			case .LivingProfitably: _title = "Living Profitably"
			case .RainyDayFunds: _title = "Rainy Day Funds"
			case .FinancialIndependence: _title = "Financial Independence"
			case .BaseLivingExpenses: _title = "Base Living Expenses"
			}
			c.textLabel?.text = _title
			return c
		} else {
			return cell!
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.tableView.deselectRow(at: indexPath, animated: true)
		let sectionContents = QIOLibrary.SectionContents(QIOLibrarySections(rawValue: indexPath.section)!)
		navigationController?.pushViewController(
			FIOGenericTextViewViewController(sectionContents[indexPath.row]),
			animated: true
		)
	}
	
}
