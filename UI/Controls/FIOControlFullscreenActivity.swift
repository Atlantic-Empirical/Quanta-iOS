//
//  FIOControlFullscreenActivity.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 12/19/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

//  Usage:
//
//  # Show Overlay
//  FIOControlFullscreenActivity.shared.presentOver(self.navigationController?.view)
//
//  # Hide Overlay
// FIOControlFullscreenActivity.shared.hide()

class FIOControlFullscreenActivity {

	private var overlayView: UIView?
	private var activityIndicator: UIActivityIndicatorView?
	private var lbl: UILabel?
	
	class var shared: FIOControlFullscreenActivity {
		struct Static {
			static let instance = FIOControlFullscreenActivity()
		}
		return Static.instance
	}
	
	func presentOverRoot() {
		if
			let nc = AppDelegate.sharedInstance.navigationController,
			let vc = nc.visibleViewController
		{
			presentOver(vc.view)
		}
	}
	
	func updateText(_ newText: String) {
		lbl?.text = newText
	}
	
	func presentOver(_ parentView: UIView, message: String = "Stand by please...") {
		if
			let _ = overlayView,
			let l = lbl
		{ // we're already visible
			l.text = message
		} else {
			overlayView = parentView.snapshotView(afterScreenUpdates: true)
			guard let ov = overlayView else { return }
			
			// BLUR
			let blurEffect = UIBlurEffect(style: .extraLight)
			let blurEffectView = UIVisualEffectView(effect: blurEffect)
			blurEffectView.frame = ov.bounds
			blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			ov.addSubview(blurEffectView)
			
			// Vibrancy Effect
			let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
			let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
			vibrancyEffectView.frame = parentView.bounds
			blurEffectView.contentView.addSubview(vibrancyEffectView)
			
			// BODY
			let body = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
			body.center = ov.center
			ov.addSubview(body)
			
			// SPINNER
			activityIndicator = qSpinner()
			if let spinner = activityIndicator {
				body.addSubview(spinner)
				spinner.anchorCenterXToSuperview()
				
				// LABEL
				let l = UILabel()
				l.translatesAutoresizingMaskIntoConstraints = false
				l.text = message
				l.font = .systemFont(ofSize: 22.0, weight: .semibold)
				l.font = l.font.italic
				l.textColor = .q_53
				l.kerning = 4.0
				l.sizeToFit()
				body.addSubview(l)
				l.anchor(centerYXAnchorToSuper: true, topAnchor: spinner.bottomAnchor, topConstant: 40)
				lbl = l
			}
			
			// DONE
			parentView.addSubview(ov)
		}
	}
	
	func hide() {
		if let ai = activityIndicator {
			ai.stopAnimating()
		}
		if let ov = overlayView {
			ov.removeFromSuperview()
			overlayView = nil
			lbl = nil
		}
	}
	
}

//			// VIBRANT TEXT
//			let vibrantLabel = UILabel()
//			vibrantLabel.text = "Vibrant"
//			vibrantLabel.font = UIFont.systemFont(ofSize: 72.0)
//			vibrantLabel.sizeToFit()
//			vibrantLabel.center = overlayView.center
//			vibrancyEffectView.contentView.addSubview(vibrantLabel)
