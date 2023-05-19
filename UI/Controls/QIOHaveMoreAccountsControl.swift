//
//  QIOHaveMoreAccountsControl.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/2/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOHaveMoreAccountsControl: UIView {

	// MARK: - Properties
	
	private let DESIGN_HEIGHT: CGFloat = 126.0
	private var parentVC: UIViewController?
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var lblHaveMoreAccounts: UILabel!

	// MARK: - View Lifecycle
	
	override func awakeFromNib() {
		super.awakeFromNib()
		lblHaveMoreAccounts.font = lblHaveMoreAccounts.font.italic
	}
	
	// MARK: - IBActions

	@IBAction func tapAction(_ sender: Any) {
		if
			let nc = AppDelegate.sharedInstance.navigationController
		{
			nc.dismiss(animated: true) {
				nc.plaidLink()
			}
		}
	}

	// MARK: - Custom
	
	public func setParentVC(_ vc: UIViewController) {
		parentVC = vc
		frame = CGRect(x: 0, y: 0, width: vc.view.w, height: DESIGN_HEIGHT)
		vc.view.addSubview(self)
	}

}
