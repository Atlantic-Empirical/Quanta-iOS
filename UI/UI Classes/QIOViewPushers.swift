//
//  QIOViewPushers.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 8/6/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Foundation

func pushTransactionListWithTransactions(
	_ transactions: [FIOTransaction],
	onNavigationController nc: UINavigationController?
) {
	nc?.pushViewController(
		FIOTransactionListViewController(transactions),
		animated: true
	)
}

func pushTransactionListWithTids(
	_ transactionIds: [String?],
	listType: QIOTransactionListType = .generic,
	onNavigationController nc: UINavigationController?
) {
	var title = ""
	switch listType {
	case .regularIncome: title = "Regular Income"
	case .deposits: title = "Deposits"
	case .transfers: title = "Transfers"
	default: title = "Transactions"
	}
	
	let nullsRemoved: [String] = transactionIds.compactMap { $0 }
	let vc = FIOTransactionListViewController(nullsRemoved)
	vc.customTitle = title
	vc.listType = listType
	nc?.pushViewController(
		vc,
		animated: true
	)
}
