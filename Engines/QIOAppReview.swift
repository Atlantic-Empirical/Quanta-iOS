//
//  QIOAppReview.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/18/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import StoreKit

let sessionCountBeforePrompting: Int = 6

class QIOAppReview {
	
	static func requestReviewDirect() {
		guard let writeReviewURL = URL(string: appUrlString + "?action=write-review")
			else { fatalError("Expected a valid URL") }
		UIApplication.shared.open(writeReviewURL, options: [:])
	}

	func resetChecks() {
		// Just for testing, reset the run counter and last bundle version checked
		Defaults.set(0, forKey: UserDefaultsKeys.processCompletedCountKey)
		Defaults.set("", forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
		print("All checks have been reset")
	}

	func incrementAndConditionalPrompt() {
		
		// If the count has not yet been stored, this will return 0
		var count = Defaults.integer(forKey: UserDefaultsKeys.processCompletedCountKey)
		count += 1
		Defaults.set(count, forKey: UserDefaultsKeys.processCompletedCountKey)
		
		print("incrementAndConditionalPrompt completed \(count) time(s)")
		
		// Get the current bundle version for the app
		let infoDictionaryKey = kCFBundleVersionKey as String
		guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
			else {
				print("Expected to find a bundle version in the info dictionary")
				return
			}
		
		let lastVersionPromptedForReview = Defaults.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
		
		// Has the process been completed sessionCountBeforePrompting times and the user has not already been prompted for this version?
		if
			count >= sessionCountBeforePrompting &&
			currentVersion != lastVersionPromptedForReview
		{
			let twoSecondsFromNow = DispatchTime.now() + 2.0
			DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
				SKStoreReviewController.requestReview()
				Defaults.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
			}
		}
	}
	
}

// MARK: - Singleton

extension QIOAppReview {
	
	struct Static {
		static var instance: QIOAppReview?
	}
	
	class var shared: QIOAppReview {
		if Static.instance == nil {
			Static.instance = QIOAppReview()
		}
		return Static.instance!
	}
	
	func dispose() {
		QIOAppReview.Static.instance = nil
		print("Disposed Singleton instance QIOAppReview")
	}
	
}
