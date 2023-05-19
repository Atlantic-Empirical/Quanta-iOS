//
//  FIOControlMoneyMap.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 12/14/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOControlMoneyMap: UIView {

	// MARK: - Model
	public var model: FIOCategories? {
		didSet {
			renderModel()
		}
	}
	
	// MARK: - Properties
//	private var navigationController: UINavigationController?
	private var parentViewController: UIViewController?
	private var detailNC: UINavigationController?
	private var detailVC: FIOCategoryDetailViewController?

	// MARK: - IBOutlets
	@IBOutlet weak var lblBigMap: UILabel!
	@IBOutlet weak var lblTranspo: UILabel!
	@IBOutlet weak var lblTravel: UILabel!
	@IBOutlet weak var lblMystery: UILabel!
	@IBOutlet weak var lblCashCancer: UILabel!
	@IBOutlet weak var lblOnTheTown: UILabel!
	@IBOutlet weak var lblAtHome: UILabel!
	@IBOutlet weak var lblFriendsFamily: UILabel!
	@IBOutlet weak var lblHealthFitness: UILabel!
	@IBOutlet weak var lblShopping: UILabel!
	@IBOutlet weak var lblPro: UILabel!
	@IBOutlet weak var lblTaxi: UILabel!
	
	@IBOutlet weak var viewMapContainer: DesignableView!
	@IBOutlet weak var viewTranspo: QIOShadowView!
	@IBOutlet weak var viewTravel: QIOShadowView!
	@IBOutlet weak var viewMystery: QIOShadowView!
	@IBOutlet weak var viewMoneyFire: QIOShadowView!
	@IBOutlet weak var viewOnTheTown: QIOShadowView!
	@IBOutlet weak var viewDomestic: QIOShadowView!
	@IBOutlet weak var viewFamilyAndFriends: QIOShadowView!
	@IBOutlet weak var viewHealthAndFitness: QIOShadowView!
	@IBOutlet weak var viewShopping: QIOShadowView!
	@IBOutlet weak var viewPro: QIOShadowView!

	// MARK: - View Lifecycle
	
	override func awakeFromNib() {
		super.awakeFromNib()
		lblBigMap.blur(1.0)
		lblTaxi.transform = CGAffineTransform(rotationAngle: 9.degreesToRadians)
	}
	
	// MARK: IBActions
	
	@IBAction func openCategory(_ sender: UIView) {
		_ = prepDetailView(sender.tag)
		popDetailView()
	}
	
	// MARK: - Custom 
	
	private func renderModel() {
		guard let m = model else { return }
		lblHealthFitness.text = m.percentageStringFor(.HealthAndFitness)
		lblFriendsFamily.text = m.percentageStringFor(.FriendsAndFamily)
		lblTranspo.text = m.percentageStringFor(.Transpo)
		lblTravel.text = m.percentageStringFor(.Travel)
		lblMystery.text = m.percentageStringFor(.Mystery)
		lblCashCancer.text = m.percentageStringFor(.MoneyFire)
		lblOnTheTown.text = m.percentageStringFor(.OnTheTown)
		lblAtHome.text = m.percentageStringFor(.AtHome)
		lblShopping.text = m.percentageStringFor(.Fixed)
		lblPro.text = m.percentageStringFor(.CareerProfessional)
		
		viewMapContainer.subviews.forEach {
			if $0.tag >= 0 {
				($0 as! QIOShadowView).addSingleActionToView(
					#selector(openCategory(_:)),
					self,
					$0.tag,
					useGestureRecognizer: true
				)
			}
		}
	}
	
}

// MARK: - Popping and Locking

extension FIOControlMoneyMap: UIViewControllerPreviewingDelegate {

	public func setupPeekPop(parentViewController: UIViewController) {
		self.parentViewController = parentViewController
		forceTouchViews.forEach() { parentViewController.registerForPreviewing(with: self, sourceView: $0) }
	}

	// MARK: UIViewControllerPreviewingDelegate

	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		return prepDetailView(previewingContext.sourceView.tag)
	}

	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		popDetailView()
	}

	// MARK - Peek & Pop

	private func prepDetailView(_ tag: Int) -> UIViewController? {
		return nil
//		guard
//			let v = FIOTransactionCategoryId.init(rawValue: tag),
//			let m = model
//		else { return nil }
//		let dvc = FIOCategoryDetailViewController(categoryId: v, withModel: m)
//		self.detailVC = dvc
//		let dnc = UINavigationController(rootViewController: dvc)
//		self.detailNC = dnc
//		dnc.navigationBar.prefersLargeTitles = false
//		return dnc
	}

	private func popDetailView() {
		guard
			let vc = detailVC,
			let nc = detailNC,
			let pvc = parentViewController
		else { return }

		nc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
		nc.view.isOpaque = false
		nc.navigationBar.customize(withGradient: false)
		vc.addDoneButton()
		pvc.present(nc, animated: true, completion: nil)
	}

	private var forceTouchViews: [UIView] {
		return [viewTranspo, viewTravel, viewMystery, viewMoneyFire, viewOnTheTown, viewDomestic, viewFamilyAndFriends, viewHealthAndFitness, viewShopping, viewPro]
	}

}
