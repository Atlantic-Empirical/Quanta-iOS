//
//  QIOWebKitViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 4/11/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import WebKit

class QIOWebKitViewController: UIViewController, WKNavigationDelegate {

	var containerView: UIView!
	var webview: WKWebView?
	private var url: URL?

	public convenience init(_ url: URL) {
		self.init()
		self.url = url
	}
	
	override func viewDidLayoutSubviews() {
		webview = WKWebView(frame: view.bounds)
		webview?.navigationDelegate = self
		view.addSubview(webview!)
		if let u = self.url {
			webview?.load(URLRequest(url: u))
		}
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webview?.title
	}

}
