//
//  FIOGetUserHomeQuery.Data.GetUserHome+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 9/28/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

extension QFinInd {


}

extension QHome {
	
	static func localCopyIsFresh() -> Bool {
		return QIOFileSystem.fileIsFresh(fileName: userHomeFileName)
	}
	
	func storeLocal() throws {
		do { try self.writeToLocalStore(fileName: userHomeFileName) }
		catch { throw error }
	}

	static func deleteLocal() {
		QIOFileSystem.deleteFile(fileName: userHomeFileName)
	}

	var description: String {
			var out: String = "\n\n USER HOME \n"
			
//			if let val = itemId { out.append("\tItem ID: " + val + "\n") }
//
//			if let val = webhooksTransactions { out.append("\tTransaction Webhooks: " + val.count.asString + "\n") }
//			else { out.append("\tNO TRANSACTION WEBHOOKS\n") }
//
//			if let val = webhooksIncome { out.append("\tIncome Webhooks: " + val.count.asString + "\n") }
//			else { out.append("\tNO INCOME WEBHOOKS\n") }
//
//			if let val = accounts { out.append("\tAccounts: " + val.count.asString + "\n") }
//			else { out.append("\tNO ACCOUNTS\n") }
//
//			if let val = transactions {
//				out.append("\tTransactions: " + "\n")
//				if let val2 = val.lastPullDate { out.append("\t\tLast Pull Date: " + val2 + "\n") }
//				out.append("\t\tTotal Count: " + val.totalCount.asString + "\n")
//				if let val2 = val.oldestTransaction { out.append("\t\tOldest: " + val2 + "\n") }
//			} else { out.append("\tNO TRANSACTIONS\n") }
//
//			if let val = income {
//				out.append("\tIncome: " + "\n")
//				if let val2 = val.lastPullDate { out.append("\t\tLast Pull Date: " + val2 + "\n") }
//				if let val2 = val.numberOfIncomeStreams { out.append("\t\tStream Count: " + val2.asString + "\n") }
//				if let val2 = val.lastPullDate { out.append("\t\tOldest Effective Date: " + val2 + "\n") }
//			} else { out.append("\tNO INCOME\n") }
//
//			if let val = dateSpend { out.append("\tDate Spend Exists: " + val.exists!.asString + "\n") }
//			else { out.append("\tNO DATE SPEND STATUS\n") }
//
//			if let val = dateNet { out.append("\tDate Net Exists: " + val.exists!.asString + "\n") }
//			else { out.append("\tNO DATE NET STATUS\n") }
			
			out.append("\n\n")
			
			return out
	}
	
	var isChurning: Bool {
		if
			let ss = subscriptionStatus,
			let hs = ss.hasSubscription,
			let pc = ss.isInPromo,
			let ir = ss.isRenewing
		{
			if pc { return false }
			if hs && ir { return false }
		}
		return true // 🤷🏻‍♂️
	}

}

extension QAccount {
//
//	public var displayName: String {
//		if name.lowercased() == "credit card" || name == "" {
//			if let offName = officialName {
//				if offName != "" {
//					return offName
//				}
//			}
//		}
//		return name
//	}

//	public var description: String {
//		var out: String = "\n\n USER HOME \n"
//		out.append("\n\n")
//		return out
//	}
	
}

extension QItem {
	
//	var nameShort: String {
//		let out = ""
//
//
//
//		return out
//	}

	var statusIsGood: Bool {
		var itemNeedsUpdate: Bool = false
		if let b = needsUpdate, b == true {
			itemNeedsUpdate = true
		}
		var itemHealthStatusIsBad: Bool = false
		if institutionDetails.healthStatus != "HEALTH_STATUS_GREEN" {
			itemHealthStatusIsBad = true
			print(institutionDetails.healthStatus)
		}
		var itemLinkHealthStatusIsBad: Bool = false
		if institutionDetails.linkHealthStatus != "HEALTH_STATUS_GREEN" {
			itemLinkHealthStatusIsBad = true
			print(institutionDetails.linkHealthStatus)
		}
		let linkStatusIsBad = itemNeedsUpdate || itemHealthStatusIsBad || itemLinkHealthStatusIsBad
		return !linkStatusIsBad
	}
	
	func logoUrlString() -> String {
		return linkLogoUrlRoot + self.env + "/" + self.institutionId
	}

	static func logoUrlString(env: String? = nil, insId: String) -> String {
		var _env = "production"
		if let e = env { _env = e }
		else { _env = FIOPlaidManager.sharedInstance.currentEnvironmentString }
		return linkLogoUrlRoot + _env + "/" + insId
	}

	func logoImage(completion: @escaping QIOImageCompletion) {
		DispatchQueue.global(qos: .background).async {
			let i = UIImage.cacheImage(self.logoUrlString(), isBase64String: true)
			DispatchQueue.main.async {
				completion(i)
			}
		}
	}
	
	static func logoImage(env: String? = nil, insId: String) -> UIImage {
		var _env = "production"
		if let e = env { _env = e }
		else { _env = FIOPlaidManager.sharedInstance.currentEnvironmentString }
		return UIImage.cacheImage(logoUrlString(env: _env, insId: insId), isBase64String: true)
	}
	
}

extension QSpending_Ble {
	
	subscript(catId: String) -> QSpending_Ble.Summary? {
		return summary.first { $0.categoryId == catId }
	}
	
	var estimatedDailyAmount: Double {
		return ( estimatedMonthlyAmount * 12 ) / daysInYear
	}
	
}
