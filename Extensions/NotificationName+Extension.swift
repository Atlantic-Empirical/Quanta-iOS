//
//  Notification-Name+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/14/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

extension Notification.Name {

	// App
	static let statusBarTappedNotification = Notification.Name(rawValue: "statusBarTappedNotification")
	static let applicationWillEnterForeground = Notification.Name(rawValue: "applicationWillEnterForeground")
	
	// Bank Linking
	static let FIOPlaidLinkSucceeded = Notification.Name(rawValue: "FIOPlaidLinkSucceeded")
	static let FIOPlaidLinkError = Notification.Name(rawValue: "FIOPlaidLinkError")
	static let FIOPlaidLinkExit = Notification.Name(rawValue: "FIOPlaidLinkExit")
	static let FIOAccountLinkSetupCompleted = Notification.Name(rawValue: "FIOAccountLinkSetupCompleted")

	// Subscription
	static let FIOSubscriptionReceiptValidated = Notification.Name(rawValue: "FIOSubscriptionReceiptValidated")
	static let FIOSubscriptionRestoreDidNotFindValidSubscription = Notification.Name(rawValue: "FIOSubscriptionRestoreDidNotFindValidSubscription")
	static let FIOSubscriptionRestoreFailed = Notification.Name(rawValue: "FIOSubscriptionRestoreFailed")
	static let FIOSubscriptionPurchaseFailedOrCancelled = Notification.Name(rawValue: "FIOSubscriptionPurchaseFailedOrCancelled")

}
