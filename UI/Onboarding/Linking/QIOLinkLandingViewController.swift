//
//  FIONoAccountViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/6/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class QIOLinkLandingViewController: UIViewController {
	
	// MARK: - Properties
	var rendered: Bool = false
	
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
		QMix.track(.viewLinkBankLanding)
        NotifCenter.addObserver(self, selector: #selector(self.handlePlaidLinkSuccess), name: .FIOPlaidLinkSucceeded, object: nil)
        NotifCenter.addObserver(self, selector: #selector(self.handlePlaidLinkError), name: .FIOPlaidLinkError, object: nil)
        NotifCenter.addObserver(self, selector: #selector(self.handleExitWithMetadata), name: .FIOPlaidLinkExit, object: nil)
		view.backgroundColor = .white
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		buildUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		if let nc = navigationController {
			nc.setNavigationBarHidden(true, animated: false)
		}
		quantizeStatusCheck()
	}

	private func quantizeStatusCheck() {
		FIOAppSync.sharedInstance.isQuantizing() { res in
			guard let nc = self.navigationController else { return }
			var vc: UIViewController
			switch res {
			case .success(let isRunning):
				if isRunning {	
					vc = QIOQuantizeProgressViewController()
				} else {
					vc = QIOLinkFinaleViewController()
				}
				nc.pushViewController(vc, animated: true)
			case .failure(let err):
				print("checkQuantizingStatus() returned no status. Probably means Quantize has never run for this user.")
				print(err.localizedDescription)
			}
		}
	}
	
    // MARK: - IBActions

    @objc func connectAccountAction(_ sender: Any) {
		plaidLink()
    }

	@objc func howItWorksAction(_ sender: Any) {
		pushVC(FIOGenericTextViewViewController(.HowQuantaWorks))
	}
	
	@IBAction func privacySecurityAction(_ sender: Any) {
		pushVC(FIOGenericTextViewViewController(.PrivacySecurity))
	}
	
	@objc func signoutAction(_ sender: Any) {
		QUser.signOutActionSheet()
	}
	
    // MARK: - Plaid Callback Overrides
	
	@objc override func handlePlaidLinkError(_ notification: NSNotification) {
		super.handlePlaidLinkError(notification)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc override func handleExitWithMetadata(_ notification: NSNotification) {
		super.handleExitWithMetadata(notification)
		self.dismiss(animated: false, completion: nil)
    }
	
    // MARK: - Custom
	
	private func pushVC(_ vc: UIViewController) {
		guard let nc = navigationController else { return }
		nc.navigationBar.customize(bgColor: .clear, withGradient: false)
		nc.setNavigationBarHidden(false, animated: false)
		nc.pushViewController(vc, animated: true)
	}
	
	func buildUI() {
		if rendered { return } else { rendered = true }
		
		let btn = UIButton(#selector(signoutAction(_:)))
		btn.setImage(UIImage(named: "GrayProfile_24pt"), for: .normal)
		view.addSubview(btn)
		btn.anchorSizeConstant(44, 44)
		btn.anchorTopTo(view.safeAreaLayoutGuide.topAnchor, constant: 16)
		btn.anchorTrailingTo(view.safeAreaLayoutGuide.trailingAnchor, constant: -16)

		let container = UIView(frame: .zero)
		if colorful { container.backgroundColor = .randomP3 }
		container.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(container)
		container.anchorCenterToSuperview()
		container.anchorWidth(w: view.safeAreaLayoutGuide.widthAnchor)
		container.anchorHeight(h: view.safeAreaLayoutGuide.heightAnchor, constant: -1 * (0.2 * view.safeAreaLayoutGuide.layoutFrame.h))
		
		let emoji = labelGenerator("🏦", font: .systemFont(ofSize: 60))
		emoji.frame = .zero
		emoji.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(emoji)
		emoji.anchorCenterXToSuperview()
		emoji.anchorTopTo(container.topAnchor)

		let header = labelGenerator(
			"Link\nYour Accounts",
			font: baseFont(size: 28, bold: true)
		)
		header.frame = .zero
		header.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(header)
		header.anchorCenterXToSuperview()
		header.anchorTopTo(emoji.bottomAnchor, constant: 20)

		let subheader = labelGenerator(
			"Quanta works its magic by analyzing the transaction feed from the accounts you link.",
			font: baseFont(size: 18, bold: false),
			textColor: .q_38,
			maxWidth: 266
		)
		subheader.origin = .zero
		subheader.translatesAutoresizingMaskIntoConstraints = false
		subheader.font = subheader.font.italic
		subheader.setLineSpacing(5)
		subheader.textAlignment = .center
		container.addSubview(subheader)
		subheader.anchorCenterXToSuperview()
		subheader.anchorSizeConstant(266, 86)
		subheader.anchorTopTo(header.bottomAnchor, constant: 20)
		
		let howItWorks = UIButton(#selector(howItWorksAction(_:)))
		howItWorks.backgroundColor = .clear
		if colorful { howItWorks.backgroundColor = .randomP3 }
		howItWorks.setTitle("How Account Connections Work", for: .normal)
		howItWorks.titleLabel?.font = baseFont(size: 17, bold: false)
		howItWorks.setTitleColor(.q_buttonLinkBlue, for: .normal)
		container.addSubview(howItWorks)
		howItWorks.anchorSizeConstant(270, 32)
		howItWorks.anchorCenterXToSuperview()
		howItWorks.anchorBottomToSuperview()
		
		let privacySecurity = UIButton(#selector(privacySecurityAction(_:)))
		privacySecurity.backgroundColor = .clear
		if colorful { privacySecurity.backgroundColor = .randomP3 }
		privacySecurity.setTitle("Privacy & Security", for: .normal)
		privacySecurity.titleLabel?.font = baseFont(size: 17, bold: false)
		privacySecurity.setTitleColor(.q_buttonLinkBlue, for: .normal)
		container.addSubview(privacySecurity)
		privacySecurity.anchorSizeConstant(270, 32)
		privacySecurity.anchorCenterXToSuperview()
		privacySecurity.anchorBottomTo(howItWorks.topAnchor, constant: -10)
		
		let questions = labelGenerator(
			"Questions?\nCheck out these easy reads:",
			font: baseFont(size: 13, bold: false),
			textColor: .q_97
		)
		if colorful { questions.backgroundColor = .randomP3 }
		questions.frame = .zero
		questions.font = questions.font.italic
		questions.setLineSpacing(5)
		questions.textAlignment = .center
		questions.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(questions)
		questions.anchorCenterXToSuperview()
		questions.anchorSizeConstant(194, 38)
		questions.anchorBottomTo(privacySecurity.topAnchor, constant: -15)
		
		let doneBtn = UIButton(#selector(connectAccountAction(_:)))
		doneBtn.backgroundColor = .q_buttonBlue
		doneBtn.setTitle("Let's Do It", for: .normal)
		doneBtn.titleLabel?.font = baseFont(size: 22, bold: true)
		doneBtn.cornerRadius = 8
		container.addSubview(doneBtn)
		doneBtn.anchorCenterXToSuperview()
		doneBtn.anchorSizeConstant(270, 66)
		doneBtn.anchorBottomTo(questions.topAnchor, constant: -20)
	}
	
}
