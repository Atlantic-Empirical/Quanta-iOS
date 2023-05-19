//
//  UITableView+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 4/6/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

extension UITableView {
	
	func cellGenerator(style: UITableViewCell.CellStyle = .default) -> UITableViewCell {
		if let cell = dequeueReusableCell(withIdentifier: "reuseIdentifier") { return cell }
		else { return UITableViewCell(style: style, reuseIdentifier: "reuseIdentifier") }
	}

	/// Hides empty cells
	func hideUnusedCells(showLastSeparatorLine: Bool = false) {
		if showLastSeparatorLine {
			tableFooterView = UIView()
		} else {
			tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: w, height: 1)) )
		}
	}
	
	var estimatedHeight: CGFloat {
		var out: CGFloat = 0
		for section in 0...(max(numberOfSections - 1, 0)) {
			out += sectionHeaderHeight
			out += (rowHeight * numberOfRows(inSection: section).asCGFloat)
		}
		return out
	}
	
}
