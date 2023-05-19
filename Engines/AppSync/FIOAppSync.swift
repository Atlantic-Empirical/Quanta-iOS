//
//  FIOAppSync.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/1/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import AWSAppSync
import AWSMobileClient

class FIOAppSync {

	// MARK: - Properties
	
	private let database_name = "flow-app-db"
	private var appSyncClient: AWSAppSyncClient?
	private var qlUrl: String?
	private var haveEndpoint: Bool = false
	private var pullEndpointFailed: Bool = false
	
	// MARK: - Lifecycle

	private init() {
		print(#function)
		getEndpoint() { (url, err) in
			if let err = err {
				print(err.localizedDescription)
				self.pullEndpointFailed = true
			} else {
				do {
					self.qlUrl = url
					let databaseURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(self.database_name)
					let cacheConfiguration = AWSAppSyncCacheConfiguration(from: databaseURL)
					let cp = AWSMobileClient.sharedInstance()
//					let appSyncServiceConfig = try AWSAppSyncServiceConfig() // use awsconfiguration.json
					let appSyncServiceConfig = config(endpointUrlString: url!)
					let appSyncConfig = try AWSAppSyncClientConfiguration(
						appSyncServiceConfig: appSyncServiceConfig,
						credentialsProvider: cp,
						cacheConfiguration: cacheConfiguration)
					self.appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
					self.haveEndpoint = true
					print("\n###\n### AppSync initialized successfully\n###\n")
				} catch {
					print("\n\n*** ERROR initializing AppSync client. \(error)\n###\n")
					self.pullEndpointFailed = true
				}
			}
		}
	}
	
	private func getClient(_ completion: @escaping (AWSAppSyncClient) -> Void) {
		print(#function)
		if let asc = appSyncClient {
			completion(asc)
		} else if !haveEndpoint && !pullEndpointFailed { // Wait a second for this to complete
			print("ASC is waiting for endpoint to be returned")
			DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
				self.getClient(completion)
			}
		} else {
			fatalError("Could not get ASC client.")
		}
	}
	
	private func getEndpoint(completion: @escaping QIOStringErrorCompletion) {
		print(#function)
		guard
			let dictionary = Bundle.main.infoDictionary,
			let av = Bundle.main.appVersion,
			let build = dictionary["CFBundleVersion"] as? String
		else {
			completion(nil, FIOError.init("🛑 CRITICAL: FAILED TO GET VERSION & BUILD INFO FOR QL LOOKUP"))
			return
		}
		let ver = String(av.filter { !" \t".contains($0) }) // note: av comes with a \t tab for some reason
		let h: String = "https://ql.chedda.io/v\(ver).\(build)"
		print("PERFORMING QL LOOKUP FOR: \(h)")
		guard let url = URL(string: h) else {
			completion(nil, FIOError.init("🛑 CRITICAL: FAILED BUILD QL LOOKUP URL"))
			return
		}
		let session = URLSession.shared
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
			if let error = error {
				print(error)
				completion(nil, FIOError.init("DID NOT RECEIVE A QL URL. ERROR: \(error)"))
			} else if
				let data = data,
				let body = String(data: data, encoding: .utf8)
			{
				if body == "" {
					print("🛑 CRITICAL: QL URL LOOKUP RETURNED AN EMPTY STRING")
					AppDelegate.sharedInstance.hardStopAlert(
						title: "Critical Issue",
						message: "Quanta was not able to reach the server.",
						singleActionName: "Retry"
					) { alert in
						self.getEndpoint(completion: completion)
					}
				} else {
					//				print(body)
					completion(body, nil)
				}
			}
			else {
				print(response ?? "")
				completion(nil, FIOError.init("DID NOT RECEIVE A QL URL"))
			}
		})
		task.resume()
	}
	
    // MARK: - AppSync Client API
	
	func transactionsForAccount(
		_ maid: String,
		completion: @escaping (Swift.Result<[QTransaction_Account]?, Error>) -> ())
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: TransactionsForAccountQuery(maid: maid),
				cachePolicy: CachePolicy.fetchIgnoringCacheData)
				{ (result, error) in
					
					print("TransactionsForAccountQuery Returned")
					if let e = error {
						if e.code == -1009 {
							print("Offline")
						} else {
							print("APPSYNC ERROR in TransactionsForAccountQuery:")
							print(e.localizedDescription)
							Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "TransactionsForAccountQuery()")
						}
						completion(.failure(e))
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in TransactionsForAccountQuery:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "TransactionsForAccountQuery()")
								completion(.failure(e))
							} else {
								if let rd = r.data, let out = rd.transactionsForAccount {
									completion(.success(out))
								} else {
									print("No data returned.")
									completion(.failure(QIOError("\(#function): No data returned")))
								}
							}
						} else {
							completion(.failure(QIOError("\(#function): Result is nil")))
						}
					}
				}
			}
		}
	}
	
	func getInstitution(
		_ ins_id: String,
		completion: @escaping (Swift.Result<GetInstitutionQuery.Data.GetInstitution, Error>) -> ())
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: GetInstitutionQuery(ins_id: ins_id),
				cachePolicy: CachePolicy.fetchIgnoringCacheData)
				{ (result, error) in
					
					print("GetInstitutionQuery Returned")
					if let e = error {
						if e.code == -1009 {
							print("Offline")
						} else {
							print("APPSYNC ERROR in GetInstitutionQuery:")
							print(e.localizedDescription)
							Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.getInstitution()")
						}
						completion(.failure(e))
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in getInstitution:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.getInstitution()")
								completion(.failure(e))
							} else {
								if let rd = r.data, let ins = rd.getInstitution {
									completion(.success(ins))
								} else {
									print("No data returned.")
									completion(.failure(QIOError("\(#function): No data returned")))
								}
							}
						} else {
							completion(.failure(QIOError("\(#function): Result is nil")))
						}
					}
				}
			}
		}
	}
	
	func setPromoCode(
		promoCode: String,
		completion: @escaping (Swift.Result<Double, Error>) -> ())
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: PromoCodeQuery(promoCode: promoCode),
				cachePolicy: CachePolicy.fetchIgnoringCacheData)
				{ (result, error) in
					
					print("PromoCodeQuery Returned")
					if let e = error {
						if e.code == -1009 {
							print("Offline")
						} else {
							print("APPSYNC ERROR in PromoCodeQuery:")
							print(e.localizedDescription)
							Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "PromoCodeQuery()")
						}
						completion(.failure(e))
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in PromoCodeQuery:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "PromoCodeQuery()")
								completion(.failure(e))
							} else {
								if let rd = r.data, let pcObj = rd.promoCode, let timestamp = pcObj.promoGrantUntilTimestamp {
									if timestamp == 0 {
										completion(.failure(QIOError("Invalid promo code.")))
									} else {
										completion(.success(timestamp))
									}
								} else {
									print("No data returned.")
									completion(.failure(QIOError("\(#function): No data returned")))
								}
							}
						} else {
							completion(.failure(QIOError("\(#function): Result is nil")))
						}
					}
				}
			}
		}
	}

	func setAccountsHidden(
		accountIds: [String]? = nil,
		masterAccountIds: [String]? = nil,
		hiddenState: Bool = true,
		completion: @escaping (Swift.Result<Bool, Error>) -> ()
	) {
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: HideAccountsQuery(
					account_ids: accountIds,
					masterAccountIds: masterAccountIds,
					hiddenState: hiddenState),
				cachePolicy: CachePolicy.fetchIgnoringCacheData)
				{ (result, error) in
					
					print("HideAccountsQuery Returned")
					if let e = error {
						if e.code == -1009 {
							print("Offline")
						} else {
							print("APPSYNC ERROR in HideAccountsQuery:")
							print(e.localizedDescription)
							Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "HideAccountsQuery()")
						}
						completion(.failure(e))
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in HideAccountsQuery:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "HideAccountsQuery()")
								completion(.failure(e))
							} else {
								if let rd = r.data, let success = rd.hideAccounts {
									completion(.success(success))
								} else {
									print("No data returned.")
									completion(.failure(QIOError("\(#function): No data returned")))
								}
							}
						} else {
							completion(.failure(QIOError("\(#function): Result is nil")))
						}
					}
				}
			}
		}
	}

	func isQuantizing(completion: @escaping (Swift.Result<Bool, Error>) -> ()) {
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: GetQuantizeStatusQuery(),
				cachePolicy: CachePolicy.fetchIgnoringCacheData)
				{ (result, error) in
					
					print("GetQuantizeStatusQuery Returned")
					if let e = error {
						if e.code == -1009 {
							print("Offline")
						} else {
							print("APPSYNC ERROR in GetQuantizeStatusQuery:")
							print(e.localizedDescription)
							Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.GetQuantizeStatusQuery()")
						}
						completion(.failure(e))
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in GetQuantizeStatusQuery:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.GetQuantizeStatusQuery()")
								completion(.failure(e))
							} else {
								if let rd = r.data, let qStatus = rd.getQuantizeStatus {
									print("Quantize status = \(qStatus)")
									let out = qStatus.uppercased().starts(with: "STARTED")
									completion(.success(out))
								} else {
									print("No data returned.")
									completion(.failure(QIOError("\(#function): No data returned")))
								}
							}
						} else {
							completion(.failure(QIOError("\(#function): Result is nil")))
						}
					}
				}
			}
		}
	}
	
	func getSubscriptionStatus(
		completion: @escaping (GetSubscriptionStatusQuery.Data.GetSubscriptionStatus?, Error?) -> Void = { _,_  in })
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: GetSubscriptionStatusQuery(),
				cachePolicy: CachePolicy.fetchIgnoringCacheData)
				{ (result, error) in
					print("GetSubscriptionStatusQuery Returned")
					if let e = error {
						if e.code == -1009 {
							print("Offline")
						} else {
							print("APPSYNC ERROR in getSubscriptionStatus:")
							print(e.localizedDescription)
							Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.getSubscriptionStatus()")
						}
						completion(nil, e)
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in getSubscriptionStatus:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.getSubscriptionStatus()")
								completion(nil, e)
							} else {
								if let rd = r.data, let guh = rd.getSubscriptionStatus {
									// Got it!
									//							print(guh)
									completion(guh, nil)
								} else {
									print("No data returned.")
									completion(nil, nil)
								}
							}
						} else {
							completion(nil, nil)
						}
					}
				}
			}
		}
	}

	func verifyReceipt(
		receipt: String,
		completion: @escaping (ValidateReceiptMutation.Data.ValidateReceipt?) -> Void)
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.perform(
					mutation: ValidateReceiptMutation(receipt: receipt),
					queue: DispatchQueue.main,
					optimisticUpdate: nil,
					conflictResolutionBlock: nil,
					resultHandler: { (result, error) in
						
					if let e = error {
						print("APPSYNC ERROR in verifyReceipt:")
						print(e.localizedDescription)
						Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.verifyReceipt()")
						completion(nil)
					} else {
						if let r = result {
							if let d = r.data {
								completion(d.validateReceipt)
							} else if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in verifyReceipt:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.verifyReceipt()")
								completion(nil)
							}
						} else {
							print("ValidateReceiptMutation didn't receive result/data")
							completion(nil)
						}
					}
				})
			}
		}
	}

	func getPublicTokenForItem(
		_ item_id: String,
		completion: @escaping QIOStringErrorCompletion = { _,_ in })
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: GetPublicTokenForItemQuery(item_id: item_id),
				cachePolicy: CachePolicy.fetchIgnoringCacheData)
				{ (result, error) in
					
					print("GetPublicTokenForItemQuery Returned")
					if let e = error {
						if e.code == -1009 {
							print("Offline")
						} else {
							print("APPSYNC ERROR in getPublicTokenForItem:")
							print(e.localizedDescription)
							Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.getPublicTokenForItem()")
						}
						completion(nil, e)
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in getPublicTokenForItem:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.getPublicTokenForItem()")
								completion(nil, e)
							} else {
								if let rd = r.data, let publicToken = rd.getPublicTokenForItem {
									// Got it!
									// print(cd)
									completion(publicToken, nil)
								} else {
									print("No data returned.")
									completion(nil, nil)
								}
							}
						}
					}
				}
			}
		}
	}

	func putSub(
		sub: String,
		completion: @escaping (Bool) -> Void = { _ in })
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.perform(
					mutation: PutSubMutation(sub: sub),
					queue: DispatchQueue.main,
					optimisticUpdate: nil,
					conflictResolutionBlock: nil,
					resultHandler: { (selectionSet, error) in
						
					if let e = error {
						print("APPSYNC ERROR in putSub:")
						print(e.localizedDescription)
						Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.putSub()")
						completion(false)
					} else {
						if let r = selectionSet {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in putSub:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.putSub()")
								completion(false)
							} else {
								//						let result: AWSAppSync.GraphQLResult<Tillamook.PutSubMutation.Data>? = selectionSet
	//							print(r as Any)
								completion(true)
							}
						}
					}
				})
			}
		}
	}

	func userAuthExists(
		phoneNumber: String,
		completion: @escaping (Bool) -> Void = { _ in })
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: UserAuthExistsQuery(phoneNumber: phoneNumber),
				cachePolicy: .fetchIgnoringCacheData)
				{ (result, error) in
					
					print("UserAuthExistsQuery Returned")
					if let e = error {
						if e.code == -1009 {
							print("Offline")
						} else {
							print("APPSYNC ERROR in userAuthExists:")
							//						print(error as Any)
							print(e)
							print(String(describing: e))
							print(e.localizedDescription)
							Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.userAuthExists()")
							AWSMobileClient.sharedInstance().clearKeychain()
							Rollbar.info("Clearing keychain due to exception in userAuthExists()")
							
							//						let nse = e as NSError
							////						let type = e._userInfo!["error"]["type"] as? String
							//						if let ui = e._userInfo {
							//							print("ERROR")
							//							if let msg = ui["message"] as? String {
							//								print("###  Message:\t" + msg)
							//							}
							//							if let errorType = ui["__type"] as? String {
							//								print("###  Type:\t" + errorType)
							//								switch errorType {
							//								case "ResourceNotFoundException":
							//									print("Clearing Keychain")
							//									AWSMobileClient.sharedInstance().clearKeychain()
							//									print("Cleared Keychain")
							//								default:
							//									print("Error type not handled")
							//								}
							//							}
							//						}
						}
						completion(false)
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in userAuthExists:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.userAuthExists()")
								completion(false)
							} else {
								if let rd = r.data {
									let uax = rd.userAuthExists
									print("User exists for phone number: " + uax.asString)
									completion(uax)
								} else {
									print("No data returned.")
									completion(false)
								}
							}
						}
					}
				}
			}
		}
	}
	
	func searchTransactions(
		query: String,
		completion: @escaping ([SearchTransactionsQuery.Data.SearchTransaction]?) -> Void = { _ in })
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: SearchTransactionsQuery(query: query),
				cachePolicy: CachePolicy.fetchIgnoringCacheData)
				{ (result, error) in
					
					print("SearchTransactionsQuery Returned")
					if let e = error {
						if e.code == -1009 {
							print("Offline")
						} else {
							print("APPSYNC ERROR in searchTransactions:")
							print(e.localizedDescription)
							Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.searchTransactions()")
						}
						completion(nil)
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in searchTransactions:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.searchTransactions()")
								completion(nil)
							} else {
								if let rd = r.data, let txs = rd.searchTransactions {
									// Got it!
									//							print(cd)
									completion(txs)
								} else {
									print("No data returned.")
									completion(nil)
								}
							}
						}
					}
				}
			}
		}
	}

	/// Use this one on app start to get prior n periods backwards from today
	func getUserFlow(
		windowSize: FIOWindowSize,
		windowCount: Int,
		completion: @escaping ([QPeriod]) -> Void)
	{
//		print(self.className + " " + #function)

		var periodIdStart = ""
		var periodIdEnd = ""

		switch windowSize {

		case .day:
			periodIdStart = Date.yesterday.subtract(windowCount, windowSize: windowSize).toYYYYMMDD()
			periodIdEnd = Date.yesterday.toYYYYMMDD()
			
		case .week:
			periodIdStart = Date.yesterday.subtract(windowCount, windowSize: windowSize).toYYYYWW()
			periodIdEnd = Date.yesterday.toYYYYWW()

		case .month:
			periodIdStart = Date.yesterday.subtract(windowCount, windowSize: windowSize).toYYYYMM()
			periodIdEnd = Date.yesterday.toYYYYMM()

		default:
			print("Invalid input")
			completion([])
			return
		}

//		print(windowSize.rawValue)
//		print(windowCount)
//		print(periodIdStart)
//		print(periodIdEnd)

		getUserFlow(windowSize: windowSize, periodIdStart: periodIdStart, periodIdEnd: periodIdEnd, completion: completion)
	}
	
	/// Use this one when you need to specify specify start/end dates and/or page results with nextToken
	func getUserFlow(
		windowSize: FIOWindowSize,
		periodIdStart: String,
		periodIdEnd: String,
		nextToken: String? = nil,
		accumulator: [QPeriod]? = nil,
		completion: @escaping ([QPeriod]) -> Void)
	{
//		print(#function)
//		print(windowSize)
//		print(periodIdStart)
//		print(periodIdEnd)
//		print(nextToken ?? "No next token")
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: GetFlowPeriodsQuery(
					windowSize: windowSize.rawValue,
					periodIdStart: periodIdStart,
					periodIdEnd: periodIdEnd,
					nextToken: nextToken),
				cachePolicy: .fetchIgnoringCacheData)
				{ (result, error) in
					
					if let e = error {
						if e.code == -1009 {
							print("APPSYNC -- OFFLINE")
						} else {
							print("APPSYNC ERROR in getUserFlow:")
							print(e.localizedDescription)
							Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.getUserFlow()")
						}
						completion([])
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in getUserFlow:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.getUserFlow()")
								completion([])
							} else {
								if let rd = r.data {
									if let returnedPeriods = rd.getFlowPeriods.periods {
										//									print("Got a batch of \(returnedPeriods.count) periods for windowSize = \(windowSize)!")
										var accumulated = returnedPeriods
										if let a = accumulator { accumulated += a }
										//									print("Have accumulated \(accumulated.count) periods for windowSize = \(windowSize)")
										
										// DEBUG >
										//									if windowSize == .day {
										//										returnedPeriods.forEach {
										////											print($0.periodId)
										//											print($0.startDate)
										//										}
										//									}
										// < DEBUG
										
										if let nt = rd.getFlowPeriods.nextToken {
											// Need to go around again.
											print("Got a nextToken in flow period pull for windowSize = \(windowSize). Going around again.")
											self.getUserFlow(windowSize: windowSize, periodIdStart: periodIdStart, periodIdEnd: periodIdEnd, nextToken: nt, accumulator: accumulated, completion: completion)
										} else {
											// We're done
											//										print("Finished pulling periods for windowSize = \(windowSize) with a total of \(accumulated.count) periods.")
											let sortedPeriods = accumulated.sorted { $0.periodId > $1.periodId } // they come in NO order
											completion(sortedPeriods)
										}
									} else {
										print("GetFlowPeriodsQuery() NOTHING RETURNED. A")
										print(result as Any)
										completion([])
									}
								} else {
									print("GetFlowPeriodsQuery() NOTHING RETURNED. B")
									print(result as Any)
									completion([])
								}
							}
						}
					}
				}
			}
		}
    }
    
	func pullUserHome(
		completion: @escaping (GetUserHomeQuery.Data.GetUserHome?, Error?) -> Void = { _,_  in })
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: GetUserHomeQuery(),
				cachePolicy: CachePolicy.fetchIgnoringCacheData)
				{ (result, error) in
					
					print("GetUserHomeQuery Returned")
					if let e = error {
						if e.code == -1009 {
							print("Offline")
						} else {
							print("APPSYNC ERROR in pullUserHome:")
							print(e.localizedDescription)
							Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.pullUserHome()")
						}
						completion(nil, e)
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in pullUserHome:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.pullUserHome()")
								completion(nil, e)
							} else {
								if let rd = r.data, let guh = rd.getUserHome {
									// Got it!
									//							print(guh)
									completion(guh, nil)
								} else {
									print("No data returned.")
									completion(nil, nil)
								}
							}
						}
					}
				}
			}
		}
	}
    
    func pullTransactions(
		transaction_ids: [String]?,
		returnSummary: Bool = true,
		completion: @escaping ([QTransaction]?) -> Void = { _ in })
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: GetTransactionsQuery(transaction_ids: transaction_ids, returnSummary: returnSummary),
				cachePolicy: .fetchIgnoringCacheData)
				{ (result, error) in
					
					if let e = error {
						print("APPSYNC ERROR in GetTransactionsQuery:")
						print(e.localizedDescription)
						Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.pullTransactions()")
						completion(nil)
					} else if let r = result {
						if let re = r.errors {
							print("APPSYNC RESULT ERROR(S) in GetTransactionsQuery:\n" + String(describing: re))
							let e: Error = NSError.fromGraphQLErrors(re)
							Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.pullTransactions()")
							completion(nil)
						} else if let data = r.data {
							if let t = data.getTransactions {
								//                print(result?.data?.getTransactions! as Any)
								var out: [QTransaction] = t
								out = out.sorted { $0.date > $1.date }
								completion(out)
							} else {
								print("GetTransactionsQuery No transactions returned.")
								completion(nil)
							}
						}
					}
				}
			}
		}
    }

	func pullItemStatus(
		link_session_id: String? = nil,
		item_id: String? = nil,
		completion: @escaping (QItemStatus?) -> Void)
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
				query: GetItemStatusQuery(item_id: item_id, link_session_id: link_session_id),
				cachePolicy: .fetchIgnoringCacheData)
				{ (result, error) in
					if let e = error {
						print("APPSYNC ERROR in pullItemStatus:")
						print(e.localizedDescription)
						Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.pullItemStatus()")
						completion(nil)
					} else if let r = result {
						if let re = r.errors {
							print("APPSYNC RESULT ERROR(S) in pullItemStatus:\n" + String(describing: re))
							let e: Error = NSError.fromGraphQLErrors(re)
							Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.pullItemStatus()")
							completion(nil)
						} else if let data = r.data {
							if let itemStatus = data.getItemStatus {
								//                print(result?.data?.listFacAccounts! as Any)
								completion(itemStatus)
							} else {
								print("No item status returned.")
								completion(nil)
							}
						} else {
							print("No data and no error returned.")
							completion(nil)
						}
					}
				}
			}
		}
    }
	
	/// Intentionally fails silently, only logging info.
    func updateDeviceToken(newToken: String) {
		print(#function)
		var platform = QUser.userIsInSandbox ? "as" : "a"
		#if DEBUG
		platform = "as"
		#endif
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.perform(
					mutation: NewApnTokenMutation(token: newToken, platform: platform),
					queue: DispatchQueue.main,
					optimisticUpdate: nil,
					conflictResolutionBlock: nil,
					resultHandler: { (selectionSet, error) in
					
					if let e = error {
						print("APPSYNC ERROR in updateDeviceToken:")
						print(e.localizedDescription)
						Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.updateDeviceToken()")
					} else {
						if let r = selectionSet {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in updateDeviceToken:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.updateDeviceToken()")
							} else {
								//					let result: AWSAppSync.GraphQLResult<Tillamook.NewApnTokenMutation.Data>? = selectionSet
								//					print(result as Any)
							}
						}
					}
				})
			}
		}
    }
    
    func deleteUser(
		_ username_phonenumber: String,
		completion: @escaping (Bool, Error?) -> Void)
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
					query: DeleteUserQuery(dumbString: username_phonenumber)
				) { (result, error) in
					if let e = error {
						print("APPSYNC ERROR in deleteUser:")
						print(e.localizedDescription)
						Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.deleteUser()")
						completion(false, error)
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in deleteUser:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.deleteUser()")
								completion(false, e)
							} else if let d = r.data, let b = d.deleteUser {
								completion(b, nil)
							} else {
								completion(false, nil)
							}
						}
					}
				}
			}
		}
    }
    
	func putPlaidItem(
		item: FIOPlaidItemInput,
		force: Bool = false,
		isUpdate: Bool = false,
		completion: @escaping (Swift.Result<Bool, Error>) -> ()
	) {
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(
					query: PutItemQuery(
						item: item,
						force: force,
						isUpdate: isUpdate)
				) { (result, error) in
					print("PutItemQuery Returned")
					if let e = error {
						if e.code == -1009 {
							print("Offline")
						} else {
							print("APPSYNC ERROR in PutItemQuery:")
							print(e.localizedDescription)
							Rollbar.error(
								e.localizedDescription,
								exception: e as? NSException,
								data: nil,
								context: "PutItemQuery()")
						}
						completion(.failure(e))
					} else {
						if let r = result {
							if let re = r.errors {
								print("APPSYNC RESULT ERROR(S) in PutItemQuery:\n" + String(describing: re))
								let e: Error = NSError.fromGraphQLErrors(re)
								Rollbar.error(
									re.description,
									exception: e as? NSException,
									data: nil,
									context: "PutItemQuery()")
								completion(.failure(e))
							} else {
								if
									let success = r.data?.putItem
								{
									completion(.success(success))
								} else {
									print("No data returned.")
									completion(.failure(QIOError("\(#function): No data returned")))
								}
							}
						} else {
							completion(.failure(QIOError("\(#function): Result is nil")))
						}
					}
				}
			}
		}
    }
	
	func removeItem(
		_ item_id: String,
		completion: @escaping (Bool, Error?) -> Void)
	{
		print(#function)
		getClient { asc in
			DispatchQueue.global(qos: .userInitiated).async {
				asc.fetch(query: RemoveItemQuery(item_id: item_id)) {
					(result, error) in
					
					if let e = error {
						print("APPSYNC ERROR in removeItem:")
						print(e.localizedDescription)
						Rollbar.error(e.localizedDescription, exception: e as? NSException, data: nil, context: "FIOAppSync.removeItem()")
						completion(false, error)
					} else if let r = result {
						if let re = r.errors {
							print("APPSYNC RESULT ERROR(S) in removeItem:\n" + String(describing: re))
							let e: Error = NSError.fromGraphQLErrors(re)
							Rollbar.error(re.description, exception: e as? NSException, data: nil, context: "FIOAppSync.removeItem()")
							completion(false, e)
						} else if let d = r.data, let b = d.removeItem {
							completion(b, nil)
						} else {
							completion(false, nil)
						}
					}
				}
			}
		}
	}
	
	// MARK: - GraphQL Database File
	
	private func smashDbFile() {
		QIOFileSystem.deleteFile(fileName: database_name)
	}
	
	func onAppBackground() {
		if let u = QUser.user {
			if !u.isSignedIn { smashDbFile() }
		} else {
			print("no user")
			smashDbFile()
		}
	}

}

// MARK: - Singleton

extension FIOAppSync {
	
	struct Static {
		static var instance: FIOAppSync?
	}
	
	class var sharedInstance: FIOAppSync {
		if Static.instance == nil
		{
			Static.instance = FIOAppSync()
		}
		return Static.instance!
	}
	
	func dispose() {
		print(#function)
//		if let asc = appSyncClient {
////			asc.offlineMuationCacheClient = nil
//			appSyncClient = nil
//		}
		Static.instance = nil
		print("Disposed singleton instance FIOAppSync")
	}
	
}

//	// The API Key for authorization
//	static let StaticAPIKey = "da2-3pfd3jq2zfhxfg6gw6l63wvrny"

//	class APIKeyAuthProvider: AWSAPIKeyAuthProvider {
//		func getAPIKey() -> String {
//			// This function could dynamicall fetch the API Key if required and return it to AppSync client.
//			return StaticAPIKey
//		}
//	}

private struct config: AWSAppSyncServiceConfigProvider {
	var endpoint: URL
	var region: AWSRegionType = .USEast1
	var authType: AWSAppSyncAuthType = .awsIAM
	var apiKey: String? = nil
	var clientDatabasePrefix: String? = nil
	
	init(endpointUrlString: String) {
		endpoint = URL(string: endpointUrlString)!
		print("APPSYNC is using: \(endpointUrlString)")
	}
}
