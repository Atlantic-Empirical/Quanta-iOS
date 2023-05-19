//
//  UIView+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/14/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.

import Foundation
import UIKit

extension UIView {

	// MARK: Constants
	static var moduleTopBottomPad: CGFloat = 34.0
	static var moduleInternalVerticalSeparation: CGFloat = 20.0
	static var moduleInternalVerticalSeparation_tight: CGFloat = 16.0

	// MARK: - Lifecycle
	
	class func fromNib<T: UIView>() -> T {
		return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
	}
	
	public func removeAllSubviews() {
		subviews.forEach() { $0.removeFromSuperview() }
	}

	public func addModuleSubviews(_ views: [UIView]) {
		views.forEach { addModuleSubview($0) }
	}
	
	public func addModuleSubview(
		_ v: UIView,
		atY: CGFloat? = nil,
		useTightVerticalSpacing: Bool = false,
		centerBelowTitle: Bool = false
	) {
		var y: CGFloat = 0
		if let atY = atY { y = atY }
		else if v.y > 0 { y = v.y }
		else if subviews.count == 0 { y = 0 }
		else {
			y = subviewBottomY + (
				useTightVerticalSpacing ?
				UIView.moduleInternalVerticalSeparation_tight :
				UIView.moduleInternalVerticalSeparation
			)
		}
		v.center.x = w/2
		
		if centerBelowTitle {
			v.center.y = subviewBottomY + ((h - subviewBottomY) / 2)
		} else {
			v.y = y
		}
		
		addSubview(v)
	}
	
	public func addAndDistributeViewsHorizontally(
		_ views: [UIView],
		atY: CGFloat? = nil,
		spacing: CGFloat
	) {
		let y: CGFloat = atY ?? subviewBottomY + UIView.moduleInternalVerticalSeparation
		var totalRequiredWidthWithFullSpacing = views.reduce(0) { $0 + $1.frame.width }
		totalRequiredWidthWithFullSpacing += ((views.count - 1).asCGFloat * spacing)
		let container = UIView()
		let heights = views.map { $0.h }
		let maxHeight = heights.max() ?? 50.0
		container.frame = CGRect(x: 0, y: y, width: totalRequiredWidthWithFullSpacing, height: maxHeight)
		container.center.x = frame.width / 2
		var xCursor: CGFloat = 0
		views.forEach() {
			$0.frame.origin = CGPoint(x: xCursor, y: 0)
			container.addSubview($0)
			xCursor += $0.frame.width + spacing
		}
		addSubview(container)
	}

	// MARK: - Viz
	
	func roundCornersSpecific(_ corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		self.layer.mask = mask
	}
	
	func getColorFromPoint(_ point: CGPoint) -> UIColor {
		
		let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		
		var pixelData: [UInt8] = [0, 0, 0, 0]
		
		let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
		context?.translateBy(x: -point.x, y: -point.y)
		
		self.layer.render(in: context!)
		
		let red: CGFloat = CGFloat(pixelData[0]) / CGFloat(255.0)
		let green: CGFloat = CGFloat(pixelData[1]) / CGFloat(255.0)
		let blue: CGFloat = CGFloat(pixelData[2]) / CGFloat(255.0)
		let alpha: CGFloat = CGFloat(pixelData[3]) / CGFloat(255.0)
		
		let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
		
		return color
	}
	
	// MARK: - Frame
	
	public var safeL: CGFloat { return safeAreaInsets.left }
	public var safeR: CGFloat { return safeAreaInsets.right }
	public var safeT: CGFloat { return safeAreaInsets.top }
	public var safeB: CGFloat { return safeAreaInsets.bottom }

	public func setHeight(withBottomPad: Bool = true) {
		h = subviewBottomY + (withBottomPad ? UIView.moduleTopBottomPad : 0)
	}

	public var subviewBottomY: CGFloat {
		var y: CGFloat = 0
		subviews.forEach {
			if
				$0.y_bottom > y &&
				!$0.isHidden &&
				$0.tag != 98765 // module decorative view
			{ y = $0.y_bottom }
		}
		return y
	}

	/**
	Rotate a view by specified degrees
	- parameter angle: angle in degrees
	*/
	func rotate(_ angle: CGFloat) {
		let radians = angle / 180.0 * CGFloat.pi
		let rotation = transform.rotated(by: radians)
		transform = rotation
	}
	
	func rotateView(byRadianDegrees radianDegrees: CGFloat, withAnchorPoint relativeAnchorPoint: CGPoint) {
		let viewBounds: CGRect = self.bounds
		let anchorPoint = CGPoint(x: viewBounds.size.width * relativeAnchorPoint.x, y: viewBounds.size.height * relativeAnchorPoint.y)
		var transform: CGAffineTransform = CGAffineTransform.identity
		transform = transform.translatedBy(x: anchorPoint.x, y: anchorPoint.y)
		transform = transform.rotated(by: radianDegrees)
		transform = transform.translatedBy(x: -anchorPoint.x, y: -anchorPoint.y)
		
		// Translate back
		self.transform = transform
	}
	
	/// Helper to get pre transform frame
	var originalFrame: CGRect {
		let currentTransform = transform
		transform = .identity
		let originalFrame = frame
		transform = currentTransform
		return originalFrame
	}
	
	/// Helper to get point offset from center
	func centerOffset(_ point: CGPoint) -> CGPoint {
		return CGPoint(x: point.x - center.x, y: point.y - center.y)
	}
	
	/// Helper to get point back relative to center
	func pointRelativeToCenter(_ point: CGPoint) -> CGPoint {
		return CGPoint(x: point.x + center.x, y: point.y + center.y)
	}
	
	/// Helper to get point relative to transformed coords
	func newPointInView(_ point: CGPoint) -> CGPoint {
		// get offset from center
		let offset = centerOffset(point)
		// get transformed point
		let transformedPoint = offset.applying(transform)
		// make relative to center
		return pointRelativeToCenter(transformedPoint)
	}
	
	var newTopLeft: CGPoint {
		return newPointInView(originalFrame.origin)
	}
	
	var newTopRight: CGPoint {
		var point = originalFrame.origin
		point.x += originalFrame.width
		return newPointInView(point)
	}
	
	var newBottomLeft: CGPoint {
		var point = originalFrame.origin
		point.y += originalFrame.height
		return newPointInView(point)
	}
	
	var newBottomRight: CGPoint {
		var point = originalFrame.origin
		point.x += originalFrame.width
		point.y += originalFrame.height
		return newPointInView(point)
	}
	
	public func positionIn(_ view: UIView) -> CGRect {
		if let superview = superview {
			return superview.convert(frame, to: view)
		}
		return frame
	}
	
	public func addHeight(_ amount: CGFloat) {
		frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height + amount)
	}
	
	public var origin: CGPoint {
		get {
			return frame.origin
		}
		set {
			frame = CGRect(origin: newValue, size: frame.size)
		}
	}
	
	public var size: CGSize {
		get {
			return frame.size
		}
		set {
			frame = CGRect(origin: frame.origin, size: newValue)
		}
	}

	public var h: CGFloat {
		get {
			return frame.height
		}
		set {
			frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: newValue)
		}
	}
	
	public var w: CGFloat {
		get {
			return frame.width
		}
		set {
			frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newValue, height: frame.height)
		}
	}
	
	public var x: CGFloat {
		get {
			return frame.origin.x
		}
		set {
			frame = CGRect(x: newValue, y: frame.origin.y, width: frame.width, height: frame.height)
		}
	}
	
	public var y: CGFloat {
		get {
			return frame.origin.y
		}
		set {
			frame = CGRect(x: frame.origin.x, y: newValue, width: frame.width, height: frame.height)
		}
	}

	public var y_bottom: CGFloat {
		get {
			return y + h
		}
		set {
			h = newValue - y
		}
	}
	
	public func setYbyBottomY(_ yB: CGFloat) {
		y = yB - h
	}

	public var x_right: CGFloat {
		return x + w
	}

	public func sizeToFitCustom() {
		var w: CGFloat = 0, h: CGFloat = 0
		subviews.forEach {
			if $0.frame.origin.x + $0.frame.width > w { w = $0.frame.origin.x + $0.frame.width }
			if $0.frame.origin.y + $0.frame.height > h { h = $0.frame.origin.y + $0.frame.height }
		}
		frame.size = CGSize(width: w, height: h)
	}
	
	func move(direction: QIODirection, byPoints: CGFloat, animateDuration: Double) {
		var x = self.x
		var y = self.y
		switch direction {
		case .down: y += byPoints
		case .up: y -= byPoints
		case .right: x += byPoints
		case .left: x -= byPoints
		}
		UIView.animate(withDuration: animateDuration) {
			self.frame = CGRect(origin: CGPoint(x: x, y: y), size: self.size)
		}
	}
	
	public var centerPointInParent: CGPoint {
		return convert(center, from: superview)
	}
	
	public func centerWithinParent() {
		if let sv = superview {
			center.x = sv.w / 2
		}
	}
	
	// MARK: - Transitions
	
	public func fadeTransition(_ duration: CFTimeInterval) {
		
		let animation = CATransition()
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		animation.type = CATransitionType.fade
		animation.duration = duration
		layer.add(animation, forKey: CATransitionType.fade.rawValue)
	}
	
	// MARK: - Snapshotting
	
	func imageFromView() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
		drawHierarchy(in: bounds, afterScreenUpdates: true)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}
	
	func imageFromView2() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
		layer.render(in: UIGraphicsGetCurrentContext()!)
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return img!
	}

	func screenshot() -> UIImage {
		return UIGraphicsImageRenderer(size: bounds.size).image { _ in
			drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
		}
	}
	
}

enum QIODirection {
	case up
	case down
	case left
	case right
}
