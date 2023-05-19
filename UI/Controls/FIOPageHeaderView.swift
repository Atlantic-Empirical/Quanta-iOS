//
//  FIOPageHeaderView.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/20/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOPageHeaderView: UIView {

    // MARK: - Properties
	
	private var defaultKerning: CGFloat = 3
    
    // MARK: - IBOutlets
	
    @IBOutlet weak var lblEmoji: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
	@IBOutlet weak var imgLogo: UIImageView!
	
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
		lblTitle.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
		if colorful { backgroundColor = .randomP3 }
    }
	
	public func setup(
		_ title: String,
		subtitle: String? = nil,
		emoji: String? = nil,
		image: UIImage? = nil
	) {
		if let s = subtitle {
			lblSubtitle.text = s
			lblSubtitle.kerning = 2.0 // This approach is needed because .kerning actually sets the text value to an attribtuted string
			lblSubtitle.numberOfLines = 0
			lblSubtitle.lineBreakMode = .byWordWrapping
			lblSubtitle.size = lblSubtitle.sizeThatFits(
				CGSize(
					width: 300,
					height: CGFloat.greatestFiniteMagnitude))
			lblSubtitle.center.x = center.x
		}
		else { lblSubtitle.removeFromSuperview() }

		lblEmoji.isHidden = true
		imgLogo.isHidden = true
		if let e = emoji {
			lblEmoji.text = e
			lblEmoji.isHidden = false
		} else if let i = image {
			imgLogo.image = i
			imgLogo.isHidden = false
		}
		
		if colorful { backgroundColor = .randomP3 }
		lblTitle.text = title
		setHeight()
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard let object = object else { return }
		if keyPath == "text" && ((object as! UILabel) == self.lblTitle) {
			// This approach is needed because .kerning actually sets the text value to an attribtuted string
			// It is not a native value to the label.
//			print("old:", change?[.oldKey] as Any)
//			print("new:", change?[.newKey] as Any)
			lblTitle.kerning = defaultKerning
			lblTitle.lineBreakMode = .byWordWrapping
			lblTitle.textAlignment = .center
			lblTitle.numberOfLines = 0
//			lblTitle.backgroundColor = UIColor.magenta.withAlphaComponent(0.3)
			let s = lblTitle.sizeThatFits(CGSize(width: 320, height: CGFloat.greatestFiniteMagnitude))
			lblTitle.frame = CGRect(origin: lblTitle.frame.origin, size: s)
			lblTitle.center.x = lblTitle.superview!.w/2
			lblSubtitle.y = lblTitle.y_bottom + 10.0
//			print("will magicsize \(lblTitle.text)")
			self.setHeight()
		}
	}
	
}
