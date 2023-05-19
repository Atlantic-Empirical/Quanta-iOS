//
//  QIOUIGenerator.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/29/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

// MARK: - Module Internal Elements

func moduleFreedomSummaryItem(title: String, unlocked: Bool) -> UIView {
	let f = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 30))
	if colorful { f.backgroundColor = .randomP3 }
	
	let main = labelGenerator(
		title.uppercased(),
		font: .systemFont(ofSize: 16, weight: .medium),
		textColor: .black,
		alignment: .right,
		kerning: 0
	)
	if colorful { main.backgroundColor = .randomP3 }
	main.frame = CGRect(x: 10, y: 2, width: 186, height: 30)
	f.addSubview(main)
	
	let emoji = labelGenerator(
		unlocked ? "✅" : "🔒",
		font: .systemFont(ofSize: 22),
		alignment: .right
	)
	if colorful { emoji.backgroundColor = .randomP3 }
	emoji.frame = CGRect(x: main.x_right + 7, y: 0, width: 28, height: 30)
	f.addSubview(emoji)
	
	return f
}

// MARK: - Raw Elements

func genLabel2(
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

func labelGenerator(
	_ text: String,
	font: UIFont = baseFont(size: 15, bold: false),
	textColor: UIColor = .q_38,
	alignment: NSTextAlignment = .center,
	kerning: CGFloat = 0,
	maxWidth: CGFloat = 0
) -> UILabel {
	let lbl = UILabel(frame: .zero) // Size is set below, origin must be set later
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

func disclosureBox(
	title: String,
	subtitle: String? = nil,
	thirdTitle: String? = nil,
	atY: CGFloat = 0.0,
	forcedWidth: CGFloat = 230.0,
	actionTarget: Selector? = nil,
	tag: Int = 0
) -> UIView {
	let box = UIView(frame: CGRect(x: 0, y: 0, width: forcedWidth, height: 30.0))
	box.translatesAutoresizingMaskIntoConstraints = false
	if colorful { box.backgroundColor = .randomP3 }
	box.cornerRadius = 4.0
	box.borderColor = .q_97
	box.borderWidth = 1.0
	
	let titleLbl = UILabel(frame: CGRect(x: 10.0, y: 4.0, width: forcedWidth, height: 25.0))
	titleLbl.text = title
	titleLbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
	titleLbl.textColor = .black
	box.addSubview(titleLbl)
	
	let disclosureIndicator = UIImageView(image: UIImage(named: "DisclosureIndicator"))
	disclosureIndicator.frame = CGRect(x: box.frame.width - 8.0 - 10.0, y: 0.0, width: 8.0, height: 13.0)
	box.addSubview(disclosureIndicator)
	
	if let st = subtitle {
		let subtitleLbl = UILabel(frame: CGRect(x: 10.0, y: 22.0, width: forcedWidth, height: 25.0))
		subtitleLbl.text = st
		subtitleLbl.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
		subtitleLbl.textColor = .q_97
		box.addSubview(subtitleLbl)
		box.frame = CGRect(origin: box.frame.origin, size: CGSize(width: box.frame.width, height: 50.0))
	} else {
		titleLbl.center.y = box.center.y
	}
	
	if let tt = thirdTitle {
		let thirdTitleLbl = UILabel(frame: CGRect(x: box.w - 32 - 100, y: 0.0, width: 100.0, height: 25.0))
		thirdTitleLbl.center.y = box.h / 2
		thirdTitleLbl.text = tt
		thirdTitleLbl.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
		thirdTitleLbl.textColor = .q_97
		thirdTitleLbl.textAlignment = .right
		box.addSubview(thirdTitleLbl)
	}
	
	disclosureIndicator.center.y = box.center.y
	
	let frame = UIView(frame: CGRect(x: 0, y: atY, width: forcedWidth, height: box.frame.height))
	frame.addSubview(box)
	box.center.x = frame.center.x
	
	if let at = actionTarget {
		let btn = UIButton(frame: box.frame)
		btn.addTarget(nil, action: at, for: .touchUpInside)
		btn.tag = tag
		frame.addSubview(btn)
	}
	
	return frame
}

/// For use with constraints
func qSpinner(color: UIColor = .q_brandGold, centerPoint: CGPoint = .zero) -> UIActivityIndicatorView {
	let out = UIActivityIndicatorView(style: .whiteLarge)
	if centerPoint != .zero {
		out.center = centerPoint
	} else {
		out.translatesAutoresizingMaskIntoConstraints = false
	}
	out.color = color
	out.hidesWhenStopped = true
	out.startAnimating()
	return out
}

func minorValue(
	value: String,
	valueAmount: Double? = nil,
	title: String,
	atY: CGFloat = 0,
	addTick: Bool = false,
	numericValue: Double? = nil,
	valueFont: UIFont? = baseFont(size: 28),
	titleFont: UIFont? = baseFont(size: 15, bold: false),
	minimumWidth: CGFloat = 80.0,
	suffix: String? = nil,
	maximumWidth: CGFloat = 0
) -> UIView {
	let frame = UIView(frame: CGRect(x: 0, y: atY, width: max(140, maximumWidth), height: 70))
	frame.translatesAutoresizingMaskIntoConstraints = false
	frame.clipsToBounds = false
	if colorful { frame.backgroundColor = .randomP3 }
	
	let lblValue = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
	if colorful { lblValue.backgroundColor = .randomP3 }

	if let valueAmount = valueAmount {
		lblValue.attributedText = valueAmount.asAttributedCurrencyString(fontSize: 28)
	} else {
		lblValue.text = value
	}

	lblValue.font = valueFont
	lblValue.kerning = 0.0
	lblValue.textColor = .q_38
	lblValue.textAlignment = .center
	lblValue.sizeToFit()
	frame.addSubview(lblValue)
	
	if addTick {
		let imgTickProj = UIImageView(frame: CGRect(x: lblValue.x - 32, y: 0, width: 20.0, height: 20.0))
		imgTickProj.contentMode = .scaleAspectFit
		imgTickProj.center.y = lblValue.center.y
		frame.addSubview(imgTickProj)
		if let valNum = numericValue {
			if valNum == 0 {
			} else if valNum > 0.0 {
				imgTickProj.image = UIImage(named: "Up Box Black")
			} else { // negative
				imgTickProj.image = UIImage(named: "Down Box Black")
			}
		}
	}
	
	var lblPercentSign: UILabel?
	if let suf = suffix {
		lblPercentSign = UILabel(frame: CGRect(x: lblValue.x_right + 14, y: lblValue.y_bottom - 20.0, width: 50.0, height: 14.0))
		if let lblPercentSign = lblPercentSign {
			if colorful { lblPercentSign.backgroundColor = .randomP3 }
			lblPercentSign.text = suf
			lblPercentSign.font = UIFont.systemFont(ofSize: 14, weight: .bold)
			//			lblPercentSign.kerning = 0.0
			lblPercentSign.textColor = .black
			lblPercentSign.textAlignment = .left
			frame.addSubview(lblPercentSign)
		}
	}
	
	let titleLine = UIView(frame: CGRect(
		x: 0,
		y: lblValue.y_bottom + 4,
		width: max(frame.w, minimumWidth),
		height: 1.0
	))
	titleLine.backgroundColor = .black
	frame.addSubview(titleLine)
	
	let lblTitle = UILabel(frame: CGRect(
		x: 0,
		y: titleLine.y_bottom + 6,
		width: max(frame.w, minimumWidth),
		height: 16.0
	))
	if colorful { lblTitle.backgroundColor = .randomP3 }
	lblTitle.text = title.uppercased()
	lblTitle.font = titleFont
	lblTitle.kerning = 2.0
	lblTitle.textColor = .q_53
	lblTitle.textAlignment = .center
	lblTitle.lineBreakMode = .byWordWrapping
	lblTitle.numberOfLines = 0
	let s = lblTitle.sizeThatFits(CGSize(width: titleLine.w, height: CGFloat.greatestFiniteMagnitude))
	lblTitle.frame = CGRect(origin: lblTitle.frame.origin, size: s)
	lblTitle.center.x = titleLine.center.x
	frame.addSubview(lblTitle)
	
	// Set the overall width to that of the wider label
	let titleTextRect = lblTitle.textRect(forBounds: lblTitle.bounds, limitedToNumberOfLines: 1)
	let newWidth: CGFloat = CGFloat.maximum(CGFloat.maximum(titleTextRect.w, lblValue.w), minimumWidth)
	frame.w = newWidth
	titleLine.w = newWidth
	titleLine.center.x = newWidth / 2
	lblValue.center.x = newWidth / 2
	if let lblPercentSign = lblPercentSign { lblPercentSign.x = lblValue.x_right + 3.0 }
	lblTitle.center.x = newWidth / 2
	
	frame.h = frame.subviewBottomY
	return frame
}

func subminorValue(
	value: String,
	title: String,
	minimumWidth: CGFloat = 80.0
) -> UIView {
	return minorValue(
		value: value,
		title: title,
		valueFont: .systemFont(ofSize: 20.0, weight: .semibold),
		titleFont: .systemFont(ofSize: 13.0, weight: .medium),
		minimumWidth: minimumWidth
	)
}

func moduleTitleSubtitle(
	_ title: String? = nil,
	_ subtitle: String? = nil,
	condensedTitle: Bool = false,
	titleY: CGFloat = 24.0,
	uppercaseSubtitle: Bool = true,
	width: CGFloat
) -> UIView {
	let out = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0))
	if colorful { out.backgroundColor = .randomP3 }
	if let title = title {
		let titleLbl = UILabel(frame: CGRect(x: 0, y: titleY, width: out.w, height: 30.0))
		if colorful { titleLbl.backgroundColor = .randomP3 }
		titleLbl.text = title.uppercased()
		titleLbl.font = .systemFont(ofSize: 24, weight: .semibold)
		if condensedTitle { titleLbl.font = titleLbl.font.compact }
		titleLbl.kerning = 2.0
		titleLbl.textColor = .black
		titleLbl.textAlignment = .center
		titleLbl.numberOfLines = 0
		titleLbl.lineBreakMode = .byWordWrapping
		titleLbl.sizeToFit()
		titleLbl.center.x = out.w/2
		out.addSubview(titleLbl)
		
		let textRect: CGRect = titleLbl.textRect(forBounds: titleLbl.bounds, limitedToNumberOfLines: 1)
		let titleLine = UIView(frame: CGRect(
			x: 0,
			y: titleLbl.y_bottom + 8.0,
			width: max(textRect.width, 240),
			height: 1.0
		))
		titleLine.center.x = titleLbl.center.x
		titleLine.backgroundColor = .black
		out.addSubview(titleLine)
		
		if let st = subtitle {
			let subtitleLbl = UILabel(frame: CGRect(
				x: 0, y: titleLine.y + 11,
				width: 0, height: 0
			))
			if colorful { subtitleLbl.backgroundColor = .randomP3 }
			subtitleLbl.textAlignment = .center
			subtitleLbl.lineBreakMode = .byWordWrapping
			subtitleLbl.numberOfLines = 0
			subtitleLbl.font = .systemFont(ofSize: 15, weight: .medium)
			subtitleLbl.kerning = 2.0
			subtitleLbl.textColor = .q_53
			subtitleLbl.text = uppercaseSubtitle ? st.uppercased() : st
			let s = subtitleLbl.sizeThatFits(CGSize(
				width: width - 58.0,
				height: CGFloat.greatestFiniteMagnitude
			))
			subtitleLbl.frame = CGRect(origin: subtitleLbl.frame.origin, size: s)
			subtitleLbl.center.x = titleLine.center.x
			subtitleLbl.sizeToFit()
			out.addSubview(subtitleLbl)
			
			titleLine.w = max(subtitleLbl.w + 20, titleLbl.w + 20)
			titleLine.centerWithinParent()
		}
	}
	out.setHeight(withBottomPad: false)
	return out
}

func moduleSuperTitle(
	emoji: String = "⁉️",
	title: String = "<>",
	emojiSize: CGFloat = 38.0,
	width: CGFloat = 320
) -> UIView {
	let out = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 88))
	out.tag = 32778
	if colorful { out.backgroundColor = .randomP3 }
	
	let emojiLbl = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: out.w, height: 50.0)))
	if colorful { emojiLbl.backgroundColor = .randomP3 }
	emojiLbl.textAlignment = .center
	emojiLbl.font = .systemFont(ofSize: emojiSize)
	emojiLbl.text = emoji
	out.addSubview(emojiLbl)
	
	let titleLbl = UILabel(frame: CGRect(
		x: 0,
		y: emojiLbl.y_bottom + 4.0,
		width: out.w,
		height: out.h - emojiLbl.h))
	if colorful { titleLbl.backgroundColor = .randomP3 }
	titleLbl.text = title.uppercased()
	titleLbl.font = .systemFont(ofSize: 32, weight: .semibold)
	titleLbl.font = titleLbl.font.compact
	titleLbl.kerning = 2.0
	titleLbl.textColor = .black
	titleLbl.textAlignment = .center
	out.addSubview(titleLbl)
	return out
}

func headerModuleView(
	_ message: String,
	width: CGFloat = 320
) -> UIView {
	let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
	label.text = message.uppercased()
	label.font = .systemFont(ofSize: 10, weight: .semibold)
	label.kerning = 2.0
	label.numberOfLines = 0
	label.lineBreakMode = .byWordWrapping
	label.textColor = .q_78
	label.textAlignment = .center
	label.sizeToFit()
	return label
}

func balanceFluxView(
	atY: CGFloat,
	from: Double,
	to: Double,
	width: CGFloat = 320
) -> UIView {
	let frame = UIView(frame: CGRect(x: 0, y: atY, width: width, height: 54.0))
	
	let lblVal = UILabel(frame: CGRect(x: 0.0, y: 0, width: width, height: 30.0))
	var balanceString = ""
	if from == to {
		balanceString = from.toCurrencyString()
	} else {
		if from > to {
			balanceString = from.toCurrencyString() + "   ↘️   " + to.toCurrencyString()
		} else if from < to {
			balanceString = from.toCurrencyString() + "   ↗️   " + to.toCurrencyString()
		} else {
			balanceString = "Unchanged @ " + from.toCurrencyString()
		}
	}
	lblVal.text = balanceString
	lblVal.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
	lblVal.textColor = .black
	lblVal.textAlignment = .center
	frame.addSubview(lblVal)
	
	let lblBal = UILabel(frame: CGRect(x: 0, y: lblVal.frame.origin.y + lblVal.frame.height + 8, width: width, height: 18.0))
	lblBal.text = "balance".uppercased()
	lblBal.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
	lblBal.textColor = .q_97
	lblBal.textAlignment = .center
	frame.addSubview(lblBal)
	
	return frame
}

func bigLabel(
	_ text: String,
	font: UIFont = .systemFont(ofSize: 52, weight: .heavy),
	textColor: UIColor = .black,
	width: CGFloat = 320
) -> UILabel {
	let bigLbl = UILabel(frame: CGRect(x: 16, y: 0, width: width - 32, height: 64.0))
	if colorful { bigLbl.backgroundColor = .randomP3 }
	bigLbl.text = text
	bigLbl.font = font
	bigLbl.kerning = 2.0
	bigLbl.textColor = textColor
	bigLbl.textAlignment = .center
	bigLbl.numberOfLines = 0
	bigLbl.lineBreakMode = .byWordWrapping
	bigLbl.sizeToFit()
	//		let r = bigLbl.font.sizeOfString(string: bigLbl.text!, constrainedToWidth: bigLbl.w)
	//		bigLbl.h = r.height
	return bigLbl
}

func smallLabel(
	_ text: String,
	width: CGFloat = 320
) -> UILabel {
	let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 20.0))
	lbl.text = text
	lbl.font = .systemFont(ofSize: 16)
	lbl.kerning = 2.0
	lbl.textColor = .black
	lbl.textAlignment = .center
	return lbl
}

func graphView(
	nonNormalizedValues: [Double],
	title: String,
	addGraphBorder: Bool = false,
	barColor: UIColor = .q_brandGreen
) -> UIView {
	let mean = nonNormalizedValues.reduce(0, +) / nonNormalizedValues.count.asDouble
	let normalizingCenterPoint = 0.5
	let normalizedValues = nonNormalizedValues.map {
		return (($0 / mean) * normalizingCenterPoint).roundToDecimal(3)
	}
	//		print("Normalized values = \(normalizedValues)")
	return graphView(normalizedValues:normalizedValues, title: title, addGraphBorder: addGraphBorder, barColor: barColor)
}

/// Normalized means a zero to one value
func graphView(
	normalizedValues: [Double],
	title: String,
	addGraphBorder: Bool = false,
	barColor: UIColor = .q_brandGold,
	width: CGFloat = 320
) -> UIView {
	let frame = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 66))
	let graph = UIView(frame: CGRect(x: 30, y: 0, width: width - 60, height: 42.0))
	if colorful { graph.backgroundColor = .randomP3 }
	if colorful { frame.backgroundColor = .randomP3 }
	
	if normalizedValues.count > 0 {
		
		// Adapt bar width to set size
		let barWidth = max(graph.w / normalizedValues.count.asCGFloat, 1)
		let barSpacing = max((barWidth * 0.1).rounded(), 1)
		let totalSpaceReqdPerBar = barWidth + barSpacing
		let spaceForAllVals = normalizedValues.count.asCGFloat * totalSpaceReqdPerBar
		
		var barCount = 0
		
		if spaceForAllVals > graph.w {
			barCount = floor(graph.w / totalSpaceReqdPerBar).asInt
		} else {
			barCount = normalizedValues.count
		}
		
		for i in 0...(barCount-1) {
			let x = graph.w - ((i+1).asCGFloat * totalSpaceReqdPerBar)
			let h = max(graph.h * normalizedValues[i].asCGFloat, 1)
			let bar = UIView(frame: CGRect(x: x, y: graph.h - h, width: barWidth, height: h))
			bar.backgroundColor = barColor
			graph.addSubview(bar)
			
			let bgBar = UIView(frame: CGRect(x: x, y: 0, width: barWidth, height: graph.h))
			bgBar.backgroundColor = UIColor.black.withAlphaComponent(0.05)
			graph.insertSubview(bgBar, belowSubview: bar)
		}
		
		if addGraphBorder {
			graph.borderColor = barColor.withAlphaComponent(0.5)
			graph.borderWidth = 1.0
		}
		
		frame.addSubview(graph)
	}
	
	let lbl = UILabel(frame: CGRect(x: 0, y: graph.h + 12, width: width, height: 15.0))
	lbl.text = title.uppercased()
	lbl.font = .systemFont(ofSize: 13, weight: .medium)
	lbl.kerning = 2.0
	lbl.textColor = .q_53
	lbl.textAlignment = .center
	frame.addSubview(lbl)
	
	return frame
}

func majValMinVal(
	maj_value: String,
	maj_title: String,
	maj_suffix: String = "",
	min_value: String,
	min_title: String,
	min_suffix: String = "",
	width: CGFloat = 320
) -> UIView {
	let v = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 186.0))
	if colorful { v.backgroundColor = UIColor.blue.withAlphaComponent(0.3) }
	let majVal = majorValue(
		value: maj_value,
		title: maj_title,
		suffix: maj_suffix
	)
	majVal.frame = CGRect(x: 0, y: 0, width: v.w, height: 92)
	v.addSubview(majVal)
	let minVal = minorValue(
		value: min_value,
		title: min_title,
		suffix: min_suffix,
		maximumWidth: width - 40.0
	)
	minVal.center.x = v.w/2
	minVal.y = majVal.y_bottom + 20.0
	v.addSubview(minVal)
	return v
}

func superMajorValue(
	value: String,
	title: String,
	addTick: Bool = false,
	tickUp: Bool = false,
	suffix: String? = nil
) -> UIView {
	return majorValue(
		value: value,
		title: title,
		atY: 146.0, // tuned
		width: 280,
		addTick: addTick,
		tickUp: tickUp,
		valueFont: .systemFont(ofSize: 70, weight: .bold),
		titleFont: UIFont.systemFont(ofSize: 18).italic,
		suffix: suffix
	)
}

func majorValue(
	value: String,
	title: String? = nil,
	atY: CGFloat = 0.0,
	width: CGFloat = 320,
	addPercentSign: Bool = false,
	addTick: Bool? = nil,
	tickUp: Bool? = nil,
	textColor: UIColor = .black,
	valueFont: UIFont = .systemFont(ofSize: 44, weight: .bold),
	titleFont: UIFont = .systemFont(ofSize: 18, weight: .semibold),
	suffix: String? = nil,
	suffixFont: UIFont = .systemFont(ofSize: 14, weight: .bold)
) -> UIView {
	var sideMarginSpace: CGFloat = 40
	if let suffix = suffix {
		let suffixW = suffix.width(withConstrainedHeight: .greatestFiniteMagnitude, font: suffixFont)
		sideMarginSpace += suffixW
	}
	let frame = UIView(frame: CGRect(x: 0, y: atY, width: width, height: 0))
	if colorful { frame.backgroundColor = .randomP3 }
	frame.clipsToBounds = false
	
	let lblValue = UILabel(frame: CGRect(x: 0, y: 0, width: frame.w, height: 60.0))
	if colorful { lblValue.backgroundColor = .randomP3 }
	lblValue.text = value
	lblValue.font = valueFont
	lblValue.kerning = 2.0
	lblValue.textColor = textColor
	lblValue.textAlignment = .center
	lblValue.adjustsFontSizeToFitWidth = true
	lblValue.size = CGSize(
		width: width - sideMarginSpace,
		height: lblValue.textRectSimple.h)
	lblValue.center.x = width/2
	frame.addSubview(lblValue)
	
	if let suf = suffix {
		let lblSuffix = UILabel(frame: .zero)
		if colorful { lblSuffix.backgroundColor = .randomP3 }
		lblSuffix.text = suf
		lblSuffix.font = suffixFont
		lblSuffix.textColor = textColor
		lblSuffix.textAlignment = .left
		lblSuffix.sizeToFit()
		lblSuffix.y = lblValue.y_bottom - lblSuffix.h - 5 // Tuned but probably need to rebuild this entirely with constraints
		lblSuffix.x = lblValue.x + lblValue.textRectSimple.x_right
		frame.addSubview(lblSuffix)
	}
	
	if
		let addTick = addTick,
		let up = tickUp,
		addTick == true
	{
		let tick = UIImage(named: "tickTriangle_" + (up ? "up" : "down"))
		let tickIV = UIImageView(frame: CGRect(
			x: lblValue.textRectSimple.x - 6.0,
			y: 0,
			width: 16,
			height: 15))
		tickIV.center.y = lblValue.center.y
		tickIV.image = tick
		frame.addSubview(tickIV)
	}
	
	if let title = title {
		let lineY = lblValue.y_bottom + 6
		let lblTitle = UILabel(frame: CGRect(x: 0, y: lineY + 12, width: frame.w, height: 12.0))
		if colorful { lblTitle.backgroundColor = .randomP3 }
		lblTitle.text = title.uppercased()
		lblTitle.font = titleFont
		lblTitle.kerning = 2.5
		lblTitle.textColor = .q_53
		lblTitle.textAlignment = .center
		lblTitle.sizeToFit()
		lblTitle.lineBreakMode = .byWordWrapping
		lblTitle.numberOfLines = 0
		let s = lblTitle.sizeThatFits(CGSize(width: 240, height: CGFloat.greatestFiniteMagnitude))
		lblTitle.frame = CGRect(origin: lblTitle.frame.origin, size: s)
		lblTitle.center.x = frame.w / 2
		frame.addSubview(lblTitle)
		
		let valW = lblValue.textRect(forBounds: lblValue.bounds, limitedToNumberOfLines: 1).w
		let titleW = lblTitle.textRect(forBounds: lblTitle.bounds, limitedToNumberOfLines: 1).w
		let lineLength = max(valW, titleW) + 40.0
		let titleLine = UIView(frame: CGRect(x: 0, y: lineY, width: lineLength, height: 2.0))
		titleLine.center.x = frame.w / 2
		titleLine.backgroundColor = textColor
		frame.addSubview(titleLine)
	}
	
	frame.setHeight(withBottomPad: false)
	return frame
}

func oneLineValue(
	title: String,
	value: String,
	valueTextColor: UIColor = .black,
	titleTextColor: UIColor = .q_53,
	valueFont: UIFont? = UIFont.systemFont(ofSize: 17, weight: .heavy),
	titleFont: UIFont? = UIFont.systemFont(ofSize: 14, weight: .semibold),
	atY: CGFloat = 0.0,
	width: CGFloat = 320
) -> UIView {
	let frame = UIView(frame: CGRect(x: 0, y: atY, width: width, height: 28))
	if colorful { frame.backgroundColor = UIColor.blue.withAlphaComponent(0.3) }
	
	let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: (frame.w / 2) - 6.0, height: 28.0))
	if colorful { lblTitle.backgroundColor = UIColor.cyan.withAlphaComponent(0.3) }
	lblTitle.text = title.uppercased()
	lblTitle.font = titleFont
	lblTitle.kerning = 0.0
	lblTitle.textColor = .q_53
	lblTitle.textAlignment = .right
	frame.addSubview(lblTitle)
	
	let lblValue = UILabel(frame: CGRect(x: lblTitle.x_right + 12.0, y: 0, width: (frame.w / 2) - 6.0, height: 28.0))
	if colorful { lblValue.backgroundColor = UIColor.magenta.withAlphaComponent(0.3) }
	lblValue.text = value
	lblValue.font = valueFont
	lblValue.kerning = 0.0
	lblValue.textColor = valueTextColor
	lblValue.textAlignment = .left
	frame.addSubview(lblValue)
	
	return frame
}

func multiLineValue(
	value: String,
	title: String,
	valueTextColor: UIColor = .black,
	titleTextColor: UIColor = .q_53,
	valueFont: UIFont? = UIFont.systemFont(ofSize: 17, weight: .heavy),
	titleFont: UIFont? = UIFont.systemFont(ofSize: 14, weight: .semibold),
	atY: CGFloat = 0.0,
	width: CGFloat = 320
) -> UIView {
	let frame = UIView(frame: CGRect(x: 0, y: atY, width: width, height: 28.0))
	if colorful { frame.backgroundColor = UIColor.blue.withAlphaComponent(0.3) }
	
	let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: frame.w, height: 28.0))
	if colorful { lblTitle.backgroundColor = UIColor.cyan.withAlphaComponent(0.3) }
	lblTitle.text = title.uppercased()
	lblTitle.font = titleFont
	lblTitle.kerning = 0.0
	lblTitle.textColor = .q_53
	lblTitle.textAlignment = .center
	frame.addSubview(lblTitle)
	
	let lblValue = UILabel(frame: CGRect(x: 0, y: lblTitle.y_bottom, width: frame.w, height: 0))
	if colorful { lblValue.backgroundColor = UIColor.magenta.withAlphaComponent(0.3) }
	lblValue.text = value
	lblValue.font = valueFont
	lblValue.kerning = 0.0
	lblValue.textColor = valueTextColor
	lblValue.textAlignment = .center
	lblValue.numberOfLines = 0
	lblValue.lineBreakMode = .byWordWrapping
	//		lblValue.
	lblValue.sizeToFit()
	lblValue.center.x = lblTitle.center.x
	frame.addSubview(lblValue)
	
	return frame
}

func simpleTextView(
	_ body: String,
	font: UIFont = .systemFont(ofSize: 16, weight: .medium),
	topInset: CGFloat = 0.0,
	bottomInset: CGFloat = 0.0,
	width: CGFloat = 320
) -> UIView {
	let textView = UITextView(frame: CGRect(x: 0, y: 0, width: width - 20, height: 0))
	textView.backgroundColor = .clear
	if colorful { textView.backgroundColor = .randomP3 }
	textView.text = body
	textView.font = font
	textView.textColor = .q_38
	textView.textContainerInset = UIEdgeInsets(top: topInset, left: 14, bottom: bottomInset, right: 14)
	textView.sizeToFit()
	textView.center.x = width / 2
	textView.isScrollEnabled = false
	textView.isSelectable = false
	textView.isEditable = false
	textView.isUserInteractionEnabled = false
	return textView
}

// MARK: - Modules

func moduleSavingsRate(onVC: UIViewController) -> QIOShadowView {
	let base = onVC.baseModuleView(
		title: "Savings Rate",
		subtitle: "How much of the surplus goes toward Financial Independence?")
	if
		let uh = QFlow.userHome,
		let fi = uh.financialIndependence,
		let sr = fi.savingsRate
	{
		if QFlow.isProfitable {
			base.addAndDistributeViewsHorizontally(
				[
					minorValue(
						value: sr.actualSavingsRate_90d.asString,
						title: "Actual".uppercased(),
						titleFont: .systemFont(ofSize: 14, weight: .semibold),
						minimumWidth: 100,
						suffix: "%"
					),
					minorValue(
						value: sr.potentialSavingsRate_90d.asString,
						title: "Potential".uppercased(),
						titleFont: .systemFont(ofSize: 14, weight: .semibold),
						minimumWidth: 100,
						suffix: "%"
					)
				],
				spacing: 34.0
			)
		} else {
			base.addAndDistributeViewsHorizontally(
				[
					minorValue(
						value: "N/A",
						title: "Actual".uppercased(),
						minimumWidth: 100
					),
					minorValue(
						value: "N/A",
						title: "Potential".uppercased(),
						minimumWidth: 100
					)
				],
				spacing: 24.0
			)
			let l = labelGenerator(
				"Savings rate is not applicable until a profit is generated.",
				maxWidth: onVC.moduleWidth - 40)
			l.center.x = base.center.x
			l.font = l.font.italic
			base.addModuleSubview(l)
		}
	}
	base.setHeight()
	return base
}
