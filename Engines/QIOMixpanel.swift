//
//  QIOMixpanel.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/19/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Mixpanel

class QIOMixpanel {

	@discardableResult
	init() {
		Mixpanel.sharedInstance(withToken: "d3e149a9e50929298ac9a541fe69bb17")
	}
	
	func track(
		_ event: QIOMixpanelEvent,
		_ properties: [String: String]? = nil
	) {
		var p = [String: String]()
		if let passedProps = properties {
			p = passedProps
		}
		p["PROD"] = Env.isProduction().asString
		
		Mixpanel.sharedInstance()?.track(
			event.rawValue,
			properties: p)
	}
	
}

enum QIOMixpanelEvent: String {
	
	// APP-LEVEL EVENTS
	case appForegrounded = 				"APP_Foregrounded"
	case appBackgrounded = 				"APP_Backgrounded"

	// VIEW LOADS
	case viewAuthLanding = 				"VIEW_AuthLanding"
	case viewEnterVerificationCode = 	"VIEW_EnterVerificationCode"
	case viewLinkBankLanding = 			"VIEW_LinkBankLanding"
	case viewLinkingAccountSelection = 	"VIEW_AccountSelection"
	case viewLinkingTxImport = 			"VIEW_TxImport"
	case viewLinkingQuantizing = 		"VIEW_Quantizing"
	case viewLinkingQuantizeFinale = 	"VIEW_QuantizeFinale"
	case viewMembershipMerchInitial = 	"VIEW_MembershipMerchInitial"
	case viewMembershipMerchRestart = 	"VIEW_MembershipMerchRestart"
	case viewCoreDetail 			= 	"VIEW_CoreDetail"

	// EVENTS
	case eventUserSetLoose = 			"EVENT_UserSetLoose"
	case eventItemLinked = 				"EVENT_ItemLinked"
	case eventBioIdEnabled = 			"EVENT_BioIdEnabled"
	case eventMembershipActivated = 	"EVENT_MembershipActivated"
	case eventMembershipRestored = 		"EVENT_MembershipRestored"
	case eventPlaidLinkSuccess = 		"EVENT_PlaidLinkSuccess"
	case eventPlaidLinkFailed = 		"EVENT_PlaidLinkFailed"

	// ACTIONS
	case actionDeleteAccount = 			"ACTION_DeleteAccount"
	case actionSignOut = 				"ACTION_SignOut"
	case actionNotifsSoftDecline = 		"ACTION_NotifsSoftDecline"
	case actionNotifsSoftApprove = 		"ACTION_NotifsSoftApprove"
	case actionNotifsHardDecline = 		"ACTION_NotifsHardDecline"
	case actionNotifsHardApprove = 		"ACTION_NotifsHardApprove"

}

// MARK: - Singleton

extension QIOMixpanel {
	
	struct Static {
		static var instance: QIOMixpanel?
	}
	
	class var shared: QIOMixpanel {
		if Static.instance == nil {
			Static.instance = QIOMixpanel()
		}
		return Static.instance!
	}
	
	func dispose() {
		QIOMixpanel.Static.instance = nil
		print("Disposed Singleton instance QIOMixpanel")
	}
	
}

