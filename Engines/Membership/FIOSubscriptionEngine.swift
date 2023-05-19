//
//  FIOSubscriptionEngine.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 1/30/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import StoreKit
import os.log

class FIOSubscriptionEngine : NSObject {
	
	// MARK: - Properties
	
	var products: [SKProduct]?
	var isReady: Bool {
		if !canMakePurchases { return false }
		if !hasProduct { return false }
		return true
	}
	var subscriptionState: FIOSubscriptionState?
	private let productId = "app.Flow.QuantaMonthly"
	private var canMakePurchases: Bool = false
	private var hasProduct: Bool = false
	private var pendingRestoreTransactions = false
	
	// MARK: - Lifecycle

	override init() {
		super.init()
		print("FIOSubscriptionEngine init()")
		SKPaymentQueue.default().add(self)
	}
	
	// MARK: - API
	
	func appLaunch() {
		print("FIOSubscriptionEngine and SKPaymentQueue initialized.")
	}

	func openSubscriptionManagement() {
		if let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") {
			if UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url, options: [:])
			}
		}
	}

	/// Pull the products from iTunes and confirm that user can make purchases.
	func prepForPitch() {
		updateCanMakePurchases()
		fetchAvailableProducts()
	}
	
	func restoreTransactions() {
		os_log("[QUANTA] restoreTransactions")
		SKPaymentQueue.default().restoreCompletedTransactions()
	}

	func buySubscription() {
		os_log("[QUANTA] buySubscription")
		guard let products = self.products else { return }
		
		if let p = products.first {
			os_log("[QUANTA] Sending the Payment Request to Apple")
			print("Sending the Payment Request to Apple")
			SKPaymentQueue.default().add(SKPayment(product: p))
		}
	}
	
	func checkSubscriptionState(completion: @escaping ((FIOSubscriptionState?, Error?) -> Void) = { (_,_) in }) {
		FIOAppSync.sharedInstance.getSubscriptionStatus() { (result, error) in
			if let e = error {
				print(e)
				self.subscriptionState = nil
			} else if let r = result {
				self.subscriptionState = FIOSubscriptionState(r)
			} else {
				self.subscriptionState = nil
			}
			completion(self.subscriptionState, error)
		}
	}
	
	// MARK: - Custom
	
	private func fetchAvailableProducts() {
		guard let identifier = NSSet(objects: productId) as? Set<String> else { return }
		let productsRequest = SKProductsRequest(productIdentifiers: identifier)
		productsRequest.delegate = self
		productsRequest.start()
	}

	private func updateCanMakePurchases() {
		canMakePurchases = SKPaymentQueue.canMakePayments()
		os_log("[QUANTA] Can make purchases = %b", String(describing: canMakePurchases))
	}
	
	private func receiptValidationForTransaction(_ tx: SKPaymentTransaction) {
		do {
			let receiptFileURL = Bundle.main.appStoreReceiptURL
			let receiptData = try Data(contentsOf: receiptFileURL!)
			let receiptString = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
			
			os_log("[QUANTA] Sending receipt for validation =\n%@", receiptString)

			FIOAppSync.sharedInstance.verifyReceipt(receipt: receiptString) { result in
				
				if let r = result {
					os_log("[QUANTA] GOT RESULT FROM VERIFYRECEIPT")

					SKPaymentQueue.default().finishTransaction(tx)

					let obj = FIOSubscriptionState(r)
					self.subscriptionState = obj

					if obj.isValid {
						os_log("[QUANTA] Subscription is valid.")
						NotifCenter.post(name: .FIOSubscriptionReceiptValidated, object: obj)
						
					} else {
						os_log("[QUANTA] Subscription is not valid.")
						NotifCenter.post(name: .FIOSubscriptionRestoreDidNotFindValidSubscription, object: nil)
					}

				} else {
					os_log("[QUANTA] MAJOR FAIL: NO OBJECT RETURNED FROM VERIFYRECEIPT")
				}
			}
		} catch {
			 print("Unexpected error: \(error).")
		}
	}
	
	func collectAndAttemptApplyPromoCode(completion: @escaping (Swift.Result<Date, String>) -> ()) {
		AppDelegate.sharedInstance.alertWithTextField(title: "Promo Code", placeholder: "Enter code", okButtonTitle: "Submit") { result in
			
			if result == "<cancelled>" {
				completion(.failure("Cancelled"))
			} else {
				FIOControlFullscreenActivity.shared.presentOverRoot()
				FIOAppSync.sharedInstance.setPromoCode(promoCode: result) { res in
					switch res {
					case .success(let timestamp):
						let d = Date.fromEpochSeconds(timestamp)
						AppDelegate.sharedInstance.presentAlertWithTitle("Success", message: "Free trial extended until \(d.toFriendly_long()).", singleActionString: "👍")
						self.checkSubscriptionState() { (ss, err) in
							FIOControlFullscreenActivity.shared.hide()
							completion(.success(d))
						}
					case .failure(let fail):
						AppDelegate.sharedInstance.presentAlertWithTitle("⚠️ Promo Code Issue ⚠️", message: fail.localizedDescription) { action in
							self.collectAndAttemptApplyPromoCode(completion: completion)
						}
					}
				}
			}
		}
	}
	
}

extension FIOSubscriptionEngine: SKPaymentTransactionObserver {
	
	internal func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		print(self.className + " " + #function)
		os_log("[QUANTA] Received transaction from Apple. Total count = %d", transactions.count)

		var transactionsToProcess = transactions // make it mutable
		
		// Sort them by date descending
		if (transactionsToProcess.count > 1) {
			transactionsToProcess = transactionsToProcess.sorted(by: { $0.transactionDate!.compare($1.transactionDate!) == .orderedDescending })
		}
 
		// Handle restored transactions
		let restoredTransactions = transactionsToProcess.filter { $0.transactionState == .restored }
		os_log("[QUANTA] %d RESTORE TRANSACTIONS RECEIVED", restoredTransactions.count)
		if restoredTransactions.count > 0 {
			os_log("[QUANTA] validating latest restored transaction. Finishing the rest immediately.")
			QMix.track(.eventMembershipRestored)
			transactionsToProcess = transactionsToProcess.filter { $0.transactionState != .restored } // Limit the set for further processing below
			print("last restored transaction: " + restoredTransactions[0].description)
			for (idx, tx) in restoredTransactions.enumerated() {
				if idx > 0 { SKPaymentQueue.default().finishTransaction(tx) }
			}
			receiptValidationForTransaction(restoredTransactions[0]) // Or should this validate $0.original?
		}
		
		// Handle purchase transactions
		let purchaseTransactions = transactionsToProcess.filter { $0.transactionState == .purchased }
		os_log("[QUANTA] %d PURCHASE TRANSACTIONS RECEIVED", purchaseTransactions.count)
		if purchaseTransactions.count > 0 {
			os_log("[QUANTA] validating latest purchase transaction. Finishing the rest immediately.")
			QMix.track(.eventMembershipActivated)
			transactionsToProcess = transactionsToProcess.filter { $0.transactionState != .purchased } // Limit the set for further processing below
			print("last purchased transaction: " + purchaseTransactions[0].description)
			for (idx, tx) in purchaseTransactions.enumerated() {
				if idx > 0 { SKPaymentQueue.default().finishTransaction(tx) }
			}
			receiptValidationForTransaction(purchaseTransactions[0])
		}

		// Log whatever's left & handle failed transactions
		transactionsToProcess.forEach {
			os_log("[QUANTA] OTHER TRANSACTION STATE: %d", $0.transactionState.rawValue)
//			Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "PromoCodeQuery()")
			Rollbar.info("[QUANTA] OTHER TRANSACTION STATE: \($0.transactionState.rawValue)")

			if $0.transactionState == .failed {
				os_log("[QUANTA] PURCHASE FAILED (OR WAS CANCELLED BY USER PART WAY THROUGH)")
				Rollbar.info("[QUANTA] PURCHASE FAILED (OR WAS CANCELLED BY USER PART WAY THROUGH)")
				if let e = $0.error {
					os_log("[QUANTA] ERROR =\n%@", e.localizedDescription)
					Rollbar.error("[QUANTA] ERROR = \(e.localizedDescription)")
				}
				SKPaymentQueue.default().finishTransaction($0)
				NotifCenter.post(name: .FIOSubscriptionPurchaseFailedOrCancelled, object: nil)
			}
		}
	}

	internal func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
		print(#function + " transactions on queue = " + queue.transactions.count.asString)
		
		if queue.transactions.count == 0 {
			NotifCenter.post(name: .FIOSubscriptionRestoreDidNotFindValidSubscription, object: nil)
		}
	}

	internal func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
		print(self.className + " " + #function)
		NotifCenter.post(name: .FIOSubscriptionRestoreFailed, object: nil)
	}
	
	internal func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
		print(self.className + " " + #function)
	}
	
	internal func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
		print(#function + " count = " + transactions.count.asString)
	}
	
//	internal func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
//		print(self.className + " " + #function)
//	}
	
}

extension FIOSubscriptionEngine: SKProductsRequestDelegate {
	
	internal func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//		print("Got the productsRequest response from Apple.")
		os_log("[QUANTA] Received available products. Count = %d", response.products.count)

		response.products.forEach { print($0.description) }
		self.products = response.products
		self.hasProduct = response.products.count > 0
	}
	
}

// MARK: - Singleton

extension FIOSubscriptionEngine {
	
	struct Static {
		static var instance: FIOSubscriptionEngine?
	}
	
	class var shared: FIOSubscriptionEngine {
		if Static.instance == nil {
			Static.instance = FIOSubscriptionEngine()
		}
		
		return Static.instance!
	}
	
	func dispose() {
		print("Disposed Singleton instance FIOSubscriptionEngine")
	}
	
}

class FIOSubscriptionState {
	
	var isValid: Bool = false

	var expiresDateStr: String = ""
	var expiresSec: Int = 0
	var expiresDate: Date?
	var isInTrial: Bool = true
	var subscriptionStartDate: Date?
	var inBillingRetry: Bool = false
	var latestTransactionDateSec: Int = 0
	var isInPromoCodePeriod: Bool = false
//	var willAutoRenew: FIOExpirationIntent = .NotSet
	var expirationIntent: FIOExpirationIntent = .NotSet

	init(_ val: GetSubscriptionStatusQuery.Data.GetSubscriptionStatus) {
		if
			let promoExpiresSec = val.promoGrantUntilTimestamp,
			let appleSubscriptionExpiresSec = val.expiresDateSec,
			promoExpiresSec > appleSubscriptionExpiresSec.asDouble
		{ // takes precedence over apple subscription if it is later
			let d = Date(timeIntervalSince1970: promoExpiresSec)
			expiresDate = d
			expiresDateStr = d.toYYYYMMDD()
			isInPromoCodePeriod = true
		} else {
			expiresDateStr = val.expiresDateFormattedPst ?? ""
			expiresSec = val.expiresDateSec ?? 0
			expiresDate = Date(timeIntervalSince1970: expiresSec.asDouble)
			isInTrial = val.isTrialPeriod ?? false
			subscriptionStartDate = Date(timeIntervalSince1970: (val.originalTransactionDateSec ?? 0).asDouble)
			latestTransactionDateSec = val.latestTransactionDateSec ?? 0
			if let ibr = val.isInBillingRetryPeriod {
				inBillingRetry = ibr
			}
			if let ei = val.autoRenewStatus {
				expirationIntent = FIOExpirationIntent(rawValue: ei)!
			} else if let ei = val.expirationIntent {
				expirationIntent = FIOExpirationIntent(rawValue: ei)!
			}
		}
		if let d = expiresDate {
			isValid = Date().timeIntervalSince(d).sign == FloatingPointSign.minus
			if !isValid { isInPromoCodePeriod = false }
		} else {
			isValid = false
			isInPromoCodePeriod = false
		}
	}
	
	init(_ val: ValidateReceiptMutation.Data.ValidateReceipt) {
		expiresDateStr = val.expiresDateFormattedPst ?? ""
		expiresSec = val.expiresDateSec ?? 0
		expiresDate = Date(timeIntervalSince1970: expiresSec.asDouble)
		isInTrial = val.isTrialPeriod ?? false
		subscriptionStartDate = Date(timeIntervalSince1970: (val.originalTransactionDateSec ?? 0).asDouble)
		latestTransactionDateSec = val.latestTransactionDateSec ?? 0
		if let ibr = val.isInBillingRetryPeriod {
			inBillingRetry = ibr
		}
		if let ei = val.autoRenewStatus {
			expirationIntent = FIOExpirationIntent(rawValue: ei)!
		} else if let ei = val.expirationIntent {
			expirationIntent = FIOExpirationIntent(rawValue: ei)!
		}
		if let d = expiresDate {
			isValid = Date().timeIntervalSince(d).sign == FloatingPointSign.minus
		} else {
			isValid = false
		}
	}
	
	enum FIOExpirationIntent: Int {
		case NotSet = 0
		case VoluntaryChurn = 1
		case InvoluntaryChurn = 2
	}
	
}
