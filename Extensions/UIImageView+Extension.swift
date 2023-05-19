//
//  UIImageView+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 7/3/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
	
	func setImageFromUrlWithCache(_ urlStr: String, completion: @escaping QIOBoolCompletion) {
		DispatchQueue.global(qos: .background).async {
			let i = UIImage.cacheImage(urlStr)
			DispatchQueue.main.async {
				if i.size != .zero {
					self.image = i
					completion(true)
				} else {
					completion(false)
				}
			}
		}
	}
	
}
