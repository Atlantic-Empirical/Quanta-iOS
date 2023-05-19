//
//  QIOLinkLogoCollection.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 4/22/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOLinkLogoCollection:
	UICollectionView,
	UICollectionViewDelegate,
	UICollectionViewDataSource
{
	// MARK: - Constants
	
	static let height: CGFloat = 44.0
	static let interitemSpacing: CGFloat = 14.0
	
	// MARK: - Properties
	
	private var items = [QItem]()
	private var onDidSelect: (obj: AnyObject, selector: Selector)?
	private let reuseIdentifier = "linkCell"
	private var includeAddButton: Bool = true
	var q_contentWidth: CGFloat {
		return (QIOLinkLogoCollection.height + QIOLinkLogoCollection.interitemSpacing) * items.count.asCGFloat
	}
	
	// MARK: - Lifecycle
	
	/// When using constraints
	convenience init(
		_ items: [QItem],
		onDidSelect: (AnyObject, Selector)? = nil,
		includeAddButton: Bool = true
	) {
		self.init(
			frame: .zero,
			items: items,
			onDidSelect: onDidSelect,
			includeAddButton: includeAddButton)
		translatesAutoresizingMaskIntoConstraints = false
	}

	convenience init(
		frame: CGRect,
		items: [QItem],
		onDidSelect: (AnyObject, Selector)? = nil,
		includeAddButton: Bool = true
	) {
		self.init(
			frame: frame,
			collectionViewLayout: QIOLinkLogoCollection.layout
		)
		self.includeAddButton = includeAddButton
		self.items = items
		self.onDidSelect = onDidSelect
		delegate = self
		dataSource = self
		backgroundColor = .clear
		clipsToBounds = false
		register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
	}

	// MARK: - Custom
	
	private func pushVC(_ vc: UIViewController) {
		guard let nc = AppDelegate.sharedInstance.navigationController else { return }
		nc.navigationBar.customize(withGradient: false)
		nc.setNavigationBarHidden(false, animated: false)
		nc.pushViewController(vc, animated: true)
	}
	
	private func isAddLinkBtn(_ row: Int) -> Bool {
		return row == items.count
	}
	
	// MARK: - Delegate
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let itms = items.count + (includeAddButton ? 1 : 0)
		
		// Logic for centering content when the items take up less than one full screen width
		let effectiveContentWidth = itms.asCGFloat * widthPerItem
		let excessSpace = w - effectiveContentWidth
		let lrInset: CGFloat = excessSpace > 3 ? excessSpace/2 : 0
		contentInset = UIEdgeInsets(top: 0, left: lrInset, bottom: 0, right: lrInset)

		return itms
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
		cell.contentView.removeAllSubviews()
		if isAddLinkBtn(indexPath.row) {
			let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 30.0, height: 30.0))
			iv.center = cell.contentView.center
			iv.image = UIImage(named: "AddCircle30")
			cell.contentView.addSubview(iv)
		} else {
			let iv = UIImageView(frame: cell.bounds)
			let itm = items[indexPath.row]
			itm.logoImage() { img in
				iv.image = img
			}
			cell.contentView.addSubview(iv)
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: false)
		if let so = onDidSelect {
			// Closes the tray
			so.obj.performSelector(onMainThread: so.selector, with: self, waitUntilDone: false)
		}
		if isAddLinkBtn(indexPath.row) {
			AppDelegate.sharedInstance.navigationController?.plaidLink()
		} else {
			pushVC(QIOLinkDetailViewController(items[indexPath.row]))
		}
	}
	
	// MARK: - Computed Vars
	
	static var layout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: height, height: height)
		layout.minimumInteritemSpacing = interitemSpacing
		layout.minimumLineSpacing = interitemSpacing
		return layout
	}()
	
	lazy var widthPerItem: CGFloat = {
		return QIOLinkLogoCollection.layout.itemSize.w + QIOLinkLogoCollection.interitemSpacing
	}()
	
}

//		let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
//		longPressGR.minimumPressDuration = 0.75
//		longPressGR.delaysTouchesBegan = true
//		cvBanks.addGestureRecognizer(longPressGR)
