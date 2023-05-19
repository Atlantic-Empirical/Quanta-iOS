//
//  DeviceTokenManager.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 5/4/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//
//

import UserNotifications

class QIONotificationManager: NSObject {
	
	var notifPermissionStatus: UNAuthorizationStatus = .notDetermined
	
	convenience init(_ completion: @escaping QIOSimpleCompletion) {
		self.init()
		UNNotifCenter.delegate = self
		
		print("Locally cached APNS token = \(APNSToken)")

		let f = Defaults.integer(forKey: UserDefaultsKeys.notificationPermissionStatus)
		notifPermissionStatus = UNAuthorizationStatus(rawValue: f) ?? .notDetermined
		checkNotificationPermissionSetting() {
			completion()
		}
	}
	
	func propmtUserForNotificationPermission(completion: QIOTwoBoolCompletion? = nil) {
		if requestStatus == .hardAskDenied || notifPermissionStatus == .denied {
			hardPermissionRequiredAlert() { openedSettings in
				if let c = completion { c(true, openedSettings) }
			}
		} else {
			UNNotifCenter.requestAuthorization(
				options: [.alert, .badge, .sound],
				completionHandler: { authorized, error in
					print("\n###\n### NOTIFICATIONS requestAuthorization() result: \(authorized)\n###\n")
					
					if let e = error {
						let msg = "ERROR in propmtUserForNotificationPermission: \(e)"
						print(msg)
						Rollbar.error(msg)
						self.requestStatus = .errorCondition
						if let c = completion { c(false, false) }
					} else {
						if authorized {
							QMix.track(.actionNotifsHardApprove)
							Defaults.set(UNAuthorizationStatus.authorized.rawValue, forKey: UserDefaultsKeys.notificationPermissionStatus)
							Defaults.synchronize()
							self.registerForNotifications()
							self.requestStatus = .hardAskGranted
							if let c = completion { c(false, true) }
						} else {
							QMix.track(.actionNotifsHardDecline)
							Defaults.set(UNAuthorizationStatus.denied.rawValue, forKey: UserDefaultsKeys.notificationPermissionStatus)
							Defaults.synchronize()
							self.requestStatus = .hardAskDenied
							if let c = completion { c(false, false) }
						}
					}
				}
			)
		}
	}
	
	func hardPermissionRequiredAlert(completion: @escaping QIOBoolCompletion) {
		let goToSettingsAlert = UIAlertController(
			title: "Permission Needed",
			message: "Please approve notifications in settings.",
			preferredStyle: .alert)
		
		goToSettingsAlert.addAction(
			UIAlertAction(title: "Settings", style: .default) { action in
				DispatchQueue.main.async {
					guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
					if UIApplication.shared.canOpenURL(settingsUrl) {
						UIApplication.shared.open(settingsUrl) { success in
							print("Settings opened: \(success)") // Prints true
							completion(true)
						}
					}
				}
			}
		)
		goToSettingsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
			completion(false)
		})
		AppDelegate.sharedInstance.navigationController?.present(goToSettingsAlert, animated: true)
	}
	
	func registerForNotifications() {
		DispatchQueue.main.async {
			UIApplication.shared.registerForRemoteNotifications()
		}
	}
	
	/// Done becuase user may have changed it in settings area.
	func checkNotificationPermissionSetting(completion: QIOSimpleCompletion? = nil) {
		
        UNNotifCenter.getNotificationSettings { settings in
            print("\n###\n NOTIFICATION SETTINGS: \(settings)\n###\n")
			
			let freshStatus: UNAuthorizationStatus = settings.authorizationStatus
			
			if freshStatus != self.notifPermissionStatus || freshStatus == .notDetermined {
				print("NEW NOTIFICATION PERMISSION STATUS DETECTED")
				print("WAS: \(self.notifPermissionStatus.rawValue)")
				print("NOW IS: \(freshStatus.rawValue)")
				
				self.notifPermissionStatus = freshStatus
				
				switch freshStatus {
				case .authorized:
					self.registerForNotifications()
					self.requestStatus = .hardAskGranted
				case .denied:
					self.APNSToken = ""
					self.requestStatus = .hardAskDenied
				case .notDetermined:
					self.propmtUserForNotificationPermission()
				case .provisional: break
				@unknown default: break
				}
			} else if freshStatus == .authorized && self.APNSToken == "" {
				self.registerForNotifications()
			}
			if let c = completion { c() }
        }
    }

    // MARK: - Custom Token Management
	
	var APNSTokenExists: Bool {
		return APNSToken != ""
	}
	
	var APNSToken: String {
        get {
			if _APNSToken == "_" {
				if let locallyStoredToken = Defaults.string(forKey: UserDefaultsKeys.apnsDeviceToken) {
					_APNSToken = locallyStoredToken
				} else {
					_APNSToken = ""
				}
			}
            return _APNSToken
        }
        set {
			if newValue != _APNSToken {
				if newValue == "" {
					Defaults.removeObject(forKey: UserDefaultsKeys.apnsDeviceToken)
				} else {
					Defaults.set(newValue, forKey: UserDefaultsKeys.apnsDeviceToken)
				}
				Defaults.synchronize()
				updateRemoteApnsToken(tokenValue: newValue)
				_APNSToken = newValue
            }
        }
    }
	var _APNSToken: String = "_" // unchecked state
	
	func updateRemoteApnsToken(tokenValue: String) {
		#if targetEnvironment(simulator)
		return // No tokens for simulator (notifs not supported)
		#endif
		print("storeTokenRemote(" + tokenValue + ")")
        FIOAppSync.sharedInstance.updateDeviceToken(newToken: tokenValue)
    }
	
	// MARK: - Handling Notif Tap Cases
	
	func handleNotifTap(_ msg: [String: AnyObject]) {
		guard
			let customData = msg["customData"] as? [String: AnyObject],
			let messageType = customData["messageType"] as? Int,
			let aps = msg["aps"] as? [String: AnyObject],
			let alert = aps["alert"] as? [String: AnyObject]
			else {
				print("Opened app with unrecognized notif data")
				return
			}
		
		switch messageType {
			
		case 1:
			print("NOTIF: FLOW_NOTIF")
			AppDelegate.sharedInstance.openPeriodDetailViewForYesterday()
			if let d = customData["date"] as? String {
				print("Opened app with daily flow notif for date \(d)")
			}
			
		case 2:
			print("NOTIF: REAUTH")
			AppDelegate.sharedInstance.bankReauth()
			if let item_id = customData["item_id"] as? String {
				print("Opened app with item refresh notif for item: \(item_id).")
			}
			
		case 3:
			print("NOTIF: WINBACK_1")
			AppDelegate.sharedInstance.navigationController?.pushViewController(QIOMembershipViewController(), animated: true)

		case 4:
			print("NOTIF: NEW_VERSION")
			var title = "New Version Released"
			var body = "Check it out in the App Store."
			if let t = alert["title"] as? String {
				title = t
			}
			if let b = alert["body"] as? String {
				body = b
			}
			if let st = alert["subtitle"] as? String {
				body = st + "\n\n" + body
			}
			let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
			let action = UIAlertAction(title: "Go to App Store", style: .default) { action in
				if let writeReviewURL = URL(string: appUrlString) {
					UIApplication.shared.open(writeReviewURL, options: [:])
				}
			}
			alert.addAction(action)
			alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
			AppDelegate.sharedInstance.navigationController?.present(alert, animated: true)

		default:
			print("Opened app with unrecognized notif data")
		}
	}

	// MARK: - Notif Permission Request Status
	
	var requestStatus: eQIONotifRequestStatus {
		get {
			if _requestStatus == .notDetermined {
				let locallyStoredRequestStatus = Defaults.integer(forKey: UserDefaultsKeys.notifRequestStatus)
				return eQIONotifRequestStatus(rawValue: locallyStoredRequestStatus) ?? .notDetermined
			} else {
				return _requestStatus
			}
		}
		set {
			Defaults.set(newValue.rawValue, forKey: UserDefaultsKeys.notifRequestStatus)
			Defaults.synchronize()
			_requestStatus = newValue
		}
	}
	private var _requestStatus: eQIONotifRequestStatus = .notDetermined

	enum eQIONotifRequestStatus: Int {
		case notDetermined
		case softAskGranted
		case softAskDenied
		case hardAskGranted
		case hardAskDenied
		case errorCondition
	}
	
}

// MARK: - Local Notifs

extension QIONotificationManager {
	
	func postLocalNotif(
		title: String,
		subtitle: String? = nil,
		body: String,
		categoryId: String = "DEFAULT_CATEGORY",
		postInSeconds: Double = 5,
		badgeValue: NSNumber = 0,
		userInfo: [ AnyHashable : Any ] = [:]
	) {
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
		if let subtitle = subtitle { content.subtitle = subtitle }
		content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
		content.categoryIdentifier = categoryId
		content.sound = .default
		content.badge = badgeValue
		content.userInfo = userInfo

		let request = UNNotificationRequest(
			identifier: "quantaLocalNotif",
			content: content,
			trigger: UNTimeIntervalNotificationTrigger(
				timeInterval: postInSeconds,
				repeats: false
			)
		)
		
		UNNotifCenter.add(request) { error in
			if let error = error {
				print("FAILED to post local notif: " + error.localizedDescription)
			} else {
				print("Local notif was posted")
			}
		}
	}
	
}

// MARK: - UNUserNotificationCenterDelegate

extension QIONotificationManager: UNUserNotificationCenterDelegate {
	
	/// This function is called when the app receives a notification
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
	) {
		// show the notification alert (banner), and with sound
		completionHandler([.alert, .sound])
	}
	
	/// This function is called right after user taps on the notification
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void
	) {
		let application = UIApplication.shared
		
		switch application.applicationState {
			
		case .active:
			print("user tapped the notification when the app is in foreground")
			
		case .background:
			print("user tapped the notification when the app is in background")
			
		case .inactive:
			print("user tapped the notification when the app is in inactive state")
			// this seems to be simple background state, not clear when the background state above is active
			
		@unknown default:
			fatalError()
		}
		
		if let userInfo = response.notification.request.content.userInfo as? [String : AnyObject] {
			handleNotifTap(userInfo)
		}
		
		completionHandler()
	}
	
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		openSettingsFor notification: UNNotification?
	) {
		print(#function)
	}
	
}

// MARK: - Singleton

extension QIONotificationManager {
	
	struct Static {
		static var instance: QIONotificationManager?
	}
	
	class var sharedInstance: QIONotificationManager {
		if Static.instance == nil {
			Static.instance = QIONotificationManager()
		}
		return Static.instance!
	}
	
	func dispose() {
		QIONotificationManager.Static.instance = nil
		print("Disposed Singleton instance FIOAPNSManager")
		
	}
	
}
