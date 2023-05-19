//
//  AppDelegate.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/4/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

import CoreData
import UserNotifications
import AWSCore
import AWSMobileClient
import Rollbar
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	// MARK: - Properties
	
    var window: UIWindow?
    var navigationController: UINavigationController?
    var app: UIApplication?
	var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	var rvc: UIViewController?

	// MARK: - Singleton
	
    static var sharedInstance: AppDelegate {
		return UIApplication.shared.delegate as! AppDelegate
    }
	
	// MARK: - Lifecycle
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
//		QUser.signout()
		
		#if !DEBUG
		FORCE_PULL_FRESH_HOME = false
		colorful = false
		#endif
		
		self.app = application
		self.launchOptions = launchOptions

		// Logging Config
		let config: RollbarConfiguration = RollbarConfiguration()
		config.environment = self.environment
		Rollbar.initWithAccessToken("e1a1a7b3cd754616b10d26d43854c419", configuration: config)
		
		AWSDDLog.add(AWSDDTTYLogger.sharedInstance) // TTY = Xcode console
		AWSDDLog.sharedInstance.logLevel = .info
		
		// Init Branch
		let branch: Branch = Branch.getInstance()
		branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: { params, error in
			if error == nil {
				// params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
				// params will be empty if no data found
				// ... insert custom logic here ...
				print("params: %@", params as? [String: AnyObject] ?? {})
			}
		})
		
		// Init Mixpanel
		QIOMixpanel()
		
        // Init Nav Controller & Customize the Navigation Bar
        navigationController = UINavigationController()
		if let nc = navigationController {
			nc.navigationBar.prefersLargeTitles = false
			nc.isNavigationBarHidden = true // start with it hidden
			nc.viewControllers = [FIOAppLoadingViewController()]
		}
		
        // Setup Window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = navigationController
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible();
		
		// Clear Notification Badge
		UIApplication.shared.applicationIconBadgeNumber = 0

        // Our app startup routine
        self.freshStart()
		
        return true
    }

	// Respond to Universal Links
	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
		guard
			userActivity.activityType == NSUserActivityTypeBrowsingWeb,
			let incomingURL = userActivity.webpageURL,
			let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
			let path = components.path,
			let params = components.queryItems
			else { return false }
		
		print("path = \(path)")
		
		// Pass the url to the handle deep link call
		Branch.getInstance().continue(userActivity)

		if
			let testLink = params.first(where: { $0.name == "testUniversalLink" } )?.value
		{
			print("testLink = \(testLink)")
			return true
		} else {
			print("Invalid test path")
			return false
		}
	}
	
	// Respond to URI scheme links
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

		// Pass the url to the handle deep link call
		if Branch.getInstance().application(
			application,
			open: url,
			sourceApplication: sourceApplication,
			annotation: annotation) {
			// Branch handled the link
		} else {
			// If not handled by Branch, do other deep link routing for the Facebook SDK, Pinterest SDK, etc
		}
		
		return true
	}
	
    // MARK: - App Start Routine
	
	func freshStart() {
		print(self.className + " " + #function)
		
		// Init cache
		let _ = QIOCache.sharedInstance
		let _ = QAS
		
        initUser() {
			print("\n\n### INITIALIZED USER")
			print("###")

			if QUser.userIsInSandbox {
				FIOPlaidManager.sharedInstance.PLAID_ENV = .sandbox	// Set Plaid Env for Sandbox users
			}

			if let sub = QUser.userAttribute_sub {
				print("###\t\tSub: " + sub)
				Rollbar.currentConfiguration()?.setPersonId(sub, username: "", email: "")
			}

			if let phone = QUser.userAttribute_phone_number {
				print("###\t\tPhone: " + phone)
			}
			print("###\n")

			#if !targetEnvironment(simulator)
			self.initNotifs() {
				// Check if launched from notification
				// When the app launch after user tap on notification (originally was not running / not in background)
				// https://www.raywenderlich.com/156966/push-notifications-tutorial-getting-started
			}
			#endif

			self.checkQuantizingStatus() {
				
				if FORCE_PULL_FRESH_HOME {
					print("⚠️ Forcing pull of a fresh user home due to hard coded value. \(#file) \(#function) line: \(#line)")
				}
				
				QFlow.pullUserHome(forcePullFromSource: FORCE_PULL_FRESH_HOME) { (result, error) in
					if let _ = error { // Do nothing. The user is being kicked out already.
					} else {
						if QFlow.itemsNeedUpdating {
							self.bankReauth()
						} else {
							self.setUserLooseIntoApp()
						}
					}
				}
			}
        }
    }
	
	func bankReauth() {
		guard let nc = self.navigationController else { return }

		QFlow.pullUserHome(forcePullFromSource: true) { // doing this to ensure that we have the latest info here / not cached
			userHome, error in
			if let item = QFlow.itemsInNeedOfUpdate.first {
				
				guard let vc = nc.topViewController	else {
					print("⚠️ No topViewController to present Plaid Link upon.")
					return
				}

				NotifCenter.addObserver(
					vc,
					selector: #selector(vc.handlePlaidLinkSuccess),
					name: .FIOPlaidLinkSucceeded,
					object: nil)
				NotifCenter.addObserver(
					vc,
					selector: #selector(vc.handlePlaidLinkError),
					name: .FIOPlaidLinkError,
					object: nil)
				NotifCenter.addObserver(
					vc,
					selector: #selector(vc.handleExitWithMetadata),
					name: .FIOPlaidLinkExit,
					object: nil)
				
				FIOControlFullscreenActivity.shared.updateText("Update \(item.institutionName) Link")
				
				FIOPlaidManager.sharedInstance.enterItemUpdateFlow(item, vc: vc) {
					itemUpdated in
					if !itemUpdated {
						self.hardStopAlert(
							title: "Bank Link",
							message:"It seems that the bank link update didn't work.",
							singleActionName: "Try Again"
						) { action in
							self.bankReauth() // whatever they do, try again.
						}
					} else {
						print("The user should now be on the item connecting view now.")
						// FIXME: how does the user get set loose into the app?
					}
				}
			} else {
				// FAIL CASE
			}
		}
	}
	
	func setUserLooseIntoApp(_ debug: Bool = false) {
		guard let nc = navigationController	else { return }
		print(#function)
		
		QMix.track(.eventUserSetLoose)
		FIOControlFullscreenActivity.shared.hide() // In case it is still visible
		
		var d = debug
		#if !DEBUG
		d = false // GUARD: don't accidentially release a build to the public with this on
		#endif
		
		if d { // Load an arbitratry VC
//			let vc = QIOLinkLandingViewController()
//			let vc = QIONotifPermissonViewController()
//			let vc = QIOHomeViewController()
			let vc = QIOLinkFinaleViewController()
			nc.viewControllers = [vc]
		} else {
			if let _ = QFlow.userHome {
				let vc = QIOHomeViewController(showSearch: true, title: nil)
				if
					let lo = launchOptions,
					let remoteNotif: [String: AnyObject] = lo[UIApplication.LaunchOptionsKey.remoteNotification] as? [String : AnyObject]
				{
					vc.pendingNotif = remoteNotif
				} else {
					QIOAppReview.shared.incrementAndConditionalPrompt()
				}
				rvc = vc
			} else {
				rvc = QIOLinkLandingViewController()
			}
			nc.viewControllers = [rvc!]
		}
	}
	
    private func initUser(completion: @escaping QIOSimpleCompletion) {
        print("initUser")
        
        QUser.hydrateUser() { error in
			
            if let e = error {
                print("AppLaunch Error: " + e.localizedDescription) // Offline is the only case landing here currently.
				self.presentAlertWithTitle("⚠️", message: e.localizedDescription, singleActionString: "Retry", nc: self.navigationController) {
					(action) in
					
					self.freshStart()
				}
			} else {
				self.bioIdStep() {
					FIOSubscriptionEngine.shared.appLaunch() // Important that this happen here, as early as possible after user is hydrated
					
					var enforceSubscription: Bool = true
					
					#if targetEnvironment(simulator)
					print("*** NOT ENFORCING SUBSCRIPTION DUE TO SIMULATOR ENVIRONMENT ***")
					enforceSubscription = false
					#endif

					#if DEBUG
					print("*** NOT ENFORCING SUBSCRIPTION DUE TO DEBUG BUILD ***")
					enforceSubscription = false
					#endif

					if QUser.userIsInSandbox {
						print("*** NOT ENFORCING SUBSCRIPTION (user set to sandbox) ***")
						enforceSubscription = false
					}
					
					if enforceSubscription {
						// Now that we have a user check their subscription state
						FIOSubscriptionEngine.shared.checkSubscriptionState() { (subscriptionState, error) in
							if let ss = subscriptionState {
								DispatchQueue.main.async {
									if ss.isValid {
										print("User has a valid subscription until \(ss.expiresDateStr)")
										completion()
									} else {
										print("User's subscription is not valid")
										guard let nc = self.navigationController else { return }
										let vc = FIOSubscriptionIssueViewController()
										vc.completion = completion
										vc.subscriptionState = ss
										nc.pushViewController(vc, animated: false)
									}
								}
							} else {
								// Didn't get subscription state - probably means they've never had a subscription
								if let e = error {
									print("AppLaunch Error failed to get subscription state: " + e.localizedDescription)
									self.presentAlertWithTitle("⚠️", message: "Failed to get subscription status. \(e.localizedDescription)", singleActionString: "Retry", nc: self.navigationController) { action in
										self.freshStart()
									}
								} else {
									print("Server didn't return a subscription object. Means user has never had a subscription.")
									let vc = FIOSubscriptionOfferViewController()
									vc.completion = completion
									self.navigationController?.topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
									self.navigationController?.pushViewController(vc, animated: false)
								}
							}
						}
					} else {
						// short cut around subscription enforcement
						completion()
					}
				}
			}
		}
    }
	
	private func bioIdStep(_ completion: @escaping QIOSimpleCompletion) {
		var performBioId = QUser.userPrefReadBool(qPrefKey_bioIdIsEnabled)
		
		#if targetEnvironment(simulator) || DEBUG
		print("*** BIO ID IS DISABLED IN CODE FOR SIMULATOR OR DEBUG BUILD ***")
		performBioId = false
		#endif
		
		if performBioId {
			QBio.performBioAuth() { success in
				if success {
					completion()
				} else {
					self.presentAlertWithTitle(QBio.biometryTypeString, message: "Seems that \(QBio.biometryTypeString) sign-in failed. Try again?", singleActionString: "Yes", nc: self.navigationController) {
						alertAction in
						self.bioIdStep(completion)
					}
				}
			}
		} else {
			completion()
		}
	}
	
	func checkQuantizingStatus(completion: @escaping QIOSimpleCompletion = {}) {
		FIOAppSync.sharedInstance.isQuantizing() { res in
			switch res {
			case .success(let isRunning):
				if isRunning {
					let nc = UINavigationController(rootViewController: QIOQuantizeProgressViewController(completion))
					self.navigationController?.present(nc, animated: true)
				} else {
					completion()
				}
			case .failure(let err):
				print("Failed in checkQuantizingStatus() \(err)")
				completion()
			}
		}
	}

	func openPeriodDetailViewForYesterday() {
		QFlow.getThatFlow(windowSize: .day, forceWindowCount: 1) { (result, nextToken) in
			if let res = result.first {
				let vc = FIOPeriodDetailViewController(res)
				let nc = UINavigationController(rootViewController: vc)
				nc.navigationBar.setupForQuantaHome()
				vc.addNavBackButton()
				self.navigationController?.present(nc, animated: true) {
					nc.setNavigationBarHidden(false, animated: false)
				}
			}
		}
	}
	
	// MARK: -
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		
		let statusBarRect = UIApplication.shared.statusBarFrame
		guard let touchPoint = event?.allTouches?.first?.location(in: self.window) else { return }
		
		if statusBarRect.contains(touchPoint) {
			NotifCenter.post(name: .statusBarTappedNotification, object: nil)
		}
	}

    // MARK: - AWS Setup _ Instantiate the AWSMobileClient
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return AWSMobileClient.sharedInstance().interceptApplication(
//            application, open: url,
//            sourceApplication: sourceApplication,
//            annotation: annotation)
//
//    }
	
    // MARK: - Common Alerts

	func nop(_ msg: String? = nil) {
		DispatchQueue.main.async() {
			let alert = UIAlertController(
				title: "not implemented".uppercased(),
				message: msg,
				preferredStyle: .alert
			)
			alert.addAction(UIAlertAction(title: "ok", style: .default))
			self.navigationController?.present(alert, animated: true)
		}
	}

	func hardStopAlert(title: String, message: String, singleActionName: String = "Ok", completion: ((UIAlertAction) -> Void)? = { _ in }) {
		if let nc = self.navigationController {
			DispatchQueue.main.async() {
				let alert = UIAlertController(title: "🆘  " + title + "  🆘", message: "\n" + message, preferredStyle: .alert)
				let action = UIAlertAction(title: singleActionName, style: .default, handler: completion)
				alert.addAction(action)
				let sendSupportMessage = UIAlertAction(title: "Contact Quanta Support", style: .default) { action in
					self.contactActionSheet(completion: completion)
				}
				alert.addAction(sendSupportMessage)
				nc.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	func presentAlertWithTitle(
		_ title: String,
		message: String = "",
		singleActionString: String = "OK",
		nc: UINavigationController? = nil,
		completion: @escaping ((UIAlertAction) -> Void) = { _ in }
	) {
		DispatchQueue.main.async() {
			var nc2 = nc
			if nc2 == nil {
				if let nc1 = self.navigationController {
					nc2 = nc1
				} else {
					return
				}
			}
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			let action = UIAlertAction(title: singleActionString, style: .default, handler: completion)
			alert.addAction(action)
			nc2!.present(alert, animated: true, completion: nil)
		}
	}
	
	func alertWithTextField(title: String? = nil, message: String? = nil, placeholder: String? = nil, cancelButtonTitle: String = "Cancel", okButtonTitle: String = "Ok", completion: @escaping ((String) -> Void) = { _ in }) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addTextField() { newTextField in newTextField.placeholder = placeholder }
		alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in completion("<cancelled>") })
		alert.addAction(UIAlertAction(title: okButtonTitle, style: .default) { action in
			if
				let textFields = alert.textFields,
				let tf = textFields.first,
				let result = tf.text
			{ completion(result) }
			else
			{ completion("") }
		})
		navigationController?.present(alert, animated: true)
	}
	
	func contactActionSheet(errorText: String = "", nc: UINavigationController? = nil, completion: ((UIAlertAction) -> Void)? = { _ in }) {
		let alertController = UIAlertController(title: "💡 🤔 🆘", message: "CONTACT US WITH YOUR:\nIdeas, questions, & problems.\n We love to hear from you!", preferredStyle: .actionSheet)
		let subject = ""
		var body = ""
		let emailAction = UIAlertAction(title: "Email", style: .default) { action in
			if errorText != "" {
				body = ("\n\n\nERROR INFO\n" + errorText).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
			}
			if self.appInstalled("gmail") {
				if let url = URL(string: "googlegmail:///co?to=\(supportEmailAddress)&subject=\(subject)&body=\(body)") {
					UIApplication.shared.open(url, options: [:]) { result in }
				}
			} else if self.appInstalled("inbox") {
				if let url = URL(string: "inbox-gmail://co?to=\(supportEmailAddress)&subject=\(subject)&body=\(body)") {
					UIApplication.shared.open(url, options: [:]) { result in }
				}
			} else {
				UIApplication.shared.open(URL(string: "mailto:\(supportEmailAddress)?subject=\(subject)&body=\(body)")!)
			}
			completion?(action)
		}
		alertController.addAction(emailAction)
		let iMessageAction = UIAlertAction(title: "iMessage", style: .default) { action in
			if errorText != "" {
				body = ("ERROR INFO\n" + errorText).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
			}
			UIApplication.shared.open(URL(string: "sms:\(supportPhoneNumber)&body=\(body)")!)
			completion?(action)
		}
		alertController.addAction(iMessageAction)
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: completion)
		alertController.addAction(cancel)
		if let nc = nc {
			nc.present(alertController, animated: true)
		} else {
			navigationController?.present(alertController, animated: true)
 		}
	}
	
	func appInstalled(_ appId: String) -> Bool {
		var urlString = ""
		switch appId {
		case "gmail": urlString = "googlegmail://"
		case "inbox": urlString = "inbox-gmail://"
		default: return false
		}
		if let appURL = URL(string: urlString) {
			let canOpen = UIApplication.shared.canOpenURL(appURL)
			print("Can open \"\(appURL)\": \(canOpen)")
			return canOpen
		} else { return false }
	}
	
	// MARK: - Computed Vars
	
	lazy var environment: String = {
		#if targetEnvironment(simulator) || DEBUG
		return "development"
		#else
		return "production"
		#endif
	}()
	
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Tillamook")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
	
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension AppDelegate {
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		QMix.track(.appBackgrounded)
		FIOAppSync.sharedInstance.onAppBackground()
		QFlow.onAppBackground()
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
		NotifCenter.post(name: .applicationWillEnterForeground, object: nil)
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		QMix.track(.appForegrounded)
		#if !targetEnvironment(simulator)
		QNotifs.checkNotificationPermissionSetting()
		#endif
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}
	
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		if
			let vvc = navigationController?.visibleViewController,
			vvc is QIOChartViewController &&
			!vvc.isBeingDismissed
		{
			return UIInterfaceOrientationMask.landscape
		} else {
			return UIInterfaceOrientationMask.portrait
		}
	}
	
}

// MARK: - Notifications

extension AppDelegate {
	
	private func initNotifs(completion: @escaping () -> Void) {
		print(#function)
		QIONotificationManager.Static.instance = QIONotificationManager(completion)
	}
	
	func application(
		_ application: UIApplication,
		didReceiveRemoteNotification userInfo: [AnyHashable : Any],
		fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
	) {
		print(#function)
		// https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/pushing_updates_to_your_app_silently
	}

	func application(
		_ application: UIApplication,
		didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
	) {
		let tokenParts = deviceToken.map { data -> String in
			return String(format: "%02.2hhx", data)
		}
		
		let token: String = tokenParts.joined()
		print("Device Token: \(token)")
		QNotifs.APNSToken = token
	}
	
	func application(
		_ application: UIApplication,
		didFailToRegisterForRemoteNotificationsWithError error: Error
	) {
		if (error.code == 3010) {
			print("\n###\n### NO REMOTE NOTIFICATIONS IN SIMULATOR\n###\n")
		} else {
			print("\n###\n### FAILED TO REGISTER FOR REMOTE NOTIFICATIONS \(error)\n###\n")
		}
		QNotifs.APNSToken = ""
	}

}
