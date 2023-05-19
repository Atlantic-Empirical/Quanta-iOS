//
//  FIOPeriodItemView.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/23/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOPeriodSliderViewItem: QIOShadowView {
	
	// MARK: - Consts
	private let kTitleBorderWidth: CGFloat = 0.0
	private let kBorderWidth: CGFloat = 0.0
	static let designWidth: CGFloat = 240.0
	static let designHeight: CGFloat = 88.0
	static var designSize: CGSize = CGSize(
		width: FIOPeriodSliderViewItem.designWidth,
		height: FIOPeriodSliderViewItem.designHeight
	)

    // MARK: - Properties
	private var model: QPeriod?
	var parent: FIOPeriodSliderView?
	var modelIndex: Int = -1 // store this incase we have to use rerenderModelsInViews()

    // MARK: - IBOutlets
	@IBOutlet weak var viewBody: UIView!
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblAmount: UILabel!
	@IBOutlet weak var viewProjectionLabel: UIView!
	@IBOutlet weak var btnMain: UIButton!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	@IBOutlet weak var lblDebugInfo: UILabel!
	@IBOutlet weak var viewBoxBehindTitle: UIView!
	@IBOutlet weak var viewContainer: UIView!
	@IBOutlet weak var imgTickTri: UIImageView!
	
	// MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
		viewBody.backgroundColor = UIColor.q_brandGoldLight.withAlphaComponent(0.7)
		viewBoxBehindTitle.backgroundColor = UIColor.q_brandGoldLight
		isWaitingForModel = true
    }
	
	// MARK: - Actions
	
	@IBAction func buttonAction(_ sender: Any) {
		guard let vm = model else { return }
		self.blinkShadow() {
			self.parent?.navigationController?.setNavBarVisible()
			self.parent?.navigationController?.pushViewController(FIOPeriodDetailViewController(vm), animated: true)
		}
	}
	
	// MARK: - Custom
	
	public func renderModel(_ newModel: QPeriod, index: Int) {
//		print(newModel.description)
		lblDebugInfo.text = index.asString

		viewBody.borderWidth = kBorderWidth
		
		isWaitingForModel = false
		modelIndex = index
		model = newModel
		isFinalCell = newModel.includesEndOfData

		viewContainer.isHidden = false
		if let projection = newModel.projection, let projectedNet = projection.net {
			viewProjectionLabel.isHidden = false
			lblAmount.text = projectedNet.toCurrencyString()
			setPosNeg(projectedNet)
		} else {
			viewProjectionLabel.isHidden = true
			lblAmount.text = newModel.periodSummary.netAmount.toCurrencyString()
			setPosNeg(newModel.periodSummary.netAmount)
		}
		
		// Title
		let t = newModel.titles()
		lblTitle.text = t.mainTitle.uppercased()
		lblTitle.kerning = 2.0
		
		lblTitle.sizeToFit()
		lblTitle.center.x = viewBody.center.x
		lblTitle.center.y = viewBody.frame.origin.y
		
		let textRect: CGRect = lblTitle.textRect(forBounds: lblTitle.bounds, limitedToNumberOfLines: 1)
		viewBoxBehindTitle.frame.size = CGSize(width: lblTitle.frame.width + 20, height: textRect.h + 4)
		viewBoxBehindTitle.center.x = viewBody.center.x
		viewBoxBehindTitle.center.y = lblTitle.center.y
		viewBoxBehindTitle.borderWidth = kTitleBorderWidth
		viewBoxBehindTitle.cornerRadius = 3.0
	}

	private func setPosNeg(_ val: Double) {
		viewBody.borderColor = .black
		viewBoxBehindTitle.borderColor = .q_53
		imgTickTri.isHidden = val == 0
		if !imgTickTri.isHidden {
			imgTickTri.frame = CGRect(x: lblAmount.textRectSimple.x - 13.0, y: 0, width: 16, height: 15)
			imgTickTri.center.y = lblAmount.center.y + 1
			imgTickTri.image = UIImage(named: "tickTriangle_" + (val > 0 ? "up" : "down"))
		}
	}
	
//	 MARK: - Computed Properties

	public var isFinalCell: Bool = false {
		didSet {
			//            if newValue {
			//                viewLoading.isHidden = false
			//                lblLoading.text = "that's all folks!"
			//                viewLoading.backgroundColor = .red
			//                loadingSpinner.isHidden = true
			//            } else {
			////                viewLoading.isHidden = true // probably not needed
			//                lblLoading.text = "gathering more info"
			//                viewLoading.backgroundColor = .white
			//                loadingSpinner.isHidden = false
			//            }
			//            lblLoading.kerning = 3.0
		}
	}

	public var isWaitingForModel: Bool = false {
		didSet {
			viewBody.isHidden = isWaitingForModel
			if isWaitingForModel {
				spinner.startAnimating()
			} else {
				spinner.stopAnimating()
			}
		}
	}

}
