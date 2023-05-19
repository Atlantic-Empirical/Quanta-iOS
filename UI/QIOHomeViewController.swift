//
//  QIOHomeViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 7/3/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Charts
import AAInfographics

class QIOHomeViewController: QIOBaseViewController, IQIOBaseVC {

	// MARK: - Consts
	
	static let FLOW_RESULT_V_SPACE: CGFloat = 10
	static let BADGE_SECTION_H: CGFloat = 30
	static let BADGE_SIZE: CGFloat = 30
	let MAX_CARET_ALPHA: Double = 0.2
	typealias FlowSectionSubValue = (view: UIView, titleLbl: UILabel, valueLbl: UILabel)
	
	// MARK: - Properties
	
	var slider: UIView?
	var dailyButton: UIButton!
	var monthlyButton: UIButton!
	var flowShowYesterday: Bool = true
	var spendingQ: QSpending_Quantized?
	var pendingNotif: [String: AnyObject]?
	var yesterday: QYesterday!
	var thisMonth: QThisMonth!
	var caret: UIImageView?
	
	var flowTitleLbl: UILabel!
	var flowSubtitleLbl: UILabel!
	var flowStreakLbl: UILabel!
	var flowOutcomeTitleLbl: UILabel!
	var flowOutcomeLbl: UILabel!
	var flowIncomeLbl: UILabel!
	var flowBaseSpendLbl: UILabel!
	var flowOtherSpendLbl: UILabel!
	var flowBgArrowIv: UIImageView!
	var flowTitleArrowIv: UIImageView!
	var flowRegInc: FlowSectionSubValue!
	var flowBaseSpend: FlowSectionSubValue!
	var flowOtherSpend: FlowSectionSubValue!

	// MARK: - View Lifecycle
	
	override func loadView() {
		super.loadView()
		setRightBarButton(.settings)
		scroller.delegate = self
		guard let y = home.yesterday else { return }
		yesterday = y
		guard let tm = home.thisMonth else { return }
		thisMonth = tm
	}

	// MARK: - Actions
	
	@objc func badgeAction(sender: UIButton) {
//		print(#function + " " + sender.tag.asString)
		guard let which = QIOBadge(rawValue: sender.tag) else { return }

		var t = ""
		var m = ""
		
		switch which {
		case .achievedFinancialFreedom:
			t = "Financial Freedom"
			m = QFlow.ipm_LongTermMoneyDescription
		case .healthyMoneyRental:
			t = "Healthy Money Rental"
			m = QFlow.ipm_MoneyRentalDescription
		case .healthySavingsBuffer:
			t = "Healthy Savings"
			m = QFlow.ipm_RainyDayMoneyDescription
		case .livingProfitably:
			t = "Living Profitably"
			m = QFlow.ipm_SurplusLivingDescription
		}
		
//		AppDelegate.sharedInstance.presentAlertWithTitle(t, message: m)
		
		let alert = UIAlertController(title: "\n\n\n" + t, message: m, preferredStyle: .alert)
		let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alert.addAction(action)
		
		let iv = genImage(which.imageName, withTint: .q_brandGold)
		iv.translatesAutoresizingMaskIntoConstraints = true
		iv.frame = CGRect(o: CGPoint(x: 0, y: 20), wh: 52)
		iv.center.x = 270 / 2
		alert.view.addSubview(iv)
		
		navigationController?.present(alert, animated: true, completion: nil)
		print(alert.view.frame.w)
	}

	@objc func disclosureAction(sender: UIButton) {
		guard let which = QIOHomeDisclosureActions(rawValue: sender.tag) else { return }
		print(which.asString)
		
		switch which {
			
		case .baseLivingExpenses:
			navigationController?.pushViewController(QIOBleOverviewViewController(), animated: true)
			
		case .significantSpending:
			navigationController?.pushViewController(QIOSpendingViewController(), animated: true)
			
		case .rainyDayFunds:
			navigationController?.pushViewController(FIORainyDetailViewController(), animated: true)
			
		case .financialIndependence:
			navigationController?.pushViewController(QIOFireViewController(), animated: true)
			
		case .moneyRental:
			navigationController?.pushViewController(FIOMoneyRentalViewController(), animated: true)
			
		case .flow:
			navigationController?.pushViewController(QIOFlowViewController(), animated: true)
			
		case .generalSpending:
			var tids = [String]()
			if flowShowYesterday {
				if
					let tx = yesterday.periodSummary.transactions,
					let debits = tx.debits
				{
					tids = debits.transactionIds
				}
			} else {
				if
					let tx = thisMonth.periodSummary.transactions,
					let debits = tx.debits
				{
					tids = debits.transactionIds
				}
			}
			pushTransactionListWithTids(tids, onNavigationController: navigationController)

		case .primaryNetValue:
			if flowShowYesterday {
				navigationController?.pushViewController(
					FIOPeriodDetailViewController(yesterday), animated: true)
			} else {
				navigationController?.pushViewController(
					FIOPeriodDetailViewController(thisMonth), animated: true)
			}
			
		case .standardDay:
			print("need a standard day vc")
			
		case .income:
			navigationController?.pushViewController(FIOIncomeViewController(), animated: true)
			
		}
	}
	
	@objc func significantSpendBarAction(sender: UIButton) {
		print(#function + " \(sender.tag)")
		guard let ss = spendingQ?[sender.tag] else { return }
		navigationController?.pushViewController(
			QIOPayeeDetailViewController(ss),
			animated: true)
	}
	
	@objc func mapBarAction(sender: UIButton) {
		print(#function + " \(sender.tag)")
		
		if
			let cat = home.spending?.categories.cats.first(where: { $0.id == sender.tag }),
			let spending = home.spending
		{
			navigationController?.pushViewController(
				FIOCategoryDetailViewController(
					cat: QIOCat(cat),
					fioCats: FIOCategories(uhs: spending.categories)),
				animated: true)
		}
//		guard
//			let v = FIOTransactionCategoryId.init(rawValue: sender.tag),
//			let spending = home.spending
//			else { return }
//		navigationController?.pushViewController(
//			FIOCategoryDetailViewController(
//				categoryId: v,
//				withModel: FIOCategories(uhs: spending.categories)
//			),
//			animated: true)
	}
		
	@objc func toggleDayMonthAction(sender: UIButton) {
		let btns: (old: UIButton, new: UIButton) = (sender.tag == 1 ? (monthlyButton, dailyButton) : (dailyButton, monthlyButton))
		UIView.transition(with: btns.old, duration: 0.3, options: .transitionCrossDissolve, animations: {
			self.slider?.x = btns.new.x
			btns.old.setTitleColor(.q_C0, for: .normal)
		})
		UIView.transition(with: btns.new, duration: 0.3, options: .transitionCrossDissolve, animations: {
			btns.new.setTitleColor(.white, for: .normal)
		})
		flowShowYesterday.toggle()
		renderFlowPeriod(flowShowYesterday)
	}
	
	func renderFlowPeriod(_ renderYesterday: Bool = true) {
		
		let amount: Double = renderYesterday ?
			yesterday.periodSummary.netAmount :
			thisMonth.periodSummary.netAmount
//			(thisMonth.projection?.net ?? 0)
		
		var subttl: String
		var img: UIImage?
		let today = Date()
		let daysLeftInMonth = today.daysInMonth() - today.day
		let daysString = "day".pluralize(daysLeftInMonth)
		
		if amount == 0 {
			subttl = "Even is good 🙌"
			img = nil
		} else if amount > 0 {
			if renderYesterday {
				subttl = "Nice work! 👍\nYou were profitable yesterday."
			} else {
				subttl = "Solid. 🤜\nYou're headed for profit this month."
			}
			img = UIImage(named: "Circle-Arrow-Up")
		} else {
			if renderYesterday {
				subttl = "Today is a new day.\nKeep at it. 👊"
			} else {
				subttl = "Headed for a loss, there are \(daysLeftInMonth) \(daysString) left to turn it around."
			}
			img = UIImage(named: "Circle-Arrow-Down")
		}
		
		flowTitleLbl.text = renderYesterday ? "Yesterday" : "This Month"
		flowSubtitleLbl.text = subttl
		flowBgArrowIv.image = img
		flowTitleArrowIv.image = img
		
		let dateString = today.toFriendly(style: .full) + " Net:"
		let monthString = today.monthName + " \(today.year) Net So Far:"
		flowOutcomeTitleLbl.text = renderYesterday ? dateString : monthString
		flowOutcomeLbl.attributedText = amount.asAttributedCurrencyString(fontSize: 90, bold: false, light: true)
		
		let cpd = renderYesterday ?
			(home.streaks?.days.periodCount ?? 0) :
			(home.streaks?.months.periodCount ?? 0)
		if cpd > 0 {
			flowStreakLbl.text = "That makes \(cpd) \(renderYesterday ? "days" : "months") in a row."
		}
		
		// BOTTOM SECTION
		var inc: Double = 0, base: Double = 0, other: Double = 0
		if renderYesterday {
			inc = yesterday.periodSummary.income
			base = yesterday.periodSummary.spending.spendBleAmortized ?? 0
			other = yesterday.periodSummary.spending.spendWithoutBle ?? 0
		} else {
			inc = thisMonth.periodSummary.income
			base = thisMonth.periodSummary.spending.spendBleAmortized ?? 0
			other = thisMonth.periodSummary.spending.spendWithoutBle ?? 0
		}
		
		let sz: CGFloat = 24
		let bold = false
		flowRegInc.valueLbl.attributedText = inc.asAttributedCurrencyString(fontSize: sz, bold: bold)
		flowBaseSpend.valueLbl.attributedText = base.asAttributedCurrencyString(fontSize: sz, bold: bold)
		flowOtherSpend.valueLbl.attributedText = other.asAttributedCurrencyString(fontSize: sz, bold: bold)
	}
	
	// MARK: - Build
	
	override func buildUI() {
		secBadges()
		secFlow()
		renderFlowPeriod()
		secSpending()
		secMoneyRental()
		secRainyDayFund()
		secFI()
		super.buildComplete()
	}
	
	func secBadges() {
		guard // First confirm that any badges are going to be rendered
			QFlow.ipm_SurplusLiving ||
			QFlow.ipm_MoneyRental ||
			QFlow.ipm_RainyDayMoney ||
			QFlow.ipm_LongTermMoney
		else { return }
		
		let firstMargin: CGFloat = 0
		let standardMargin: CGFloat = 10
		
		let base = UIView(frame: .zero)
		base.translatesAutoresizingMaskIntoConstraints = false
		addModuleNew(base, vSpace: 10)
		base.anchorHeight(QIOHomeViewController.BADGE_SIZE)
		var currentXAnchor = base.leadingAnchor
		var isFirst = true
		let badgeHW: CGFloat = QIOHomeViewController.BADGE_SIZE
		
		if QFlow.ipm_SurplusLiving {
			let b = genBadge(.livingProfitably)
			base.addSubview(b)
			b.anchorTopToSuperview()
			b.anchorLeadingTo(currentXAnchor, constant: isFirst ? firstMargin : standardMargin)
			b.anchorSizeConstantSquare(badgeHW)
			currentXAnchor = b.trailingAnchor
			isFirst = false
		}
		if QFlow.ipm_MoneyRental {
			let b2 = genBadge(.healthyMoneyRental)
			base.addSubview(b2)
			b2.anchorTopToSuperview()
			b2.anchorLeadingTo(currentXAnchor, constant: isFirst ? firstMargin : standardMargin)
			b2.anchorSizeConstantSquare(badgeHW)
			currentXAnchor = b2.trailingAnchor
			isFirst = false
		}
		if QFlow.ipm_RainyDayMoney {
			let b3 = genBadge(.healthySavingsBuffer)
			base.addSubview(b3)
			b3.anchorTopToSuperview()
			b3.anchorLeadingTo(currentXAnchor, constant: isFirst ? firstMargin : standardMargin)
			b3.anchorSizeConstantSquare(badgeHW)
			currentXAnchor = b3.trailingAnchor
			isFirst = false
		}
		if QFlow.ipm_LongTermMoney {
			let b4 = genBadge(.achievedFinancialFreedom)
			base.addSubview(b4)
			b4.anchorTopToSuperview()
			b4.anchorLeadingTo(currentXAnchor, constant: isFirst ? firstMargin : standardMargin)
			b4.anchorSizeConstantSquare(badgeHW)
			currentXAnchor = b4.trailingAnchor
			isFirst = false
		}
		
		base.anchorBottomTo(base.subviews.first!.bottomAnchor)
	}
	
	func secFlow() {
		let out = UIView(frame: .zero)
//		out.backgroundColor = .randomP3
		out.translatesAutoresizingMaskIntoConstraints = false
		addModuleNew(out)
		out.anchorHeight(h: view.safeAreaLayoutGuide.heightAnchor, constant: -QIOHomeViewController.BADGE_SECTION_H - (navigationController?.navigationBar.h ?? 0) + view.safeAreaInsets.bottom)

		// CONSTS
		let topSectionH: CGFloat = 100
		let bottomSectionH: CGFloat = 124
		let midSectionH: CGFloat = 180
		
		// MIDDLE SECTION
		let middleSection = UIView(frame: .zero)
		middleSection.translatesAutoresizingMaskIntoConstraints = false
		out.addSubview(middleSection)
		middleSection.anchorSidesToSuperview()
		middleSection.anchorCenterYToSuperview(constant: -30)
		middleSection.anchorHeight(midSectionH)

		let iv = genImage("Circle-Arrow-Up", withTint: .black)
		iv.alpha = 0.06
		middleSection.addSubview(iv)
		iv.anchorSizeConstantSquare(284)
		iv.anchorCenterYToSuperview()
		iv.anchorCenterXTo(out.trailingAnchor, constant: -30)
		flowBgArrowIv = iv
		
		let resultLbl = genMoneyLabel(
			0, // outcome amount
			baseTextSize: 90,
			lightFont: true)
		middleSection.addSubview(resultLbl)
		resultLbl.anchorSidesToSuperview()
		resultLbl.anchorCenterYToSuperview()
		flowOutcomeLbl = resultLbl

		let btn1 = UIButton(#selector(disclosureAction(sender:)), tag: QIOHomeDisclosureActions.primaryNetValue.rawValue)
		middleSection.addSubview(btn1)
		btn1.anchorSidesToOtherview(resultLbl)

		let m1 = genLabel(
			"<outcome title>",
			font: baseFont(size: 17, bold: false),
			textColor: .q_C0)
		middleSection.addSubview(m1)
		m1.anchorSidesToSuperview()
		m1.anchorBottomTo(resultLbl.topAnchor, constant: 10)
		flowOutcomeTitleLbl = m1
		
		// TOP SECTION
		let topSection = UIView(frame: .zero)
		topSection.translatesAutoresizingMaskIntoConstraints = false
		out.addSubview(topSection)
		topSection.anchorSidesToSuperview()
		topSection.anchorHeight(topSectionH)
		topSection.anchorBottomTo(middleSection.topAnchor, constant: -20)
		
		let l1 = genLabel(
			"<flow area title>",
			font: baseFont(size: 30, bold: true))
		topSection.addSubview(l1)
		l1.anchorLeadingToSuperview()
		l1.anchorTopToSuperview()
		flowTitleLbl = l1
		
		let iv2 = genImage("Circle-Arrow-Up", withTint: .q_38)
		iv2.alpha = 1.0
		topSection.addSubview(iv2)
		iv2.anchorSizeConstantSquare(26)
		iv2.anchorCenterYTo(l1.centerYAnchor, constant: 4)
		iv2.anchorLeadingTo(l1.trailingAnchor, constant: 10)
		flowTitleArrowIv = iv2

		let l2 = genLabel("<flow area subtitle>", font: baseFontLight(size: 22))
		topSection.addSubview(l2)
		l2.anchorSidesToSuperview()
		l2.anchorTopTo(l1.bottomAnchor, constant: 4)
		flowSubtitleLbl = l2

		let l3 = genLabel(
			"<streak>",
			font: baseFont(size: 15, bold: true),
			textColor: UIColor("93E0A9"))
		l3.isHidden = true
		topSection.addSubview(l3)
		l3.anchorSidesToSuperview()
		l3.anchorTopTo(l2.bottomAnchor, constant: 4)
		flowStreakLbl = l3

		// BOTTOM SECTION
		let bottomSection = UIView(frame: .zero)
		bottomSection.translatesAutoresizingMaskIntoConstraints = false
		out.addSubview(bottomSection)
		bottomSection.anchorSidesToSuperview()
		bottomSection.anchorHeight(bottomSectionH)
		bottomSection.anchorTopTo(middleSection.bottomAnchor, constant: 20)

		flowRegInc = flowVal(
			name: "Regular\nIncome",
			amount: yesterday.periodSummary.income,
			action: #selector(disclosureAction(sender:)),
			tag: QIOHomeDisclosureActions.income.rawValue)
		bottomSection.addSubview(flowRegInc.view)
		flowRegInc.view.anchorSizeConstantSquare(76)
		flowRegInc.view.anchorTopToSuperview()
		flowRegInc.view.anchorLeadingToSuperview()

		flowBaseSpend = flowVal(
			name: "Base\nSpending",
			amount: yesterday.periodSummary.spending.spendBleAmortized ?? 0,
			action: #selector(disclosureAction(sender:)),
			tag: QIOHomeDisclosureActions.baseLivingExpenses.rawValue)
		bottomSection.addSubview(flowBaseSpend.view)
		flowBaseSpend.view.anchorSizeConstantSquare(76)
		flowBaseSpend.view.anchorTopToSuperview()
		flowBaseSpend.view.anchorLeadingTo(flowRegInc.view.trailingAnchor, constant: 30)

		flowOtherSpend = flowVal(
			name: "Other\nSpending",
			amount: yesterday.periodSummary.spending.spendWithoutBle ?? 0,
			action: #selector(disclosureAction(sender:)),
			tag: QIOHomeDisclosureActions.generalSpending.rawValue)
		bottomSection.addSubview(flowOtherSpend.view)
		flowOtherSpend.view.anchorSizeConstantSquare(76)
		flowOtherSpend.view.anchorTopToSuperview()
		flowOtherSpend.view.anchorLeadingTo(flowBaseSpend.view.trailingAnchor, constant: 30)
		
		let tog = genFlowToggle(inView: bottomSection)
		tog.anchorSidesToSuperview()
		tog.anchorBottomToSuperview()
		
		// CARET
		let c = genImage("nav-caret-up", withTint: .black)
		c.rotate(180) // looks better pointed down
		c.alpha = MAX_CARET_ALPHA.asCGFloat
		out.addSubview(c)
		c.anchorSizeConstant(32, 6)
		c.anchorCenterXToSuperview()
		c.anchorBottomTo(out.bottomAnchor)
		caret = c
	}
	
	func secSpending() {
		genSectionHeader(
			"Spending",
			action: #selector(disclosureAction(sender:)),
			tag: QIOHomeDisclosureActions.significantSpending.rawValue,
			includeSpacer: true
		)
		
		genSubSectionTitle("Categories")
		if let cats = home.spending?.categories.cats {
			var catsSorted = cats.sorted(by: { $0.percentage > $1.percentage })
			for i in 0...9 {
				genMoneyMapBar(catsSorted[i], vSpace: (i == 0 ? 20 : 5))
			}
		}

		if let sq = home.spending?.quantized {
			spendingQ = sq
			genSubSectionTitle("Significant Spending", vSpace: 30)

			for i in 0...min(5, (sq.count-1)) {
				genRecurringSpendBar(
					spendItem: sq[i],
					action: #selector(significantSpendBarAction(sender:)),
					tag: i,
					vSpace: (i == 0 ? 20 : 5))
			}
			if sq.count > 6 {
				genSubvalueDisclosure(
					"More",
					vSpace: 5,
					action: #selector(disclosureAction(sender:)),
					tag: QIOHomeDisclosureActions.significantSpending.rawValue)
			}
		}
	}
	
	func secMoneyRental() {
		genSectionHeader(
			"Money Rental",
			action: #selector(disclosureAction(sender:)),
			tag: QIOHomeDisclosureActions.moneyRental.rawValue
		)
//		genSubSectionDescription("The cost of spending other people's money.")
		if let cc = home.moneyRental?.creditCards {
			
			genSubSectionTitle("Daily Money Rent Paid")
			genMajorValue(
				amount: cc.rent.averagePerDay,
				action: #selector(disclosureAction(sender:)),
				tag: QIOHomeDisclosureActions.moneyRental.rawValue)
			genSubvalueDisclosure(
				cc.balance.current.total.toCurrencyString(includeCents: true) + " Total Debt",
				vSpace: 0)
			
			genSubSectionTitle("Credit Card Utilization")
			genCreditCardUtilizationBar(cc.balance.current.utilizationPercentage)
			
			genSubSectionTitle("6 Month Balance History")
			genChart(
				values: cc.balance.historical.dates.map { $0.balance }.prefix(180).reversed(),
				tag: QIOHomeCharts.creditUtilization.rawValue,
				which: .creditUtilization,
				tappable: false
			)
		}
	}
	
	func secRainyDayFund() {
		genSectionHeader(
			"Rainy Day Fund",
			action: #selector(disclosureAction(sender:)),
			tag: QIOHomeDisclosureActions.rainyDayFunds.rawValue
		)
//		genSubSectionDescription("Ready money, just in case.")
		if
			let rdf = home.financialIndependence?.liquidCushion,
			let current = rdf.current,
			let historical = rdf.historical,
			let dates = historical.dates
		{
			genSubSectionTitle("Months Survivable Without Income")
			genMajorValue(
				current.months.asString,
				action: #selector(disclosureAction(sender:)),
				tag: QIOHomeDisclosureActions.rainyDayFunds.rawValue,
				suffix: "Mo")
			genSubvalueDisclosure(
				current.balance.toCurrencyString(includeCents: true) + " Liquid Capital",
				vSpace: 0)
			genSubSectionTitle("Balance Trend")
			genChart(
				values: dates.prefix(90).reversed().map { $0.balance },
				tag: QIOHomeCharts.rainyDay.rawValue,
				which: .rainyDay,
				tappable: false
			)
		}
	}
	
	func secFI() {
		if
			let fi = home.financialIndependence,
			let swr = fi.safeWithdrawal,
			let tc = fi.totalCapital
		{
			genSectionHeader(
				"Financial\nFreedom",
				action: #selector(disclosureAction(sender:)),
				tag: QIOHomeDisclosureActions.financialIndependence.rawValue
			)
			
			genSubSectionTitle("Safe Withdrawal Rate")
			genMajorValue(
				amount: swr/12,
				action: #selector(disclosureAction(sender:)),
				tag: QIOHomeDisclosureActions.financialIndependence.rawValue)
			genSubvalueDisclosure("Per month, based on", vSpace: 0)
			genSubvalueDisclosure(tc.toCurrencyString() + " Total Capital", vSpace: 0)
			
			if let sr = fi.savingsRate {
//				genSubSectionTitle("Savings Rate")
//				sr.potentialSavingsRate_90d
//				sr.actualSavingsRate_90d
			}
		}
	}
	
}

// MARK: - UI Generators

extension QIOHomeViewController {
	
	func genAAChart(
		values: [Double]?,
		vSpace: CGFloat = 15,
		tag: Int,
		which: QIOHomeCharts,
		tappable: Bool = true
	) {
		guard var values = values else { return }
//			print(values)
		
		// FOR DEBUGGING
		values = [Double]()
		for _ in 0...89 {
			values.append(Double.random(in: -20...20))
		}
		//			print(values)
		// FOR DEBUGGING
		
		let positiveVals = values.filter { $0 > 0}
		let negativeVals = values.filter { $0 < 0}
		var posMax = positiveVals.max() ?? 0
		var negMax = negativeVals.min() ?? 0
		
		if abs(posMax) > abs(negMax) {
			negMax = -posMax
		} else if abs(negMax) > abs(posMax) {
			posMax = -negMax
		}
		
//			let bgPositiveSet = values.map { _ in return posMax }
//			let bgNegativeSet = values.map { _ in return negMax }
		
		let chartView = AAChartView()
		chartView.frame = .zero
		chartView.translatesAutoresizingMaskIntoConstraints = false
		chartView.scrollEnabled = false
		chartView.delegate = self
		chartView.isClearBackgroundColor = true
		//			chartView.cornerRadius = 10
		//			chartView.backgroundColor = UIColor("FFF5E3")
		addModuleNew(chartView, vSpace: vSpace, bgc: .white, bottomAnchorConstant: 10)
		chartView.anchorHeight(140)
		chartView.wkWebView?.anchorLeadingToSuperview(constant: -20)
		chartView.wkWebView?.anchorTopToSuperview(constant: -20)
		chartView.wkWebView?.anchorTrailingToSuperview(constant: 20)
		chartView.wkWebView?.anchorBottomToSuperview(constant: 20)
		
		let r = AAGradientColor.gradientColorDictionary(
			direction: .toTop,
			startColor: "#ff0000",
			endColor: "#ffffff"
		)
		let g = AAGradientColor.gradientColorDictionary(
			direction: .toTop,
			startColor: "#ffffff",
			endColor: "#00ff00"
		)
		
		//			let r = "#ff3333"
		//			let g = "#33ff33"
		
		let model = AAChartModel()
			.chartType(.column)
			//				.backgroundColor(UIColor.black.hexString)
			//				.colorsTheme(["#1e90ff","#ef476f","#ffd066","#04d69f","#25547c"])
			.title("")
			.backgroundColor(UIColor.clear.hexString)
			.subtitle("")
			.legendEnabled(false)
			.tooltipEnabled(false)
			.xAxisVisible(false)
			.yAxisVisible(false)
			.marginLeft(10)
			.marginRight(10)
			.dataLabelEnabled(false)
			.touchEventEnabled(false)
			.series([
				AASeriesElement()
					.data(values)
					.zones([
						["value": 0.0, "color": r],
						["color": g]
						])
					.toDic()!
				])
			.animationType(.easeOutQuint)
			.animationDuration(1200)
		
		//					AASeriesElement()
		//						.data(bgPositiveSet)
		//						.color(UIColor.purple.hexString)
		//						.toDic()!,
		//					AASeriesElement()
		//						.data(bgNegativeSet)
		//						.color(UIColor.blue.hexString)
		//						.toDic()!
		
		let aaOptions = AAOptionsConstructor.configureAAOptions(aaChartModel: model)
		let aaYAxis = aaOptions["yAxis"] as! NSMutableDictionary
		aaYAxis["min"] = negMax
		aaYAxis["max"] = posMax
		chartView.aa_drawChartWithChartOptions(aaOptions)
		
		let v = UIView(frame: .zero)
		v.translatesAutoresizingMaskIntoConstraints = false
		v.backgroundColor = UIColor.black.withAlphaComponent(0.2)
		chartView.addSubview(v)
		v.anchorHeight(1)
		v.anchorWidthToSuperview()
		v.anchorCenterYToSuperview(constant: -2)
		
		if tappable {
			let btn = UIButton(#selector(chartTap(sender:)), tag: tag)
			chartView.addSubview(btn)
			btn.anchorToSuperview()
		}
	}
	
	func genBadge(_ which: QIOBadge) -> UIView {
		let badge = UIView(frame: .zero)
		badge.translatesAutoresizingMaskIntoConstraints = false
		
		let iv = genImage(which.imageName, withTint: .q_brandGold)
		badge.addSubview(iv)
		iv.anchorToSuperview()
		
		let btn = UIButton(#selector(badgeAction(sender:)), tag: which.rawValue)
		badge.addSubview(btn)
		btn.anchorToSuperview()
		
		return badge
	}
	
	func genCreditCardUtilizationBar(_ percentage: Double, vSpace: CGFloat = 10) {
		let barHeight: CGFloat = 36
		let bar = UIView(frame: .zero)
		bar.translatesAutoresizingMaskIntoConstraints = false
		addModuleNew(bar, vSpace: vSpace)
		bar.anchorHeight(barHeight)
		
		let bg = QIORainbowView(frame: .zero)
		let pctLbl = genLabel(
			"",
			font: baseFont(size: 18),
			textColor: .white
		)
		pctLbl.attributedText = percentage.asAttributedPercentString(fontSize: 18, smallTextSizeFactor: 2)
		pctLbl.textAlignment = .center
		bg.setPercentageIndicator(pctLbl, percentage)
		bg.translatesAutoresizingMaskIntoConstraints = false
		bg.cornerRadius = 5
		bar.addSubview(bg)
		bg.anchorLeadingTo(bar.leadingAnchor)
		bg.anchorTrailingTo(bar.trailingAnchor)
		bg.anchorHeight(barHeight)
	}
	
	func genMoneyMapBar(_ cat: QCat, vSpace: CGFloat = 6) {
		let barAnchorHeight: CGFloat = 34
		
		let emoji = cat.emoji
		let percentage = cat.percentage
		let name = cat.name
		
		let bar = UIView(frame: .zero)
		bar.translatesAutoresizingMaskIntoConstraints = false
		addModuleNew(bar, vSpace: vSpace)
		bar.anchorHeight(barAnchorHeight)
		
		let e = genLabel(emoji, font: .systemFont(ofSize: 0.8 * barAnchorHeight))
		e.translatesAutoresizingMaskIntoConstraints = false
		e.textAlignment = .center
		bar.addSubview(e)
		e.anchorLeadingTo(bar.leadingAnchor)
		let const: CGFloat = emoji == "🛫" ? -5 : 0
		e.anchorCenterYToSuperview(constant: const)
		
		let i = genImage("CaretRightSmallLight", withTint: .q_brandGoldLight)
		bar.addSubview(i)
		i.anchorTrailingTo(bar.trailingAnchor)
		i.anchorCenterYToSuperview()
		
		let bg = UIView(frame: .zero)
		bg.translatesAutoresizingMaskIntoConstraints = false
		bg.backgroundColor = UIColor.q_brandGoldLight.withAlphaComponent(0.3)
		bg.cornerRadius = 5
		bg.clipsToBounds = true
		bar.addSubview(bg)
		let spacing: CGFloat = 0.4 * barAnchorHeight
		bg.anchorLeadingTo(e.trailingAnchor, constant: spacing)
		bg.anchorTrailingTo(i.leadingAnchor, constant: -spacing)
		bg.anchorHeight(h: bar.heightAnchor)
		
		let fg = UIView(frame: .zero)
		fg.translatesAutoresizingMaskIntoConstraints = false
		fg.backgroundColor = .q_brandGold
		fg.cornerRadius = 5
		bg.addSubview(fg)
		fg.anchorLeadingTo(bg.leadingAnchor)
		fg.widthAnchor.constraint(equalTo: bg.widthAnchor, multiplier: percentage.asCGFloat).activate()
		fg.anchorHeight(h: bg.heightAnchor)
		
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
		
		let pct = genLabel(
			percentage.toStringPercent(1, includePercentSign: true),
			font: baseFont(size: 13),
			textColor: UIColor.black.withAlphaComponent(0.7)
		)
		blurView.contentView.addSubview(pct)
		pct.anchorLeadingTo(blurView.contentView.leadingAnchor, constant: 10)
		pct.anchorHeight(h: blurView.contentView.heightAnchor)
		pct.anchorCenterYToSuperview()
		
		let nm = genLabel(
			name,
			font: baseFont(size: 13),
			textColor: UIColor("686868").withAlphaComponent(0.7),
			alignment: .right
		)
		nm.translatesAutoresizingMaskIntoConstraints = false
		blurView.contentView.addSubview(nm)
		nm.anchorTrailingTo(bg.trailingAnchor, constant: -10)
		nm.anchorHeight(h: bg.heightAnchor)
		nm.anchorCenterYToSuperview()
		
		let btn = UIButton(#selector(mapBarAction(sender:)), tag: cat.id)
		bar.addSubview(btn)
		btn.anchorToSuperview()
	}
	
	@discardableResult
	func genFlowToggle(vSpace: CGFloat = 20, inView: UIView? = nil) -> UIView {
		let toggleH: CGFloat = 24
		
		let base = UIView(frame: .zero)
		base.translatesAutoresizingMaskIntoConstraints	= false
		if let inView = inView {
			inView.addSubview(base)
		} else {
			addModuleNew(base, vSpace: vSpace, bgc: .white)
		}
		base.anchorHeight(toggleH)
		
		// Toggle
		let toggleParent = UIView(frame: .zero)
		toggleParent.backgroundColor = .q_F0
		toggleParent.cornerRadius = 5
		if colorful { toggleParent.backgroundColor = .randomP3 }
		toggleParent.translatesAutoresizingMaskIntoConstraints = false
		base.addSubview(toggleParent)
		toggleParent.anchorSizeConstant(182, toggleH)
		toggleParent.anchorLeadingToSuperview()
		toggleParent.anchorTopToSuperview()
		
		let b1 = UIButton(#selector(toggleDayMonthAction(sender:)), title: "Daily", tag: 1)
		b1.backgroundColor = .clear
		b1.titleLabel?.font = baseFont(size: 13)
		b1.setTitleColor(.white, for: .normal)
		toggleParent.addSubview(b1)
		b1.anchorTopTo(toggleParent.topAnchor)
		b1.anchorLeadingTo(toggleParent.leadingAnchor)
		b1.anchorSizeConstant(86, toggleH)
		dailyButton = b1
		
		let b2 = UIButton(#selector(toggleDayMonthAction(sender:)), title: "Monthly", tag: 2)
		b2.backgroundColor = .clear
		b2.titleLabel?.font = baseFont(size: 13)
		b2.setTitleColor(.q_C0, for: .normal)
		toggleParent.addSubview(b2)
		b2.anchorTopTo(toggleParent.topAnchor)
		b2.anchorLeadingTo(b1.trailingAnchor, constant: 10)
		b2.anchorSizeConstant(86,  toggleH)
		monthlyButton = b2
		
		let slider  = UIView(frame: .zero)
		slider.translatesAutoresizingMaskIntoConstraints = false
		slider.backgroundColor = .q_brandGold // UIColor("DC23F2")
		toggleParent.insertSubview(slider, belowSubview: b1)
		slider.anchorTopTo(toggleParent.topAnchor)
		slider.anchorLeadingTo(toggleParent.leadingAnchor)
		slider.anchorWidth(w: b1.widthAnchor)
		slider.anchorHeight(h: b1.heightAnchor)
		slider.cornerRadius = 5
		slider.borderColor = UIColor("F6B000")
		slider.borderWidth = 0.5
		self.slider = slider
		
		return base
	}
	
	@discardableResult
	func genFlowBar(
		name: String,
		amount: Double,
		periodTitle: String,
		daily: Bool = true,
		action: Selector? = nil,
		tag: Int = 0,
		vSpace: CGFloat = 6,
		plus: Bool = false
	) -> UIView {
		let barAnchorHeight: CGFloat = 44
		
		let bar = UIView(frame: .zero)
		bar.translatesAutoresizingMaskIntoConstraints = false
		addModuleNew(bar, vSpace: vSpace)
		bar.anchorHeight(barAnchorHeight)
		
		let i = genImage("CaretRightSmallLight", withTint: .q_brandGoldLight)
		i.contentMode = .scaleAspectFill
		bar.addSubview(i)
		i.anchorTrailingTo(bar.trailingAnchor)
		i.anchorCenterYToSuperview()
		i.anchorHeight(18)
		
		let iv = genImage(
			plus ? "add-circle" : "subtract-circle",
			withTint: .q_38)
		iv.contentMode = .scaleAspectFit
		bar.addSubview(iv)
		iv.anchorCenterYToSuperview()
		iv.anchorLeadingToSuperview(constant: 4)
		
		let amountLbl = genMoneyLabel(
			amount,
			baseTextSize: 22
		)
		//		amountLbl.backgroundColor = .green
		bar.addSubview(amountLbl)
		amountLbl.anchorLeadingTo(iv.trailingAnchor, constant: 15)
		amountLbl.anchorCenterYToSuperview()
		
		let nameLbl = genLabel(name, font: baseFont(size: 13))
		nameLbl.setLineSpacing(-10)
		bar.addSubview(nameLbl)
		nameLbl.anchorLeadingTo(amountLbl.trailingAnchor, constant: 25)
		nameLbl.anchorCenterYToSuperview()
		
		let period = genLabel(
			periodTitle,
			font: baseFont(size: 13, bold: false),
			textColor: UIColor("686868").withAlphaComponent(0.7),
			alignment: .right
		)
		period.translatesAutoresizingMaskIntoConstraints = false
		bar.addSubview(period)
		period.anchorTrailingTo(i.leadingAnchor, constant: -24)
		period.anchorCenterYToSuperview()
		
		let bg = UIView(frame: .zero)
		bg.translatesAutoresizingMaskIntoConstraints = false
		bg.backgroundColor = UIColor("FFF5E3")
		bg.cornerRadius = 6
		bar.insertSubview(bg, at: 0)
		bg.anchorLeadingTo(nameLbl.leadingAnchor, constant: -10)
		bg.anchorTrailingTo(i.leadingAnchor, constant: -14)
		bg.anchorHeight(h: bar.heightAnchor)
		
		if let a = action {
			let btn = UIButton(a, tag: tag)
			bar.addSubview(btn)
			btn.anchorToSuperview()
		}
		
		return bar
	}
	
	func flowVal(
		name: String,
		amount: Double,
		action: Selector,
		tag: Int
	) -> FlowSectionSubValue {
		let out = UIView(frame: .zero)
		out.translatesAutoresizingMaskIntoConstraints = false
		
		let n = genLabel(
			name,
			font: baseFont(size: 17, bold: false),
			textColor: .q_C0)
		out.addSubview(n)
		n.anchorTopToSuperview()
		n.anchorSidesToSuperview()
		
		let a = genMoneyLabel(
			amount,
			baseTextSize: 24,
			bold: false)
		out.addSubview(a)
		a.anchorTopTo(n.bottomAnchor, constant: 4)
		a.anchorSidesToSuperview()
		
		let btn = UIButton(action, tag: tag)
		out.addSubview(btn)
		btn.anchorToSuperview()
		
		return (view: out, titleLbl: n, valueLbl: a)
	}

}

// MARK: - Chart Delegate

extension QIOHomeViewController: AAChartViewDelegate {
	
	func aaChartViewDidFinishedLoad() {
		print("🙂🙂🙂, AAChartView Did Finished Load!!!")
	}
	
	func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
		print(
			"""

			selected point series element name: \(moveOverEventMessage.name ?? "")
			🔥🔥🔥WARNING!!!!!!!!!!!!!!!!!!!! Touch Event Message !!!!!!!!!!!!!!!!!!!! WARNING🔥🔥🔥
			------------------------------------------------------------------------------------------
			user finger moved over!!!,get the move over event message: {
			category = \(String(describing: moveOverEventMessage.category));
			index = \(String(describing: moveOverEventMessage.index));
			name = \(String(describing: moveOverEventMessage.name));
			offset = \(String(describing: moveOverEventMessage.offset));
			x = \(String(describing: moveOverEventMessage.x));
			y = \(String(describing: moveOverEventMessage.y));
			}
			------------------------------------------------------------------------------------------
			🔥🔥🔥WARNING!!!!!!!!!!!!!!!!!!!! Touch Event Message !!!!!!!!!!!!!!!!!!!! WARNING🔥🔥🔥

			"""
		)
	}

}

// MARK: - UIScrollViewDelegate

extension QIOHomeViewController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		print(scrollView.contentOffset.y)
		guard let c = caret else { return }
		if scrollView.contentOffset.y <= 0 {
			if c.alpha == 0 {
//				print("Starting caret show animation")
				UIView.animate(withDuration: 0.3) {
					c.alpha = self.MAX_CARET_ALPHA.asCGFloat
				}
			}
		} else {
			if c.alpha.asDouble.roundToDecimal(1) == self.MAX_CARET_ALPHA {
//				print("Starting caret hide animation")
				UIView.animate(withDuration: 0.3) {
					c.alpha = 0
				}
			}
		}
	}
	
}

// MARK: - Classes / Structs / Enums

enum QIOBadge: Int {
	
	case livingProfitably
	case healthyMoneyRental
	case healthySavingsBuffer
	case achievedFinancialFreedom
	
	var asString: String {
		return "\(self)"
	}
	
	var imageName: String {
		switch self {
		case .achievedFinancialFreedom: return "badge-1"
		case .healthyMoneyRental: return "badge-3"
		case .healthySavingsBuffer: return "badge-2"
		case .livingProfitably: return "badge-4"
		}
	}

}

enum QIOHomeDisclosureActions: Int {
	
	case primaryNetValue
	case flow
	case significantSpending
	case rainyDayFunds
	case financialIndependence
	case moneyRental
	case standardDay
	case income
	case baseLivingExpenses
	case generalSpending
	
	var asString: String {
		return "\(self)"
	}
	
}
