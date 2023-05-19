//
//  QIOLinkAccountSelectionViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 4/17/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOLinkAccountSelectionViewController: UITableViewController {

	// MARK: - Properties
	
	private let pollIntervalSeconds: Int = 3
	private var linkMetadata: FIOPlaidLinkMetadata?
	private var institutionName = ""
	private var institutionId = ""
	private var item_id: String = ""
	private var itemStatus: QItemStatus?
	private var accounts = [QItemStatus.Account]()
	private var logo: UIImage?
	private var logoIV: UIImageView?
	private var continueButton: UIButton?
	private var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
	private var spinnerKilt: Bool = false
	private var continuePolling: Bool = true

	// MARK: - View Lifecycle
	
	convenience init(linkMetadata: FIOPlaidLinkMetadata) {
		self.init()
		self.linkMetadata = linkMetadata
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		QMix.track(.viewLinkingAccountSelection)
		title = "Select Account(s)"
		navigationItem.setHidesBackButton(true, animated: false)
		tableView.hideUnusedCells()
		tableView.allowsMultipleSelection = true
		view.backgroundColor = UIColor("F9F9F9")
		view.translatesAutoresizingMaskIntoConstraints = false
		
		guard let m = linkMetadata else {
			print("Bouncing - NO MODEL. Must be set before showing the view. \n\n")
			return }
		guard let iid = m.institution_id else {
			print("Bouncing - NO INSTITUTION_ID. \n\n")
			return }
		guard let name = m.institution_name else {
			print("Bouncing - NO INSTITUTION_NAME. \n\n")
			return }
		
		institutionId = iid
		institutionName = name
		pullLogo()
		pullItemStatus()
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		if !spinnerKilt { spinnerStart() }
		if continueButton == nil {
			continueButton = addContinueButton(
				selector: #selector(continueAction),
				onObj: self,
				startDisabled: true,
				toView: view.superview)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavBarVisible()
		continuePolling = true
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		continuePolling = false
	}
	
	// MARK: - Pull Status
	
	private func pullItemStatus() {
		FIOAppSync.sharedInstance.pullItemStatus(link_session_id: self.link_session_id, item_id: self.item_id) {
			(result: QItemStatus?) in
			if let r = result {
				print("*** GOT ITEM STATUS ***")
				//				print(r.description)
				self.itemStatus = r
				self.item_id = r.itemId ?? ""
				
				if let accts = r.accounts {
					print("Bailing out of poll loop because accounts returned.")
					self.accounts = accts
					self.title = "Select Account".pluralize(accts)
					self.enableContinueButton()
					self.spinnerStop()
					self.tableView.reloadData()
					self.selectAll()
				} else {
					self.poll()
					print("itemSetupCompleted is FALSE. Going around again after a delay of \(self.pollIntervalSeconds) seconds.")
				}
			} else {
				print("No item status object returned. Going around again")
				self.poll()
			}
		}
	}
	
	private func poll() {
		if !continuePolling { return }
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(self.pollIntervalSeconds), execute: {
			self.pullItemStatus()
		})
	}

	// MARK: - Custom
	
	private func spinnerStart() {
		spinner.hidesWhenStopped = true
		spinner.color = .q_brandGold
		spinner.center = view.center
		view.addSubview(spinner)
		spinner.startAnimating()
	}
	
	internal func spinnerStop() {
		spinnerKilt = true
		spinner.stopAnimating()
	}
	
	private func selectAll() {
		for (idx, _) in accounts.enumerated() {
			self.tableView.selectRow(at: IndexPath(row: idx, section: 0), animated: false, scrollPosition: .none)
		}
	}
	
	private func pullLogo() {
		let logo = QItem.logoImage(insId: institutionId)
		let image = logo.resize(CGSize(width: 34, height: 34))
		self.logo = image
		if let i = image, let iv = logoIV {
			iv.image = i
		}
	}
	
	@objc func continueAction() {
		let _ = selectedAccounts // Get the deselected accounts populated
		let masterAccountIdsToHide = deselectedAccounts.map { $0.masterAccountId }
		if masterAccountIdsToHide.count > 0 {
			FIOAppSync.sharedInstance.setAccountsHidden(masterAccountIds: masterAccountIdsToHide) { res in
				
				switch res {
				case .success(let suc):
					print("setAccountsHidden SUCCESS: \(suc)")
				case .failure(let fail):
					print("setAccountsHidden FAILURE: \(fail)")
				}
				self.pushQuantizeStatusVC()
			}
		} else {
			pushQuantizeStatusVC()
		}
	}

	private func pushQuantizeStatusVC() {
		navigationController?.setNavBarVisible()
		navigationController?.pushViewController(
			QIOLinkTxImportViewController(linkMetadata: self.linkMetadata!),
			animated: true
		)
	}
	
	// MARK: - Computed Vars
	
	private var link_session_id: String {
		if let md = linkMetadata, let lsi = md.link_session_id {
			return lsi
		} else {
			return ""
		}
	}

	private var selectedAccounts: [QItemStatus.Account] {
		var out = [QItemStatus.Account]()

		for (idx, acct) in accounts.enumerated() {
			if let c = tableView.cellForRow(at: IndexPath(row: idx, section: 0)) {
				if c.isSelected {
					out.append(acct)
				} else {
					deselectedAccounts.append(acct)
				}
			}
		}
		
		return out
	}
	private var deselectedAccounts = [QItemStatus.Account]()
	
}

// MARK: - Table Delegate

extension QIOLinkAccountSelectionViewController {
	
	var headerHeight: CGFloat { return 80.0 }
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return accounts.count
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return headerHeight
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.w, height: headerHeight))
		
		let _logoIV = UIImageView(frame: .zero)
//		_logoIV.backgroundColor = .randomP3
		_logoIV.translatesAutoresizingMaskIntoConstraints = false
		v.addSubview(_logoIV)
		_logoIV.anchorTopToSuperview(constant: 20)
		_logoIV.anchorLeadingToSuperview(constant: 18)
		_logoIV.anchorSizeConstantSquare(34)
		logoIV = _logoIV
		if let i = logo {
			_logoIV.image = i
		}
		
		let rightSide = UIView(frame: .zero)
//		rightSide.backgroundColor = .randomP3
		rightSide.translatesAutoresizingMaskIntoConstraints = false
		v.addSubview(rightSide)
		rightSide.anchorLeadingTo(_logoIV.trailingAnchor, constant: 16)
		rightSide.anchorTopTo(_logoIV.topAnchor)
		rightSide.anchorHeight(34)
		
		let title = UILabel(frame: .zero)
		title.translatesAutoresizingMaskIntoConstraints = false
//		title.backgroundColor = .randomP3
		title.text = institutionName
		title.font = baseFont(size: 18, bold: true)
		title.textColor = .q_53
		title.sizeToFit()
		rightSide.addSubview(title)
		title.anchorTopToSuperview()
		title.anchorLeadingToSuperview()

		let subtitle = UILabel(frame: .zero)
		subtitle.translatesAutoresizingMaskIntoConstraints = false
//		subtitle.backgroundColor = .randomP3
		subtitle.text = "Hide accounts from Quanta by deselecting."
		subtitle.font = baseFont(size: 12, bold: false)
		subtitle.textColor = .q_53
		subtitle.sizeToFit()
		rightSide.addSubview(subtitle)
		subtitle.anchorTopTo(title.bottomAnchor, constant: 0)
		subtitle.anchorLeadingToSuperview()

		return v
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 50.0
	}
	
//	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//		if accounts.count == 0 { return UIView() }
//		let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.w, height: 50.0))
//		v.backgroundColor = .clear
//		let title = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.w, height: 50.0))
//		title.text = "Unselect accounts to exclude from Quanta."
//		title.font = baseFont(size: 13, bold: true)
//		title.textColor = UIColor("808080")
//		title.textAlignment = .center
//		v.addSubview(title)
//		return v
//	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
		if cell == nil {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
		}
		if let c = cell {
			c.quantaDefaultViz()
			let a = accounts[indexPath.row]
			if let dn = a.displayName {
				c.textLabel?.text = dn
			} else {
				c.textLabel?.text = a.name == "" ? a.officialName : a.name
			}
			if let b = a.balances, let current = b.current {
				c.detailTextLabel?.text = "Balance: " + current.toCurrencyString(includeCents: true)
			}
			c.selectionStyle = .none
			c.accessoryType = .checkmark
//			c.isSelected = true
//			c.setSelected(true, animated: false)
		}
		
		return cell!
	}
	 
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) {
			cell.accessoryType = .none
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) {
			cell.accessoryType = .checkmark
		}
	}
	
}
