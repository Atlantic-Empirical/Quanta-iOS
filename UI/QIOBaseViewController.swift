//
//  QIOBaseViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 7/14/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import UIKit

@objc protocol IQIOBaseVC {
	
	func buildUI()
	@objc func disclosureAction(sender: UIButton)

}

class QIOBaseViewController: UIViewController {

	// MARK: - Consts
	
	static let sectionHeaderBgColor = UIColor("fbfbfb") // UIColor.blue.withAlphaComponent(0.3)
	let minLRMargins: CGFloat = 30
	let minContentWidth: CGFloat = 280
	var computedSideMargin: CGFloat { return min((Env.screenWidth - minContentWidth) / 2, minLRMargins) }
	var contentWidth: CGFloat { return Env.screenWidth - (2 * computedSideMargin) }

	// MARK: - Model
	
	var home: QHome!

	// MARK: - Properties
	
	let scroller = UIScrollView()
	let stackView = UIStackView()
	let spinner = qSpinner(color: .q_brandGold)
	var rendered: Bool = false
	var showSearch: Bool = false
	var customTitle: String?
	
	// MARK: - Search Stuff
	
	let resultsTable = QIOSearchResultsTableViewController()
	var searchController: UISearchController!
	var searchTask: DispatchWorkItem?
	var searchString: String?

	// MARK: - View Lifecycle
	
	convenience init(showSearch: Bool = false, title: String?) {
		self.init()
		self.showSearch = showSearch
		self.customTitle = title
	}
	
	override func loadView() {
		super.loadView()
		
		guard let h = QFlow.userHome else {
			fatalError("User home is nil in QIOHomeViewController.")
		}
		home = h
		
		navigationItem.backBarButtonItem = .nil()
		view.backgroundColor = .white
		
		// Add and setup scroll view
		view.addSubview(scroller)
		scroller.translatesAutoresizingMaskIntoConstraints = false
		
		// Constrain scroll view
		scroller.anchorLeadingTo(view.leadingAnchor)
		scroller.anchorTopTo(view.topAnchor)
		scroller.anchorTrailingTo(view.trailingAnchor)
		scroller.anchorBottomTo(view.bottomAnchor)
		
		// Add and setup stack view
		scroller.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 0
		
		// Constrain stack view to scroll view
		stackView.anchorLeadingTo(scroller.leadingAnchor)
		stackView.anchorTopTo(scroller.topAnchor)
		stackView.anchorTrailingTo(scroller.trailingAnchor)
		stackView.anchorBottomTo(scroller.bottomAnchor)
		
		// Constrain width of stack view to width of self.view, NOT scroll view
		stackView.anchorWidth(w: view.widthAnchor)
		
		// Setup Nav Bar
		navigationController?.setNavigationBarHidden(false, animated: false)
		navigationController?.navigationBar.setupForQuantaHome()
		navigationItem.backBarButtonItem = .nil()
		
		if let t = customTitle  {
			navigationItem.titleView = nil
			title = t
		} else {
			let iv = UIImageView(image: UIImage(named: "QuantaWordmark"))
			iv.contentMode = .scaleAspectFit
			navigationItem.titleView = iv
			title = ""
		}

		// Setup Search
		if showSearch {
//			navigationItem.leftBarButtonItem = UIBarButtonItem(
//				image: UIImage(named:"mag"),
//				style: .plain,
//				target: self,
//				action: #selector(focusSearchBar)
//			)
			searchController = UISearchController(searchResultsController: resultsTable)
			resultsTable.searchController = searchController
			navigationItem.searchController = searchController
			navigationItem.hidesSearchBarWhenScrolling = true
			searchController.searchBar.autocapitalizationType = .none
			searchController.searchResultsUpdater = self
			searchController.obscuresBackgroundDuringPresentation = false
			searchController.searchBar.placeholder = "Search Transactions by Merchant"
			searchController.delegate = self
			searchController.searchBar.delegate = self // Monitor when the search button is tapped.
			searchController.dimsBackgroundDuringPresentation = false // The default is true.
			definesPresentationContext = true
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		startUIBuild()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.setupForQuantaHome()
	}
	
	// MARK: - asdf
	
	func setRightBarButton(
		_ which: QIONavRightSideButtons,
		libraryItem: QIOLibraryInventory? = nil,
		action: Selector? = nil,
		actionObj: AnyObject? = nil
	) {
		switch which {
			
		case .settings:
			let v = UIView(frame: CGRect(square: 34))
			let b = UIButton(
				frame: v.bounds,
				action: #selector(settingsAction),
				actionObj: self,
				img: UIImage(named:"cog")?.withRenderingMode(.alwaysTemplate)
			)
			b.tintColor = .q_brandGold
			b.imageView?.contentMode = .center
			v.addSubview(b)

			let badgeSize: CGFloat = 8
			let dot = UIView(frame: CGRect(o: CGPoint(x: v.w - badgeSize, y: 0), wh: badgeSize))
			dot.cornerRadius = dot.h/2
			dot.backgroundColor = .red
			v.addSubview(dot)
			dot.isHidden = !home.isChurning
			navigationItem.rightBarButtonItem = UIBarButtonItem(customView: v)
			
		case .info:
			let infoButton = UIButton(type: .infoLight)
			infoButton.tag = libraryItem?.rawValue ?? 0
			infoButton.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
			navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)

		case .actionSheet:
			navigationItem.rightBarButtonItem = UIBarButtonItem(
				image: UIImage(named:"cog"),
				style: .plain,
				target: actionObj,
				action: action
			)
		}
	}
		
	@objc func infoButtonTapped(sender: UIButton) {
		guard let item = QIOLibraryInventory(rawValue: sender.tag) else { return }
		navigationController?.pushViewController(FIOGenericTextViewViewController(item), animated: true)
	}
	
	private func startUIBuild() {
		if rendered { return } else { rendered = true }
		spinnerStart()
		buildUI()
	}
	
	func buildUI() {
		fatalError("Must override \(#function)")
	}
	
	/// Must be called by implementing classes
	func buildComplete() {
		spacer(50) // so user can scroll last section off the bottom a little bit
		spinnerStop()
	}
	
	private func spinnerStart() {
		view.addSubview(spinner)
		spinner.anchorCenterToSuperview()
		spinner.startAnimating()
	}
	
	private func spinnerStop() {
		spinner.stopAnimating()
	}

	// MARK: - Actions
	
	@objc func settingsAction() {
		navigationController?.pushViewController(FIOSettingsViewController(), animated: true)
	}

	@objc func focusSearchBar() {
		DispatchQueue.main.async {
			self.searchController.searchBar.becomeFirstResponder()
		}
	}

	@objc func chartTap(sender: UIButton) {
		print(#function)
		guard let which = QIOHomeCharts(rawValue: sender.tag) else { return }
		print(which.asString + " chart")
		navigationController?.present(QIOChartViewController(which), animated: false)
	}

}

// MARK: - UI Generators

extension QIOBaseViewController {
	
	func addModuleNew(
		_ module: UIView?,
		vSpace: CGFloat = 0,
		bgc: UIColor = .white,
		anchorTrailing: Bool = true,
		bottomAnchorConstant: CGFloat = 0,
		anchorSides: Bool = true
	) {
		guard let module = module else { return }
		
		let out = UIView(frame: .zero)
		out.backgroundColor = bgc
		out.translatesAutoresizingMaskIntoConstraints = false
		if colorful { out.backgroundColor = .randomP3 }
		stackView.addArrangedSubview(out)
		out.addSubview(module)
		module.anchorTopToSuperview(constant: vSpace)
		out.anchorBottomTo(module.bottomAnchor, constant: bottomAnchorConstant)
		
		// LEFT-RIGHT ANCHORS
		if anchorSides {
			module.anchorLeadingTo(view.safeAreaLayoutGuide.leadingAnchor, constant: computedSideMargin)
			if anchorTrailing {
				module.anchorTrailingTo(view.safeAreaLayoutGuide.trailingAnchor, constant: -computedSideMargin)
			}
		}
	}
	
	func insertModule(
		_ module: UIView?,
		at: Int,
		vSpace: CGFloat = 0,
		bgc: UIColor = .white,
		anchorTrailing: Bool = true
	) {
		guard let module = module else { return }
		
		let out = UIView(frame: .zero)
		out.backgroundColor = bgc
		out.translatesAutoresizingMaskIntoConstraints = false
		if colorful { out.backgroundColor = .randomP3 }
		stackView.insertArrangedSubview(out, at: at)
		out.addSubview(module)
		module.anchorTopToSuperview(constant: vSpace)
		out.anchorBottomTo(module.bottomAnchor)
		
		// LEFT-RIGHT ANCHORS
		let minLRMargins: CGFloat = 20
		let minContentWidth: CGFloat = 280
		let leftConst: CGFloat = min((UIScreen.main.bounds.width - minContentWidth) / 2, minLRMargins)
		module.anchorLeadingTo(view.safeAreaLayoutGuide.leadingAnchor, constant: leftConst)
		if anchorTrailing {
			module.anchorTrailingTo(view.safeAreaLayoutGuide.trailingAnchor, constant: -leftConst)
		}
	}
	
	func genTableContainer(_ table: UITableView, height: CGFloat, vSpace: CGFloat = 20) {
		let out = UIView(frame: .zero)
		out.translatesAutoresizingMaskIntoConstraints = false
		addModuleNew(
			out,
			vSpace: vSpace
		)
		out.anchorHeight(height)

		table.translatesAutoresizingMaskIntoConstraints = false
		out.addSubview(table)
		table.anchorCenterToSuperview()
		table.anchorHeightToSuperview()
		table.anchorWidthToSuperview(constant: 28)
	}
	
	func genGauge(pct: Double, greenToRed: Bool, vSpace: CGFloat = 10, squareSize: CGFloat = 240) {
		let gaugeParent = UIView(frame: .zero)
		if colorful { gaugeParent.backgroundColor = .randomP3 }
		gaugeParent.translatesAutoresizingMaskIntoConstraints = false
		gaugeParent.clipsToBounds = true
		addModuleNew(gaugeParent, vSpace: vSpace)
		gaugeParent.anchorSizeConstant(squareSize, squareSize/2)

		let gp2 = UIView(frame: CGRect(square: squareSize))
		gaugeParent.addSubview(gp2)
		
		let viewGauge: FIOViewGradientGauge = .fromNib()
		viewGauge.size = CGSize(square: squareSize)
		viewGauge.translatesAutoresizingMaskIntoConstraints = true
		gp2.addSubview(viewGauge)
		viewGauge.scaleIndicator()
		if greenToRed {
			viewGauge.setupForCreditCards(min(pct * 100, 100))
		} else {
			viewGauge.setupForRainyDay(min(pct * 100, 100))
		}
	}
	
	func standardSectionHeader(_ title: String, addTickForValue: Double? = nil, isFirst: Bool = false) {
		genSectionHeader(
			title,
			vSpace: isFirst ? -50 : 0,
			titleSize: 40,
			titleColor: .q_38,
			includeSpacer: false,
			bgc: .clear,
			addDividers: false,
			addTickForValue: addTickForValue)
	}
	
	func genSectionHeader(
		_ text: String,
		vSpace: CGFloat = 0,
		action: Selector? = nil,
		tag: Int = 0,
//		overrideHeight: CGFloat = 0,
		titleSize: CGFloat = 26,
		titleColor: UIColor = UIColor("777777"),
		includeSpacer: Bool = true,
		description: String? = nil,
		bgc: UIColor = sectionHeaderBgColor,
		addDividers: Bool = true,
		addTickForValue: Double? = nil
	) {
		let spacerHeight: CGFloat = 40
		let sectionHeaderHeightEmpty: CGFloat = 50

		let out = UIView(frame: .zero)
//		out.backgroundColor = .randomP3
		out.translatesAutoresizingMaskIntoConstraints = false
		addModuleNew(
			out,
			vSpace: vSpace,
			bgc: bgc
		)
		
		var nextYAnchor: NSLayoutYAxisAnchor = out.bottomAnchor
		var isFirst: Bool = true
		var targetHeight = sectionHeaderHeightEmpty
		
		if includeSpacer {
			let v = UIView(frame: .zero)
			v.translatesAutoresizingMaskIntoConstraints = false
			v.backgroundColor = .white
			out.addSubview(v)
			targetHeight += spacerHeight
			v.anchorHeight(spacerHeight)
			v.anchorTopToSuperview()
			v.anchorLeadingToSuperview(constant: -1000)
			v.anchorTrailingToSuperview(constant: 1000)
			if addDividers { addDividerTo(v) }
		}

		if let d = description {
			let descLbl = genLabel(
				d,
				font: baseFont(size: 13, bold: false)
			)
			out.addSubview(descLbl)
			descLbl.anchorLeadingToSuperview()
			descLbl.anchorBottomTo(nextYAnchor, constant: -14)
			targetHeight += descLbl.h
			nextYAnchor = descLbl.topAnchor
			isFirst = false
		}

		let lbl = genLabel(
			text,
			font: baseFont(size: titleSize),
			textColor: titleColor
		)
		out.addSubview(lbl)
		targetHeight += lbl.h
		lbl.anchorBottomTo(nextYAnchor, constant: isFirst ? -14 : 0)
		lbl.anchorLeadingToSuperview()

		if let v = addTickForValue, v != 0 {
			let up = v > 0
			let tickIV = genImage("Circle-Arrow-" + (up ? "Up" : "Down"))
			out.addSubview(tickIV)
			tickIV.anchorSizeConstantSquare(34)
			tickIV.anchorCenterYTo(lbl.centerYAnchor, constant: 6)
			tickIV.anchorLeadingTo(lbl.trailingAnchor, constant: 10)
		}
		
		out.anchorHeight(targetHeight)
		if addDividers { addDividerTo(out, color: UIColor("dddddd")) }

		if let action = action  {
			let i = genImage("CaretRightLargeDark", withTint: lbl.textColor)
			out.addSubview(i)
			i.anchorBottomTo(lbl.lastBaselineAnchor)
			i.anchorTrailingTo(out.trailingAnchor)
			i.anchorHeight(titleSize - 8)

			let btn = UIButton(action, tag: tag)
			out.addSubview(btn)
			btn.anchorToSuperview()
		}
	}
	
	func genMajorHeader(
		name: String,
		imageView: UIImageView,
		vSpace: CGFloat = 20,
		subtitle: String? = nil
	) {
		let out = UIView(frame: .zero)
		//		out.backgroundColor = .randomP3
		out.translatesAutoresizingMaskIntoConstraints = false
		
		let imgSize: CGFloat = 60
		imageView.size = CGSize(width: imgSize, height: imgSize)
		out.addSubview(imageView)
		imageView.anchorTopToSuperview(constant: 14)
		imageView.anchorLeadingToSuperview()
		imageView.anchorSizeConstantSquare(imgSize)
		imageView.cornerRadius = imgSize / 2
		imageView.clipsToBounds = true
		
		let lbl = genLabel(
			name,
			font: baseFont(size: 28),
			kerning: 0,
			maxWidth: 290)
		out.addSubview(lbl)
		lbl.anchorTopTo(imageView.bottomAnchor, constant: 5)
		lbl.anchorLeadingToSuperview()
		lbl.anchorSizeToOwnFrame()
		
		var subtitleLbl: UILabel?
		if let subtitle = subtitle {
			let st = genLabel(subtitle, font: baseFont(size: 14, bold: false), maxWidth: contentWidth)
			out.addSubview(st)
			st.anchorTopTo(lbl.bottomAnchor, constant: 5)
			st.anchorLeadingToSuperview()
			st.anchorSizeToOwnFrame()
			subtitleLbl = st
		}
		
		addModuleNew(out, vSpace: vSpace, bgc: QIOBaseViewController.sectionHeaderBgColor)
		out.anchorLeadingTo(scroller.leadingAnchor)

		if let st = subtitleLbl {
			out.anchorBottomTo(st.bottomAnchor, constant: 14)
		} else {
			out.anchorBottomTo(lbl.bottomAnchor, constant: 10)
		}
		
		addDividerTo(out)
	}
	
	func genMajorHeader(
		name: String,
		image: UIImage? = nil,
		vSpace: CGFloat = 20,
		subtitle: String? = nil
	) {
		if let _ = image {
			genMajorHeader(name: name, imageView: genImage(image), vSpace: vSpace, subtitle: subtitle)
		} else {
			genMajorHeader(name: name, imageView: genImage(withIconSearch: name.firstWord()), vSpace: vSpace, subtitle: subtitle)
		}
	}
	
	@discardableResult
	func genSubSectionTitle(_ text: String, vSpace: CGFloat = 20) -> UILabel {
		let out = genLabel(text, font: baseFont(size: 16))
		addModuleNew(out, vSpace: vSpace)
		return out
	}
	
	func genSubSectionDescription(_ text: String, vSpace: CGFloat = 0) {
		addModuleNew(
			genLabel(
				text,
				font: baseFont(size: 13, bold: false)
			),
			vSpace: vSpace
		)
	}
	
	@discardableResult
	func genMajorValue(
		_ text: String = "",
		amount: Double? = nil,
		addDisclosure: Bool = false,
		action: Selector? = nil,
		tag: Int = 0,
		suffix: String? = nil,
		vSpace: CGFloat = 0,
		addTick: Bool = false,
		baseTextSize: CGFloat = 70,
		addToStackView: Bool = true,
		sv: UIView? = nil,
		tickBeforeValue: Bool = false
	) -> UIView {
		let out = UIView(frame: .zero)
		//		out.backgroundColor = .randomP3
		out.translatesAutoresizingMaskIntoConstraints = false
		var nextXAnchor = out.leadingAnchor
		var isFirst = true

		var l: UILabel
		if let amount = amount {
			l = genMoneyLabel(
				amount,
				baseTextSize: baseTextSize
			)
		} else {
			l = genLabel(
				text,
				font: baseFont(size: baseTextSize)
			)
		}
		out.addSubview(l)
		l.anchorTopTo(out.topAnchor)
		l.anchorLeadingTo(nextXAnchor, constant: isFirst ? 0 : 14)
		l.anchorHeight(l.h)
		nextXAnchor = l.trailingAnchor
		isFirst = false
		
		if let suffix = suffix {
			let s = genLabel(
				suffix,
				font: baseFont(size: 18))
			if colorful { s.backgroundColor = .randomP3 }
			out.addSubview(s)
			s.anchorLeadingTo(nextXAnchor, constant: 8)
			s.anchorBaselineTo(l.lastBaselineAnchor)
			nextXAnchor = s.trailingAnchor
		}

		let caret = genImage("CaretRightLargeDark")
		out.addSubview(caret)
		caret.anchorCenterYToSuperview()
		caret.anchorTrailingToSuperview()
		caret.isHidden = !addDisclosure

		if
			addTick == true,
			let amount = amount,
			amount != 0
		{
			let up = amount > 0
			let iv = genImage("Circle-Arrow-" + (up ? "Up" : "Down"))
			out.addSubview(iv)
			iv.anchorSizeConstantSquare(34)
			iv.anchorCenterYToSuperview()
			
			if tickBeforeValue {
				iv.anchorLeadingTo(out.leadingAnchor)
				l.anchorLeadingTo(iv.trailingAnchor, constant: 10)
			} else {
				iv.anchorLeadingTo(l.trailingAnchor, constant: 10)
			}
			
			if addDisclosure {
				iv.anchorTrailingTo(caret.leadingAnchor, constant: -10)
			} else {
				iv.anchorTrailingToSuperview(constant: -0)
			}
			//			nextXAnchor = iv.trailingAnchor
			//			isFirst = false
		}

		if addToStackView {
			addModuleNew(out, vSpace: vSpace)
			out.anchorLeadingTo(scroller.leadingAnchor)
		} else if let sv = sv {
			sv.addSubview(out)
		}
		out.anchorBottomTo(l.bottomAnchor)

		if let action = action {
			let btn = UIButton(action, tag: tag)
			out.addSubview(btn)
			btn.anchorToSuperview()
		}
		
		return out
	}
	
	@discardableResult
	func genMajorAmountValue(
		amount: Double,
		addDisclosure: Bool = false,
		action: Selector? = nil,
		tag: Int = 0,
		suffix: String? = nil,
		vSpace: CGFloat = 0,
		addTick: Bool = false,
		baseTextSize: CGFloat = 70,
		tickBeforeValue: Bool = false,
		substituteStringForZero: String? = nil
	) -> UIView {
		let out = UIView(frame: .zero)
//		out.backgroundColor = .randomP3
		out.translatesAutoresizingMaskIntoConstraints = false
		
		var l: UILabel
		if let sst = substituteStringForZero, amount == 0 {
			l = genLabel(sst)
		} else {
			l = genMoneyLabel(amount, baseTextSize: baseTextSize)
		}
		out.addSubview(l)
		l.anchorTopTo(out.topAnchor)
		l.anchorHeight(l.h)
		
		var suffixView: UIView?
		if let suffix = suffix {
			suffixView = genLabel(
				suffix,
				font: baseFont(size: 18))
			if colorful { suffixView!.backgroundColor = .randomP3 }
			out.addSubview(suffixView!)
			suffixView!.anchorBaselineTo(l.lastBaselineAnchor)
		}
		
		let caret = genImage("CaretRightLargeDark")
		out.addSubview(caret)
		caret.anchorCenterYToSuperview()
		caret.anchorTrailingToSuperview()
		caret.isHidden = !addDisclosure
		
		var tickIV: UIImageView?
		if
			addTick == true,
			amount != 0
		{
			let up = amount > 0
			tickIV = genImage("Circle-Arrow-" + (up ? "Up" : "Down"))
			out.addSubview(tickIV!)
			tickIV!.anchorSizeConstantSquare(34)
			tickIV!.anchorCenterYToSuperview()
		}

		// Layout left to right
		var nextXAnchor = out.leadingAnchor

		if let tiv = tickIV {
			if tickBeforeValue {
				tiv.anchorLeadingTo(nextXAnchor)
				nextXAnchor = tiv.trailingAnchor
				l.anchorLeadingTo(nextXAnchor, constant: 14)
				nextXAnchor = l.trailingAnchor
			} else {
				l.anchorLeadingTo(nextXAnchor, constant: 14)
				nextXAnchor = l.trailingAnchor
				tiv.anchorLeadingTo(nextXAnchor)
				nextXAnchor = tiv.trailingAnchor
			}
		} else {
			l.anchorLeadingTo(nextXAnchor, constant: 0)
			nextXAnchor = l.trailingAnchor
		}

		if let sv = suffixView {
			sv.anchorLeadingTo(nextXAnchor, constant: 8)
			nextXAnchor = sv.trailingAnchor
		}
		
		addModuleNew(out, vSpace: vSpace)
		out.anchorLeadingTo(scroller.leadingAnchor)
		out.anchorBottomTo(l.bottomAnchor)
		
		if let action = action {
			let btn = UIButton(action, tag: tag)
			out.addSubview(btn)
			btn.anchorToSuperview()
		}
		
		return out
	}

	func genImage(_ name: String, withTint: UIColor? = nil) -> UIImageView {
		return genImage(UIImage(named: name), withTint: withTint)
	}
	
	func genImage(_ image: UIImage?, withTint: UIColor? = nil) -> UIImageView {
		let i = UIImageView(frame: .zero)
		i.translatesAutoresizingMaskIntoConstraints = false
		i.image = image
		i.contentMode = .scaleAspectFit
		if let tint = withTint {
			i.image = i.image?.withRenderingMode(.alwaysTemplate)
			i.tintColor = tint
		}
		return i
	}
	
	func genImage(withIconSearch: String) -> UIImageView {
		let iv = UIImageView(frame: .zero)
		QIOMiscAPIs.s.logoUrlForString(withIconSearch) { firstUrlStr in
			if let u = firstUrlStr {
				iv.setImageFromUrlWithCache(u) { imageLoaded in
					if !imageLoaded {
						iv.image = #imageLiteral(resourceName: "cash-payment-bag-1")
						iv.alpha = 0.6
					}
				}
			}
		}
		iv.translatesAutoresizingMaskIntoConstraints = false
		iv.contentMode = .scaleAspectFit
		return iv
	}
		
	func genSubvalueDisclosure(
		_ text: String,
		vSpace: CGFloat = -5,
		action: Selector? = nil,
		tag: Int = 0,
		font: UIFont = baseFont(size: 16)
	) {
		let out = UIView(frame: .zero)
		out.translatesAutoresizingMaskIntoConstraints = false
		
		let l = genLabel(
			text,
			font: font,
			textColor: .q_97
		)
		out.addSubview(l)
		l.anchorTopTo(out.topAnchor)
		l.anchorSidesToSuperview()
		
		addModuleNew(out, vSpace: vSpace)
		out.anchorBottomTo(l.bottomAnchor)
		out.anchorLeadingTo(scroller.leadingAnchor)
		
		if let action = action {
			let i = genImage("CaretRightSmallLight", withTint: l.textColor)
			out.addSubview(i)
			i.anchorCenterYTo(l, constant: 1)
			i.anchorLeadingTo(l.trailingAnchor, constant: 10)

			let btn = UIButton(action, tag: tag)
			out.addSubview(btn)
			btn.anchorToSuperview()
		}
	}
	
	func genTag(_ text: String) {
		let out = UIView(frame: .zero)
		out.translatesAutoresizingMaskIntoConstraints = false
		
		let i = genImage("up-arrow-circle")
		out.addSubview(i)
		i.anchorTopTo(out.topAnchor)
		i.anchorLeadingTo(out.leadingAnchor)
		
		let l = genLabel(
			text,
			font: baseFont(size: 16),
			textColor: UIColor("4ADD73")
		)
		out.addSubview(l)
		l.anchorCenterYTo(i)
		l.anchorLeadingTo(i.trailingAnchor, constant: 7)
		
		addModuleNew(out, vSpace: 8)
		out.anchorBottomTo(l.bottomAnchor)
		out.anchorLeadingTo(scroller.leadingAnchor)
	}
	
	func spacer(_ h: CGFloat) {
		let v = UIView(frame: .zero)
		v.translatesAutoresizingMaskIntoConstraints = false
		addModuleNew(v, vSpace: h)
	}
	
	func PLACEHOLDER(_ h: CGFloat, vSpace: CGFloat = 20) {
		let v = UIView(frame: .zero)
		v.translatesAutoresizingMaskIntoConstraints = false
		v.backgroundColor = .randomP3
		addModuleNew(v, vSpace: vSpace)
		v.anchorHeight(h)
	}
	
	func genRecurringSpendBar(
		spendItem: QSpending_QuantizedItem,
		action: Selector,
		tag: Int,
		vSpace: CGFloat = 6
	) {
		let barAnchorHeight: CGFloat = 34
//		print(spendItem.nameFriendly)
		var o: (name: String, amount: Double, isRecurring: Bool)
		o.name = spendItem.nameFriendly.prefixToLength(20).capitalized
		o.amount = spendItem.pastThreeMonths/3
		o.isRecurring = spendItem.isRecurring

//		if
//			spendItem.isRecurring,
//			let rs = spendItem.recurringStream
//		{
//			o.name = spendItem.nameFriendly.prefixToLength(20).capitalized
//			o.amount = rs.amountDistribution.monthlyEstimate
//			o.isRecurring = true
//		} else {
//			o.name = spendItem.nameFriendly.prefixToLength(20).capitalized
//			o.amount = spendItem.pastThreeMonths/3
//			o.isRecurring = false
//		}
		
		let bar = UIView(frame: .zero)
		bar.translatesAutoresizingMaskIntoConstraints = false
		addModuleNew(bar, vSpace: vSpace)
		bar.anchorHeight(barAnchorHeight)
		
		let iconSize: CGFloat = barAnchorHeight * 0.85
		let iconContainer = UIView(frame: .zero)
		iconContainer.translatesAutoresizingMaskIntoConstraints = false
		iconContainer.cornerRadius = 0.5 * iconSize
		iconContainer.clipsToBounds = true
		bar.addSubview(iconContainer)
		iconContainer.anchorSizeConstant(iconSize, iconSize)
		iconContainer.anchorLeadingTo(bar.leadingAnchor)
		iconContainer.anchorCenterYToSuperview()
		
		let iv = UIImageView(frame: .zero)
		iv.translatesAutoresizingMaskIntoConstraints = false
		iv.contentMode = .scaleAspectFill
		iconContainer.addSubview(iv)
		iv.anchorSizeToSuperview()
		
		QIOMiscAPIs.s.logoUrlForString(o.name.firstWord()) { firstUrlStr in
			if let u = firstUrlStr {
				iv.setImageFromUrlWithCache(u) { imageLoaded in
					if !imageLoaded {
						iv.image = #imageLiteral(resourceName: "cash-payment-bag-1")
						iv.alpha = 0.6
					}
//					mergedSpending[tag].image = iv.image
				}
			}
		}
		
		let i = genImage("CaretRightSmallLight", withTint: .q_brandGoldLight)
		bar.addSubview(i)
		i.anchorTrailingTo(bar.trailingAnchor)
		i.anchorCenterYToSuperview()
		i.anchorHeight(0.33 * barAnchorHeight)
		
		let bg = UIView(frame: .zero)
		bg.translatesAutoresizingMaskIntoConstraints = false
		bg.backgroundColor = UIColor("FFF5E3")
		bg.cornerRadius = 5
		bg.clipsToBounds = true
		bar.addSubview(bg)
		let spacing: CGFloat = 0.4 * barAnchorHeight
		bg.anchorLeadingTo(iconContainer.trailingAnchor, constant: spacing)
		bg.anchorTrailingTo(i.leadingAnchor, constant: -spacing)
		bg.anchorHeight(h: bar.heightAnchor)
		
		//		// Add bubbles to bg to give it some texture
		//		let fg = UIView(frame: .zero)
		//		fg.translatesAutoresizingMaskIntoConstraints = false
		//		fg.cornerRadius = 5
		//		bg.addSubview(fg)
		//		fg.anchorToSuperview()
		//		let starterRect = CGRect(o: .zero, w: view.w, h: barAnchorHeight)
		//		for _ in 0...9 {
		//			let bubble = UIView(frame: starterRect.randomRectInside)
		//			print(bubble.frame)
		//			bubble.backgroundColor = .q_brandGold
		//			bubble.cornerRadius = bubble.w/2
		//			fg.addSubview(bubble)
		//		}
		
		// Blur
		let blurEffect = UIBlurEffect(style: .light)
		let blurView = UIVisualEffectView(effect: blurEffect)
		blurView.translatesAutoresizingMaskIntoConstraints = false
		blurView.contentView.translatesAutoresizingMaskIntoConstraints = false
		bar.addSubview(blurView)
		blurView.anchorLeadingTo(bg.leadingAnchor)
		blurView.anchorTrailingTo(bg.trailingAnchor)
		blurView.anchorHeight(h: bg.heightAnchor)
		blurView.anchorCenterYToSuperview()
		blurView.contentView.anchorLeadingTo(blurView.leadingAnchor)
		blurView.contentView.anchorTrailingTo(blurView.trailingAnchor)
		blurView.contentView.anchorHeight(h: blurView.heightAnchor)
		blurView.contentView.anchorCenterYToSuperview()
		blurView.backgroundColor = UIColor.white.withAlphaComponent(0.01)
		blurView.clipsToBounds = true
		blurView.layer.cornerRadius = 5.0
		
		let nm = genLabel(
			o.name.prefixToLength(20),
			font: baseFont(size: 13),
			textColor: UIColor.black.withAlphaComponent(0.7)
		)
		blurView.contentView.addSubview(nm)
		nm.anchorLeadingTo(blurView.contentView.leadingAnchor, constant: 10)
		nm.anchorHeight(h: blurView.contentView.heightAnchor)
		nm.anchorCenterYToSuperview()
		
		if o.isRecurring {
			let l = genLabel("Recurring", font: baseFont(size: 13, bold: false), textColor: .q_8C)
			bg.addSubview(l)
			l.anchorTopTo(nm.bottomAnchor, constant: 0)
			l.anchorLeadingTo(nm.leadingAnchor)
			bar.anchorHeight(barAnchorHeight + 15)
			bg.anchorHeight(barAnchorHeight + 15)
		}
		
		let amount = genLabel(
			o.amount.toCurrencyString() + "/mo",
			font: baseFont(size: 13),
			textColor: UIColor("686868").withAlphaComponent(0.7),
			alignment: .right
		)
		amount.translatesAutoresizingMaskIntoConstraints = false
		blurView.contentView.addSubview(amount)
		amount.anchorTrailingTo(bg.trailingAnchor, constant: -10)
		amount.anchorHeight(h: bg.heightAnchor)
		amount.anchorCenterYToSuperview()
		
		let btn = UIButton(action, tag: tag)
		bar.addSubview(btn)
		btn.anchorToSuperview()
	}
	
	/// For use when applying attributedText
	func genLabel() -> UILabel {
		return genLabel("", font: baseFont())
	}
	
	func genLabel(
		_ text: String,
		font: UIFont = baseFont(size: 16, bold: false),
		textColor: UIColor = .q_38,
		alignment: NSTextAlignment = .left,
		kerning: CGFloat = 0,
		maxWidth: CGFloat = 0
	) -> UILabel {
		let lbl = UILabel(frame: .zero) // Size is set below, origin must be set later
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.text = text
		lbl.kerning = kerning
		lbl.font = font
		lbl.textColor = textColor
		lbl.textAlignment = alignment
		lbl.numberOfLines = 0
		lbl.lineBreakMode = .byWordWrapping
		if maxWidth > 0 {
			lbl.size = lbl.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
		} else {
			lbl.sizeToFit()
		}
		return lbl
	}
	
	func genTextView(
		_ text: String,
		font: UIFont = baseFont(size: 16, bold: false),
		textColor: UIColor = .q_38,
		alignment: NSTextAlignment = .left,
		maxWidth: CGFloat = 0
	) -> UITextView {
		let tv = UITextView(frame: .zero)
		tv.translatesAutoresizingMaskIntoConstraints = false
		tv.text = text
		tv.font = font
		tv.textColor = textColor
		tv.textAlignment = alignment
		if maxWidth > 0 {
			tv.size = tv.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
		} else {
			tv.sizeToFit()
		}
		tv.linkTextAttributes = [NSAttributedString.Key.link: UIColor.green]
		tv.isEditable = false
		tv.dataDetectorTypes = .all
		tv.isSelectable = true
		tv.isScrollEnabled = false
		return tv
	}
	
	func genMoneyLabel(
		_ amount: Double,
		baseTextSize: CGFloat,
		textColor: UIColor = .q_38,
		alignment: NSTextAlignment = .left,
		maxWidth: CGFloat = 0,
		bold: Bool = true,
		lightFont: Bool = false
	) -> UILabel {
		let lbl = UILabel(frame: .zero)
		//		lbl.backgroundColor = .randomP3
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.textColor = textColor
		lbl.textAlignment = alignment
		lbl.attributedText = amount.asAttributedCurrencyString(fontSize: baseTextSize, bold: bold, light: lightFont)
		lbl.numberOfLines = 1
		lbl.adjustsFontSizeToFitWidth = true
		lbl.minimumScaleFactor = 0.1
		lbl.lineBreakMode = .byTruncatingTail
		if maxWidth > 0 {
			lbl.size = lbl.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
		} else {
			lbl.sizeToFit()
		}
		return lbl
	}
	
	func addDividerTo(_ v: UIView, bottom: Bool = true, color: UIColor = UIColor("cccccc")) {
		let l1 = UIView(frame: .zero)
		l1.translatesAutoresizingMaskIntoConstraints = false
		l1.backgroundColor = color
		v.addSubview(l1)
		l1.anchorHeight(0.5)
		if bottom {
			l1.anchorBottomToSuperview(constant: -0.5)
		} else {
			l1.anchorTopToSuperview()
		}
		l1.anchorLeadingToSuperview(constant: -1000)
		l1.anchorTrailingToSuperview(constant: 1000)
	}
	
	func genChart(values: [Double]?, vSpace: CGFloat = 10, tag: Int, which: QIOHomeCharts, tappable: Bool = true) {
		let out = QIOChartContainer(frame: .zero)
		out.translatesAutoresizingMaskIntoConstraints = false
		out.backgroundColor = UIColor.q_brandGoldLight.withAlphaComponent(0.2)
		out.cornerRadius = 10
		out.clipsToBounds = true
		addModuleNew(out, vSpace: vSpace)
		out.anchorHeight(100)
		out.size = CGSize(width: 200, height: 100) // This is needed to get the chart to layout initially
		
		if
			let values = values,
			let chartView = buildLineAreaChart(
				values,
				which: which
			)
		{
			//		chartView.backgroundColor = .randomP3
			chartView.frame = out.bounds
			out.addSubview(chartView)
			chartView.animate(xAxisDuration: 1, yAxisDuration: 1)
		}
		
		if tappable {
			let btn = UIButton(#selector(chartTap(sender:)), tag: tag)
			out.addSubview(btn)
			btn.anchorToSuperview()
		}
	}
	
}

// MARK: - UISearchResultsUpdating Delegate

extension QIOBaseViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		if
			let searchString = searchController.searchBar.text,
			searchString != ""
		{
			self.resultsTable.startSpinner()
			self.resultsTable.searchResults = nil
			
			// Cancel previous task if any
			self.searchTask?.cancel()
			
			// Replace previous task with a new one
			let task = DispatchWorkItem { [weak self] in
				if let s = self {
					s.filterContentForSearchText(searchController.searchBar.text!)
				}
			}
			self.searchTask = task
			
			// Execute task in 0.5 seconds (if not cancelled !)
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
		}
	}
	
	// Custom
	
	private var isSearching: Bool {
		return searchController.isActive && !searchBarIsEmpty
	}
	
	/// Returns true if the text is empty or nil
	private var searchBarIsEmpty: Bool {
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	private func filterContentForSearchText(_ searchText: String) {
		guard searchText != "" else { return }
		searchString = searchText
		FIOAppSync.sharedInstance.searchTransactions(query: searchText.lowercased()) { results in
			self.resultsTable.searchResults = results
			self.resultsTable.stopSpinner()
		}
	}
	
}

// MARK: - UISearchBarDelegate

extension QIOBaseViewController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
}

// MARK: - UISearchControllerDelegate

extension QIOBaseViewController: UISearchControllerDelegate {
	
	func presentSearchController(_ searchController: UISearchController) {
		//		debugPrint("UISearchControllerDelegate invoked method: \(#function).")
	}
	
	func willPresentSearchController(_ searchController: UISearchController) {
		//		debugPrint("UISearchControllerDelegate invoked method: \(#function).")
		searchStartOverlay()
	}
	
	func didPresentSearchController(_ searchController: UISearchController) {
		//		debugPrint("UISearchControllerDelegate invoked method: \(#function).")
	}
	
	func willDismissSearchController(_ searchController: UISearchController) {
		//		debugPrint("UISearchControllerDelegate invoked method: \(#function).")
		removeSearchOverlay()
	}
	
	func didDismissSearchController(_ searchController: UISearchController) {
		//		debugPrint("UISearchControllerDelegate invoked method: \(#function).")
	}
	
	// MARK: - Custom
	
	func searchStartOverlay() {
		let out = UIView(frame: .zero)
		out.translatesAutoresizingMaskIntoConstraints = false
		out.backgroundColor = .white
		out.alpha = 0
		out.tag = 89764583674
		view.addSubview(out)
		out.anchorToSuperview()
		UIView.animate(withDuration: 0.3) {
			out.alpha = 1.0
		}
	}
	
	func removeSearchOverlay() {
		view.subviews.forEach { v in
			if v.tag == 89764583674 {
				UIView.animate(
					withDuration: 0.3,
					animations: {
						v.alpha = 0
				},
					completion: { completed in
						v.removeFromSuperview()
						return
				}
				)
			}
		}
	}
	
}

enum QIONavRightSideButtons {
	
	case settings
	case info
	case actionSheet
	
}
