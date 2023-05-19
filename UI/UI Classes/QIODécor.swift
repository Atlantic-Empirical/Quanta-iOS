//
//  QIOBrandedDecoration.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/28/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	func applyQioGradientBackground() {
		backgroundColor = .white
		layer.addSublayer(QIODécor.viewBackgroundGradient(frame: bounds))
	}
	
}

extension UITableViewCell {
	
	func quantaDefaultViz() {
		textLabel?.font = baseFont(size: 16, bold: true)
		textLabel?.textColor = .q_38
		detailTextLabel?.font = baseFont(size: 14, bold: false)
		detailTextLabel?.textColor = .q_78
		selectedBackgroundView = UIView()
		selectedBackgroundView?.backgroundColor = UIColor.q_brandGold.withAlphaComponent(0.3)
	}
	
}

func baseFont(
	size: CGFloat = 18.0,
	bold: Bool = true
) -> UIFont {
	guard let customFont = UIFont(
		name: "GTWalsheim" + (bold ? "Bold" : "Regular"),
		size: size
	)
	else {
		fatalError("""
				Failed to load the custom font.
				Make sure the font file is included in the project and the font name is spelled correctly.
				"""
		)
	}
	return customFont
}

func baseFontLight(
	size: CGFloat = 18.0
) -> UIFont {
	guard let customFont = UIFont(
		name: "GTWalsheimLight",
		size: size
		)
		else {
			fatalError("""
				Failed to load the custom font.
				Make sure the font file is included in the project and the font name is spelled correctly.
				"""
			)
	}
	return customFont
}

class QIODécor {

	/// Prints all font names on system, very useful when using custom fonts.
	static func enumerateFontNames() {
		for family in UIFont.familyNames.sorted() {
			let names = UIFont.fontNames(forFamilyName: family)
			print("Family: \(family) Font names: \(names)")
		}
	}
	
	static func viewBackgroundGradient(frame: CGRect) -> CAGradientLayer {
		let gradient = CAGradientLayer()
		gradient.colors = [
			UIColor.q_brandGold.withAlphaComponent(0.3).cgColor,
			UIColor.q_brandGold.cgColor
		]
		gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
		gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
		gradient.frame = frame
		return gradient
	}
	
	static let cornerRadius: CGFloat = 16.0
	
	static func applyGradientToView(_ m: UIView) {
		let v = UIView(frame: m.bounds)
		v.cornerRadius = m.cornerRadius
		v.tag = 98765
		
		let gradient = CAGradientLayer()
		gradient.colors = [
			UIColor.q_brandGoldLight.cgColor,
			UIColor.q_brandGold.cgColor
		]
		//		gradient.locations = [0, 0.1, 0.2, 1.0]
		gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
		gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
		gradient.frame = v.bounds
		gradient.cornerRadius = v.cornerRadius
		
		v.layer.addSublayer(gradient)
		m.insertSubview(v, at: 0)
	}

	static func addMajorShadowToView(
		_ containerView: UIView,
		_ viewToShadow: UIView,
		shadowColor: UIColor = .black
	) {

		let shadow = UIView(frame: .zero)
		shadow.backgroundColor = .clear // UIColor(white: 0, alpha: 0)
		shadow.translatesAutoresizingMaskIntoConstraints = false
		shadow.layer.masksToBounds = false
		shadow.layer.shadowColor = shadowColor.cgColor
		shadow.layer.shadowRadius = 10
		shadow.layer.shadowOpacity = 0.3
		shadow.layer.shadowOffset = CGSize(width: 0, height: 0)
		shadow.tag = 8043
		containerView.insertSubview(shadow, belowSubview: viewToShadow)

		// Set size constraints on the module (required or following code will fail)
		viewToShadow.addConstraint(NSLayoutConstraint(
			item: viewToShadow,
			attribute: .width,
			relatedBy: .equal,
			toItem: nil,
			attribute: .notAnAttribute,
			multiplier: 1,
			constant: viewToShadow.w))

		viewToShadow.addConstraint(NSLayoutConstraint(
			item: viewToShadow,
			attribute: .height,
			relatedBy: .equal,
			toItem: nil,
			attribute: .notAnAttribute,
			multiplier: 1,
			constant: viewToShadow.h))

		// Create constraints for the shadow view
		let sizeConstraints: [(NSLayoutConstraint.Attribute, CGFloat)] =
			[
				(NSLayoutConstraint.Attribute.width, 0.8),
				(NSLayoutConstraint.Attribute.height, 0.9)
		]

		for info: (attribute: NSLayoutConstraint.Attribute, scale: CGFloat) in sizeConstraints {
			if let frontViewConstraint = viewToShadow.getConstraint(info.attribute) {
				shadow >>>- {
					$0.attribute = info.attribute
					$0.constant = frontViewConstraint.constant * info.scale
					return
				}
			}
		}

		let centerConstraints: [(NSLayoutConstraint.Attribute, CGFloat)] =
			[
				(NSLayoutConstraint.Attribute.centerX, 0),
				(NSLayoutConstraint.Attribute.centerY, 30)
		]

		for info: (attribute: NSLayoutConstraint.Attribute, offset: CGFloat) in centerConstraints {
			(containerView, shadow, viewToShadow) >>>- {
				$0.attribute = info.attribute
				$0.constant = info.offset
				return
			}
		}

		// Set the shadowPath
		if
			let widthConstraint = shadow.getConstraint(.width),
			let heightConstraint = shadow.getConstraint(.height)
		{
			shadow.layer.shadowPath = UIBezierPath(roundedRect:
				CGRect(
					w: widthConstraint.constant,
					h: heightConstraint.constant
				),
				cornerRadius: 0).cgPath
		}
	}
	
	/// won't work yet... still need to figure this out
//	static func animateMajorShadowAlpha(
//		to: CGFloat,
//		in container: UIView,
//		withDuration duration: TimeInterval
//	) {
//		if let shadowView = container.subviews.first(where: { $0.tag == 8043 }) {
//			UIView.animate(withDuration: duration) {
//				shadowView.alpha = to
//			}
//		}
//	}

}

// MARK: - QIO COLORS

extension UIColor {
	
	static var q_brandGreen: UIColor { return UIColor("10C020") }
	static var q_brandGold: UIColor { return UIColor("FFAD09") } // FFBB33
	static var q_brandGoldLight: UIColor { return UIColor("FAD488") } // FFE28F
	static var q_buttonBlue: UIColor { return UIColor("54ACFF") }
	static var q_buttonLinkBlue: UIColor { return UIColor("067AFF") }
	static var q_DeficitRed: UIColor { return UIColor("F85C5C") }
	static var q_38: UIColor { return UIColor("383838") }
	static var q_53: UIColor { return UIColor("535353") }
	static var q_78: UIColor { return UIColor("787878") }
	static var q_8C: UIColor { return UIColor("8C8C8C") }
	static var q_97: UIColor { return UIColor("979797") }
	static var q_C0: UIColor { return UIColor("c0c0c0") }
	static var q_C7: UIColor { return UIColor("c7c7c7") }
	static var q_F0: UIColor { return UIColor("f0f0f0") }
	static var q_FA: UIColor { return UIColor("fafafa") }
	
}
