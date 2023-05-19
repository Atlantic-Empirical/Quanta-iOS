//
//  FIOPeriodSliderView.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 1/11/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class FIOPeriodSliderView: UIView {

	// MARK: - Properties
	
	var windowSize: FIOWindowSize = .day
	var navigationController: UINavigationController?
	private var modelIsRendered: Bool = false
	private var viewIsLoaded: Bool = false
	private var visiblePeriodIndex: Int = 0
	private var renderedVisiblePeriodIndex: Int = -1
	private var currentScrollDestinationX: CGFloat = 0
	private var periodViews: [FIOPeriodSliderViewItem]?
	private var touchGR: FIOTouchGestureRecognizer?
	private var windowPullInProgress: Bool = false

	// MARK: - Fast Scroll Properties
	
	private let fastScrollStepSize: CGFloat = 800.0
	private var timerIsRunning: Bool = false
	private var fastScrollDirection: UITextLayoutDirection = .left
	private var animator: UIViewPropertyAnimator?
	
	// MARK: - Model
	var model: [QPeriod] {
		get {
			return _model
		}
		set {
			_model = newValue
//			let stdPeriod = QPeriod(periodId: "standard", windowSize: windowSize)
//			_model.insert(stdPeriod, at: 0)
			if (!modelIsRendered && viewIsLoaded) {
				renderModel()
			}
		}
	}
	private var _model: [QPeriod] = []
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var scroller: UIScrollView!
	@IBOutlet weak var btnLeft: UIButton!
	@IBOutlet weak var btnRight: UIButton!
	
	// MARK: - View Lifecycle

	override func awakeFromNib() {
		super.awakeFromNib()

		scroller.delegate = self
		
//		touchGR = FIOTouchGestureRecognizer(target: self, action: #selector(handleScrollerTouch(recognizer:)))
//		touchGR!.delegate = self
//		touchGR!.cancelsTouchesInView = false
//		addGestureRecognizer(touchGR!)
		
		if (model.count > 0) {
			renderModel()
		}
		viewIsLoaded = true
		
//		performFastScroll(.left)
	}

	// MARK: - IBActions

	@IBAction func goPrevious(_ sender: Any) {
		let proposedNewX = currentScrollDestinationX + FIOPeriodSliderViewItem.designSize.width
//		print("proposedNewX = " + proposedNewX.asString + " scroller width = " + scroller.contentSize.width.asString)
		if proposedNewX > (scroller.contentSize.width - FIOPeriodSliderViewItem.designWidth) {
			print("bouncing because this would push beyond edge")
		} else {
			currentScrollDestinationX = proposedNewX
			//            print("new currentScrollDestinationX = " + currentScrollDestinationX.asString)
			let r = CGRect(origin: CGPoint(x: currentScrollDestinationX, y: 0.0), size: FIOPeriodSliderViewItem.designSize)
			scroller.scrollRectToVisible(r, animated: true)
		}
	}

	@IBAction func goNext(_ sender: Any) {
		let proposedNewX = currentScrollDestinationX - FIOPeriodSliderViewItem.designSize.width
		//        print("proposedNewX = " + proposedNewX.asString + " scroller width = " + scroller.contentSize.width.asString)
		if proposedNewX < 0 {
			//            print("bouncing because this would push beyond edge")
		} else {
			currentScrollDestinationX = proposedNewX
			//            print("new currentScrollDestinationX = " + currentScrollDestinationX.asString)
			let r = CGRect(origin: CGPoint(x: currentScrollDestinationX, y: 0.0), size: FIOPeriodSliderViewItem.designSize)
			scroller.scrollRectToVisible(r, animated: true)
		}
	}
	
	// MARK: - Scroller

	private func renderModel() {
//		print(#function + " in FIOPeriodViewController")
		if model.count == 0 {
			print("no models to render")
			// FIXME: do something better here
			return
		}
		
		// Consts
		let viewCount: CGFloat = 5.0
		let cellCount: CGFloat = 500.0
		let width: CGFloat = cellCount * FIOPeriodSliderViewItem.designWidth
		
		// Scroller
		scroller.contentSize = CGSize(width: width, height: scroller.frame.height)
		scroller.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft // Required, look at UIScrollView.addSubview extension
		scroller.transform = CGAffineTransform(scaleX: -1, y: 1) // RTL
		addGestureRecognizer(scroller.panGestureRecognizer)
		scroller.removeGestureRecognizer(scroller.panGestureRecognizer)
		
		periodViews = []
		for i in 0 ... Int(viewCount - 1) {
			let tv: FIOPeriodSliderViewItem = FIOPeriodSliderViewItem.fromNib()
			// note: important! yes, in this case the model index matches the view index as we're rendering the first five models on view load
//			tv.btnMain.addTarget(self, action: #selector(btnOverlay_TouchUpInside(_:event:)), for: .touchUpInside)
			tv.frame = CGRect(x: CGFloat(i) * FIOPeriodSliderViewItem.designWidth, y: 0.0, width: FIOPeriodSliderViewItem.designWidth, height: FIOPeriodSliderViewItem.designHeight)
			tv.parent = self
			if i < model.count {
				tv.renderModel( model[i], index: i )
			}
			tv.alpha = 0 // This will be updated momentarily by setTileAlphasToRestState()
			scroller.addSubview(tv)
			periodViews!.append(tv) // this should be a safe force unwrap becuase it was just init above
		}
		
		arrangeViewsAndRenderCell()
		updateScrollerContentSize()
//		goPrevious(self) // To default to position 1, putting standard period off screen to the right to start
		setTileAlphasToRestState(quiet: true)
		scrollViewDidScroll(scroller) // cause the first cells to zoom / scale up
		modelIsRendered = true
	}

	private func arrangeViewsAndRenderCell() {
		guard let pv = periodViews else { return }
//		print("\n\n==================")
//		print(self.className + " " + #function)
//		print("")

		if (needMoreDataCheck(visiblePeriodIndex)) { pullMoreWindows() }

		var checkIdx: Int
		var checkIdxX: CGFloat
		var aViewResidesAtCheckIdxX: Bool

//		if let pvs = periodViews {
//			for (idx, v) in pvs.enumerated() {
//				print(idx.asString + " frame: " + String(describing: v.frame))
//			}
//		}

		for i in [0, -1, 1, -2, 2] { // Order matters

			checkIdx = visiblePeriodIndex + i
			if checkIdx < 0 { break } // we're at today/week/month
			checkIdxX = (CGFloat(checkIdx) * FIOPeriodSliderViewItem.designWidth)
			let checkIdxX_center = checkIdxX + (FIOPeriodSliderViewItem.designWidth / 2) // Get target center instead
//			print("Check center x = \(checkIdxX)")
			let testView = pv.first(where: { $0.center.x == checkIdxX_center })
			aViewResidesAtCheckIdxX = (testView != nil)
//			print("aViewResidesAtCheckIdxX = \(aViewResidesAtCheckIdxX)")
			
			if !aViewResidesAtCheckIdxX {
//				print("MOVING A VIEW to: " + checkIdxX.asString)
				moveItemViewTo(checkIdxX, andRenderModelForIndex: checkIdx)
			}
		}
		
//		if let pvs = periodViews {
//			for (idx, v) in pvs.enumerated() {
//				print(idx.asString + " frame: " + String(describing: v.frame))
//			}
//		}

	}

	private func updateScrollerContentSize() {
		guard let pv = periodViews else { return }
		
		let newWidth: CGFloat = model.count.asCGFloat * FIOPeriodSliderViewItem.designWidth
		//        print("new scroller width: " + newWidth.asString)
		
		scroller.contentSize = CGSize(width: newWidth, height: scroller.contentSize.height)
		
		// In case this happens after the user ends a scroll, clean up by hiding views that are to the left of the visible final view
		pv.forEach {
			$0.isHidden = $0.frame.origin.x > (scroller.contentSize.width - FIOPeriodSliderViewItem.designWidth)
			//            print($0.frame.origin.x.asString + " isHidden = " + $0.isHidden.asString)
		}
	}

	private func moveItemViewTo(_ x: CGFloat, andRenderModelForIndex idx: Int) {
		if let v = farthestView {
			v.isHidden = true
//			v.isHidden = x > (scroller.contentSize.width - FIOPeriodSliderViewItem.designWidth)
			//        print("width = " + scroller.contentSize.width.asString + " x = " + x.asString + " isHidden = " + v.isHidden.asString)
			v.frame = CGRect(x: x, y: v.y, width: v.w, height: v.h)
			if idx < model.count {
				v.renderModel(model[idx], index: idx)
			} else {
				v.isWaitingForModel = true
				v.modelIndex = idx
			}
			v.isHidden = false
		}
	}

	private func setAllTilesAlpha1() {
		
		if let views = self.periodViews {
			views.forEach { view in
//				animator = UIViewPropertyAnimator(
//					duration: 0.2,
//					dampingRatio: 0.4,
//					animations: {
//						self.alpha = 1.0
//					}
//				)
//				animator?.startAnimation(afterDelay: 0.5)
//				animator.finishAnimation(.start)
//				animator?.stopAnimation(true)
//				animator.pauseAnimation()
//				animator.startAnimation()
				
				UIView.animate(
					withDuration: 0.2,
					delay: 0.5,
					options: UIView.AnimationOptions.curveEaseIn,
					animations: { view.alpha = 1.0 },
					completion: { completed in }
				)
			}
		}
	}
	
	private func setTileAlphasToRestState(quiet: Bool = false) {
		self.periodViews?.forEach { view in
			if view.modelIndex != visiblePeriodIndex {
				UIView.animate(withDuration: 0.2) { view.alpha = 0.15 }
			}
			else {
				view.alpha = 1.0
			}
		}
	}

	// MARK: - Window Paging
	
	private func pullMoreWindows() {
		print(self.className + " " + #function)

		if (windowPullInProgress) {
			print("bouncing because window pull is in progress")
			return }
		else { windowPullInProgress = true }

		QFlow.pullMoreFlow(windowSize: windowSize) { result in
			if let r = result {
				self.model = r
				self.updateScrollerContentSize()
				self.rerenderModelsInViews()
			}
			self.windowPullInProgress = false
		}
	}

	private func rerenderModelsInViews() {
		guard let pv = periodViews else { return }
		pv.forEach { $0.renderModel(model[$0.modelIndex], index: $0.modelIndex) }
	}

	// MARK: - Custom

	private func pushDetailForCurrentVisibleModel() {
		guard let vm = visibleModel else { return }
		guard let nc = AppDelegate.sharedInstance.navigationController else { return }
		nc.setNavBarVisible()
		nc.pushViewController(FIOPeriodDetailViewController(vm), animated: true)
	}
	
	private func updateForVisiblePeriod(_ forceRefresh: Bool = false) {
		if (renderedVisiblePeriodIndex == visiblePeriodIndex) && (!forceRefresh) { return }
		renderedVisiblePeriodIndex = visiblePeriodIndex
		QIOAudio.pickerTick()
	}

	// MARK: - Computed Properties

	private var farthestView: FIOPeriodSliderViewItem? {
		guard let pv = periodViews else { return nil }
		let x = scroller.contentOffset.x
		pv.forEach { (v) in  v.tag = Int(x - v.frame.origin.x) } // Put the distance in .tag
		let views_sorted_by_distance = pv.sorted(by: { abs($0.tag) > abs($1.tag) }) // Sort by distance
		return views_sorted_by_distance.first! // return the farthest view
	}

	public func periodAtIndex(_ idx: Int) -> FIOFlowPeriod {
		//		print(self.className + " " + #function)
		//		print(idx.asString)
		
		switch windowSize {
			
		case .day:
			if (idx == 1) { return .yesterday}
			else { return .custom }
			
		case .week:
			if (idx == 1) { return .thisWeek}
			else if (idx == 2) { return .lastWeek}
			else { return .custom }
			
		case .month:
			if (idx == 1) { return .thisMonth}
			else if (idx == 2) { return .lastMonth}
			else { return .custom }
			
		default: return .invalid
		}
	}
	
	private func needMoreDataCheck(_ idx: Int) -> Bool {
//		print(#function + " for index: \(idx) \(model.count))")
		if holdingEndOfData { return false }
		switch windowSize {
		case .day: return (model.count - idx < defaultDayScrollThresholdCount)
		case .week: return (model.count - idx < defaultWeekScrollThresholdCount)
		case .month: return (model.count - idx < defaultMonthScrollThresholdCount)
		default: return false
		}
	}
	
	private var holdingEndOfData: Bool {
		return model.reduce(false, { result, examine in
			return result || examine.includesEndOfData
		})
	}
	
	private var visibleModel: QPeriod? {
		return model[visiblePeriodIndex]
	}

	private var visibleView: FIOPeriodSliderViewItem? {
		if let pv = periodViews, let matchingView = pv.first(where: { $0.modelIndex == visiblePeriodIndex }) {
			return matchingView
		} else { return nil }
	}

}

// MARK: - Touchings

extension FIOPeriodSliderView: UIScrollViewDelegate, UIGestureRecognizerDelegate {
	
	func gestureRecognizer(
		_ gestureRecognizer: UIGestureRecognizer,
		shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
	) -> Bool {
		return true
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		print(self.className + " " + #function)

//        print("scrollViewDidScroll contentOffset: " + String(describing: scrollView.contentOffset))
		let newVisiblePeriodIndex = Int(round(scroller.contentOffset.x / CGFloat(FIOPeriodSliderViewItem.designWidth)))

		let isNewVisiblePeriodIndex = newVisiblePeriodIndex != visiblePeriodIndex
		visiblePeriodIndex = newVisiblePeriodIndex

		if isNewVisiblePeriodIndex {
//			print("new visiblePeriodIndex = " + visiblePeriodIndex.asString)
			
			if scrollView.isDecelerating {
//				print("Scrollview is decelerating and there's a new visiblePeriodIndex")
				// So do this....
				setTileAlphasToRestState()
			}
		}
		
		if let pvs = periodViews {

			// at 0 distance target scale = maxScale
			// at 1/2 screen width distance target scale = minScale
			let maxScale = 1.2
			let minScale = 1.0
			let scaleRange = maxScale - minScale

			let halfScreenWidth = UIScreen.main.bounds.size.width / 2
//			print("halfScreenWidth = \(halfScreenWidth)")

			let scrollerCenterX = scrollView.convert(scrollView.center, to: self).x
//			print("scrollerCenterX = " + scrollerCenterX.asString)

			pvs.forEach { v in

				let tileCenterX = v.center.x
//				print("tileCenterX = " + tileCenterX.asString)
				
				let distanceFromCenter = abs(tileCenterX - scrollerCenterX)
//				print("distanceFromCenter = \(distanceFromCenter)")
				
				let distanceAsPercentageOfHalfScreen = distanceFromCenter / halfScreenWidth
//				print("distanceAsPercentageOfHalfScreen = \(distanceAsPercentageOfHalfScreen)")
				
				let deltaToApply = distanceAsPercentageOfHalfScreen * scaleRange.asCGFloat
//				print("deltaToApply = \(deltaToApply)")
				
				// Clip to min-max
				var targetScaleValue = maxScale.asCGFloat - deltaToApply
				targetScaleValue = CGFloat.minimum(targetScaleValue, maxScale.asCGFloat)
				targetScaleValue = CGFloat.maximum(targetScaleValue, minScale.asCGFloat)
				
				// Snap to 1
				let distFromMin = abs(targetScaleValue - minScale.asCGFloat)
				if (distFromMin <= 0.02) {
//					print("distFromMin = " + distFromMin.asString)
//					print("Snap to 1")
					targetScaleValue = 1.0
				}
//				print("targetScaleValue = \(targetScaleValue)")
				
				v.transform = CGAffineTransform(scaleX: targetScaleValue * -1, y: targetScaleValue) // -1 to flip horizontal due to RTL scroller
			}
		}
		
		updateForVisiblePeriod()
	}
	
	// Dragging
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//		print(self.className + " " + #function)
	}

	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//		print(self.className + " " + #function)
	}

	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//		print(self.className + " " + #function)
		arrangeViewsAndRenderCell()
		if !decelerate {
			setTileAlphasToRestState()
		}
	}

	// Decelerating
	
	func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//		print(self.className + " " + #function)
		setTileAlphasToRestState()
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//		print(self.className + " " + #function)
		arrangeViewsAndRenderCell()
		QIOHaptic.s.tap(.select, from: #function + "-" + self.className + "-" + String(describing: windowSize))
	}
	
	// Scrolling Animation
	
	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//		print(self.className + " " + #function)
		setTileAlphasToRestState()
		arrangeViewsAndRenderCell()
	}

}

// MARK: - Fast Scroll

//extension FIOPeriodSliderView {
//
//	@objc func handleScrollerTouch(recognizer: UIGestureRecognizer) {
//		switch recognizer.state {
//		case .began:
//			setAllTilesAlpha1()
//
//		case .ended, .cancelled, .failed:
//			setTileAlphasToRestState()
//			cancelFastScroll()
//
//		case .changed:
//			if let tgr = touchGR, let touch = tgr.trackedTouch {
//				let distFromEdge: CGFloat = 30.0 // How close to the edge must the user slide to trigger the fast scroll?
//				let newLocation: CGPoint =  touch.previousLocation(in: self)
//				let screenWidth = UIScreen.main.bounds.size.width
//				let moduloramus: CGFloat = (self.w - screenWidth) / 2
//				let leftTrigger: CGFloat = moduloramus + distFromEdge
//				let rightTrigger: CGFloat = moduloramus + screenWidth - distFromEdge
//				if newLocation.x < leftTrigger {
//					performFastScroll(.left)
//				} else if newLocation.x > rightTrigger {
//					performFastScroll(.right)
//				} else {
//					cancelFastScroll()
//				}
//			}
//
//		default: return
//		}
//	}
//
//	private func performFastScroll(_ direction: UITextLayoutDirection) {
////		//		print(self.className + " " + #function)
////
////		if timerIsRunning {
////			//			print("timerIsRunning")
////			return
////		} else {
////			timerIsRunning = true
////		}
////
//////		print("STARTING FAST SCROLL")
////
//////		print(Thread.isMainThread)
////
////		self.fastScrollDirection = direction
////
////		if self.fastScrollDirection == .left {
//////			self.btnLeft.backgroundColor = .red
////		} else {
//////			self.btnRight.backgroundColor = .red
////		}
////
////		var targetXoffset: CGFloat = 0
////
////		if self.fastScrollDirection == .left {
////			targetXoffset = self.fastScrollStepSize
////		} else {
////			targetXoffset = -1 * self.fastScrollStepSize
////		}
////
////		var tempNewX = self.scroller.contentOffset.x + targetXoffset
//////		print(tempNewX)
////
////		if tempNewX < 0 {
//////			print("tempNewX is < 0. Setting to 0.")
////			tempNewX = 0
////
////		} else if tempNewX > self.scroller.contentSize.width - FIOPeriodSliderViewItem.designWidth {
//////			print("tempNewX is too high. Setting to the outer limit")
////			tempNewX = self.scroller.contentSize.width - FIOPeriodSliderViewItem.designWidth
////		}
////
////		// CONTINUE HERE: get the animation to start faster, get it to limit at the edges, maybe only go toward zero for now due to the complexity of page pulling
////		// Get the views layout as needed during scroll.
////
////		let t = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
////			//				print("tick")
////
////			if self.timerIsRunning {
////
////				self.animator = UIViewPropertyAnimator(duration: timer.timeInterval + 0.1, curve: .linear) {
////					self.scroller.contentOffset.x = tempNewX
////				}
////
////				if let a = self.animator {
////					a.startAnimation()
////				}
////
////				//					UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
////				//						self.scroller.contentOffset.x += (self.fastScrollDirection == .left ? self.fastScrollStepSize : -1 * self.fastScrollStepSize)
////				//					},
////				//					completion: { completed in })
////
////			} else {
////				timer.invalidate()
////			}
////		}
////
////		RunLoop.main.add(t, forMode: .commonModes)
//	}
//
//	private func cancelFastScroll() {
////		//		print(self.className + " " + #function)
////
////		if !timerIsRunning { return }
//////		print("CANCELLING FAST SCROLL")
////
////		if let a = animator {
////			a.stopAnimation(true)
////		}
////		arrangeViewsAndRenderCell()
////		timerIsRunning = false
////		btnLeft.backgroundColor = .clear
////		btnRight.backgroundColor = .clear
//	}
//
//}
