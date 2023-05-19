//
//  UIView-Constraints+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/31/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	func anchor(x: NSLayoutXAxisAnchor, y: NSLayoutYAxisAnchor, w: NSLayoutDimension, h: NSLayoutDimension) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		anchorCenter(x: x, y: y)
		anchorSize(w: w, h: h)
	}
	
	func anchor(
		centerYXAnchorToSuper: Bool = false,
		centerXAnchor: NSLayoutXAxisAnchor? = nil,
		anchorXToSuperCenter: Bool = false,
		centerYAnchor: NSLayoutYAxisAnchor? = nil,
		anchorYToSuperCenter: Bool = false,
		topAnchor: NSLayoutYAxisAnchor? = nil,
		topConstant: CGFloat = 0,
		w: CGFloat? = nil,
		wAnchor: NSLayoutDimension? = nil,
		h: CGFloat? = nil,
		hAnchor: NSLayoutDimension? = nil,
		leadingAnchor: NSLayoutXAxisAnchor? = nil,
		trailingAnchor: NSLayoutXAxisAnchor? = nil,
		bottomAnchor: NSLayoutYAxisAnchor? = nil
	) {
		guard let sv = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}

		// CENTER
		if centerYXAnchorToSuper {
			self.centerXAnchor.constraint(equalTo: sv.centerXAnchor).activate()
			self.centerYAnchor.constraint(equalTo: sv.centerYAnchor).activate()
		} else {
			if let cxa = centerXAnchor {
				self.centerXAnchor.constraint(equalTo: cxa).activate()
			} else if anchorXToSuperCenter {
				self.centerXAnchor.constraint(equalTo: sv.centerXAnchor).activate()
			}
			
			if let cya = centerYAnchor {
				self.centerYAnchor.constraint(equalTo: cya).activate()
			} else if anchorYToSuperCenter {
				self.centerYAnchor.constraint(equalTo: sv.centerYAnchor).activate()
			}
		}

		// TOP
		if let top = topAnchor {
			self.topAnchor.constraint(equalTo: top, constant: topConstant).activate()
		}
		
		// LEFT
		if let la = leadingAnchor {
			self.leadingAnchor.constraint(equalTo: la).activate()
		}
		
		// RIGHT
		if let ta = trailingAnchor {
			self.trailingAnchor.constraint(equalTo: ta).activate()
		}

		// BOTTOM
		if let ba = bottomAnchor {
			self.bottomAnchor.constraint(equalTo: ba).activate()
		}

		// WIDTH
		if let w = w {
			self.widthAnchor.constraint(equalToConstant: w).activate()
		} else if let w = wAnchor {
			self.widthAnchor.constraint(equalTo: w).activate()
		}
		
		// HEIGHT
		if let h = h {
			self.heightAnchor.constraint(equalToConstant: h).activate()
		} else if let h = hAnchor {
			self.heightAnchor.constraint(equalTo: h).activate()
		}
	}
	
	func anchorToSuperview(constant: CGFloat = 0) {
		anchorLeadingToSuperview(constant: constant)
		anchorTopToSuperview(constant: constant)
		anchorTrailingToSuperview(constant: constant)
		anchorBottomToSuperview(constant: constant)
	}

	func anchorTopAndSidesToSuperview(constant: CGFloat = 0, height: CGFloat = 0) {
		anchorTopToSuperview(constant: constant)
		if height > 0 { anchorHeight(height) }
		anchorSidesToSuperview(constant: constant)
	}

	func anchorSidesToSuperview(constant: CGFloat = 0) {
		anchorLeadingToSuperview(constant: constant)
		anchorTrailingToSuperview(constant: constant)
	}

	func anchorSidesToOtherview(_ v: UIView) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		leadingAnchor.constraint(equalTo: v.leadingAnchor).activate()
		topAnchor.constraint(equalTo: v.topAnchor).activate()
		trailingAnchor.constraint(equalTo: v.trailingAnchor).activate()
		bottomAnchor.constraint(equalTo: v.bottomAnchor).activate()
	}
	
	func anchorCenterToSuperview() {
		guard let sv = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		centerXAnchor.constraint(equalTo: sv.centerXAnchor).activate()
		centerYAnchor.constraint(equalTo: sv.centerYAnchor).activate()
	}

	func anchorCenterXToSuperview() {
		guard let sv = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		centerXAnchor.constraint(equalTo: sv.centerXAnchor).activate()
	}

	func anchorCenterXTo(_ otherXanchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		centerXAnchor.constraint(equalTo: otherXanchor, constant: constant).activate()
	}

	func anchorCenterYToSuperview(constant: CGFloat = 0) {
		guard let sv = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		centerYAnchor.constraint(equalTo: sv.centerYAnchor, constant: constant).activate()
	}

	func anchorCenterYTo(_ view: UIView, constant: CGFloat = 0) {
		centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).activate()
	}

	func anchorBottomToSuperview(constant: CGFloat = 0) {
		guard let sv = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		bottomAnchor.constraint(equalTo: sv.bottomAnchor, constant: constant).activate()
	}

	func anchorBottomTo(_ otherYanchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		bottomAnchor.constraint(equalTo: otherYanchor, constant: constant).activate()
	}

	func anchorBaselineTo(_ otherYanchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		lastBaselineAnchor.constraint(equalTo: otherYanchor).activate()
	}

	func anchorCenterXYTo(_ view: UIView) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
		centerYAnchor.constraint(equalTo: view.centerYAnchor).activate()
	}

	func anchorTopToSuperview(constant: CGFloat = 0) {
		guard let sv = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		topAnchor.constraint(equalTo: sv.topAnchor, constant: constant).activate()
	}

	func anchorTopTo(_ otherYanchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		topAnchor.constraint(equalTo: otherYanchor, constant: constant).activate()
	}

	func anchorLeadingTo(_ otherXanchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		leadingAnchor.constraint(equalTo: otherXanchor, constant: constant).activate()
	}
	
	func anchorLeadingToSuperview(constant: CGFloat = 0) {
		guard let sv = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		leadingAnchor.constraint(equalTo: sv.leadingAnchor, constant: constant).activate()
	}

	func anchorTrailingTo(_ otherXanchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		trailingAnchor.constraint(equalTo: otherXanchor, constant: constant).activate()
	}
	
	func anchorTrailingToSuperview(constant: CGFloat = 0) {
		guard let sv = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		trailingAnchor.constraint(equalTo: sv.trailingAnchor, constant: constant).activate()
	}

	func anchorCenterYTo(_ y: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		centerYAnchor.constraint(equalTo: y, constant: constant).activate()
	}

	func anchorCenter(x: NSLayoutXAxisAnchor, y: NSLayoutYAxisAnchor) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		NSLayoutConstraint.activate([
			centerXAnchor.constraint(equalTo: x),
			centerYAnchor.constraint(equalTo: y)
			])
	}
	
	func anchorSize(w: NSLayoutDimension, h: NSLayoutDimension) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalTo: w),
			heightAnchor.constraint(equalTo: h)
		])
	}

	func anchorSizeToSuperview() {
		guard let sv = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalTo: sv.widthAnchor),
			heightAnchor.constraint(equalTo: sv.heightAnchor)
		])
	}

	func anchorHeightToSuperview(constant: CGFloat = 0) {
		guard let sv = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		NSLayoutConstraint.activate([
			heightAnchor.constraint(equalTo: sv.heightAnchor, constant: constant)
		])
	}

	func anchorWidthToSuperview(constant: CGFloat = 0) {
		guard let sv = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalTo: sv.widthAnchor, constant: constant),
		])
	}

	func anchorSizeConstant(_ w: CGFloat, _ h: CGFloat) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalToConstant: w),
			heightAnchor.constraint(equalToConstant: h)
			])
	}

	func anchorSizeToOtherView(_ v: UIView) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		heightAnchor.constraint(equalToConstant: v.h).activate()
		widthAnchor.constraint(equalToConstant: v.w).activate()
	}

	
	func anchorSizeToOwnFrame() {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		heightAnchor.constraint(equalToConstant: self.h).activate()
		widthAnchor.constraint(equalToConstant: self.w).activate()
	}

	func anchorSizeConstantSquare(_ wh: CGFloat) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalToConstant: wh),
			heightAnchor.constraint(equalToConstant: wh)
		])
	}

	func anchorWidth(w: NSLayoutDimension) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalTo: w)
		])
	}

	func anchorWidth(_ w: CGFloat) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		NSLayoutConstraint.activate([
			widthAnchor.constraint(equalToConstant: w)
		])
	}

	func anchorHeight(h: NSLayoutDimension, constant: CGFloat = 0) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		NSLayoutConstraint.activate( [ heightAnchor.constraint(equalTo: h, constant: constant) ])
	}
	
	func anchorHeight(_ h: CGFloat) {
		guard let _ = superview else {
			print("WARNING: \(#function) called before view was added to superview. Abort ⚠️.")
			return
		}
		heightAnchor.constraint(equalToConstant: h).activate()
	}

}
