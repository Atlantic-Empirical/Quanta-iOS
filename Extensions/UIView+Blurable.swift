//
//  UIView+Blurable.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/10/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

extension UIView
{
	/// IMPORTANT: note that the returned view has alpha set to 0 so you can animate it in
	func insertBlur(style: UIBlurEffect.Style, belowView: UIView) -> UIVisualEffectView? {
		guard let s = snapshotView(afterScreenUpdates: false) else { return nil }
		let blurEffect = UIBlurEffect(style: style)
		let bev = UIVisualEffectView(effect: blurEffect)
		bev.frame = s.bounds
		bev.alpha = 0
		insertSubview(bev, belowSubview: belowView)
		let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
		let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
		vibrancyEffectView.frame = s.bounds
		bev.contentView.addSubview(vibrancyEffectView)
		return bev
	}
	
	func applyDynamicBlur() {
		let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
		blurEffectView.frame = bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(blurEffectView)
	}
	
    func blur(_ blurRadius: CGFloat) {
        
//        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 1)
//
//        self.layer.render(in: UIGraphicsGetCurrentContext()!)
//
//        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//
//        UIGraphicsEndImageContext();
//
////        let ci: CIImage? = CIImage(image: image!)
////        let ci2: CIImage? = ci?.applyingGaussianBlur(sigma: 20.0)
////        let filteredImage: UIImage = UIImage(ciImage: ci2!)
////        let filteredImage = image!
//
//        let context  = CIContext(options: [kCIContextWorkingColorSpace : NSNull()])
//
//        let baseImg = CIImage(image: image!)!
//        let blurImg = baseImg.clampedToExtent().applyingGaussianBlur(sigma: 20.0).cropped(to: baseImg.extent)
//        guard let cgImg = context.createCGImage(blurImg, from: baseImg.extent) else { return }
//        layer.contents = cgImg
        
        if self.superview == nil { return }

        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 1)
        
        self.layer.render(in: UIGraphicsGetCurrentContext()!)

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();

        let boundingBox = self.bounds
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let blur: CIFilter = CIFilter(name: "CIGaussianBlur") else
            {
                return
            }
            
            blur.setValue(CIImage(image: image!), forKey: kCIInputImageKey)
            blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
            
			let ciContext = CIContext(options: [CIContextOption.workingColorSpace : NSNull()])
            
            let result: CIImage? = blur.value(forKey: kCIOutputImageKey) as! CIImage?
            let cgImageX: CGImage? = ciContext.createCGImage(result!, from: boundingBox) // This is the slow line
            let filteredImage: UIImage = UIImage(cgImage: cgImageX!)
            
            DispatchQueue.main.async {

                let blurOverlay: UIImageView = UIImageView()
                blurOverlay.frame = self.bounds
                blurOverlay.image = filteredImage
				blurOverlay.contentMode = UIView.ContentMode.left

                UIView.transition(from: self,
                                  to: blurOverlay,
                                  duration: 0.2,
								  options: UIView.AnimationOptions.curveEaseIn,
                                  completion: nil)

            }
        }
    
        
//        if let superview = superview as? UIStackView, let index = (superview as UIStackView).arrangedSubviews.index(of: self)
//        {
//            self.removeFromSuperview()
//            superview.insertArrangedSubview(blurOverlay, at: index)
//
//        } else {
//
//            blurOverlay.frame.origin = self.frame.origin
//
//            UIView.transition(from: self,
//                              to: blurOverlay,
//                              duration: 0.2,
//                              options: UIViewAnimationOptions.curveEaseIn,
//                              completion: nil)
//        }

//        objc_setAssociatedObject(self,
//                                 &BlurableKey.blurable,
//                                 blurOverlay,
//                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func unBlur() {
        guard let blurOverlay = objc_getAssociatedObject(self, &BlurableKey.blurable) as? UIImageView else
        {
            return
        }
        
		if let superview = blurOverlay.superview as? UIStackView, let index = (blurOverlay.superview as! UIStackView).arrangedSubviews.firstIndex(of: blurOverlay)
        {
            
            blurOverlay.removeFromSuperview()
            superview.insertArrangedSubview(self, at: index)
            
        } else {
            
            self.frame.origin = blurOverlay.frame.origin
            
            UIView.transition(from: blurOverlay,
                              to: self,
                              duration: 0.2,
							  options: UIView.AnimationOptions.curveEaseIn,
                              completion: nil)
        }
        
        objc_setAssociatedObject(self,
                                 &BlurableKey.blurable,
                                 nil,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    var isBlurred: Bool {
        return objc_getAssociatedObject(self, &BlurableKey.blurable) is UIImageView
    }
    
}

struct BlurableKey {
    static var blurable = "blurable"
}

//    func addBlurEffect()
//    {
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.bounds
//
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
//        self.addSubview(blurEffectView)
//    }
//
//    func removeBlurEffect() {
//        let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
//        blurredEffectViews.forEach{ blurView in
//            blurView.removeFromSuperview()
//        }
//    }


