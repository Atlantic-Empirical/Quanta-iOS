//
//  FIOTransaction.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 12/19/18.
//  Copyright © 2018-2019 Flow Capital, LLC. All rights reserved.
//

class FIOTransaction: NSObject {

	// MARK: - Properties
	
	var amount: Double = 0
	var name: String = ""
	var friendlyName: String = ""
	var fioCategoryId: Int = 0
	var transaction_id: String = ""
	var date: String = ""
	var masterAccountId: String = ""
	var pending: Bool = false
	
//	GraphQLField("category", type: .list(.scalar(String.self))),
//	GraphQLField("masterAccountId", type: .scalar(String.self)),
//	GraphQLField("account_owner", type: .scalar(String.self)),
//	GraphQLField("category_id", type: .scalar(Double.self)),
//	GraphQLField("insertTimestamp", type: .scalar(Double.self)),
//	GraphQLField("institution_id", type: .scalar(String.self)),
//	GraphQLField("item_id", type: .scalar(String.self)),
//	GraphQLField("pending", type: .scalar(Bool.self)),
//	GraphQLField("pending_transaction_id", type: .scaalar(String.self)),
//	GraphQLField("transaction_type", type: .scalar(String.self)),
//	GraphQLField("account_name", type: .scalar(String.self)),
//	GraphQLField("account_institution_name", type: .scalar(String.self)),
//	GraphQLField("location", type: .object(Location.selections)),
//	GraphQLField("payment_meta", type: .object(PaymentMetum.selections)),
	
	// MARK: - Lifecycle
	
	init(_ tx: QPeriod.PeriodSummary.Transaction.Debit.Transaction) {
		super.init()
		amount = tx.amount
		date = tx.date
		transaction_id = tx.transactionId
		fioCategoryId = tx.fioCategoryId
		name = tx.name
		friendlyName = tx.friendlyName ?? ""
		masterAccountId = tx.masterAccountId
		pending = tx.pending ?? false
	}

	init(_ tx: QTransaction) {
		super.init()
		amount = tx.amount
		date = tx.date
		transaction_id = tx.transactionId
		fioCategoryId = tx.fioCategoryId
		name = tx.name
		friendlyName = tx.friendlyName ?? ""
		masterAccountId = tx.masterAccountId
		pending = tx.pending ?? false
	}
	
	init(_ tx: QTransaction_Account) {
		super.init()
		amount = tx.amount
		date = tx.date
		transaction_id = tx.transactionId
		fioCategoryId = tx.fioCategoryId
		name = tx.name
		friendlyName = tx.friendlyName ?? ""
		masterAccountId = tx.masterAccountId
		pending = tx.pending ?? false
	}
	
}

extension Array where Element == QPeriod.PeriodSummary.Transaction.Debit.Transaction {
	
	var asFIOTransactionArray: [FIOTransaction] {
		let c = compactMap { $0 }
		return c.map { FIOTransaction($0) }
	}
	
}

extension Array where Element == QTransaction {
	
	var asFIOTransactionArray: [FIOTransaction] {
		let c = compactMap { $0 }
		return c.map { FIOTransaction($0) }
	}
	
}

extension Array where Element == QTransaction_Account {
	
	var asFIOTransactionArray: [FIOTransaction] {
		let c = compactMap { $0 }
		return c.map { FIOTransaction($0) }
	}
	
}


