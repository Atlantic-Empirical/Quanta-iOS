//
//  GetTransactionsQueryDataGetTransaction+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/21/18.
//  Copyright © 2018-2019 Flow Capital LLC. All rights reserved.
//

extension QTransaction {
    
    public var description: String {
		var out: String = "\n\n $$$$  TRANSACTION DETAILS  $$$$\n\n"
		
		out += "name: " + name + "\n"
		
		out += "amount: " + amount.toCurrencyString() + "\n"

		let cats:[String?]? = self.category
		if (cats == nil) {
			out += "category: nil" + "\n"
		} else {
			let cats2: [String] = cats! as! [String]
			out += "category: " + cats2.asSentence + "\n"
		}
		
		out += "date: " + date + "\n"
		
		if let iT = self.insertTimestamp, let tI = TimeInterval(exactly: iT / 1000) {
				
			let date = Date(timeIntervalSince1970: tI)
			
			let dateFormatter = DateFormatter()
			dateFormatter.timeZone = TimeZone.current
			dateFormatter.locale = NSLocale.current
			dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
			out += "insertTimestamp: " + dateFormatter.string(from: date) + "\n"
		}
		
		if let cid = self.categoryId { out += "category_id: " + cid.asString + "\n" }
		out += "fioCategoryId: " + fioCategoryId.asString + "\n"
		out += "masterAccountId: " + masterAccountId + "\n"
		out += "account_name: " + (self.accountName ?? "") + "\n"
		out += "account_institution_name: " + (self.accountInstitutionName ?? "") + "\n"
		out += "account_owner: " + (self.accountOwner ?? "") + "\n"
		out += "instution_id: " + (self.institutionId ?? "") + "\n"
		out += "item_id: " + (self.itemId ?? "") + "\n"
		if let p = pending { out += "pending: " + String(p) + "\n" }
		out += "pending_transaction_id: " + (self.pendingTransactionId ?? "") + "\n"
		out += "transaction_id: " + transactionId + "\n"
		out += "transaction_type: " + (self.transactionType ?? "") + "\n"
//		out += "payment_meta: " + (self.paymentMeta?.description ??  "") + "\n"
		
		return out
	}
    
}

extension QTransaction.PaymentMetum {

    public var description: String {
		var out = "\n"
		
		out += "  byOrderOf: " + (self.byOrderOf ??  "nil") + "\n"
		out += "  payee: " + (self.payee ??  "nil") + "\n"
		out += "  payer: " + (self.payer ??  "nil") + "\n"
		out += "  paymentMethod: " + (self.paymentMethod ??  "nil") + "\n"
		out += "  paymentProcessor: " + (self.paymentProcessor ??  "nil") + "\n"
		out += "  ppdId: " + (self.ppdId ??  "nil") + "\n"
		out += "  reason: " + (self.reason ??  "nil") + "\n"
		out += "  referenceNumber: " + (self.referenceNumber ??  "nil") + "\n"
		
		return out
    }
    
}
