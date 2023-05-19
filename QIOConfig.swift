//
//  QIOConfig.swift
//

import UserNotifications

// MARK: - DEBUG STUFF

var colorful: Bool = false
var FORCE_PULL_FRESH_HOME: Bool = true

 // MARK: - GENERAL CLIENT CONFIGURATION

let appName = "Quanta"
let appUrlString = "https://apps.apple.com/us/app/id1389569707"
let appStoreUrlStringAlt = "https://get.quantamoney.app"
let QST = TimeZone(identifier: "America/New_York")
let supportPhoneNumber = "+14157797976"
let supportEmailAddress = "support@quantamoney.app"
let qPrefKey_bioIdIsEnabled = "bioIdIsEnabled"
let linkLogoUrlRoot = "https://s3.amazonaws.com/flow.app.banklogos."
let nightlyBatchHour = 0
let nightlyBatchMinute = 30
public let nightlyBatchBuffer = 30
let navControlAlpha: CGFloat = 0.66

// MARK: - FLOW PULLING

// 	How many periods of a given size should be pulled on each pull
let defaultDayPullCount: Int = 45
let defaultWeekPullCount: Int = 26
let defaultMonthPullCount: Int = 12
// 	When to start pulling more data
let defaultDayScrollThresholdCount: Int = 20
let defaultWeekScrollThresholdCount: Int = 6
let defaultMonthScrollThresholdCount: Int = 4

// MARK: - TYPE ALIASING

typealias QHome = GetUserHomeQuery.Data.GetUserHome
typealias QItem = QHome.Item
typealias QAccount = QHome.Account
typealias QIncome = QHome.Income
typealias QSpending = QHome.Spending
typealias QCat = QSpending.Category.Cat
typealias QFinInd = QHome.FinancialIndependence
typealias QSpending_Ble = QHome.Spending.BasicLivingExpense
typealias QSpending_BleSummary = QSpending_Ble.Summary
typealias QSpending_QuantizedItem = QHome.Spending.Quantized
typealias QSpending_Quantized = [QSpending_QuantizedItem]
//typealias QSpending_VendorAnalysis = QHome.Spending.VendorAnalysis
typealias QSpending_BleMonth = QSpending_Ble.Month
typealias QSpending_BleCategory = QSpending_BleMonth.ByCategory
typealias QTransaction = GetTransactionsQuery.Data.GetTransaction
typealias QTransaction_Account = TransactionsForAccountQuery.Data.TransactionsForAccount
typealias QItemStatus = GetItemStatusQuery.Data.GetItemStatus
typealias QPeriod = GetFlowPeriodsQuery.Data.GetFlowPeriod.Period
public typealias QPeriodSummary = GetFlowPeriodsQuery.Data.GetFlowPeriod.Period.PeriodSummary
public typealias QPeriodSummaryBalance = QPeriodSummary.Balance
typealias QPeriodSummaryTransaction = QPeriodSummary.Transaction
typealias QYesterday = GetUserHomeQuery.Data.GetUserHome.Yesterday
typealias QThisMonth = GetUserHomeQuery.Data.GetUserHome.ThisMonth

// MARK: - INSTANCE ALIASING

let Defaults = UserDefaults.standard
let NotifCenter = NotificationCenter.default
let UNNotifCenter = UNUserNotificationCenter.current()

let QAS = FIOAppSync.sharedInstance
let QNotifs = QIONotificationManager.sharedInstance
let QUser = FIOUserManager.sharedInstance
let QBio = QIOBioID.sharedInstance
let QFlow = QIOFlow.s
let QMix = QIOMixpanel.shared
let QMember = FIOSubscriptionEngine.shared
let QPlaid = FIOPlaidManager.sharedInstance

// MARK: - USER DEFAULTS

struct UserDefaultsKeys {
	static let appOpenedCount = "APP_OPENED_COUNT"
	static let processCompletedCountKey = "processCompletedCount"
	static let lastVersionPromptedForReviewKey = "lastVersionPromptedForReview"
	static let notificationPermissionStatus = "notificationPermissionStatus"
	static let apnsDeviceToken = "apnsDeviceToken"
	static let notifRequestStatus = "notifRequestStatus"
}

// MARK: - FILE NAMING

let userHomeFileName = "userHome.quanta"
let savingsDetailFileName = "savingsDetail.quanta"
let creditDetailFileName = "creditDetail.quanta"
let incomeDetailFileName = "incomeDetail.quanta"
let spendStreamFileName = "spendStream.quanta"
let flowDaysFileName = "flowDays.quanta"
let flowWeeksFileName = "flowWeeks.quanta"
let flowMonthsFileName = "flowMonths.quanta"
let allTransactionsFileName = "allTransactions.quanta"

// MARK: - DATE CONSTANTS

let daysInYear: Double = 365.2422
let averageDaysPerMonth: Double = daysInYear / 12
let minutesPerDay: Double = 24 * 60
let secondsPerMonth: Double = averageDaysPerMonth * minutesPerDay * 60

// MARK: - ENV

class Env {
	
	static var iPad: Bool { return UIDevice.current.userInterfaceIdiom == .pad }
	
	static var screenWidth: CGFloat { return UIScreen.main.bounds.w }

	static let production: Bool = {
		#if DEBUG
		return false
		#else
		return true
		#endif
	}()
	
	static func isProduction () -> Bool {
		return self.production
	}
	
}
