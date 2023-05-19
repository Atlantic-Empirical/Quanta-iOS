//
//  Date+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/14/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

// MARK: - Instance Extension

extension Date {
	
	func daysInMonth(_ monthNumber: Int? = nil, _ year: Int? = nil) -> Int {
		let calendar = Calendar.current
		var dateComponents = DateComponents()
		dateComponents.year = year ?? self.year
		dateComponents.month = monthNumber ?? self.month
		if
			let d = calendar.date(from: dateComponents),
			let interval = calendar.dateInterval(of: .month, for: d),
			let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day
		{ return days } else { return -1 }
	}
	
	public func toFriendly(style: DateFormatter.Style = .medium) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = style
		dateFormatter.timeStyle = .none
		return dateFormatter.string(from: self)
	}

	public func toFriendly_long() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .none
		return dateFormatter.string(from: self)
	}

    public var components: DateComponents {
        return Calendar.current.dateComponents( Set( [ .year, .month, .day, .hour, .minute, .second, .weekday, .weekOfYear, .yearForWeekOfYear ] ), from: self)
    }

    public var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

	public var isYesterday: Bool {
		return Calendar.current.isDateInYesterday(self)
	}

    public var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    public var year: Int {
        return Calendar.current.component(.year,  from: self)
    }

   	public var month: Int {
        return Calendar.current.component(.month,  from: self)
    }

    public var day: Int {
        return Calendar.current.component(.day,  from: self)
    }
    
    public var isLastDayOfMonth: Bool {
        return Date.tomorrow.month != month
    }
	
	public func toYYYYMMDD() -> String {
		return format("YYYY-MM-dd")
	}
	
	public func toYYYYWW() -> String {
		return format("YYYY-'W'ww")
	}

	public func toYYYYMM() -> String {
		return format("YYYY-MM")
	}

	public func format(_ pattern: String, putDateFormatterInQST: Bool = true) -> String {
		var customCalendar = Calendar(identifier: .gregorian)
		customCalendar.firstWeekday = 2 // set first day to monday because that's how people think about their money. Monday is a new week, coming out of the weekend.
		let df = DateFormatter()
		df.calendar = customCalendar
		df.dateFormat = pattern
		if putDateFormatterInQST {
			df.timeZone = QST
		}
		return df.string(from: self)
	}
	
	// Alternative
//	public var asISO8601String: String {
//		// https://developer.apple.com/documentation/foundation/iso8601dateformatter
//		let df = ISO8601DateFormatter()
//		df.formatOptions = [.withFullDate, .withDashSeparatorInDate]
//		return df.string(from: self)
//	}
	
	func skip(forward: Bool, count: Int, period: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: period, value:(forward ? count : -1 * count), to: self)!
    }
    
	var monthName: String {
		let df = DateFormatter()
		df.dateFormat = "MMMM"
		return df.string(from: self)
    }

	var monthName_abrv: String {
		let df = DateFormatter()
		df.dateFormat = "MMM"
		return df.string(from: self) + ((self.month == 5) ? "" : ".")
	}

	func add(_ number: Int, windowSize: FIOWindowSize) -> Date {
		
		var _size: Calendar.Component
		var _number = number
		
		switch windowSize {
		case .day:
			_size = .day
			
		case .week:
			_size = .day
			_number *= 7
			
		case .month:
			_size = .month
			
		default:
			return Date() // fail
		}
		
		return Calendar.current.date(byAdding: _size, value: _number, to: self)!
	}
	
	func subtract(_ number: Int, windowSize: FIOWindowSize) -> Date {
		
		var _size: Calendar.Component
		var _number = -1 * number // make it subtraction
		
		switch windowSize {
		case .day:
			_size = .day
			
		case .week:
			_size = .day
			_number *= 7
			
		case .month:
			_size = .month
			
		default:
			return Date() // fail
		}
		
		return Calendar.current.date(byAdding: _size, value: _number, to: self)!
	}
	
	func add(_ number: Int, size: Calendar.Component) -> Date {
		return Calendar.current.date(byAdding: size, value: number, to: self)!
	}
	
	func subtract(_ number: Int, size: Calendar.Component) -> Date {
		return Calendar.current.date(byAdding: size, value: -1 * number, to: self)!
	}
	
	var currentWeekMonday: Date {
//		return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!

		let calendar = Calendar(identifier: .iso8601)
		var comp: DateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
		comp.timeZone = QST
		let mondayDate = calendar.date(from: comp)!
//		print("Monday \(mondayDate)")
		return mondayDate
	}
	
	func formattedFromComponents(styleAttitude: DateFormatter.Style, year: Bool = false, month: Bool = false, day: Bool = false, hour: Bool = false, minute: Bool = false, second: Bool = false, locale: Locale = Locale.current) -> String {
		
		let long = styleAttitude == .long || styleAttitude == .full
		let short = styleAttitude == .short
		var comps = ""
		
		if year { comps += long ? "yyyy" : "yy" }
		if month { comps += long ? "MMMM" : (short ? "MM" : "MMM") }
		if day { comps += long ? "dd" : "d" }
		
		if hour { comps += long ? "HH" : "H" }
		if minute { comps += long ? "mm" : "m" }
		if second { comps += long ? "ss" : "s" }
		let format = DateFormatter.dateFormat(fromTemplate: comps, options: 0, locale: locale)
		let formatter = DateFormatter()
		formatter.dateFormat = format
		
		return formatter.string(from: self)
	}
	
	var suffix: String {
		let calendar = Calendar.current
		let dayOfMonth = calendar.component(.day, from: self)
		switch dayOfMonth {
		case 1, 21, 31: return "st"
		case 2, 22: return "nd"
		case 3, 23: return "rd"
		default: return "th"
		}
	}
	
	func weeksAgoDisplay() -> String {
		let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
		return diff.asString + " week".pluralize(diff) + " ago"
	}
	
	func timeAgoDisplay() -> String {
		let calendar = Calendar.current
		let oneMinuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
		let oneHourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
		let oneDayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
		let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
		let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: Date())!
		
		if oneMinuteAgo < self {
			let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
			return "\(diff) sec ago"
			
		} else if oneHourAgo < self {
			let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
			return "\(diff) min ago"
			
		} else if oneDayAgo < self {
			let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
			return diff.asString + " hour".pluralize(diff) + " ago"
			
		} else if oneWeekAgo < self {
			let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
			return diff.asString + " day".pluralize(diff) + " ago"
			
		} else if oneMonthAgo < self {
			let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
			return diff.asString + " week".pluralize(diff) + " ago"
			
		} else {
			let diff = Calendar.current.dateComponents([.month], from: self, to: Date()).month ?? 0
			
			if (diff < 12) {
				return diff.asString + " month".pluralize(diff) + " ago"
				
			} else if (Date().year - self.year == 1) {
				return "last year"
				
			} else {
				//                let yrs = Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
				let yrs = Date().year - self.year
				return "\(yrs) years ago"
			}
		}
	}

	func timeAgoSinceDate() -> String {
		let fromDate = self
		let toDate = Date()

		// Year
		if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
			return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
		}
		
		// Month
		if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
			return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
		}
		
		// Day
		if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
			return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
		}
		
		// Hours
		if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
			return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
		}
		
		// Minute
		if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
			return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
		}
		
		return "a moment ago"
	}

}

// Static Extension

extension Date {
	
	static func fromYMD(year: Int, month: Int, day: Int) -> Date {
		var components = Calendar.current.dateComponents([.year, .day, .month], from: Date())
		components.timeZone = TimeZone.current
		components.calendar = Calendar.current
		components.year = year
		components.month = month
		components.day = day
		return components.date!
	}
	
	public static func fromYYYYMMDD(_ YYYYMMDD: String) -> Date {
		let df = ISO8601DateFormatter()
		df.timeZone = TimeZone.current
		df.formatOptions = [.withFullDate, .withDashSeparatorInDate]
		return df.date(from: YYYYMMDD)!
	}

	/// Aka periodId. Note that this returns the first day of the month in the date.
	public static func fromYYYYMM(_ YYYYMM: String) -> Date {
		return Date.fromYYYYMMDD(YYYYMM + "-01")
	}

	public static func fromEpochSeconds(_ sec: Double) -> Date {
		return Date(timeIntervalSince1970: sec)
	}
	
	public static func todayNightlyBatch_Eastern_withOffset(minutes: Int = nightlyBatchBuffer) -> Date {
		return todayNightlyBatch_Eastern.add(minutes, size: .minute)
	}
	
	public static var todayNightlyBatch_Eastern: Date {
		
		var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
		
		components.timeZone = TimeZone.init(identifier: "America/New_York")
		components.calendar = Calendar.current

		let today = Date()
		components.year = today.year
		components.month = today.month
		components.day = today.day
		components.hour = nightlyBatchHour
		components.minute = nightlyBatchMinute
		
		return components.date!
	}
	
    public static var noonToday: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
    }
    
    public static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noonToday)!
    }
    
    public static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noonToday)!
    }

    public static func nameOfMonth(monthNumber: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let d: Date = Date.fromYMD(year: Date().year, month: monthNumber, day: 1)
        return dateFormatter.string(from: d)
    }

    public static func isoDateStringFrom(year: Int, month: Int, day: Int) -> String {
        return Date.fromYMD(year: year, month: month, day: day).toYYYYMMDD()
    }

    public static var currentTimeZoneString: String {
        return TimeZone.current.localizedName(for: TimeZone.current.isDaylightSavingTime() ? .daylightSaving : .standard, locale: .current) ?? ""
    }
    
    public static func daysInMonth(month: Int, year: Int) -> Int {
        let date = Date.fromYMD(year: year, month: month, day: 15)
        return Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date)!.count
    }
    
    public static func YYYYMMDD_to_FriendlyString(_ YYYYMMDD: String) -> String {
		if YYYYMMDD.count != 10 { return "" }
       return Date.fromYYYYMMDD(YYYYMMDD).toFriendly()
    }
	
	public static func YYYYMMDD_to_FriendlyString_long(_ YYYYMMDD: String) -> String {
		if YYYYMMDD.count != 10 { return "" }
		return Date.fromYYYYMMDD(YYYYMMDD).toFriendly_long()
	}
    
    // MARK: - Flow Period - Year
    
    public static var firstDayOfThisYear8601String: String {
		return String(Date().components.year!) + "-01-01"
    }
    
    public static var lastDayOfThisYear8601String: String {
		return String(Date().components.year!) + "-12-31"
    }
    
    public static var firstDayOfLastYear8601String: String {
		let year = Date().components.year!
		return String(year - 1) + "-01-01"
    }
    
    public static var lastDayOfLastYear8601String: String {
		let year = Date().components.year!
		return String(year-1) + "-12-31"
    }
	
    // MARK: - Flow Period - Month
    
    public static var firstDayOfThisMonth8601String: String {
		let date = Date() // Today
		return String(date.components.year!) + "-" + String(format: "%02d", date.components.month!) + "-01"
    }
    
    public static var lastDayOfThisMonth8601String: String {
		let date = Date() // Today
		let year = date.components.year
		let month = date.components.month
		
		return String(year!) + "-" + String(format: "%02d", month!) + "-" + String(Date.daysInMonth(month: month!, year: year!))
    }
    
    public static var firstDayOfLastMonth8601String: String {
		let date = Date() // Today
		var year = date.components.year!
		var month = date.components.month!
		
		if (month == 1) {
			year -= 1
			month = 12
		} else {
			month -= 1
		}
		
		return String(year) + "-" + String(format: "%02d", month) + "-01"
    }
    
    public static var lastDayOfLastMonth8601String: String {
		let date = Date() // Today
		var year = date.components.year!
		var month = date.components.month!
		
		if (month == 1) {
			year -= 1
			month = 12
		} else {
			month -= 1
		}
		
		return String(year) + "-" + String(format: "%02d", month) + "-" + String(Date.daysInMonth(month: month, year: year))
    }
	
    // MARK: - Flow Period - Week
	
    public static var firstDayOfThisWeekYYYYMMDD: String {
		return Date().currentWeekMonday.toYYYYMMDD()
    }
    
    public static var lastDayOfThisWeekYYYYMMDD: String {
		return Date().currentWeekMonday.add(6, size: .day).toYYYYMMDD()
    }
    
    public static var firstDayOfLastWeekYYYYMMDD: String {
		return Date().currentWeekMonday.subtract(7, size: .day).toYYYYMMDD()
    }
    
    public static var lastDayOfLastWeekYYYYMMDD: String {
		return Date().currentWeekMonday.subtract(1, size: .day).toYYYYMMDD()
    }
	
	// MARK: - Other

	public static func lockupForTwoDates(_ startDate: Date, _ endDate: Date, longMonth: Bool = false, includeYear: Bool = false, includeYearIfNotThisYear: Bool = true) -> String {
		
		let monthFormat = longMonth ? "MMMMd" : "MMMd"
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dateFormatter.locale = Locale(identifier: "en_US")
		
		var startStr = ""
		var endStr = ""
		
		if (startDate.month == endDate.month) {
			
			// Week begins and ends in the same month
			dateFormatter.setLocalizedDateFormatFromTemplate(monthFormat) // set template after setting locale
			startStr = dateFormatter.string(from: startDate) + startDate.suffix
			endStr = String(endDate.day) + endDate.suffix
			
		} else {
			
			// Different month (could cross year boundary
			dateFormatter.setLocalizedDateFormatFromTemplate(monthFormat) // set template after setting locale
			startStr = dateFormatter.string(from: startDate) + startDate.suffix
			endStr = dateFormatter.string(from: endDate) + endDate.suffix
		}
		
		var out = ""
		
		if startDate.compare(endDate) == .orderedSame { // same start and end dates
			out = startStr
		} else {
			out = startStr + " to " + endStr
		}
		
		// YEAR STUFF
		if (includeYear || (includeYearIfNotThisYear && (Date().year != endDate.year))) {
			out += ", " + endDate.year.asString
		}
		
		return out
	}

	public static func verifyDateCalculations() {
		
		// Month Verification
		print("firstDayOfThisMonth8601String: " + firstDayOfThisMonth8601String)
		print("lastDayOfThisMonth8601String: " + lastDayOfThisMonth8601String)
		print("firstDayOfLastMonth8601String: " + firstDayOfLastMonth8601String)
		print("lastDayOfLastMonth8601String: " + lastDayOfLastMonth8601String)
		
		// Year Verification
		print("firstDayOfThisYear8601String: " + firstDayOfThisYear8601String)
		print("lastDayOfThisYear8601String: " + lastDayOfThisYear8601String)
		print("firstDayOfLastYear8601String: " + firstDayOfLastYear8601String)
		print("lastDayOfLastYear8601String: " + lastDayOfLastYear8601String)
		
		// Week Verification
		print("firstDayOfThisWeek8601String: " + firstDayOfThisWeekYYYYMMDD)
		print("lastDayOfThisWeek8601String: " + lastDayOfThisWeekYYYYMMDD)
		print("firstDayOfLastWeek8601String: " + firstDayOfLastWeekYYYYMMDD)
		print("lastDayOfLastWeek8601String: " + lastDayOfLastWeekYYYYMMDD)
	}

}

// MARK: String Date Logic

extension String {

	func YYYYMMDDtoFriendlyString(_ dateFormat: DateFormatter.Style = .medium) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = dateFormat
		dateFormatter.timeStyle = .none
		return dateFormatter.string(from: Date.fromYYYYMMDD(self))
	}
	
	func YYYYMMDDtoMonthYearString(omitCurrentYear: Bool = true) -> String {
		let date = Date.fromYYYYMMDD(self)
		var out = date.monthName
		if omitCurrentYear {
			out += ((date.year == Date.noonToday.year) ? "" : " " + String(date.year))
		} else {
			out += " " + String(date.year)
		}
		return out
	}
	
	func monthNameFromPeriodId() -> String {
		return Date.fromYYYYMM(self).monthName
	}

}
