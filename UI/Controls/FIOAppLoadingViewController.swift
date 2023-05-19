//
//  FIOAppLoadingViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 10/1/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOAppLoadingViewController: UIViewController {

	@IBOutlet weak var ai: UIActivityIndicatorView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		UIView.animate(withDuration: 0.5) {
			self.ai.alpha = 1
		}
	}

}
