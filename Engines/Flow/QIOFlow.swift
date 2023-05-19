//
//  QIOFlow.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/13/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import AWSAppSync

class QIOFlow {
	
    // MARK: - Properties
    var userHome: GetUserHomeQuery.Data.GetUserHome?
	var flowDays: [QPeriod]?
	var flowWeeks: [QPeriod]?
	var flowMonths: [QPeriod]?
	var allTransactions: [QTransaction]?

	// MARK: - Lifecycle

	private init() {
		print("FIOFlow init()")
		hydrateObjectsFromLocalStore()
	}
	
	func onAppBackground() {
		persistObjects()
	}
	
    // MARK: - API
	
	func pullUserHome(forcePullFromSource: Bool = false, completion: @escaping (GetUserHomeQuery.Data.GetUserHome?, Error?) -> Void = { _,_ in }) {
		print(#function)

		if !forcePullFromSource, let uh = userHome {
			print("Using cached userHome")
			completion(uh, nil)
			
		} else {
			print("Pulling fresh userHome")

			FIOAppSync.sharedInstance.pullUserHome() {
				(result: GetUserHomeQuery.Data.GetUserHome?, error: Error?) in
				
				if let newHome = result {
					self.userHome = newHome
					completion(newHome, nil)
				} else {
					if let e = error {
						print(String(describing: e))
						print("HARD UX STOP: pullUserHome() returned nothing. Either there's a problem in the server (bad QL response for userhome is most likely) or the user is offline.")
						let title = "Hey, sorry about this."
						let message = "\n\(appName) is trying to phone home but isn't getting through."
						let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
						let tryAgain = UIAlertAction(title: "Check Again", style: .default) { action in
							self.pullUserHome(completion: completion)
						}
						alert.addAction(tryAgain)
						let textAlex = UIAlertAction(title: "Send Error to Quanta", style: .default) { action in
							AppDelegate.sharedInstance.contactActionSheet(errorText: String(describing: e)) { action in
								self.pullUserHome(completion: completion) // put the alert back on screen
							}
						}
						alert.addAction(textAlex)
						AppDelegate.sharedInstance.navigationController!.present(alert, animated: true, completion: nil)
					} else {
						print("No userHome object returned but also no error. Presume that this is a new user and they've not linked a bank yet and thus CTN has never run for them")
						completion(nil, nil)
					}
				}
			}
		}
	}
	
	func getThatFlow(
		windowSize: FIOWindowSize,
		forceWindowCount: Int = 0,
		forcePullFromSource: Bool = false,
		completion: @escaping ([QPeriod], Error?) -> Void
	) {
		print(#function)
		var _windowCount: Int = 0

		switch windowSize {

		case .day:
			if !forcePullFromSource, let days = flowDays {
				print("Using cached flowDays")
				completion(days, nil)
				return
			} else {
				print("Will pull fresh flowDays")
				if forceWindowCount > 0 {
					_windowCount = forceWindowCount
				} else {
					_windowCount = defaultDayPullCount
				}
			}
			
		case .week:
			if !forcePullFromSource, let weeks = flowWeeks {
				print("Using cached flowWeeks")
				completion(weeks, nil)
				return
			} else {
				print("Will pull fresh flowWeeks")
				if forceWindowCount > 0 {
					_windowCount = forceWindowCount
				} else {
					_windowCount = defaultWeekPullCount
				}
			}
			
		case .month:
			if !forcePullFromSource, let months = flowMonths {
				print("Using cached flowMonths")
				completion(months, nil)
				return
			} else {
				print("Will pull fresh flowMonths")
				if forceWindowCount > 0 {
					_windowCount = forceWindowCount
				} else {
					_windowCount = defaultMonthPullCount
				}
			}

		default: break
		}
		
		FIOAppSync.sharedInstance.getUserFlow(windowSize: windowSize, windowCount: _windowCount) {
			result in

			switch windowSize {
				
			case .day:
				self.flowDays = result.sorted(by: { $0.startDate > $1.startDate })
			case .week:
				self.flowWeeks = result.sorted(by: { $0.startDate > $1.startDate })
			case .month:
				self.flowMonths = result.sorted(by: { $0.startDate > $1.startDate })
			default:
				completion([], FIOError("Invalid window size."))
				return
			}

			completion(result, nil)
		}
	}

	func pullMoreFlow(windowSize: FIOWindowSize, forceWindowCount: Int = 0, completion: @escaping ([QPeriod]?) -> Void) {
		print(#function)
		guard let fd = self.flowDays else { return }
		guard let fw = self.flowWeeks else { return }
		guard let fm = self.flowMonths else { return }

		var periodIdStart = ""
		var periodIdEnd = ""
		
		switch windowSize {
			
		case .day:
			let oldestFlowDateStr = fd.last!.startDate // same as endDate
			let oldestFlowDate = Date.fromYYYYMMDD(oldestFlowDateStr)
			let newPeriodIdEndDate = oldestFlowDate.subtract(1, size: .day)
			periodIdStart = newPeriodIdEndDate.subtract(defaultDayPullCount, windowSize: windowSize).toYYYYMMDD()
			periodIdEnd = newPeriodIdEndDate.toYYYYMMDD()

		case .week:
			let oldestFlowDateStr = fw.last!.startDate
			let oldestFlowDate = Date.fromYYYYMMDD(oldestFlowDateStr)
			let newPeriodIdEndDate = oldestFlowDate.subtract(1, size: .day)
			periodIdStart = newPeriodIdEndDate.subtract(defaultWeekPullCount, windowSize: windowSize).toYYYYWW()
			periodIdEnd = newPeriodIdEndDate.toYYYYWW()

		case .month:
			let oldestFlowDateStr = fm.last!.startDate
			let oldestFlowDate = Date.fromYYYYMMDD(oldestFlowDateStr)
			let newPeriodIdEndDate = oldestFlowDate.subtract(1, size: .month)
			periodIdStart = newPeriodIdEndDate.subtract(defaultMonthPullCount, windowSize: windowSize).toYYYYMM()
			periodIdEnd = newPeriodIdEndDate.toYYYYMM()

		default:
			print("Invalid input")
			completion([])
			return
		}
		
		FIOAppSync.sharedInstance.getUserFlow(windowSize: windowSize, periodIdStart: periodIdStart, periodIdEnd: periodIdEnd) {
			result  in
			
			switch windowSize {
				
			case .day:
				self.flowDays = (result + fd).sorted(by: { $0.startDate > $1.startDate })
				completion(self.flowDays)

			case .week:
				self.flowWeeks = (result + fw).sorted(by: { $0.startDate > $1.startDate })
				completion(self.flowWeeks)

			case .month:
				self.flowMonths = (result + fm).sorted(by: { $0.startDate > $1.startDate })
				completion(self.flowMonths)
				
			default:
				completion([])
			}
		}
	}

	func deleteAllLocalObjectFiles() {
		GetUserHomeQuery.Data.GetUserHome.deleteLocal()
		QIOFileSystem.deleteFile(fileName: flowDaysFileName)
		QIOFileSystem.deleteFile(fileName: flowWeeksFileName)
		QIOFileSystem.deleteFile(fileName: flowMonthsFileName)
		QIOFileSystem.deleteFile(fileName: allTransactionsFileName)
	}

	// MARK: - Local Object Persistence
	
	private func persistObjects() {
		do {
			if let uh = userHome {
				try uh.storeLocal()
			}
			if let days = flowDays {
				try days.map { $0 }.batchWriteToSingleFile(fileName: flowDaysFileName)
			}
			if let weeks = flowWeeks {
				try weeks.map { $0 }.batchWriteToSingleFile(fileName: flowWeeksFileName)
			}
			if let months = flowMonths {
				try months.map { $0 }.batchWriteToSingleFile(fileName: flowMonthsFileName)
			}
			if let at = allTransactions {
				try at.map { $0 }.batchWriteToSingleFile(fileName: allTransactionsFileName)
			}
		}
		catch {
			print("ERROR persiting local models: \(error).")
		}
	}
	
	private func hydrateObjectsFromLocalStore() {

		// ALL TRANSACTIONS
		if QIOFileSystem.fileIsFresh(fileName: allTransactionsFileName) {
			do {
				let a = try Array<GraphQLSelectionSet>(fromLocalFileName: allTransactionsFileName, ofType: QTransaction.self)
				allTransactions = a as? [QTransaction]
				print("allTransactions hydrated from local store.")
			}
			catch {
				print("Error hydrating allTransactions: \(error).")
				QIOFileSystem.deleteFile(fileName: allTransactionsFileName)
			}
		}
		
		// FLOW - DAYS
		if QIOFileSystem.fileIsFresh(fileName: flowDaysFileName) {
			do {
				let a = try Array<GraphQLSelectionSet>(fromLocalFileName: flowDaysFileName, ofType: QPeriod.self)
				if a.count > 0 {
					flowDays = a as? [QPeriod]
					print("flowDays hydrated from local store.")
				}
			}
			catch {
				print("Error hydrating flowDays: \(error).")
				QIOFileSystem.deleteFile(fileName: flowDaysFileName)
			}
		}
		
		// FLOW - WEEKS
		if QIOFileSystem.fileIsFresh(fileName: flowWeeksFileName) {
			do {
				let a = try Array<GraphQLSelectionSet>(fromLocalFileName: flowWeeksFileName, ofType: QPeriod.self)
				if a.count > 0 {
					flowWeeks = a as? [QPeriod]
					print("flowWeeks hydrated from local store.")
				}
			}
			catch {
				print("Error hydrating flowWeeks: \(error).")
				QIOFileSystem.deleteFile(fileName: flowWeeksFileName)
			}
		}

		// FLOW - MONTHS
		if QIOFileSystem.fileIsFresh(fileName: flowMonthsFileName) {
			do {
				let a = try Array<GraphQLSelectionSet>(fromLocalFileName: flowMonthsFileName, ofType: QPeriod.self)
				if a.count > 0 {
					flowMonths = a as? [QPeriod]
					print("flowMonths hydrated from local store.")
				}
			}
			catch {
				print("Error hydrating flowMonths: \(error).")
				QIOFileSystem.deleteFile(fileName: flowMonthsFileName)
			}
		}

		// USER HOME
		if GetUserHomeQuery.Data.GetUserHome.localCopyIsFresh() {
			do {
				userHome = try GetUserHomeQuery.Data.GetUserHome(fromLocalFileName: userHomeFileName)
				print("userHome hydrated from local store.")
			}
			catch {
				print("Error hydrating userHome: \(error).")
				QIOFileSystem.deleteFile(fileName: userHomeFileName)
			}
		}
		
	}
	
}

// MARK: - Period Persistence Utility

/// This exists to make it easy to use the functions in the GraphQLSelectionSet extension
class FIOFlowPeriodPersistanceUtility: GraphQLSelectionSet {
	required init(snapshot: Snapshot) {}
	static var selections: [GraphQLSelection] = []
	var snapshot: Snapshot = [:]
}

// MARK: - Singleton

extension QIOFlow {
	
	struct Static { static var instance: QIOFlow? }
	
	class var s: QIOFlow {
		if Static.instance == nil {
			Static.instance = QIOFlow()
		}
		return Static.instance!
	}
	
	func dispose() {
		userHome = nil
		deleteAllLocalObjectFiles()
		QIOFlow.Static.instance = nil
		print("Disposed Singleton instance FIOFlow")
	}
	
}
