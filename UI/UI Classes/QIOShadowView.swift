//
//  QIOShadowView.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 4/5/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

//import AudioToolbox

open class QIOShadowView: UIView, UIGestureRecognizerDelegate {
	
	// MARK: - Properties
	private var tapGR: UITapGestureRecognizer?
	private let haptic = UISelectionFeedbackGenerator()
	internal var singleActionSelector: Selector?
	internal var selectorObject: NSObject?
	private var touchesBeganAt: Double = 0
	private var cancelTap: Bool = false
	private var targetShadowRadius: CGFloat = 4.0
	private var performingTap: Bool = false

	// MARK: - Lifecycle

	convenience init(frame: CGRect, addShadow: Bool = true) {
		self.init(frame: frame)
		if addShadow { applyShadow() }
		cornerRadius = frame.w * 0.05 // 5% of width
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Shadow
	
	private func applyShadow() {
		shadowColor = UIColor.lightGray.withAlphaComponent(0.8)
		shadowOpacity = 1.0
		shadowOffset = .zero // Set the light angle, zero is straight above
		shadowRadius = targetShadowRadius
	}
	
	private func toggleShadow() {
		if !isActionable || performingTap { return }
		layer.shadowRadius = (layer.shadowRadius == 0) ? targetShadowRadius : 0.0
		haptic.selectionChanged()
	}
	
	internal func blinkShadow(completion: @escaping QIOSimpleCompletion = {}) {
//		print(#function)
		CATransaction.begin()
		let animation = CABasicAnimation(keyPath: "shadowRadius")
		animation.fromValue = layer.shadowRadius
		animation.toValue = 0.0
		animation.duration = 0.1
		animation.autoreverses = true
		CATransaction.setCompletionBlock(completion)
		layer.add(animation, forKey: nil)
		CATransaction.commit()
		haptic.selectionChanged()
//		AudioServicesPlaySystemSound(1103)
	}

	// MARK: - Single Action
	
	func addSingleActionToView(
		_ selector: Selector?,
		_ obj: NSObject?,
		_ tag: Int = 0,
		useGestureRecognizer: Bool = false
	) {
		singleActionSelector = selector
		selectorObject = obj
		self.tag = tag
		if useGestureRecognizer {
			setupGestureRecognizer()
		}
	}
	
	private func setupGestureRecognizer() {
		tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
		if let t = tapGR {
			t.delegate = self
			t.cancelsTouchesInView = false
			t.delaysTouchesBegan = false
			t.numberOfTapsRequired = 1
			t.numberOfTouchesRequired = 1
			addGestureRecognizer(t)
		}
	}

	// MARK: - Computed Vars
	
	private var isActionable: Bool {
		return singleActionSelector != nil
	}
	
	// MARK: - UIGestureRecognizerDelegate
//
//	override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//		print(#function)
////		AudioServicesPlaySystemSound(1103)
//		touchesBeganAt = Date().timeIntervalSince1970 * 1000
//		cancelTap = false
//		toggleShadow(off: true)
//	}
//
//	override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
////		print(#function)
//		if cancelTap { return } // don't spam the console
////		print("WILL CANCEL TAP do to finger move")
//		cancelTap = true
//		touchesBeganAt = 0
//	}
//
//	override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
////		print(#function)
//		cancelTap = false
//		touchesBeganAt = 0
//		toggleShadow(off: false)
//	}

	@objc internal func handleTap(recognizer: UITapGestureRecognizer) {
		print(#function)
		if touchesBeganAt != 0 {
			let elapsedMillis = (Date().timeIntervalSince1970 * 1000) - touchesBeganAt
			if elapsedMillis > 500 {
//				print("WILL CANCEL TAP do to touch duration = \(elapsedMillis)")
				cancelTap = true
				touchesBeganAt = 0
			}
		}
		if cancelTap {
//			print("CANCELLING THE TAP")
			cancelTap = false
		} else {
			if let o = selectorObject, let s = singleActionSelector {
				o.performSelector(onMainThread: s, with: self, waitUntilDone: false)
//				blinkShadow() { [weak self] in
//				}
			}
		}
	}

	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
}
