//
//  UserIdentityViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/1/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOSettingsViewController: UITableViewController {
	
	// MARK: Properties
	
	private let baseCellCount = 9
	private var bioIdSwitch: UISwitch?
	private var notifsSwitch: UISwitch?
	private var versionFooter: UILabel?
	private var rendered: Bool = false
	private var isDebug: Bool = false
	private var numberOfDebugCells: Int = 0
	private var includeBioId: Bool = false
	private var waitingForReturnFromIOSNotifSettings: Bool = false

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Settings"
		navigationItem.largeTitleDisplayMode = .never
		view.backgroundColor = .white
		tableView.backgroundColor = .white
		tableView.hideUnusedCells()
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		tableView.delegate = self
		tableView.dataSource = self
		#if targetEnvironment(simulator) || DEBUG
		isDebug = true
		numberOfDebugCells = 1
		#endif
		includeBioId = QBio.bioIdentificationSupported
		NotifCenter.addObserver(self,
			selector: #selector(applicationWillEnterForeground),
			name: .applicationWillEnterForeground,
			object: nil)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		addBuildInfo()
//		QIODécor.applyGradientToView(view)
	}
	
	@objc private func applicationWillEnterForeground() {
		if waitingForReturnFromIOSNotifSettings {
			waitingForReturnFromIOSNotifSettings = false
			QNotifs.checkNotificationPermissionSetting() {
				QNotifs.propmtUserForNotificationPermission() { (hardPermissionReqd, bool2) in
					if hardPermissionReqd {
						DispatchQueue.main.async {
							self.notifsSwitch?.setOn(false, animated: true)
						}
					} else {
						DispatchQueue.main.async {
							self.notifsSwitch?.setOn(bool2, animated: true)
						}
					}
				}
			}
		}
	}
	
	// MARK: - Actions
	
	private func deleteUser() {
		let alertController = UIAlertController(title: "DELETE ACCOUNT", message: "Are you sure you want to delete your account? This cannot be undone.", preferredStyle: .alert)
		let defaultAction = UIAlertAction(title: "DELETE 🏁", style: .destructive) { (alert: UIAlertAction!) in
			QUser.deleteUser()
		}
		alertController.addAction(defaultAction)
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(cancel)
		present(alertController, animated: true, completion: nil)
	}
	
	private func signOut() {
		let alertController = UIAlertController(
			title: "Just checking...",
			message: "You want to sign-out, right?",
			preferredStyle: .alert
		)
		alertController.addAction(UIAlertAction(
			title: "Yeah Bai 👋",
			style: .default
		) { action in
			QUser.signout()
			self.navigationController?.dismiss(animated: true)
		})
		let cancel = UIAlertAction(title: "Nope", style: .cancel, handler: nil)
		alertController.addAction(cancel)
		present(alertController, animated: true, completion: nil)
	}
	
	@objc func switchChanged(_ sender : UISwitch!){
		print("table row switch Changed \(sender.tag)")
		print("The switch is \(sender.isOn ? "ON" : "OFF")")
		if sender == notifsSwitch {
			if sender.isOn {
				QNotifs.propmtUserForNotificationPermission() {
					(hardPermissionRequired, openedSettings) in
					if hardPermissionRequired && !openedSettings {
						DispatchQueue.main.async {
							sender.setOn(false, animated: true)
						}
					} else if openedSettings {
						self.waitingForReturnFromIOSNotifSettings = true
					}
				}
			} else {
				QNotifs.APNSToken = ""
			}
		} else if sender == bioIdSwitch {
			if sender.isOn {
				QBio.offerSetup()
			} else {
				QUser.userPrefSetBool(false, qPrefKey_bioIdIsEnabled)
			}
		}
	}
	
	private func clearLocal() {
		let ac = UIAlertController(
			title: "Clear Local Data?",
			message: "\nAll of your financial data stored on this device will be removed.\n\nYou will not be signed out.\n\nThe app will close automatically.\n\nWhen you reopen the app, your latest financal will be loaded.",
			preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		ac.addAction(UIAlertAction(title: "Delete Data", style: .destructive) { action in
			QFlow.deleteAllLocalObjectFiles()
			fatalError()
		})
		present(ac, animated: true)
	}

	private func debugAction() {
		QIOAudio.pickerTick()
		//		QIODebug.renderFeedback(type: 0)
//		AudioServicesPlaySystemSoundWithCompletion(1157, nil)
	}
	
	private func shareApp() {
		present(
			UIActivityViewController(
				activityItems: [appUrlString],
				applicationActivities: nil),
			animated: true)
	}
	
    // MARK: - Custom

	private func pushVC(_ vc: UIViewController) {
		navigationController?.pushViewController(vc, animated: true)
//		vc.setNavBarVisible(forConfigArea: true)
	}

	private func addBuildInfo() {
		if rendered { return } else { rendered = true }
		guard
			let dictionary = Bundle.main.infoDictionary,
			let av = Bundle.main.appVersion
		else { return }
		
		// note: av comes with a \t tab for some reason
		let ver = String(av.filter { !" \t".contains($0) })
		var b = ""
		if let build = dictionary["CFBundleVersion"] as? String {
			b = build
		}
		versionFooter = UILabel(frame: .zero)
		if let vf = versionFooter {
			vf.translatesAutoresizingMaskIntoConstraints = false
			vf.text = "VERSION " + ver + (b == "" ? "" : "\nBUILD " + b + "\n\n😎")
			vf.numberOfLines = 0
			vf.textAlignment = .center
			vf.textColor = .q_78
			vf.font = .systemFont(ofSize: 11.0, weight: .semibold)
			vf.kerning = 2.0
			vf.backgroundColor = .clear
			vf.sizeToFit()
			view.insertSubview(vf, aboveSubview: tableView)
			vf.anchorCenterXToSuperview()
			vf.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).activate()
			vf.heightAnchor.constraint(equalToConstant: vf.h).activate()
		}
	}

}

// MARK: - UITableView

extension FIOSettingsViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cellCount + numberOfDebugCells
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
		if cell == nil {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
		}
		
		// Configure the cell...
		cell!.accessoryType = .disclosureIndicator
		cell?.accessoryView = nil
		cell?.backgroundColor = UIColor.white.withAlphaComponent(0.0)

		var title: String = ""
		var subtitle: String = ""
		var img: UIImage? = nil
		
		cell!.textLabel?.textColor = .q_38
		cell!.detailTextLabel?.textColor = .q_53
		
		let e: Cells = cellTypeForIndex(indexPath.row)
		
		switch e {
		
//		case .phoneNumber:
//			title = "Mobile Number"
//			//String(QUser.userAttribute_phone_number_verified!)
//			if let phoneNo = QUser.userAttribute_phone_number {
//				subtitle = phoneNo
//			}
			
		case .subscription:
			title = "Membership"
			subtitle = "Manage your \(appName) membership"
			img = UIImage(named: "Membership")
			if
				let h = QFlow.userHome,
				h.isChurning
			{
				let badgeSize: CGFloat = 8
				let dot = UIView(frame: CGRect(o: CGPoint(x: 14, y: 12), wh: badgeSize))
				dot.cornerRadius = dot.h/2
				dot.backgroundColor = .red
				cell!.imageView?.superview?.addSubview(dot)
			}
			
		case .signOut:
			title = "Sign Out"
			cell?.accessoryType = .none
			img = UIImage(named: "power-button")

		case .deleteAccount:
			title = "Delete Account"
			cell!.textLabel?.textColor = .red
			cell?.accessoryType = .none
			img = UIImage(named: "atomic-bomb")

		case .bioId:
			title = QBio.biometryTypeString
			bioIdSwitch = UISwitch(frame: .zero)
			bioIdSwitch!.setOn(QUser.userPrefReadBool(qPrefKey_bioIdIsEnabled), animated: true)
			bioIdSwitch!.tag = indexPath.row
			bioIdSwitch!.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
			cell?.accessoryView = bioIdSwitch
			switch QBio.bioContext.biometryType {
			case .faceID: img = UIImage(named: "face-id")
			case .touchID: img = UIImage(named: "touch-id")
			case .none: break
			@unknown default: break
			}

		case .clearLocal:
			title = "Clear local data"
			cell?.accessoryType = .none
			img = UIImage(named: "database-refresh")

		case .genericDebugAction:
			title = "Debug action"
			cell?.accessoryType = .none
			img = UIImage(named: "computer-bug-search")

		case .share:
			title = "Share \(appName)"
			cell?.accessoryType = .none
			img = UIImage(named: "share")

		case .review:
			title = "Review \(appName) on the App Store"
			cell?.accessoryType = .none
			img = UIImage(named: "rating-five-star")

		case .notifications:
			title = "Flow Notif"
			notifsSwitch = UISwitch(frame: .zero)
			notifsSwitch!.setOn(QNotifs.APNSTokenExists, animated: true)
			notifsSwitch!.tag = indexPath.row
			notifsSwitch!.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
			cell?.accessoryView = notifsSwitch
			img = UIImage(named: "notif")
			
		case .library:
			title = "Quanta Money Library"
			img = UIImage(named: "book-library-1")

		case .links:
			title = "Bank Links"
			img = UIImage(named: "saving-bank-1")

		}
		
		cell!.textLabel?.text = title
		cell!.detailTextLabel?.text = subtitle
		cell!.imageView?.image = img
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch cellTypeForIndex(indexPath.row) {
		case Cells.subscription: return 60
		default: return 44
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.tableView.deselectRow(at: indexPath, animated: true)
		let e = cellTypeForIndex(indexPath.row)
		switch e {
//		case .phoneNumber: pushVC(FIOMobileNumberViewController())
		case .subscription: pushVC(QIOMembershipViewController())
		case .signOut: signOut()
		case .deleteAccount: deleteUser()
		case .bioId: print("nada")
		case .clearLocal: clearLocal()
		case .genericDebugAction: debugAction()
		case .share: shareApp()
		case .review: QIOAppReview.requestReviewDirect()
		case .notifications: print("Nada")
		case .library: pushVC(FIOLibraryViewController())
		case .links: pushVC(QIOLinkListViewController())
		}
	}
	
	enum Cells: Int {
//		case phoneNumber
		case subscription
		case share
		case review
		case signOut
		case deleteAccount
		case clearLocal
		case bioId
		case genericDebugAction
		case notifications
		case library
		case links
	}

	private var cellCount: Int {
		get {
			var out = baseCellCount
			out += includeBioId ? 1 : 0
			return out
		}
	}
	
	func cellTypeForIndex(_ idx: Int) -> Cells {
		switch idx {
		case 0: return .links
		case 1: return .library
		case 2: return .share
		case 3: return .review
		case 4: return .subscription
		case 5: return .signOut
		case 6: return .deleteAccount
		case 7: return .clearLocal
		case 8: return .notifications
		default: return extendedCellIdLogic(idx)
		}
	}
	
	private func extendedCellIdLogic(_ idx: Int) -> Cells {
		if includeBioId && idx == baseCellCount { return .bioId }
		else if isDebug && idx == cellCount + 1 { return .genericDebugAction }
		return .genericDebugAction // Should never get here
	}
	
}
