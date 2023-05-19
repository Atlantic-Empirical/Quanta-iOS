//
//  QIOQuantizeProgressViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 4/21/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOQuantizeProgressViewController: UIViewController {

	// MARK: - Constants
	
	private let pollIntervalSeconds: Int = 3

	// MARK: - Properties
	
	private var continueButton: UIButton?
	private var completion: QIOSimpleCompletion?
	private var viewLinkAnother: QIOHaveMoreAccountsControl = .fromNib()

	// MARK: IBOutlets
	
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	@IBOutlet weak var lblFinished: UILabel!
	
	// MARK: - View Lifecycle

	convenience init(_ c: @escaping QIOSimpleCompletion) {
		self.init()
		self.completion = c
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		QMix.track(.viewLinkingQuantizing)
		lblFinished.font = lblFinished.font.italic
		if let nc = navigationController {
			nc.setNavigationBarHidden(true, animated: true)
		}
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if continueButton == nil {
			let c = addContinueButton(selector: #selector(continueAction), onObj: self, startDisabled: true)
			continueButton = c
			viewLinkAnother.setParentVC(self)
			viewLinkAnother.y = c.y - viewLinkAnother.h
		}
		poll()
	}

	// MARK: - Custom
	
	private func poll() {
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
			self.checkQuantizingStatus()
		}
	}

	private func checkQuantizingStatus() {
		FIOAppSync.sharedInstance.isQuantizing() { res in
			switch res {
			case .success(let isRunning):
				if isRunning {
					print(Date().timeIntervalSince1970.asString)
					self.poll()
				} else {
					self.enableContinueButton()
					self.spinner.stopAnimating()
					self.lblFinished.isHidden = false
				}
			case .failure(let err):
				AppDelegate.sharedInstance.presentAlertWithTitle("🤔", message: "Quantizing failed." + String(describing: err)) { _ in
					if let c = self.completion { c() }
				}
			}
		}
	}
	
	@objc func continueAction() {
		if QPlaid.isUpdateMode {
			if let c = completion { c() }
		} else {
			if let nc = navigationController {
				nc.pushViewController(QIOLinkFinaleViewController(completion), animated: true)
			} else if let nc = AppDelegate.sharedInstance.navigationController {
				nc.pushViewController(QIOLinkFinaleViewController(completion), animated: true)
			}
		}
	}
	
}
