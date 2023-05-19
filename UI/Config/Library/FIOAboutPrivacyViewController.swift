//
//  FIOAboutPrivacyViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 12/3/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import Down

class FIOAboutPrivacyViewController: UIViewController {

	// MARK: - Properties
	private var didAppearOnce = false
	public var preferredIndex: Int = 0
	private var markdownView: DownView?

	// MARK: - IBOutlets
	@IBOutlet weak var segment: UISegmentedControl!
	@IBOutlet weak var viewWebHost: UIView!

	// MARK: - View Lifecycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		title = "Privacy & Security"
		navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
		edgesForExtendedLayout = []
		renderTextForIndex(0)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if !didAppearOnce {
			didAppearOnce = true
			markdownView = try? DownView(frame: self.viewWebHost.bounds, markdownString: "")
			viewWebHost.addSubview(markdownView!)
			viewWebHost.y_bottom = view.safeAreaLayoutGuide.layoutFrame.y_bottom
			segment.selectedSegmentIndex = preferredIndex
			segmentChanged(self)
		}
	}
	
	// MARK: - IBActions
	
	@IBAction func segmentChanged(_ sender: Any) {
		renderTextForIndex(segment.selectedSegmentIndex)
	}
	
	// MARK: - Custom
	
	public func renderTextForIndex(_ idx: Int) {
		if self.markdownView == nil { return }
		var text = ""
		switch idx {
		case 0:
			text = QIOLibrary.stringFor(.PrivacySecurity)
		case 1:
			text = QIOLibrary.stringFor(.PrivacyPolicy)
		case 2:
			text = QIOLibrary.stringFor(.TermsOfUse)
		default: return
		}
		try? self.markdownView!.update(markdownString: text)
	}
	
}
