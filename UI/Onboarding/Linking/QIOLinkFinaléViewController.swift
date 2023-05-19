//
//  QIOLinkFinaléViewController.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 4/19/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOLinkFinaleViewController: QIOBaseViewController, IQIOBaseVC {

	// MARK: - Properties
	
	private var completion: QIOSimpleCompletion?
	private var haveFresh_userHome: Bool = false
	private var haveFresh_dayFlow: Bool = false
	private var viewMoneyMap: FIOControlMoneyMap = .fromNib()
	private var continueButton: UIButton?

	// MARK: - View Lifecycle
	
	convenience init(_ c: QIOSimpleCompletion?) {
		self.init()
		self.completion = c
	}

	override func loadView() {
		QMix.track(.viewLinkingQuantizeFinale)
		customTitle = "⚡️  Your Quantized Financials  ⚡️"
		navigationItem.setHidesBackButton(true, animated: false)
		navigationController?.setNavBarVisible()
		super.loadView()
	}

	// MARK: - Data Pull
	
	private func pullFreshObjects() {
		QFlow.pullUserHome(forcePullFromSource: true) { result, error in
			print("Got userHome")
			self.haveFresh_userHome = true
			if self.haveFresh_userHome && self.haveFresh_dayFlow { self.buildUI() }
		}
		QFlow.getThatFlow(windowSize: .day, forcePullFromSource: true) { result, nextToken in
			print("Got day flow")
			self.haveFresh_dayFlow = true
			if self.haveFresh_userHome && self.haveFresh_dayFlow { self.buildUI() }
		}
	}
	
	// MARK: - Actions
	
	@objc func plaidLinkAction() {
		// FIXME: probably need to dismiss the current nav stack in this action
		if let c = self.completion { c() }
		plaidLink()
	}
	
	@objc func contactAction() {
		AppDelegate.sharedInstance.contactActionSheet()
	}
	
	@objc func continueAction() {
		if let nc = navigationController {
			nc.pushViewController(QIONotifPermissonViewController(completion), animated: true)
		} else if let nc = AppDelegate.sharedInstance.navigationController {
			nc.pushViewController(QIONotifPermissonViewController(completion), animated: true)
		}
	}
	
	func disclosureAction(sender: UIButton) {
		
	}

	// MARK: - UI
	
	override func buildUI() {
		guard haveFresh_userHome && haveFresh_dayFlow else {
			pullFreshObjects()
			return
		}
		secLinkLogos()
		secSummarizeLinks()
		secFlow()
		secIncome()
		spendingModule()
		secMoneyRental()
		secFI()
		secFinal()
		secContinueButton()
		super.buildComplete()
	}
	
	private func secLinkLogos() {
		let c = QIOLinkLogoCollection(
			home.items!,
			includeAddButton: false
		)
//		c.backgroundColor = .randomP3
		addModuleNew(c, vSpace: 14)
		c.layoutIfNeeded() // crucial, or next line doesn't work
		c.anchorHeight(c.collectionViewLayout.collectionViewContentSize.h)
	}
	
	private func secSummarizeLinks() {
		if
			let accounts = home.accounts,
			let transactionOverview = home.transactionOverview,
			let items = home.items
		{
			let lv = majorValue(
				value: items.count.asString,
				title: "LINK".pluralize(items).uppercased(),
				textColor: .q_38,
				valueFont: baseFont(size: 24, bold: true))
			lv.frame = .zero
			lv.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(lv, vSpace: 20)
			lv.anchorHeight(lv.subviewBottomY)

			let av = majorValue(
				value: accounts.count.asString,
				title: "ACCOUNT".pluralize(accounts).uppercased(),
				textColor: .q_38,
				valueFont: baseFont(size: 24, bold: true))
			av.frame = .zero
			av.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(av, vSpace: 20)
			av.anchorHeight(av.subviewBottomY)
			
			let tv = majorValue(
				value: transactionOverview.transactionCount.asFormattedString!,
				title: "TRANSACTION".pluralize(transactionOverview.transactionCount).uppercased(),
				textColor: .q_38,
				valueFont: baseFont(size: 24, bold: true))
			tv.frame = .zero
			tv.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(tv, vSpace: 20)
			tv.anchorHeight(tv.subviewBottomY)

			let depositSum = majorValue(
				value: transactionOverview.totalIn.toCurrencyString(),
				title: "TOTAL IN",
				valueFont: baseFont(size: 24, bold: true))
			depositSum.frame = .zero
			depositSum.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(depositSum, vSpace: 20)
			depositSum.anchorHeight(depositSum.subviewBottomY)
			
			let debitSum = majorValue(
				value: transactionOverview.totalOut.toCurrencyString(),
				title: "TOTAL OUT",
				valueFont: baseFont(size: 24, bold: true))
			debitSum.frame = .zero
			debitSum.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(debitSum, vSpace: 20)
			debitSum.anchorHeight(debitSum.subviewBottomY)

			let oldest = majorValue(
				value: transactionOverview.oldestTransactionDate.YYYYMMDDtoFriendlyString(.long),
				title: "Oldest Transaction",
				valueFont: baseFont(size: 24, bold: true))
			oldest.frame = .zero
			oldest.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(oldest, vSpace: 20)
			oldest.anchorHeight(oldest.subviewBottomY)
		}
	}
	
	private func secFlow() {
		if
			let dailyFlow = QFlow.flowDays,
			let yesterday = dailyFlow.first,
			let transactions = yesterday.periodSummary.transactions,
			let debits = transactions.debits,
			let deposits = transactions.deposits
		{
			genSectionHeader("Yesterday", includeSpacer: true)
			
			let count = debits.transactionIds.count + deposits.transactionIds.count
			let tx = majorValue(
				value: yesterday.periodSummary.netAmount.toCurrencyString(includeCents: true),
				title: count.asString + " Transaction".pluralize(count).uppercased(),
				addTick: true,
				tickUp: yesterday.periodSummary.netAmount > 0,
				valueFont: baseFont(size: 24, bold: true))
			tx.frame = .zero
			tx.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(tx, vSpace: 20)
			tx.anchorHeight(tx.subviewBottomY)
		}
	}

	private func secIncome() {
		if
			let income = home.income,
			let activeStreams = income.activeStreams
		{
			genSectionHeader("Income", includeSpacer: true)

			let mv = majorValue(
				value: income.summary.activeDailyEstimate.toCurrencyString(includeCents: true),
				title: "STANDARD DAY'S INCOME",
				textColor: .q_38,
				valueFont: baseFont(size: 24, bold: true))
			mv.frame = .zero
			mv.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(mv, vSpace: 20)
			mv.anchorHeight(mv.subviewBottomY)

			if income.summary.activeDailyEstimate > 0 {
				let stv = labelGenerator(
					"From:",
					font: baseFont(size: 18, bold: true),
					textColor: .q_38,
					alignment: .center,
					kerning: 0)
				stv.translatesAutoresizingMaskIntoConstraints = false
				addModuleNew(stv, vSpace: 20)
				stv.anchorHeight(stv.h)
				stv.anchorCenterXToSuperview()
				stv.frame = .zero

				activeStreams.forEach {
					let sstv = labelGenerator(
						$0.nameFriendly.prefixToLength(22),
						font: baseFont(size: 24, bold: false),
						textColor: .q_38,
						alignment: .center,
						kerning: 0)
					sstv.translatesAutoresizingMaskIntoConstraints = false
					addModuleNew(sstv, vSpace: 5)
					sstv.anchorHeight(sstv.h)
					sstv.anchorCenterXToSuperview()
					sstv.frame = .zero
				}
			}
		}
	}

	private func spendingModule() {
		if
			let spending = home.spending,
			let ss = spending.quantized
		{
			genSectionHeader("Spending", includeSpacer: true)
			
			let mv = majorValue(
				value: spending.daily.averageAmount.toCurrencyString(includeCents: false),
				title: "STANDARD DAY'S SPEND",
				textColor: .q_38,
				valueFont: baseFont(size: 24, bold: true))
			mv.frame = .zero
			mv.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(mv, vSpace: 20)
			mv.anchorHeight(mv.subviewBottomY)
			
			viewMoneyMap.model = FIOCategories(uhs: spending.categories)
			let iv = UIImageView(frame: .zero)
			iv.translatesAutoresizingMaskIntoConstraints = false
			iv.contentMode = .scaleAspectFit
			iv.image = viewMoneyMap.screenshot()
			addModuleNew(iv, vSpace: 10)
			iv.anchorCenterXToSuperview()
			iv.anchorSizeConstantSquare(moduleWidth-40)
			
			let s1 = labelGenerator(
				ss.count.asString + " Recurring Spending Stream".pluralize(ss),
				font: baseFont(size: 18, bold: false),
				textColor: .q_38,
				alignment: .center,
				kerning: 0)
			s1.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(s1, vSpace: 10)
			s1.anchorHeight(s1.h)
			s1.anchorCenterXToSuperview()
			s1.frame = .zero

//			let s2 = simpleTextView("<Base Monthly Spend>")
//			s2.translatesAutoresizingMaskIntoConstraints = false
//			addModuleNew(s2, vSpace: 10)
//			s2.anchorHeight(s2.h)
//			s2.frame = .zero
		}
	}
	
	private func secMoneyRental() {
		if
			let moneyRental = home.moneyRental,
			let creditCards = moneyRental.creditCards
		{
			genSectionHeader("Money Rental", includeSpacer: true)

			let dm = majorValue(
				value: creditCards.rent.averagePerDay.toCurrencyString(includeCents: true),
				title: "DAILY MONEY RENT",
				textColor: .q_38,
				valueFont: baseFont(size: 24, bold: true))
			dm.frame = .zero
			dm.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(dm, vSpace: 20)
			dm.anchorHeight(dm.subviewBottomY)

			let costOfADollar = majorValue(
				value: creditCards.costOfOneDollar.toCurrencyString(includeCents: true),
				title: "Cost of $1",
				valueFont: baseFont(size: 24, bold: true))
			costOfADollar.frame = .zero
			costOfADollar.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(costOfADollar, vSpace: 20)
			costOfADollar.anchorHeight(costOfADollar.subviewBottomY)

			let totalBalance = majorValue(
				value: creditCards.balance.current.total.toCurrencyString(),
				title: "Total Balance",
				valueFont: baseFont(size: 24, bold: true))
			totalBalance.frame = .zero
			totalBalance.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(totalBalance, vSpace: 20)
			totalBalance.anchorHeight(totalBalance.subviewBottomY)

//			let utilization = UIView(frame: CGRect(x: 0, y: 0, width: 120.0, height: 120.0))
//			utilization.translatesAutoresizingMaskIntoConstraints = false
//			utilization.clipsToBounds = true
//			let viewGauge: FIOViewGradientGauge = .fromNib()
//			viewGauge.frame = utilization.bounds.insetBy(dx: 8.0, dy: 8.0)
//			viewGauge.translatesAutoresizingMaskIntoConstraints = false
//			utilization.addSubview(viewGauge)
//			viewGauge.y += 4
//			viewGauge.scaleIndicator()
//			viewGauge.setupForCreditCards(min(creditCards.balance.current.utilizationPercentage * 100, 100))
//			viewGauge.addTitle("Utilization")
//			addModuleNew(utilization)
//			utilization.anchorSizeConstantSquare(utilization.w)
//			utilization.frame = .zero
		}
	}

	private func secFI() {
		if
			let fi = home.financialIndependence,
			let lc = fi.liquidCushion,
			let swr = fi.safeWithdrawal,
			let tc = fi.totalCapital,
			let lcc = lc.current
		{
			genSectionHeader("Financial Independence", includeSpacer: true)
			
			let dm = majorValue(
				value: tc.toCurrencyString(includeCents: false),
				title: "TOTAL CAPITAL",
				textColor: .q_38,
				valueFont: baseFont(size: 24, bold: true))
			dm.frame = .zero
			dm.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(dm, vSpace: 20)
			dm.anchorHeight(dm.subviewBottomY)

			let swr = majorValue(
				value: swr.toCurrencyString(includeCents: false),
				title: "@ 4% S.W.R.",
				textColor: .q_38,
				valueFont: baseFont(size: 24, bold: true))
			swr.frame = .zero
			swr.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(swr, vSpace: 20)
			swr.anchorHeight(swr.subviewBottomY)

			let liquid = majorValue(
				value: lcc.balance.toCurrencyString(includeCents: false),
				title: "Liquid\nCapital",
				textColor: .q_38,
				valueFont: baseFont(size: 24, bold: true))
			liquid.frame = .zero
			liquid.translatesAutoresizingMaskIntoConstraints = false
			addModuleNew(liquid, vSpace: 20)
			liquid.anchorHeight(liquid.subviewBottomY)

//			let cushion = UIView(frame: CGRect(x: 0, y: 0, width: 120.0, height: 120.0))
//			cushion.translatesAutoresizingMaskIntoConstraints = false
//			cushion.backgroundColor = .randomP3
//			let viewGauge: FIOViewGradientGauge = .fromNib()
//			viewGauge.translatesAutoresizingMaskIntoConstraints = false
//			cushion.clipsToBounds = true
////			viewGauge.frame = cushion.bounds.insetBy(dx: 8.0, dy: 8.0)
//			viewGauge.frame = .zero
//			cushion.addSubview(viewGauge)
//			viewGauge.anchorSizeConstantSquare(cushion.w)
//			viewGauge.anchorCenterXToSuperview()
//			viewGauge.scaleIndicator()
//			viewGauge.setupForRainyDay(min(lcc.monthsAsPercentage * 100, 100))
//			viewGauge.addTitle("Cushion\nMonths")
//			viewGauge.backgroundColor = .randomP3
//			addModuleNew(cushion, vSpace: 20)
//			cushion.anchorSizeConstantSquare(cushion.w)
//			cushion.frame = .zero
		}
	}

	private func secFinal() {
		
		let l1 = UILabel(frame: .zero)
		l1.translatesAutoresizingMaskIntoConstraints = false
		l1.text = "Have more accounts?"
		l1.textAlignment = .center
		l1.font = baseFont(size: 15, bold: false)
		l1.font = l1.font.italic
		l1.textColor = .darkGray
		l1.sizeToFit()
		addModuleNew(l1, vSpace: 30)
		l1.anchorCenterXToSuperview()
		l1.anchorSizeToOwnFrame()
		l1.frame = .zero

		let l4 = UILabel(frame: .zero)
		l4.translatesAutoresizingMaskIntoConstraints = false
		l4.text = "Bank  |  Investment  |  Credit Card".uppercased()
		l4.textAlignment = .center
		l4.kerning = 2.0
		l4.font = baseFont(size: 9, bold: true)
		l4.textColor = .white
		l4.sizeToFit()

		let b1 = UIButton(frame: .zero)
		b1.translatesAutoresizingMaskIntoConstraints = false
		b1.cornerRadius = 8.0
		b1.setTitle("", for: .normal)
		b1.backgroundColor = UIColor.q_buttonBlue
		b1.titleLabel?.font = baseFont(size: 18, bold: true)
		b1.addTarget(self, action: #selector(plaidLinkAction), for: .touchUpInside)
		addModuleNew(b1, vSpace: 10, anchorSides: false)
		b1.anchorCenterXToSuperview()
		b1.anchorSizeConstant(l4.w + 32, 70)

		b1.addSubview(l4)
		l4.anchorCenterXToSuperview()
		l4.anchorSizeToOwnFrame()
		l4.anchorBottomTo(b1.bottomAnchor, constant: -11)
		l4.frame = .zero

		let l5 = UILabel(frame: .zero)
		l5.translatesAutoresizingMaskIntoConstraints = false
		l5.text = "Link Another"
		l5.textAlignment = .center
		l5.kerning = 2.0
		l5.font = baseFont(size: 18, bold: true)
		l5.textColor = .white
		l5.sizeToFit()
		b1.addSubview(l5)
		l5.anchorSizeToOwnFrame()
		l5.frame = .zero
		l5.anchorCenterXToSuperview()
		l5.anchorTopTo(b1.topAnchor, constant: 15)

		let l2 = UILabel(frame: .zero)
		l2.translatesAutoresizingMaskIntoConstraints = false
		l2.text = "See something incorrect?"
		l2.textAlignment = .center
		l2.font = baseFont(size: 15, bold: false)
		l2.font = l2.font.italic
		l2.textColor = .darkGray
		l2.sizeToFit()
		addModuleNew(l2, vSpace: 20)
		l2.anchorCenterXToSuperview()
		l2.anchorSizeToOwnFrame()
		l2.frame = .zero

		let b2 = UIButton(frame: .zero)
		b2.translatesAutoresizingMaskIntoConstraints = false
		b2.cornerRadius = 8.0
		b2.setTitle("Get In Touch", for: .normal)
		b2.backgroundColor = UIColor.q_buttonBlue
		b2.titleLabel?.font = baseFont(size: 18, bold: true)
		b2.addTarget(self, action: #selector(contactAction), for: .touchUpInside)
		addModuleNew(b2, vSpace: 10, anchorSides: false)
		b2.anchorCenterXToSuperview()
		b2.anchorSizeConstant(180, 44)
		
		spacer(view.layoutMargins.bottom + (continueButton?.h ?? 0) + 30) // make room for continue button to breathe
	}

	private func secContinueButton() {
		continueButton = addContinueButton(
			selector: #selector(continueAction),
			onObj: self,
			startDisabled: false)
	}

}
