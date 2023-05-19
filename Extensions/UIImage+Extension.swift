//
//  UIImage+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/16/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	
	/// 1 = no change.
	func saturation(byVal: CGFloat) -> UIImage {
		guard let cgImage = self.cgImage else { return self }
		guard let filter = CIFilter(name: "CIColorControls") else { return self }
		filter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
		filter.setValue(byVal, forKey: kCIInputSaturationKey)
		guard let result = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
		guard let newCgImage = CIContext(options: nil).createCGImage(result, from: result.extent) else { return self }
		return UIImage(cgImage: newCgImage, scale: UIScreen.main.scale, orientation: imageOrientation)
	}

    func getPixelColor(pos: CGPoint) -> UIColor {
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
 
    func tinted(_ color: UIColor, percentageFromBottom: CGFloat) -> UIImage? {
        let imageRect = CGRect(origin: .zero, size: size)
        let colorRect = CGRect(x: 0, y: (1.0 - percentageFromBottom) * size.height, width: size.width, height: percentageFromBottom * size.height)
        let renderer = UIGraphicsImageRenderer(size: size)
        let tintedImage = renderer.image { context in
            color.set()
            context.fill(colorRect)
            draw(in: imageRect, blendMode: .multiply, alpha: 1)
        }
        return tintedImage
    }
	
	/// Untested
	func blur(rect: CGRect, radius: CGFloat, scale: CGFloat) -> UIImage? {
		if let cgImage = self.cgImage {
			let inputImage = CIImage(cgImage: cgImage)
			let context = CIContext(options: nil)
			let filter = CIFilter(name: "CIGaussianBlur")
			filter?.setValue(inputImage, forKey: kCIInputImageKey)
			filter?.setValue(radius, forKey: kCIInputRadiusKey)
			
			// Rect bounds need to be adjusted for based on Image's Scale and Container's Scale
			// Y Position Needs to be Inverted because of UIKit <-> CoreGraphics Coordinate Systems
			
			let newRect = CGRect(
				x: rect.minX * scale,
				y: ((((CGFloat(cgImage.height) / scale)) - rect.minY - rect.height) * scale),
				width: rect.width * scale,
				height: rect.height * scale
			)
			
			if let outputImage = filter?.outputImage,
				let cgImage = context.createCGImage(outputImage, from: newRect) {
				return UIImage(
					cgImage: cgImage,
					scale: scale,
					orientation: imageOrientation
				)
			}
		}
		return nil
	}
	
	func luma(_ alpha: CGFloat = 0.6) -> UIImage {
        let color = UIColor.white
        let imageRect = CGRect(origin: .zero, size: size)
        let colorRect = imageRect
        let renderer = UIGraphicsImageRenderer(size: size)
        let tintedImage = renderer.image { context in
            color.set()
            context.fill(colorRect)
            draw(in: imageRect, blendMode: .luminosity, alpha: alpha)
        }
        return tintedImage
    }

    func whiteToTransparant() -> UIImage? {
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
		if let data = self.jpegData(compressionQuality: 1.0) {
			if let image = UIImage(data: data) {
				if let rawImageRef: CGImage = image.cgImage {
					let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking)
					UIGraphicsGetCurrentContext()?.translateBy(x: 0.0, y: size.height)
					UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
					UIGraphicsGetCurrentContext()?.draw(maskedImageRef!, in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
					let result = UIGraphicsGetImageFromCurrentImageContext()
					UIGraphicsEndImageContext()
					return result
				}
			}
		}
		return nil
	}

	public func resize(_ newSize: CGSize) -> UIImage? {
		if size.isSameSize(newSize) { return self }
		let scaledRect = getScaledRect(newSize)
		UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
		draw(in: scaledRect)
		let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
		UIGraphicsEndImageContext()
		return image
	}

	private func getScaledRect(_ newSize: CGSize) -> CGRect {
		let ratio   = max(newSize.width / size.width, newSize.height / size.height)
		let width   = size.width * ratio
		let height  = size.height * ratio
		return CGRect(x: 0, y: 0, width: width, height: height)
	}

	static func cacheImage(_ urlString: String, isBase64String: Bool = false) -> UIImage {
		print(urlString)

		if let imageFromCache = QIOCache.sharedInstance.image(urlString) {
			print("🤜 image cache hit 🤛 (\(urlString))")
			return imageFromCache
		} else {
			do {
				print("🤔 image cache miss 🤔 (\(urlString))")
				if let url = URL(string: urlString) {
					var data = try Data(contentsOf: url)
					if isBase64String {
						if let b64 = Data(base64Encoded: data) {
							data = b64
						} else { return UIImage() }
					}
					if let imageToCache = UIImage(data: data) {
						QIOCache.sharedInstance.setImage(imageToCache, urlString)
						return imageToCache
					}
				}
			} catch {
				print("Error while pulling image from URL: \(error)")
			}
			return UIImage()
		}
	}
	
	func asGreyscale() -> UIImage {
		
		// Create image rectangle with current image width/height
		let imageRect: CGRect = CGRect(x: 0, y: 0, width: size.w, height: size.h)
		
		// Grayscale color space
		let colorSpace = CGColorSpaceCreateDeviceGray()
		
		// Create bitmap content with current image size and grayscale colorspace
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
		
		// Draw image into current context, with specified rectangle
		// using previously defined context (with grayscale colorspace)
		let context = CGContext(
			data: nil,
			width: Int(size.w),
			height: Int(size.h),
			bitsPerComponent: 8,
			bytesPerRow: 0,
			space: colorSpace,
			bitmapInfo: bitmapInfo.rawValue)
		context?.draw(cgImage!, in: imageRect)
		let imageRef = context!.makeImage()
		
		// Create a new UIImage object
		let newImage = UIImage(cgImage: imageRef!)
		
		return newImage
	}
	
}


//extension UIImageView {
//
//	func cacheImage(urlString: String) {
//		if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
//			image = imageFromCache
//		} else {
//			guard let url = URL(string: urlString) else { return }
//			do {
//				let data = try Data(contentsOf: url)
//				if let b64Data = Data(base64Encoded: data), let imageToCache = UIImage(data: b64Data) {
//					imageCache.setObject(imageToCache, forKey: urlString as NSString)
//					print(Thread.isMainThread)
//					image = imageToCache
//				}
//			} catch {
//				print(error)
//			}
//			//			URLSession.shared.dataTask(with: url) { data, response, error in
//			//				if let d = data {
//			//					DispatchQueue.main.async {
//			//						if let imageToCache = UIImage(data: d) {
//			//							imageCache.setObject(imageToCache, forKey: urlString as NSString)
//			//							self.image = imageToCache
//			//						}
//			//					}
//			//				}
//			//			}.resume()
//		}
//	}
//
//}
