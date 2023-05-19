//
//  QIOLinkListViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 7/15/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import UIKit

class QIOLinkListViewController: UITableViewController {
	
	// MARK: - Properties
	
	lazy var home: QHome = {
		guard let h = QFlow.userHome else { fatalError("User home is nil.") }
		return h
	}()
	
	// MARK: - View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.backBarButtonItem = .nil()
		setupNewLinkButton()
		title = "Bank Links"
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorInset = .zero // Full width separators
		tableView.isScrollEnabled = false // Using the scroller in the parent view
		tableView.estimatedRowHeight = QIOBleOverviewViewController.rowHeight
		tableView.rowHeight = QIOBleOverviewViewController.rowHeight
		tableView.hideUnusedCells()
		
		NotifCenter.addObserver(self, selector: #selector(self.handlePlaidLinkSuccess), name: .FIOPlaidLinkSucceeded, object: nil)
		NotifCenter.addObserver(self, selector: #selector(self.handlePlaidLinkError), name: .FIOPlaidLinkError, object: nil)
		NotifCenter.addObserver(self, selector: #selector(self.handleExitWithMetadata), name: .FIOPlaidLinkExit, object: nil)
	}
	
	// MARK: - UI
	
	func setupNewLinkButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named:"add-circle"),
			style: .plain,
			target: self,
			action: #selector(plaidLink)
		)
	}
	
	// MARK: - Actions

}

extension QIOLinkListViewController {
	
	static var rowHeight: CGFloat = 50.0
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return home.items?.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return QIOLinkListViewController.rowHeight
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
		if cell == nil { cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier") }
		if
			let c = cell,
			let itm = home.items?[indexPath.row]
		{
			c.quantaDefaultViz()
//			c.backgroundColor = .randomP3
			c.imageView?.image = UIImage()
			itm.logoImage() { img in
				c.imageView?.image = img.resize(CGSize(square: 36))
				c.setNeedsLayout()
			}
			c.textLabel?.text = itm.institutionName
			c.textLabel?.w = 226.0
			c.selectionStyle = .default
			c.accessoryType = .disclosureIndicator
		}
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let itm = home.items?[indexPath.row] else { return }
		navigationController?.pushViewController(
			QIOLinkDetailViewController(itm),
			animated: true)
	}
	
}

//class QIOLinkListViewController: QIOBaseViewController, IQIOBaseVC {
//
//	// MARK: - Properties
//
//	let tableView = UITableView()
//
//	// MARK: - View Lifecycle
//
//    override func loadView() {
//		customTitle = "Bank Links"
//        super.loadView()
//		setRightBarButton(.info, libraryItem: .HowQuantaWorks)
//    }
//
//	// MARK: - Actions
//
//	func disclosureAction(sender: UIButton) {
//		//
//	}
//
//	// MARK: - Build UI
//
//	override func buildUI() {
//		sectionLinkTable()
//		buildComplete()
//	}
//
//	private func sectionLinkTable() {
////		genSectionHeader("", action: #selector(disclosureAction(sender:)), tag: 1)
//		tableView.delegate = self
//		tableView.dataSource = self
//		tableView.separatorInset = .zero // Full width separators
//		tableView.isScrollEnabled = false // Using the scroller in the parent view
//		tableView.estimatedRowHeight = QIOBleOverviewViewController.rowHeight
//		tableView.rowHeight = QIOBleOverviewViewController.rowHeight
//		tableView.hideUnusedCells()
//		genTableContainer(
//			tableView,
//			height: QIOBleOverviewViewController.rowHeight * 6)
//	}
//}
//
//extension QIOLinkListViewController: UITableViewDelegate, UITableViewDataSource {
//
//	static var rowHeight: CGFloat = 50.0
//
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return home.items?.count ?? 0
//	}
//
//	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//		return QIOLinkListViewController.rowHeight
//	}
//
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
//		if cell == nil { cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier") }
//		if
//			let c = cell,
//			let itm = home.items?[indexPath.row]
//		{
//			c.quantaDefaultViz()
//			c.backgroundColor = .randomP3
//			c.imageView?.image = UIImage()
//			itm.logoImage() { img in
//				c.imageView?.image = img.resize(CGSize(square: 36))
//				c.setNeedsLayout()
//			}
//			c.textLabel?.text = itm.institutionName
//			c.textLabel?.w = 226.0
//			c.selectionStyle = .default
//			c.accessoryType = .disclosureIndicator
//		}
//		return cell!
//	}
//
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		tableView.deselectRow(at: indexPath, animated: true)
//		guard let itm = home.items?[indexPath.row] else { return }
//		navigationController?.pushViewController(
//			QIOLinkDetailViewController(itm),
//			animated: true)
//	}
//
//}
