//
//  FIORecurringStream.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 2/22/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class FIORecurringStream: NSObject {
	
	public var streamType: String = ""
	public var periodSize: String = ""
	public var identifiedIn: String = ""
	public var slug: String = ""
	public var nameFriendly: String = ""
	public var tids: [String] = []
	public var amountDistribution: FIORecurringStreamAmountDistribution?
	public var dateDistribution: FIORecurringStreamDateDistribution?

//	init(_ stream: QSpending.Stream) {
//		super.init()
//
//		self.streamType = stream.streamType
//		self.periodSize = stream.periodSize
//		self.nameFriendly = stream.nameFriendly
//		self.tids = stream.tids
//		self.amountDistribution = FIORecurringStreamAmountDistribution(stream.amountDistribution)
//		self.dateDistribution = FIORecurringStreamDateDistribution(stream.dateDistribution)
//	}
	
	init(_ stream: QIncome.ActiveStream) {
		super.init()
		
		self.streamType = stream.streamType
		self.periodSize = stream.periodSize
		self.identifiedIn = stream.identifiedIn
		self.slug = stream.slug
		self.nameFriendly = stream.nameFriendly
		self.tids = stream.tids
		self.amountDistribution = FIORecurringStreamAmountDistribution(stream.amountDistribution)
		self.dateDistribution = FIORecurringStreamDateDistribution(stream.dateDistribution)
	}
	
	init(_ stream: QIncome.InactiveStream) {
		super.init()
		
		self.streamType = stream.streamType
		self.periodSize = stream.periodSize
		self.identifiedIn = stream.identifiedIn
		self.slug = stream.slug
		self.nameFriendly = stream.nameFriendly
		self.tids = stream.tids
		self.amountDistribution = FIORecurringStreamAmountDistribution(stream.amountDistribution)
		self.dateDistribution = FIORecurringStreamDateDistribution(stream.dateDistribution)
	}
	
	class FIORecurringStreamAmountDistribution: NSObject {
		
		public var annualEstimate: Double = 0
		public var totalAmountEver: Double = 0
		public var mean: Double = 0
		public var relativeStandardDeviationPct: Double = 0
		public var standardDeviation: Double = 0
		public var dailyEstimate: Double = 0
		public var monthlyEstimate: Double = 0
		public var sum: Double = 0

//		init(_ ad: QSpending.Stream.AmountDistribution) {
//			super.init()
//
//			self.annualEstimate = ad.annualEstimate
//			self.totalAmountEver = ad.totalAmountEver
//			self.mean = ad.mean
//			self.relativeStandardDeviationPct = ad.relativeStandardDeviationPct
//			self.standardDeviation = ad.standardDeviation
//			self.dailyEstimate = ad.dailyEstimate
//			self.monthlyEstimate = ad.monthlyEstimate
//			self.sum = ad.sum
//		}

		init(_ ad: QIncome.ActiveStream.AmountDistribution) {
			super.init()
			
			self.annualEstimate = ad.annualEstimate
			self.totalAmountEver = ad.totalAmountEver
			self.mean = ad.mean
			self.relativeStandardDeviationPct = ad.relativeStandardDeviationPct
			self.standardDeviation = ad.standardDeviation
			self.dailyEstimate = ad.dailyEstimate
			self.monthlyEstimate = ad.monthlyEstimate
			self.sum = ad.sum
		}

		init(_ ad: QIncome.InactiveStream.AmountDistribution) {
			super.init()
			
			self.annualEstimate = ad.annualEstimate
			self.totalAmountEver = ad.totalAmountEver
			self.mean = ad.mean
			self.relativeStandardDeviationPct = ad.relativeStandardDeviationPct
			self.standardDeviation = ad.standardDeviation
			self.dailyEstimate = ad.dailyEstimate
			self.monthlyEstimate = ad.monthlyEstimate
			self.sum = ad.sum
		}
		
	}

	class FIORecurringStreamDateDistribution: NSObject {
		
		public var avgDiffDays: Double = 0
		public var daysUntilNext: Int = 0
		public var duration: Int = 0
		public var firstDate: String = ""
		public var firstDaysAgo: Int = 0
		public var lastDate: String = ""
		public var lastDaysAgo: Int = 0
		public var relativeStandardDeviationPct: Double = 0
		public var standardDeviation: Double = 0
		
//		init(_ dd: QSpending.Stream.DateDistribution) {
//			super.init()
//
//			self.avgDiffDays = dd.avgDiffDays
//			self.daysUntilNext = dd.daysUntilNext
//			self.duration = dd.duration
//			self.firstDate = dd.firstDate
//			self.firstDaysAgo = dd.firstDaysAgo
//			self.lastDate = dd.lastDate
//			self.lastDaysAgo = dd.lastDaysAgo
//			self.relativeStandardDeviationPct = dd.relativeStandardDeviationPct
//			self.standardDeviation = dd.standardDeviation
//		}
		
		init(_ dd: QIncome.ActiveStream.DateDistribution) {
			super.init()
			
			self.avgDiffDays = dd.avgDiffDays
			self.daysUntilNext = dd.daysUntilNext
			self.duration = dd.duration
			self.firstDate = dd.firstDate
			self.firstDaysAgo = dd.firstDaysAgo
			self.lastDate = dd.lastDate
			self.lastDaysAgo = dd.lastDaysAgo
			self.relativeStandardDeviationPct = dd.relativeStandardDeviationPct
			self.standardDeviation = dd.standardDeviation
		}
		
		init(_ dd: QIncome.InactiveStream.DateDistribution) {
			super.init()
			
			self.avgDiffDays = dd.avgDiffDays
			self.daysUntilNext = dd.daysUntilNext
			self.duration = dd.duration
			self.firstDate = dd.firstDate
			self.firstDaysAgo = dd.firstDaysAgo
			self.lastDate = dd.lastDate
			self.lastDaysAgo = dd.lastDaysAgo
			self.relativeStandardDeviationPct = dd.relativeStandardDeviationPct
			self.standardDeviation = dd.standardDeviation
		}

	}
	
}


//init(_ stream: GetSpendStreamsQuery.Data.GetSpendStream.Stream) {
//	super.init()
//
//}
////	GraphQLField("payeeNameFriendly", type: .nonNull(.scalar(String.self))),
////	GraphQLField("periodSize", type: .nonNull(.scalar(String.self))),
////	GraphQLField("periodsPerYear", type: .nonNull(.scalar(Int.self))),
////	GraphQLField("streamType", type: .nonNull(.scalar(String.self))),
////	GraphQLField("transactionCount", type: .nonNull(.scalar(Int.self))),
////	GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
////	GraphQLField("amountDistribution", type: .nonNull(.object(AmountDistribution.selections))),
////	GraphQLField("dateDistribution", type: .nonNull(.object(DateDistribution.selections))),
////	GraphQLField("tids", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
////	GraphQLField("dates", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
