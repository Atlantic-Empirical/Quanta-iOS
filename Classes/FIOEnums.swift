//
//  FIOEnums.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/16/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import Foundation
import UIKit

enum QIOTransactionProperty {
	case name
	case date
	case amount
	case none
}

enum QIOTransactionListType {
	case generic
	case transfers
	case regularIncome
	case deposits
}

enum QIOFinancialAccountType {
	case all
	case checking
	case cushion
	case creditCard
	case brokerage
	case taxDeferred
}

enum FIOPages: Int {
    case home = 0, map, cc, safety, settings
}

enum FIOFlowPeriod: Int {
    case yesterday
    case thisWeek
    case lastWeek
    case thisMonth
    case lastMonth
    case thisYear
    case lastYear
    case previous
    case next
    case custom
    case invalid
	
	init?(withPeriod p: QIOFlowPeriod) {

		if p.startDate == p.endDate && Date.fromYYYYMMDD(p.startDate).isYesterday {
			self = .yesterday
		}
		
		else if p.startDate == Date.firstDayOfThisWeekYYYYMMDD && p.endDate == Date.lastDayOfThisWeekYYYYMMDD {
			self = .thisWeek
		}

		else if p.startDate == Date.firstDayOfLastWeekYYYYMMDD && p.endDate == Date.lastDayOfLastWeekYYYYMMDD {
			self = .lastWeek
		}

		else if p.startDate == Date.firstDayOfThisMonth8601String && p.endDate == Date.lastDayOfThisMonth8601String {
			self = .thisMonth
		}
			
		else if p.startDate == Date.firstDayOfLastMonth8601String && p.endDate == Date.lastDayOfLastMonth8601String {
			self = .lastMonth
		}
			
		else if p.startDate == Date.firstDayOfThisYear8601String && p.endDate == Date.lastDayOfThisYear8601String {
			self = .thisYear
		}
			
		else if p.startDate == Date.firstDayOfLastYear8601String && p.endDate == Date.lastDayOfLastYear8601String {
			self = .lastYear
		}
			
		else {
			self = .invalid
		}
	}
	
	init?(withPeriod p: QPeriod) {
		
		if p.startDate == p.endDate && Date.fromYYYYMMDD(p.startDate).isYesterday {
			self = .yesterday
		}
			
		else if p.startDate == Date.firstDayOfThisWeekYYYYMMDD && p.endDate == Date.lastDayOfThisWeekYYYYMMDD {
			self = .thisWeek
		}
			
		else if p.startDate == Date.firstDayOfLastWeekYYYYMMDD && p.endDate == Date.lastDayOfLastWeekYYYYMMDD {
			self = .lastWeek
		}
			
		else if p.startDate == Date.firstDayOfThisMonth8601String && p.endDate == Date.lastDayOfThisMonth8601String {
			self = .thisMonth
		}
			
		else if p.startDate == Date.firstDayOfLastMonth8601String && p.endDate == Date.lastDayOfLastMonth8601String {
			self = .lastMonth
		}
			
		else if p.startDate == Date.firstDayOfThisYear8601String && p.endDate == Date.lastDayOfThisYear8601String {
			self = .thisYear
		}
			
		else if p.startDate == Date.firstDayOfLastYear8601String && p.endDate == Date.lastDayOfLastYear8601String {
			self = .lastYear
		}
			
		else {
			self = .invalid
		}
	}
	
    var string: String {
        return "\(self)"
    }
    
    static let count: Int = {
        var max: Int = 0
        while let _ = FIOFlowPeriod(rawValue: max) { max += 1 }
        return max
    }()
    
    var translateToPrevious: FIOFlowPeriod {
		
        switch self {

		case .thisWeek: return .lastWeek
        case .thisMonth: return .lastMonth
        case .thisYear: return .lastYear
        default: return .previous // case .yesterday, .lastWeek, .lastMonth, .lastYear, .custom:
			
		}
    }

    var translateToNext: FIOFlowPeriod {
		
        switch self {

		case .yesterday, .thisWeek, .thisMonth, .thisYear: return .invalid
        case .lastWeek: return .thisWeek
        case .lastMonth: return .thisMonth
        case .lastYear: return .thisYear
        default: return .next // TODO: tricky, two days/weeks/months/years ago -> yesterday, lastWeek, lastMonth, lastYear
			
        }
    }

	public func asFriendlyString() -> String {
		
		switch self {

		case .thisWeek: return "This Week"
		case .thisMonth: return "This Month"
		case .thisYear: return "This Year"

		case .yesterday: return "Yesterday"
		case .lastWeek: return "Last Week"
		case .lastMonth: return "Last Month"
		case .lastYear: return "Last Year"

		case .custom: return "Custom"
		case .invalid: return "Invalid"

		case .previous: return "Previous"
		case .next: return "Next"
			
		}
	}
	
}

enum FIOWindowSize: Int {
    case day = 1
    case week = 7
    case month = 30
    case quarter = 90
    case year = 365
    case custom = 0

	init?(fuzzyDays: Int) {
		switch fuzzyDays {

		case 28...32:
			self.init(rawValue: 30)
			break
			
		case 88...92:
			self.init(rawValue: 90)
			break

		default:
			self.init(rawValue: fuzzyDays)
			break

		}
	}
	
    var string: String {
        return "\(self)"
    }
    
    static let count: Int = {
        var max: Int = 0
        while let _ = FIOWindowSize(rawValue: max) { max += 1 }
        return max
    }()

}

enum FIOTransactionType: Int {
	case Debit
	case Deposit
	case Transfer
	case Income
	
	var asString: String {
		return "\(self)"
	}
	
	static let count: Int = {
		var max: Int = 0
		while let _ = FIOTransactionType(rawValue: max) { max += 1 }
		return max
	}()
	
}

enum Direction {
	case up
	case down
	case left
	case right
}
