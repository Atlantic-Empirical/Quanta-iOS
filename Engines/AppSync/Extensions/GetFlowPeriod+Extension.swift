//
//  GetFlowPeriod.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 10/3/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

extension QPeriod {
	
	init(periodId: String, windowSize: FIOWindowSize) {
		self.init(snapshot: ["__typename": "FIOFlowPeriod", "periodId": periodId, "windowSize": windowSize.rawValue, "daysInRange": windowSize.rawValue, "startDate": "", "endDate": "", "daysRemainingInPeriod": 0, "dayNets": [], "includesEndOfData": false, "projection": [], "periodSummary": []])
	}
	
	var description: String {
		var out: String = "========================================="
		
		out.append("\n\nPERIOD:\n")
		
		out.append("\tStart Date: " + startDate + "\n")
		out.append("\tEnd Date: " + endDate + "\n")
		out.append("\tDays In Range: " + daysInRange.asString + "\n")
		out.append("\tDays Remaining in Period: " + daysRemainingInPeriod.asString + "\n")
		out.append("\tIncludes End of Data: " + includesEndOfData.asString + "\n")
		out.append(periodSummary.description)
		
		if let val = projection { out.append("\tProjection: " + val.description + "\n") }
		//			if let val = dayNets { out.append("\tDay Nets: " + val.asSentence + "\n") }
		//			if let val = endOfDataDateString { out.append("\tEnd of Data Date: " + val + "\n") }
		
		out.append("\n^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
		out.append("\n\n")
		
		return out
	}

	var title: String {
		let t = titles()
		return t.mainTitle
	}
	
	var hoursInPeriod: Int {
		return daysInRange * 24
	}

	func titles() -> periodTitles {
		var out = periodTitles()
		
		if includesEndOfData {
			out.mainTitle = "🏁 " + out.mainTitle + " 🏁"
			out.subTitle = "End of data!"
			return out
		}
		
		let period = FIOFlowPeriod(withPeriod: self)
		let wz = FIOWindowSize.init(fuzzyDays: daysInRange)!
		
		switch wz {
			
		case .day :
			let date = Date.fromYYYYMMDD(startDate)
			let dateString = date.monthName + " " + String(date.day) + date.suffix
			
			if period == .yesterday {
				out.mainTitle = "Yesterday"
				out.subTitle = dateString.uppercased()
			} else {
				out.mainTitle = dateString
				out.subTitle = "tbd".uppercased()
			}
			
		case .week:
			let _startDate = Date.fromYYYYMMDD(startDate)
			let _endDate = Date.fromYYYYMMDD(endDate)
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .medium
			dateFormatter.timeStyle = .none
			dateFormatter.locale = Locale(identifier: "en_US")
			
			var startStr = ""
			var endStr = ""
			
			if (_startDate.month == _endDate.month) {
				// Week begins and ends in the same month
				dateFormatter.setLocalizedDateFormatFromTemplate("MMMd") // set template after setting locale
				startStr = dateFormatter.string(from: _startDate) + _startDate.suffix
				endStr = String(_endDate.day) + _endDate.suffix
				
			} else {
				// Different month (could cross year boundary, for now not showing year because it should be obvious
				dateFormatter.setLocalizedDateFormatFromTemplate("MMMd") // set template after setting locale
				startStr = dateFormatter.string(from: _startDate) + _startDate.suffix
				endStr = dateFormatter.string(from: _endDate) + _endDate.suffix
			}
			
			let lockup = startStr + " to " + endStr
			
			if period == .thisWeek {
				out.mainTitle = "This Week"
				out.subTitle = daysRemainingInPeriod.asString + " days left"
				
			} else if period == .lastWeek {
				out.mainTitle = "Last Week"
				out.subTitle = lockup.uppercased()
				
			} else {
				// Not this week or last week
				out.mainTitle = _startDate.weeksAgoDisplay().uppercased()
				out.subTitle = lockup.uppercased()
			}
			
		case .month:
			let _startDate = Date.fromYYYYMMDD(startDate)
//			let ti = abs(_startDate.timeIntervalSinceNow)
//			let monthsAgo = ti / secondsPerMonth
			let thisYear = Date().year
			
			if period == .thisMonth {
				out.mainTitle = "This Month"
				out.subTitle = "" // daysRemainingInPeriod.asString + " days left"
				
			} else if period == .lastMonth {
				out.mainTitle = "Last Month"
				out.subTitle = "" // lockup.uppercased()
				
			} else if _startDate.year == thisYear {
				// This year
				out.mainTitle = _startDate.monthName
				out.subTitle = "" // _startDate.timeAgoDisplay().uppercased()

			} else if _startDate.year == thisYear - 1 {
				// Last year
				out.mainTitle = "Last " + _startDate.monthName_abrv
				out.subTitle = "" // _startDate.timeAgoDisplay().uppercased()
				
			} else {
				// Not this year or last year
				let lockup = _startDate.monthName_abrv + " " + _startDate.year.asString
				out.mainTitle = lockup.uppercased()
				out.subTitle = ""
			}
			
		default: return out
			
		}
		
		return out
	}
	
	struct periodTitles {
		public var mainTitle: String = ""
		public var subTitle: String = ""
	}

}

extension QPeriodSummary {
	
	public var description: String {
		var out: String = "\n\tPERIOD SUMMARY:\n"
		
		out.append("\t\tNet Amount: " + netAmount.asString + "\n")
		out.append("\t\tIncome: " + income.asString + "\n")
		if let val = isFillerObject { out.append("\t\tisFillerObject: " + val.asString + "\n") }
		if let val = transactions { out.append(val.description) }
		
		return out
	}
	
	public var savingsBalance: QPeriodSummaryBalance? {
		if let bals = balances {
			return bals.first(where: { $0.accountSubtype == "savings" })
		} else {
			return nil
		}
	}

	public var checkingBalance: QPeriodSummaryBalance? {
		if let bals = balances {
			return bals.first(where: { $0.accountSubtype == "checking" })
		} else {
			return nil
		}
	}

	public var creditCardsBalance: QPeriodSummaryBalance? {
		if let bals = balances {
			return bals.first(where: { $0.accountSubtype == "credit card" })
		} else {
			return nil
		}
	}

}

extension QPeriodSummaryTransaction {
	
	public var description: String {
		var out: String = "\n\t\tTRANSACTIONS:\n"
		
		if let val = totalAmount { out.append("\t\t\tTotal Amount: " + val.asString + "\n") }
		if let val = debits { out.append(val.description) }
		if let val = deposits { out.append(val.description) }
		if let val = transfers { out.append(val.description) }
		
		return out
	}
	
}

extension QPeriodSummaryTransaction.Debit {
	
	public var description: String {
		var out: String = "\n\t\t\tDEBITS:\n"
		
		out.append("\t\t\t\tTotal Amount: " + totalAmount.asString + "\n")
		out.append("\t\t\t\tTransaction IDs: " + transactionIds.asSentence + "\n")
		
		return out
	}
	
}

extension QPeriodSummaryTransaction.Deposit {
	
	public var description: String {
		var out: String = "\n\t\t\tDEPOSITS:\n"
		
		out.append("\t\t\t\tTotal Amount: " + totalAmount.asString + "\n")
		out.append("\t\t\t\tTransaction IDs: " + transactionIds.asSentence + "\n")
		
		return out
	}
	
}

extension QPeriodSummaryTransaction.Transfer {
	
	public var description: String {
		var out: String = "\n\t\t\tTRANSFERS:\n"
		
		out.append("\t\t\t\tTotal Amount: " + totalAmount.asString + "\n")
		out.append("\t\t\t\tTransaction IDs: " + transactionIds.asSentence + "\n")
		
		return out
	}
	
}

extension QPeriod.Projection {
	
	public var description: String {
		var out: String = "\n\tPROJECTION:\n"
		
		if let val = net { out.append("\t\tNet Amount: " + val.asString + "\n") }
		if let val = spendTotal { out.append("\t\tiSpend Total: " + val.asString + "\n") }
		if let val = incomeTotal { out.append("\t\tIncome TOTAL: " + val.asString + "\n") }
		
		return out
	}
	
}
