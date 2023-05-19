//  This file was automatically generated and should not be edited.

import AWSAppSync

public struct FIOPlaidItemInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(metadata: FIOPlaidItemInputMetadata, linkSessionId: String, token: String) {
    graphQLMap = ["metadata": metadata, "linkSessionId": linkSessionId, "token": token]
  }

  public var metadata: FIOPlaidItemInputMetadata {
    get {
      return graphQLMap["metadata"] as! FIOPlaidItemInputMetadata
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "metadata")
    }
  }

  public var linkSessionId: String {
    get {
      return graphQLMap["linkSessionId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "linkSessionId")
    }
  }

  public var token: String {
    get {
      return graphQLMap["token"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "token")
    }
  }
}

public struct FIOPlaidItemInputMetadata: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(status: String? = nil, requestId: String? = nil, institution: FIOPlaidItemInputMetadataInstitution? = nil) {
    graphQLMap = ["status": status, "request_id": requestId, "institution": institution]
  }

  public var status: String? {
    get {
      return graphQLMap["status"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "status")
    }
  }

  public var requestId: String? {
    get {
      return graphQLMap["request_id"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "request_id")
    }
  }

  public var institution: FIOPlaidItemInputMetadataInstitution? {
    get {
      return graphQLMap["institution"] as! FIOPlaidItemInputMetadataInstitution?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "institution")
    }
  }
}

public struct FIOPlaidItemInputMetadataInstitution: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: String? = nil, institutionId: String? = nil) {
    graphQLMap = ["name": name, "institution_id": institutionId]
  }

  public var name: String? {
    get {
      return graphQLMap["name"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var institutionId: String? {
    get {
      return graphQLMap["institution_id"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "institution_id")
    }
  }
}

public final class TransactionsForAccountQuery: GraphQLQuery {
  public static let operationString =
    "query TransactionsForAccount($maid: String!) {\n  transactionsForAccount(maid: $maid) {\n    __typename\n    name\n    friendlyName\n    date\n    amount\n    transaction_id\n    category\n    masterAccountId\n    fioCategoryId\n    pending\n  }\n}"

  public var maid: String

  public init(maid: String) {
    self.maid = maid
  }

  public var variables: GraphQLMap? {
    return ["maid": maid]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("transactionsForAccount", arguments: ["maid": GraphQLVariable("maid")], type: .list(.nonNull(.object(TransactionsForAccount.selections)))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(transactionsForAccount: [TransactionsForAccount]? = nil) {
      self.init(snapshot: ["__typename": "Query", "transactionsForAccount": transactionsForAccount.flatMap { $0.map { $0.snapshot } }])
    }

    public var transactionsForAccount: [TransactionsForAccount]? {
      get {
        return (snapshot["transactionsForAccount"] as? [Snapshot]).flatMap { $0.map { TransactionsForAccount(snapshot: $0) } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "transactionsForAccount")
      }
    }

    public struct TransactionsForAccount: GraphQLSelectionSet {
      public static let possibleTypes = ["FIOTransaction"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("friendlyName", type: .scalar(String.self)),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
        GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
        GraphQLField("category", type: .list(.scalar(String.self))),
        GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
        GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
        GraphQLField("pending", type: .scalar(Bool.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(name: String, friendlyName: String? = nil, date: String, amount: Double, transactionId: String, category: [String?]? = nil, masterAccountId: String, fioCategoryId: Int, pending: Bool? = nil) {
        self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "date": date, "amount": amount, "transaction_id": transactionId, "category": category, "masterAccountId": masterAccountId, "fioCategoryId": fioCategoryId, "pending": pending])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var friendlyName: String? {
        get {
          return snapshot["friendlyName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "friendlyName")
        }
      }

      public var date: String {
        get {
          return snapshot["date"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "date")
        }
      }

      public var amount: Double {
        get {
          return snapshot["amount"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "amount")
        }
      }

      public var transactionId: String {
        get {
          return snapshot["transaction_id"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "transaction_id")
        }
      }

      public var category: [String?]? {
        get {
          return snapshot["category"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "category")
        }
      }

      public var masterAccountId: String {
        get {
          return snapshot["masterAccountId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "masterAccountId")
        }
      }

      public var fioCategoryId: Int {
        get {
          return snapshot["fioCategoryId"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "fioCategoryId")
        }
      }

      public var pending: Bool? {
        get {
          return snapshot["pending"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "pending")
        }
      }
    }
  }
}

public final class GetPublicTokenForItemQuery: GraphQLQuery {
  public static let operationString =
    "query GetPublicTokenForItem($item_id: String!) {\n  getPublicTokenForItem(item_id: $item_id)\n}"

  public var item_id: String

  public init(item_id: String) {
    self.item_id = item_id
  }

  public var variables: GraphQLMap? {
    return ["item_id": item_id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getPublicTokenForItem", arguments: ["item_id": GraphQLVariable("item_id")], type: .scalar(String.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getPublicTokenForItem: String? = nil) {
      self.init(snapshot: ["__typename": "Query", "getPublicTokenForItem": getPublicTokenForItem])
    }

    public var getPublicTokenForItem: String? {
      get {
        return snapshot["getPublicTokenForItem"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "getPublicTokenForItem")
      }
    }
  }
}

public final class HideAccountsQuery: GraphQLQuery {
  public static let operationString =
    "query HideAccounts($account_ids: [String!], $masterAccountIds: [String!], $hiddenState: Boolean) {\n  hideAccounts(account_ids: $account_ids, masterAccountIds: $masterAccountIds, hiddenState: $hiddenState)\n}"

  public var account_ids: [String]?
  public var masterAccountIds: [String]?
  public var hiddenState: Bool?

  public init(account_ids: [String]?, masterAccountIds: [String]?, hiddenState: Bool? = nil) {
    self.account_ids = account_ids
    self.masterAccountIds = masterAccountIds
    self.hiddenState = hiddenState
  }

  public var variables: GraphQLMap? {
    return ["account_ids": account_ids, "masterAccountIds": masterAccountIds, "hiddenState": hiddenState]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("hideAccounts", arguments: ["account_ids": GraphQLVariable("account_ids"), "masterAccountIds": GraphQLVariable("masterAccountIds"), "hiddenState": GraphQLVariable("hiddenState")], type: .scalar(Bool.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(hideAccounts: Bool? = nil) {
      self.init(snapshot: ["__typename": "Query", "hideAccounts": hideAccounts])
    }

    public var hideAccounts: Bool? {
      get {
        return snapshot["hideAccounts"] as? Bool
      }
      set {
        snapshot.updateValue(newValue, forKey: "hideAccounts")
      }
    }
  }
}

public final class GetQuantizeStatusQuery: GraphQLQuery {
  public static let operationString =
    "query GetQuantizeStatus {\n  getQuantizeStatus\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getQuantizeStatus", type: .scalar(String.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getQuantizeStatus: String? = nil) {
      self.init(snapshot: ["__typename": "Query", "getQuantizeStatus": getQuantizeStatus])
    }

    public var getQuantizeStatus: String? {
      get {
        return snapshot["getQuantizeStatus"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "getQuantizeStatus")
      }
    }
  }
}

public final class UserAuthExistsQuery: GraphQLQuery {
  public static let operationString =
    "query UserAuthExists($phoneNumber: String!) {\n  userAuthExists(phoneNumber: $phoneNumber)\n}"

  public var phoneNumber: String

  public init(phoneNumber: String) {
    self.phoneNumber = phoneNumber
  }

  public var variables: GraphQLMap? {
    return ["phoneNumber": phoneNumber]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("userAuthExists", arguments: ["phoneNumber": GraphQLVariable("phoneNumber")], type: .nonNull(.scalar(Bool.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(userAuthExists: Bool) {
      self.init(snapshot: ["__typename": "Query", "userAuthExists": userAuthExists])
    }

    public var userAuthExists: Bool {
      get {
        return snapshot["userAuthExists"]! as! Bool
      }
      set {
        snapshot.updateValue(newValue, forKey: "userAuthExists")
      }
    }
  }
}

public final class SearchTransactionsQuery: GraphQLQuery {
  public static let operationString =
    "query SearchTransactions($query: String!) {\n  searchTransactions(query: $query) {\n    __typename\n    ...transactionSearchResult\n  }\n}"

  public static var requestString: String { return operationString.appending(TransactionSearchResult.fragmentString) }

  public var query: String

  public init(query: String) {
    self.query = query
  }

  public var variables: GraphQLMap? {
    return ["query": query]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("searchTransactions", arguments: ["query": GraphQLVariable("query")], type: .list(.nonNull(.object(SearchTransaction.selections)))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(searchTransactions: [SearchTransaction]? = nil) {
      self.init(snapshot: ["__typename": "Query", "searchTransactions": searchTransactions.flatMap { $0.map { $0.snapshot } }])
    }

    public var searchTransactions: [SearchTransaction]? {
      get {
        return (snapshot["searchTransactions"] as? [Snapshot]).flatMap { $0.map { SearchTransaction(snapshot: $0) } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "searchTransactions")
      }
    }

    public struct SearchTransaction: GraphQLSelectionSet {
      public static let possibleTypes = ["FIOTransaction"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
        GraphQLField("transaction_type", type: .scalar(String.self)),
        GraphQLField("institution_id", type: .scalar(String.self)),
        GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
        GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
        GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
        GraphQLField("category_id", type: .scalar(Double.self)),
        GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("friendlyName", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(date: String, masterAccountId: String, transactionType: String? = nil, institutionId: String? = nil, itemId: String, amount: Double, fioCategoryId: Int, categoryId: Double? = nil, transactionId: String, name: String, friendlyName: String? = nil) {
        self.init(snapshot: ["__typename": "FIOTransaction", "date": date, "masterAccountId": masterAccountId, "transaction_type": transactionType, "institution_id": institutionId, "item_id": itemId, "amount": amount, "fioCategoryId": fioCategoryId, "category_id": categoryId, "transaction_id": transactionId, "name": name, "friendlyName": friendlyName])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var date: String {
        get {
          return snapshot["date"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "date")
        }
      }

      public var masterAccountId: String {
        get {
          return snapshot["masterAccountId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "masterAccountId")
        }
      }

      public var transactionType: String? {
        get {
          return snapshot["transaction_type"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "transaction_type")
        }
      }

      public var institutionId: String? {
        get {
          return snapshot["institution_id"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "institution_id")
        }
      }

      public var itemId: String {
        get {
          return snapshot["item_id"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "item_id")
        }
      }

      public var amount: Double {
        get {
          return snapshot["amount"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "amount")
        }
      }

      public var fioCategoryId: Int {
        get {
          return snapshot["fioCategoryId"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "fioCategoryId")
        }
      }

      public var categoryId: Double? {
        get {
          return snapshot["category_id"] as? Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "category_id")
        }
      }

      public var transactionId: String {
        get {
          return snapshot["transaction_id"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "transaction_id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var friendlyName: String? {
        get {
          return snapshot["friendlyName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "friendlyName")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var transactionSearchResult: TransactionSearchResult {
          get {
            return TransactionSearchResult(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }
  }
}

public final class GetFlowPeriodsQuery: GraphQLQuery {
  public static let operationString =
    "query GetFlowPeriods($windowSize: Int!, $periodIdStart: String, $periodIdEnd: String, $nextToken: String) {\n  getFlowPeriods(windowSize: $windowSize, periodIdStart: $periodIdStart, periodIdEnd: $periodIdEnd, nextToken: $nextToken) {\n    __typename\n    nextToken\n    periods {\n      __typename\n      periodId\n      windowSize\n      daysInRange\n      startDate\n      endDate\n      daysRemainingInPeriod\n      dayNets\n      includesEndOfData\n      projection {\n        __typename\n        net\n        incomeTotal\n        spendTotal\n      }\n      periodSummary {\n        __typename\n        spending {\n          __typename\n          actual\n          target\n          projected\n        }\n        categories {\n          __typename\n          total\n          names\n          percentages\n          descriptions\n          amounts\n        }\n        balances {\n          __typename\n          accountSubtype\n          startingBalance\n          endingBalance\n        }\n        isFillerObject\n        netAmount\n        income\n        transactions {\n          __typename\n          totalAmount\n          deposits {\n            __typename\n            totalAmount\n            transactionIds\n          }\n          debits {\n            __typename\n            totalAmount\n            transactionIds\n            transactions {\n              __typename\n              name\n              friendlyName\n              amount\n              transaction_id\n              fioCategoryId\n              date\n              masterAccountId\n              pending\n            }\n          }\n          transfers {\n            __typename\n            totalAmount\n            transactionIds\n            transactionSummaries {\n              __typename\n              friendlyName\n              transaction_id\n              amount\n              fioCategoryId\n            }\n          }\n          regularIncome {\n            __typename\n            totalAmount\n            transactionIds\n          }\n          creditCardPayments {\n            __typename\n            totalAmount\n            destinationAccountNames\n            sourceAccountNames\n            payments {\n              __typename\n              amount\n              from {\n                __typename\n                name\n                friendlyName\n                date\n                amount\n                transaction_id\n                category\n                masterAccountId\n                fioCategoryId\n                account {\n                  __typename\n                  displayName\n                  hidden\n                  masterAccountId\n                  institution_id\n                  balances {\n                    __typename\n                    available\n                    limit\n                    current\n                  }\n                  institution_name\n                  item_id\n                  lastSynced\n                  mask\n                  name\n                  official_name\n                  subtype\n                  type\n                }\n                ...transactionDetails\n              }\n              to {\n                __typename\n                name\n                friendlyName\n                date\n                amount\n                transaction_id\n                category\n                masterAccountId\n                fioCategoryId\n                account {\n                  __typename\n                  displayName\n                  hidden\n                  masterAccountId\n                  institution_id\n                  balances {\n                    __typename\n                    available\n                    limit\n                    current\n                  }\n                  institution_name\n                  item_id\n                  lastSynced\n                  mask\n                  name\n                  official_name\n                  subtype\n                  type\n                }\n                ...transactionDetails\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n}"

  public static var requestString: String { return operationString.appending(TransactionDetails.fragmentString) }

  public var windowSize: Int
  public var periodIdStart: String?
  public var periodIdEnd: String?
  public var nextToken: String?

  public init(windowSize: Int, periodIdStart: String? = nil, periodIdEnd: String? = nil, nextToken: String? = nil) {
    self.windowSize = windowSize
    self.periodIdStart = periodIdStart
    self.periodIdEnd = periodIdEnd
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["windowSize": windowSize, "periodIdStart": periodIdStart, "periodIdEnd": periodIdEnd, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getFlowPeriods", arguments: ["windowSize": GraphQLVariable("windowSize"), "periodIdStart": GraphQLVariable("periodIdStart"), "periodIdEnd": GraphQLVariable("periodIdEnd"), "nextToken": GraphQLVariable("nextToken")], type: .nonNull(.object(GetFlowPeriod.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getFlowPeriods: GetFlowPeriod) {
      self.init(snapshot: ["__typename": "Query", "getFlowPeriods": getFlowPeriods.snapshot])
    }

    public var getFlowPeriods: GetFlowPeriod {
      get {
        return GetFlowPeriod(snapshot: snapshot["getFlowPeriods"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "getFlowPeriods")
      }
    }

    public struct GetFlowPeriod: GraphQLSelectionSet {
      public static let possibleTypes = ["PaginatedFlowPeriods"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("periods", type: .list(.nonNull(.object(Period.selections)))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(nextToken: String? = nil, periods: [Period]? = nil) {
        self.init(snapshot: ["__typename": "PaginatedFlowPeriods", "nextToken": nextToken, "periods": periods.flatMap { $0.map { $0.snapshot } }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var periods: [Period]? {
        get {
          return (snapshot["periods"] as? [Snapshot]).flatMap { $0.map { Period(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "periods")
        }
      }

      public struct Period: GraphQLSelectionSet {
        public static let possibleTypes = ["FIOFlowPeriod"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("periodId", type: .nonNull(.scalar(String.self))),
          GraphQLField("windowSize", type: .nonNull(.scalar(Int.self))),
          GraphQLField("daysInRange", type: .nonNull(.scalar(Int.self))),
          GraphQLField("startDate", type: .nonNull(.scalar(String.self))),
          GraphQLField("endDate", type: .nonNull(.scalar(String.self))),
          GraphQLField("daysRemainingInPeriod", type: .nonNull(.scalar(Int.self))),
          GraphQLField("dayNets", type: .list(.nonNull(.scalar(Double.self)))),
          GraphQLField("includesEndOfData", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("projection", type: .object(Projection.selections)),
          GraphQLField("periodSummary", type: .nonNull(.object(PeriodSummary.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(periodId: String, windowSize: Int, daysInRange: Int, startDate: String, endDate: String, daysRemainingInPeriod: Int, dayNets: [Double]? = nil, includesEndOfData: Bool, projection: Projection? = nil, periodSummary: PeriodSummary) {
          self.init(snapshot: ["__typename": "FIOFlowPeriod", "periodId": periodId, "windowSize": windowSize, "daysInRange": daysInRange, "startDate": startDate, "endDate": endDate, "daysRemainingInPeriod": daysRemainingInPeriod, "dayNets": dayNets, "includesEndOfData": includesEndOfData, "projection": projection.flatMap { $0.snapshot }, "periodSummary": periodSummary.snapshot])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var periodId: String {
          get {
            return snapshot["periodId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "periodId")
          }
        }

        public var windowSize: Int {
          get {
            return snapshot["windowSize"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "windowSize")
          }
        }

        public var daysInRange: Int {
          get {
            return snapshot["daysInRange"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "daysInRange")
          }
        }

        public var startDate: String {
          get {
            return snapshot["startDate"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "startDate")
          }
        }

        public var endDate: String {
          get {
            return snapshot["endDate"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "endDate")
          }
        }

        public var daysRemainingInPeriod: Int {
          get {
            return snapshot["daysRemainingInPeriod"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "daysRemainingInPeriod")
          }
        }

        public var dayNets: [Double]? {
          get {
            return snapshot["dayNets"] as? [Double]
          }
          set {
            snapshot.updateValue(newValue, forKey: "dayNets")
          }
        }

        public var includesEndOfData: Bool {
          get {
            return snapshot["includesEndOfData"]! as! Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "includesEndOfData")
          }
        }

        public var projection: Projection? {
          get {
            return (snapshot["projection"] as? Snapshot).flatMap { Projection(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "projection")
          }
        }

        public var periodSummary: PeriodSummary {
          get {
            return PeriodSummary(snapshot: snapshot["periodSummary"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "periodSummary")
          }
        }

        public struct Projection: GraphQLSelectionSet {
          public static let possibleTypes = ["FIOFlowPeriodProjection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("net", type: .scalar(Double.self)),
            GraphQLField("incomeTotal", type: .scalar(Double.self)),
            GraphQLField("spendTotal", type: .scalar(Double.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(net: Double? = nil, incomeTotal: Double? = nil, spendTotal: Double? = nil) {
            self.init(snapshot: ["__typename": "FIOFlowPeriodProjection", "net": net, "incomeTotal": incomeTotal, "spendTotal": spendTotal])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var net: Double? {
            get {
              return snapshot["net"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "net")
            }
          }

          public var incomeTotal: Double? {
            get {
              return snapshot["incomeTotal"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "incomeTotal")
            }
          }

          public var spendTotal: Double? {
            get {
              return snapshot["spendTotal"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "spendTotal")
            }
          }
        }

        public struct PeriodSummary: GraphQLSelectionSet {
          public static let possibleTypes = ["FIOFlowPeriodDetail"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("spending", type: .nonNull(.object(Spending.selections))),
            GraphQLField("categories", type: .object(Category.selections)),
            GraphQLField("balances", type: .list(.nonNull(.object(Balance.selections)))),
            GraphQLField("isFillerObject", type: .scalar(Bool.self)),
            GraphQLField("netAmount", type: .nonNull(.scalar(Double.self))),
            GraphQLField("income", type: .nonNull(.scalar(Double.self))),
            GraphQLField("transactions", type: .object(Transaction.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(spending: Spending, categories: Category? = nil, balances: [Balance]? = nil, isFillerObject: Bool? = nil, netAmount: Double, income: Double, transactions: Transaction? = nil) {
            self.init(snapshot: ["__typename": "FIOFlowPeriodDetail", "spending": spending.snapshot, "categories": categories.flatMap { $0.snapshot }, "balances": balances.flatMap { $0.map { $0.snapshot } }, "isFillerObject": isFillerObject, "netAmount": netAmount, "income": income, "transactions": transactions.flatMap { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var spending: Spending {
            get {
              return Spending(snapshot: snapshot["spending"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "spending")
            }
          }

          public var categories: Category? {
            get {
              return (snapshot["categories"] as? Snapshot).flatMap { Category(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "categories")
            }
          }

          public var balances: [Balance]? {
            get {
              return (snapshot["balances"] as? [Snapshot]).flatMap { $0.map { Balance(snapshot: $0) } }
            }
            set {
              snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "balances")
            }
          }

          public var isFillerObject: Bool? {
            get {
              return snapshot["isFillerObject"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "isFillerObject")
            }
          }

          public var netAmount: Double {
            get {
              return snapshot["netAmount"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "netAmount")
            }
          }

          public var income: Double {
            get {
              return snapshot["income"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "income")
            }
          }

          public var transactions: Transaction? {
            get {
              return (snapshot["transactions"] as? Snapshot).flatMap { Transaction(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "transactions")
            }
          }

          public struct Spending: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOFlowPeriodSpending"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("actual", type: .nonNull(.scalar(Double.self))),
              GraphQLField("target", type: .nonNull(.scalar(Double.self))),
              GraphQLField("projected", type: .scalar(Double.self)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(actual: Double, target: Double, projected: Double? = nil) {
              self.init(snapshot: ["__typename": "FIOFlowPeriodSpending", "actual": actual, "target": target, "projected": projected])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var actual: Double {
              get {
                return snapshot["actual"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "actual")
              }
            }

            public var target: Double {
              get {
                return snapshot["target"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "target")
              }
            }

            public var projected: Double? {
              get {
                return snapshot["projected"] as? Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "projected")
              }
            }
          }

          public struct Category: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOSpendCategories"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("total", type: .nonNull(.scalar(Double.self))),
              GraphQLField("names", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              GraphQLField("percentages", type: .nonNull(.list(.nonNull(.scalar(Double.self))))),
              GraphQLField("descriptions", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              GraphQLField("amounts", type: .nonNull(.list(.nonNull(.scalar(Double.self))))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(total: Double, names: [String], percentages: [Double], descriptions: [String], amounts: [Double]) {
              self.init(snapshot: ["__typename": "FIOSpendCategories", "total": total, "names": names, "percentages": percentages, "descriptions": descriptions, "amounts": amounts])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var total: Double {
              get {
                return snapshot["total"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "total")
              }
            }

            public var names: [String] {
              get {
                return snapshot["names"]! as! [String]
              }
              set {
                snapshot.updateValue(newValue, forKey: "names")
              }
            }

            public var percentages: [Double] {
              get {
                return snapshot["percentages"]! as! [Double]
              }
              set {
                snapshot.updateValue(newValue, forKey: "percentages")
              }
            }

            public var descriptions: [String] {
              get {
                return snapshot["descriptions"]! as! [String]
              }
              set {
                snapshot.updateValue(newValue, forKey: "descriptions")
              }
            }

            public var amounts: [Double] {
              get {
                return snapshot["amounts"]! as! [Double]
              }
              set {
                snapshot.updateValue(newValue, forKey: "amounts")
              }
            }
          }

          public struct Balance: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOPeriodBalance"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("accountSubtype", type: .nonNull(.scalar(String.self))),
              GraphQLField("startingBalance", type: .nonNull(.scalar(Double.self))),
              GraphQLField("endingBalance", type: .nonNull(.scalar(Double.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(accountSubtype: String, startingBalance: Double, endingBalance: Double) {
              self.init(snapshot: ["__typename": "FIOPeriodBalance", "accountSubtype": accountSubtype, "startingBalance": startingBalance, "endingBalance": endingBalance])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var accountSubtype: String {
              get {
                return snapshot["accountSubtype"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "accountSubtype")
              }
            }

            public var startingBalance: Double {
              get {
                return snapshot["startingBalance"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "startingBalance")
              }
            }

            public var endingBalance: Double {
              get {
                return snapshot["endingBalance"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "endingBalance")
              }
            }
          }

          public struct Transaction: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOFlowPeriodDetailTransactions"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("totalAmount", type: .scalar(Double.self)),
              GraphQLField("deposits", type: .object(Deposit.selections)),
              GraphQLField("debits", type: .object(Debit.selections)),
              GraphQLField("transfers", type: .object(Transfer.selections)),
              GraphQLField("regularIncome", type: .object(RegularIncome.selections)),
              GraphQLField("creditCardPayments", type: .object(CreditCardPayment.selections)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(totalAmount: Double? = nil, deposits: Deposit? = nil, debits: Debit? = nil, transfers: Transfer? = nil, regularIncome: RegularIncome? = nil, creditCardPayments: CreditCardPayment? = nil) {
              self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactions", "totalAmount": totalAmount, "deposits": deposits.flatMap { $0.snapshot }, "debits": debits.flatMap { $0.snapshot }, "transfers": transfers.flatMap { $0.snapshot }, "regularIncome": regularIncome.flatMap { $0.snapshot }, "creditCardPayments": creditCardPayments.flatMap { $0.snapshot }])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var totalAmount: Double? {
              get {
                return snapshot["totalAmount"] as? Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "totalAmount")
              }
            }

            public var deposits: Deposit? {
              get {
                return (snapshot["deposits"] as? Snapshot).flatMap { Deposit(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "deposits")
              }
            }

            public var debits: Debit? {
              get {
                return (snapshot["debits"] as? Snapshot).flatMap { Debit(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "debits")
              }
            }

            public var transfers: Transfer? {
              get {
                return (snapshot["transfers"] as? Snapshot).flatMap { Transfer(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "transfers")
              }
            }

            public var regularIncome: RegularIncome? {
              get {
                return (snapshot["regularIncome"] as? Snapshot).flatMap { RegularIncome(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "regularIncome")
              }
            }

            public var creditCardPayments: CreditCardPayment? {
              get {
                return (snapshot["creditCardPayments"] as? Snapshot).flatMap { CreditCardPayment(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "creditCardPayments")
              }
            }

            public struct Deposit: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOFlowPeriodDetailTransactionSet"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("transactionIds", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, transactionIds: [String]) {
                self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactionSet", "totalAmount": totalAmount, "transactionIds": transactionIds])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var transactionIds: [String] {
                get {
                  return snapshot["transactionIds"]! as! [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "transactionIds")
                }
              }
            }

            public struct Debit: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOFlowPeriodDetailTransactionSet"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("transactionIds", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
                GraphQLField("transactions", type: .list(.nonNull(.object(Transaction.selections)))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, transactionIds: [String], transactions: [Transaction]? = nil) {
                self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactionSet", "totalAmount": totalAmount, "transactionIds": transactionIds, "transactions": transactions.flatMap { $0.map { $0.snapshot } }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var transactionIds: [String] {
                get {
                  return snapshot["transactionIds"]! as! [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "transactionIds")
                }
              }

              public var transactions: [Transaction]? {
                get {
                  return (snapshot["transactions"] as? [Snapshot]).flatMap { $0.map { Transaction(snapshot: $0) } }
                }
                set {
                  snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "transactions")
                }
              }

              public struct Transaction: GraphQLSelectionSet {
                public static let possibleTypes = ["FIOTransaction"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  GraphQLField("friendlyName", type: .scalar(String.self)),
                  GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
                  GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
                  GraphQLField("date", type: .nonNull(.scalar(String.self))),
                  GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                  GraphQLField("pending", type: .scalar(Bool.self)),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(name: String, friendlyName: String? = nil, amount: Double, transactionId: String, fioCategoryId: Int, date: String, masterAccountId: String, pending: Bool? = nil) {
                  self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "amount": amount, "transaction_id": transactionId, "fioCategoryId": fioCategoryId, "date": date, "masterAccountId": masterAccountId, "pending": pending])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var name: String {
                  get {
                    return snapshot["name"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "name")
                  }
                }

                public var friendlyName: String? {
                  get {
                    return snapshot["friendlyName"] as? String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "friendlyName")
                  }
                }

                public var amount: Double {
                  get {
                    return snapshot["amount"]! as! Double
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "amount")
                  }
                }

                public var transactionId: String {
                  get {
                    return snapshot["transaction_id"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "transaction_id")
                  }
                }

                public var fioCategoryId: Int {
                  get {
                    return snapshot["fioCategoryId"]! as! Int
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "fioCategoryId")
                  }
                }

                public var date: String {
                  get {
                    return snapshot["date"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "date")
                  }
                }

                public var masterAccountId: String {
                  get {
                    return snapshot["masterAccountId"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "masterAccountId")
                  }
                }

                public var pending: Bool? {
                  get {
                    return snapshot["pending"] as? Bool
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "pending")
                  }
                }
              }
            }

            public struct Transfer: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOFlowPeriodDetailTransactionSet"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("transactionIds", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
                GraphQLField("transactionSummaries", type: .list(.nonNull(.object(TransactionSummary.selections)))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, transactionIds: [String], transactionSummaries: [TransactionSummary]? = nil) {
                self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactionSet", "totalAmount": totalAmount, "transactionIds": transactionIds, "transactionSummaries": transactionSummaries.flatMap { $0.map { $0.snapshot } }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var transactionIds: [String] {
                get {
                  return snapshot["transactionIds"]! as! [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "transactionIds")
                }
              }

              public var transactionSummaries: [TransactionSummary]? {
                get {
                  return (snapshot["transactionSummaries"] as? [Snapshot]).flatMap { $0.map { TransactionSummary(snapshot: $0) } }
                }
                set {
                  snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "transactionSummaries")
                }
              }

              public struct TransactionSummary: GraphQLSelectionSet {
                public static let possibleTypes = ["FIOTransaction"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("friendlyName", type: .scalar(String.self)),
                  GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
                  GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(friendlyName: String? = nil, transactionId: String, amount: Double, fioCategoryId: Int) {
                  self.init(snapshot: ["__typename": "FIOTransaction", "friendlyName": friendlyName, "transaction_id": transactionId, "amount": amount, "fioCategoryId": fioCategoryId])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var friendlyName: String? {
                  get {
                    return snapshot["friendlyName"] as? String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "friendlyName")
                  }
                }

                public var transactionId: String {
                  get {
                    return snapshot["transaction_id"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "transaction_id")
                  }
                }

                public var amount: Double {
                  get {
                    return snapshot["amount"]! as! Double
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "amount")
                  }
                }

                public var fioCategoryId: Int {
                  get {
                    return snapshot["fioCategoryId"]! as! Int
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "fioCategoryId")
                  }
                }
              }
            }

            public struct RegularIncome: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOFlowPeriodDetailTransactionSet"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("transactionIds", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, transactionIds: [String]) {
                self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactionSet", "totalAmount": totalAmount, "transactionIds": transactionIds])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var transactionIds: [String] {
                get {
                  return snapshot["transactionIds"]! as! [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "transactionIds")
                }
              }
            }

            public struct CreditCardPayment: GraphQLSelectionSet {
              public static let possibleTypes = ["QIOFlowPeriodCreditCardPayments"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("destinationAccountNames", type: .list(.nonNull(.scalar(String.self)))),
                GraphQLField("sourceAccountNames", type: .list(.nonNull(.scalar(String.self)))),
                GraphQLField("payments", type: .nonNull(.list(.nonNull(.object(Payment.selections))))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, destinationAccountNames: [String]? = nil, sourceAccountNames: [String]? = nil, payments: [Payment]) {
                self.init(snapshot: ["__typename": "QIOFlowPeriodCreditCardPayments", "totalAmount": totalAmount, "destinationAccountNames": destinationAccountNames, "sourceAccountNames": sourceAccountNames, "payments": payments.map { $0.snapshot }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var destinationAccountNames: [String]? {
                get {
                  return snapshot["destinationAccountNames"] as? [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "destinationAccountNames")
                }
              }

              public var sourceAccountNames: [String]? {
                get {
                  return snapshot["sourceAccountNames"] as? [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "sourceAccountNames")
                }
              }

              public var payments: [Payment] {
                get {
                  return (snapshot["payments"] as! [Snapshot]).map { Payment(snapshot: $0) }
                }
                set {
                  snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "payments")
                }
              }

              public struct Payment: GraphQLSelectionSet {
                public static let possibleTypes = ["QIOFlowPeriodCreditCardPaymentItem"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("from", type: .object(From.selections)),
                  GraphQLField("to", type: .object(To.selections)),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(amount: Double, from: From? = nil, to: To? = nil) {
                  self.init(snapshot: ["__typename": "QIOFlowPeriodCreditCardPaymentItem", "amount": amount, "from": from.flatMap { $0.snapshot }, "to": to.flatMap { $0.snapshot }])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var amount: Double {
                  get {
                    return snapshot["amount"]! as! Double
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "amount")
                  }
                }

                public var from: From? {
                  get {
                    return (snapshot["from"] as? Snapshot).flatMap { From(snapshot: $0) }
                  }
                  set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "from")
                  }
                }

                public var to: To? {
                  get {
                    return (snapshot["to"] as? Snapshot).flatMap { To(snapshot: $0) }
                  }
                  set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "to")
                  }
                }

                public struct From: GraphQLSelectionSet {
                  public static let possibleTypes = ["FIOTransaction"]

                  public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                    GraphQLField("friendlyName", type: .scalar(String.self)),
                    GraphQLField("date", type: .nonNull(.scalar(String.self))),
                    GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("category", type: .list(.scalar(String.self))),
                    GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                    GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("account", type: .object(Account.selections)),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("account_owner", type: .scalar(String.self)),
                    GraphQLField("category_id", type: .scalar(Double.self)),
                    GraphQLField("insertTimestamp", type: .scalar(Double.self)),
                    GraphQLField("institution_id", type: .scalar(String.self)),
                    GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pending", type: .scalar(Bool.self)),
                    GraphQLField("pending_transaction_id", type: .scalar(String.self)),
                    GraphQLField("transaction_type", type: .scalar(String.self)),
                    GraphQLField("account_name", type: .scalar(String.self)),
                    GraphQLField("account_institution_name", type: .scalar(String.self)),
                    GraphQLField("payment_meta", type: .object(PaymentMetum.selections)),
                  ]

                  public var snapshot: Snapshot

                  public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                  }

                  public init(name: String, friendlyName: String? = nil, date: String, amount: Double, transactionId: String, category: [String?]? = nil, masterAccountId: String, fioCategoryId: Int, account: Account? = nil, accountOwner: String? = nil, categoryId: Double? = nil, insertTimestamp: Double? = nil, institutionId: String? = nil, itemId: String, pending: Bool? = nil, pendingTransactionId: String? = nil, transactionType: String? = nil, accountName: String? = nil, accountInstitutionName: String? = nil, paymentMeta: PaymentMetum? = nil) {
                    self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "date": date, "amount": amount, "transaction_id": transactionId, "category": category, "masterAccountId": masterAccountId, "fioCategoryId": fioCategoryId, "account": account.flatMap { $0.snapshot }, "account_owner": accountOwner, "category_id": categoryId, "insertTimestamp": insertTimestamp, "institution_id": institutionId, "item_id": itemId, "pending": pending, "pending_transaction_id": pendingTransactionId, "transaction_type": transactionType, "account_name": accountName, "account_institution_name": accountInstitutionName, "payment_meta": paymentMeta.flatMap { $0.snapshot }])
                  }

                  public var __typename: String {
                    get {
                      return snapshot["__typename"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var name: String {
                    get {
                      return snapshot["name"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "name")
                    }
                  }

                  public var friendlyName: String? {
                    get {
                      return snapshot["friendlyName"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "friendlyName")
                    }
                  }

                  public var date: String {
                    get {
                      return snapshot["date"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "date")
                    }
                  }

                  public var amount: Double {
                    get {
                      return snapshot["amount"]! as! Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "amount")
                    }
                  }

                  public var transactionId: String {
                    get {
                      return snapshot["transaction_id"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "transaction_id")
                    }
                  }

                  public var category: [String?]? {
                    get {
                      return snapshot["category"] as? [String?]
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "category")
                    }
                  }

                  public var masterAccountId: String {
                    get {
                      return snapshot["masterAccountId"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "masterAccountId")
                    }
                  }

                  public var fioCategoryId: Int {
                    get {
                      return snapshot["fioCategoryId"]! as! Int
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "fioCategoryId")
                    }
                  }

                  public var account: Account? {
                    get {
                      return (snapshot["account"] as? Snapshot).flatMap { Account(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "account")
                    }
                  }

                  public var accountOwner: String? {
                    get {
                      return snapshot["account_owner"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_owner")
                    }
                  }

                  public var categoryId: Double? {
                    get {
                      return snapshot["category_id"] as? Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "category_id")
                    }
                  }

                  public var insertTimestamp: Double? {
                    get {
                      return snapshot["insertTimestamp"] as? Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "insertTimestamp")
                    }
                  }

                  public var institutionId: String? {
                    get {
                      return snapshot["institution_id"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "institution_id")
                    }
                  }

                  public var itemId: String {
                    get {
                      return snapshot["item_id"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "item_id")
                    }
                  }

                  public var pending: Bool? {
                    get {
                      return snapshot["pending"] as? Bool
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "pending")
                    }
                  }

                  public var pendingTransactionId: String? {
                    get {
                      return snapshot["pending_transaction_id"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "pending_transaction_id")
                    }
                  }

                  public var transactionType: String? {
                    get {
                      return snapshot["transaction_type"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "transaction_type")
                    }
                  }

                  public var accountName: String? {
                    get {
                      return snapshot["account_name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_name")
                    }
                  }

                  public var accountInstitutionName: String? {
                    get {
                      return snapshot["account_institution_name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_institution_name")
                    }
                  }

                  public var paymentMeta: PaymentMetum? {
                    get {
                      return (snapshot["payment_meta"] as? Snapshot).flatMap { PaymentMetum(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "payment_meta")
                    }
                  }

                  public var fragments: Fragments {
                    get {
                      return Fragments(snapshot: snapshot)
                    }
                    set {
                      snapshot += newValue.snapshot
                    }
                  }

                  public struct Fragments {
                    public var snapshot: Snapshot

                    public var transactionDetails: TransactionDetails {
                      get {
                        return TransactionDetails(snapshot: snapshot)
                      }
                      set {
                        snapshot += newValue.snapshot
                      }
                    }
                  }

                  public struct Account: GraphQLSelectionSet {
                    public static let possibleTypes = ["FIOFinAccount"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("displayName", type: .scalar(String.self)),
                      GraphQLField("hidden", type: .scalar(Bool.self)),
                      GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                      GraphQLField("institution_id", type: .nonNull(.scalar(String.self))),
                      GraphQLField("balances", type: .object(Balance.selections)),
                      GraphQLField("institution_name", type: .nonNull(.scalar(String.self))),
                      GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
                      GraphQLField("lastSynced", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("mask", type: .scalar(String.self)),
                      GraphQLField("name", type: .nonNull(.scalar(String.self))),
                      GraphQLField("official_name", type: .scalar(String.self)),
                      GraphQLField("subtype", type: .nonNull(.scalar(String.self))),
                      GraphQLField("type", type: .nonNull(.scalar(String.self))),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(displayName: String? = nil, hidden: Bool? = nil, masterAccountId: String, institutionId: String, balances: Balance? = nil, institutionName: String, itemId: String, lastSynced: Double, mask: String? = nil, name: String, officialName: String? = nil, subtype: String, type: String) {
                      self.init(snapshot: ["__typename": "FIOFinAccount", "displayName": displayName, "hidden": hidden, "masterAccountId": masterAccountId, "institution_id": institutionId, "balances": balances.flatMap { $0.snapshot }, "institution_name": institutionName, "item_id": itemId, "lastSynced": lastSynced, "mask": mask, "name": name, "official_name": officialName, "subtype": subtype, "type": type])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var displayName: String? {
                      get {
                        return snapshot["displayName"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "displayName")
                      }
                    }

                    public var hidden: Bool? {
                      get {
                        return snapshot["hidden"] as? Bool
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "hidden")
                      }
                    }

                    public var masterAccountId: String {
                      get {
                        return snapshot["masterAccountId"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "masterAccountId")
                      }
                    }

                    public var institutionId: String {
                      get {
                        return snapshot["institution_id"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "institution_id")
                      }
                    }

                    public var balances: Balance? {
                      get {
                        return (snapshot["balances"] as? Snapshot).flatMap { Balance(snapshot: $0) }
                      }
                      set {
                        snapshot.updateValue(newValue?.snapshot, forKey: "balances")
                      }
                    }

                    public var institutionName: String {
                      get {
                        return snapshot["institution_name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "institution_name")
                      }
                    }

                    public var itemId: String {
                      get {
                        return snapshot["item_id"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "item_id")
                      }
                    }

                    public var lastSynced: Double {
                      get {
                        return snapshot["lastSynced"]! as! Double
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "lastSynced")
                      }
                    }

                    public var mask: String? {
                      get {
                        return snapshot["mask"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "mask")
                      }
                    }

                    public var name: String {
                      get {
                        return snapshot["name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "name")
                      }
                    }

                    public var officialName: String? {
                      get {
                        return snapshot["official_name"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "official_name")
                      }
                    }

                    public var subtype: String {
                      get {
                        return snapshot["subtype"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "subtype")
                      }
                    }

                    public var type: String {
                      get {
                        return snapshot["type"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "type")
                      }
                    }

                    public struct Balance: GraphQLSelectionSet {
                      public static let possibleTypes = ["FIOFinAccountBalances"]

                      public static let selections: [GraphQLSelection] = [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("available", type: .scalar(Double.self)),
                        GraphQLField("limit", type: .scalar(Double.self)),
                        GraphQLField("current", type: .scalar(Double.self)),
                      ]

                      public var snapshot: Snapshot

                      public init(snapshot: Snapshot) {
                        self.snapshot = snapshot
                      }

                      public init(available: Double? = nil, limit: Double? = nil, current: Double? = nil) {
                        self.init(snapshot: ["__typename": "FIOFinAccountBalances", "available": available, "limit": limit, "current": current])
                      }

                      public var __typename: String {
                        get {
                          return snapshot["__typename"]! as! String
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "__typename")
                        }
                      }

                      public var available: Double? {
                        get {
                          return snapshot["available"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "available")
                        }
                      }

                      public var limit: Double? {
                        get {
                          return snapshot["limit"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "limit")
                        }
                      }

                      public var current: Double? {
                        get {
                          return snapshot["current"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "current")
                        }
                      }
                    }
                  }

                  public struct PaymentMetum: GraphQLSelectionSet {
                    public static let possibleTypes = ["FIOTransactionPaymentMetadata"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("by_order_of", type: .scalar(String.self)),
                      GraphQLField("payee", type: .scalar(String.self)),
                      GraphQLField("payer", type: .scalar(String.self)),
                      GraphQLField("payment_method", type: .scalar(String.self)),
                      GraphQLField("payment_processor", type: .scalar(String.self)),
                      GraphQLField("ppd_id", type: .scalar(String.self)),
                      GraphQLField("reason", type: .scalar(String.self)),
                      GraphQLField("reference_number", type: .scalar(String.self)),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(byOrderOf: String? = nil, payee: String? = nil, payer: String? = nil, paymentMethod: String? = nil, paymentProcessor: String? = nil, ppdId: String? = nil, reason: String? = nil, referenceNumber: String? = nil) {
                      self.init(snapshot: ["__typename": "FIOTransactionPaymentMetadata", "by_order_of": byOrderOf, "payee": payee, "payer": payer, "payment_method": paymentMethod, "payment_processor": paymentProcessor, "ppd_id": ppdId, "reason": reason, "reference_number": referenceNumber])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var byOrderOf: String? {
                      get {
                        return snapshot["by_order_of"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "by_order_of")
                      }
                    }

                    public var payee: String? {
                      get {
                        return snapshot["payee"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payee")
                      }
                    }

                    public var payer: String? {
                      get {
                        return snapshot["payer"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payer")
                      }
                    }

                    public var paymentMethod: String? {
                      get {
                        return snapshot["payment_method"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payment_method")
                      }
                    }

                    public var paymentProcessor: String? {
                      get {
                        return snapshot["payment_processor"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payment_processor")
                      }
                    }

                    public var ppdId: String? {
                      get {
                        return snapshot["ppd_id"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "ppd_id")
                      }
                    }

                    public var reason: String? {
                      get {
                        return snapshot["reason"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "reason")
                      }
                    }

                    public var referenceNumber: String? {
                      get {
                        return snapshot["reference_number"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "reference_number")
                      }
                    }
                  }
                }

                public struct To: GraphQLSelectionSet {
                  public static let possibleTypes = ["FIOTransaction"]

                  public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                    GraphQLField("friendlyName", type: .scalar(String.self)),
                    GraphQLField("date", type: .nonNull(.scalar(String.self))),
                    GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("category", type: .list(.scalar(String.self))),
                    GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                    GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("account", type: .object(Account.selections)),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("account_owner", type: .scalar(String.self)),
                    GraphQLField("category_id", type: .scalar(Double.self)),
                    GraphQLField("insertTimestamp", type: .scalar(Double.self)),
                    GraphQLField("institution_id", type: .scalar(String.self)),
                    GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pending", type: .scalar(Bool.self)),
                    GraphQLField("pending_transaction_id", type: .scalar(String.self)),
                    GraphQLField("transaction_type", type: .scalar(String.self)),
                    GraphQLField("account_name", type: .scalar(String.self)),
                    GraphQLField("account_institution_name", type: .scalar(String.self)),
                    GraphQLField("payment_meta", type: .object(PaymentMetum.selections)),
                  ]

                  public var snapshot: Snapshot

                  public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                  }

                  public init(name: String, friendlyName: String? = nil, date: String, amount: Double, transactionId: String, category: [String?]? = nil, masterAccountId: String, fioCategoryId: Int, account: Account? = nil, accountOwner: String? = nil, categoryId: Double? = nil, insertTimestamp: Double? = nil, institutionId: String? = nil, itemId: String, pending: Bool? = nil, pendingTransactionId: String? = nil, transactionType: String? = nil, accountName: String? = nil, accountInstitutionName: String? = nil, paymentMeta: PaymentMetum? = nil) {
                    self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "date": date, "amount": amount, "transaction_id": transactionId, "category": category, "masterAccountId": masterAccountId, "fioCategoryId": fioCategoryId, "account": account.flatMap { $0.snapshot }, "account_owner": accountOwner, "category_id": categoryId, "insertTimestamp": insertTimestamp, "institution_id": institutionId, "item_id": itemId, "pending": pending, "pending_transaction_id": pendingTransactionId, "transaction_type": transactionType, "account_name": accountName, "account_institution_name": accountInstitutionName, "payment_meta": paymentMeta.flatMap { $0.snapshot }])
                  }

                  public var __typename: String {
                    get {
                      return snapshot["__typename"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var name: String {
                    get {
                      return snapshot["name"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "name")
                    }
                  }

                  public var friendlyName: String? {
                    get {
                      return snapshot["friendlyName"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "friendlyName")
                    }
                  }

                  public var date: String {
                    get {
                      return snapshot["date"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "date")
                    }
                  }

                  public var amount: Double {
                    get {
                      return snapshot["amount"]! as! Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "amount")
                    }
                  }

                  public var transactionId: String {
                    get {
                      return snapshot["transaction_id"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "transaction_id")
                    }
                  }

                  public var category: [String?]? {
                    get {
                      return snapshot["category"] as? [String?]
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "category")
                    }
                  }

                  public var masterAccountId: String {
                    get {
                      return snapshot["masterAccountId"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "masterAccountId")
                    }
                  }

                  public var fioCategoryId: Int {
                    get {
                      return snapshot["fioCategoryId"]! as! Int
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "fioCategoryId")
                    }
                  }

                  public var account: Account? {
                    get {
                      return (snapshot["account"] as? Snapshot).flatMap { Account(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "account")
                    }
                  }

                  public var accountOwner: String? {
                    get {
                      return snapshot["account_owner"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_owner")
                    }
                  }

                  public var categoryId: Double? {
                    get {
                      return snapshot["category_id"] as? Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "category_id")
                    }
                  }

                  public var insertTimestamp: Double? {
                    get {
                      return snapshot["insertTimestamp"] as? Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "insertTimestamp")
                    }
                  }

                  public var institutionId: String? {
                    get {
                      return snapshot["institution_id"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "institution_id")
                    }
                  }

                  public var itemId: String {
                    get {
                      return snapshot["item_id"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "item_id")
                    }
                  }

                  public var pending: Bool? {
                    get {
                      return snapshot["pending"] as? Bool
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "pending")
                    }
                  }

                  public var pendingTransactionId: String? {
                    get {
                      return snapshot["pending_transaction_id"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "pending_transaction_id")
                    }
                  }

                  public var transactionType: String? {
                    get {
                      return snapshot["transaction_type"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "transaction_type")
                    }
                  }

                  public var accountName: String? {
                    get {
                      return snapshot["account_name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_name")
                    }
                  }

                  public var accountInstitutionName: String? {
                    get {
                      return snapshot["account_institution_name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_institution_name")
                    }
                  }

                  public var paymentMeta: PaymentMetum? {
                    get {
                      return (snapshot["payment_meta"] as? Snapshot).flatMap { PaymentMetum(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "payment_meta")
                    }
                  }

                  public var fragments: Fragments {
                    get {
                      return Fragments(snapshot: snapshot)
                    }
                    set {
                      snapshot += newValue.snapshot
                    }
                  }

                  public struct Fragments {
                    public var snapshot: Snapshot

                    public var transactionDetails: TransactionDetails {
                      get {
                        return TransactionDetails(snapshot: snapshot)
                      }
                      set {
                        snapshot += newValue.snapshot
                      }
                    }
                  }

                  public struct Account: GraphQLSelectionSet {
                    public static let possibleTypes = ["FIOFinAccount"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("displayName", type: .scalar(String.self)),
                      GraphQLField("hidden", type: .scalar(Bool.self)),
                      GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                      GraphQLField("institution_id", type: .nonNull(.scalar(String.self))),
                      GraphQLField("balances", type: .object(Balance.selections)),
                      GraphQLField("institution_name", type: .nonNull(.scalar(String.self))),
                      GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
                      GraphQLField("lastSynced", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("mask", type: .scalar(String.self)),
                      GraphQLField("name", type: .nonNull(.scalar(String.self))),
                      GraphQLField("official_name", type: .scalar(String.self)),
                      GraphQLField("subtype", type: .nonNull(.scalar(String.self))),
                      GraphQLField("type", type: .nonNull(.scalar(String.self))),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(displayName: String? = nil, hidden: Bool? = nil, masterAccountId: String, institutionId: String, balances: Balance? = nil, institutionName: String, itemId: String, lastSynced: Double, mask: String? = nil, name: String, officialName: String? = nil, subtype: String, type: String) {
                      self.init(snapshot: ["__typename": "FIOFinAccount", "displayName": displayName, "hidden": hidden, "masterAccountId": masterAccountId, "institution_id": institutionId, "balances": balances.flatMap { $0.snapshot }, "institution_name": institutionName, "item_id": itemId, "lastSynced": lastSynced, "mask": mask, "name": name, "official_name": officialName, "subtype": subtype, "type": type])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var displayName: String? {
                      get {
                        return snapshot["displayName"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "displayName")
                      }
                    }

                    public var hidden: Bool? {
                      get {
                        return snapshot["hidden"] as? Bool
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "hidden")
                      }
                    }

                    public var masterAccountId: String {
                      get {
                        return snapshot["masterAccountId"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "masterAccountId")
                      }
                    }

                    public var institutionId: String {
                      get {
                        return snapshot["institution_id"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "institution_id")
                      }
                    }

                    public var balances: Balance? {
                      get {
                        return (snapshot["balances"] as? Snapshot).flatMap { Balance(snapshot: $0) }
                      }
                      set {
                        snapshot.updateValue(newValue?.snapshot, forKey: "balances")
                      }
                    }

                    public var institutionName: String {
                      get {
                        return snapshot["institution_name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "institution_name")
                      }
                    }

                    public var itemId: String {
                      get {
                        return snapshot["item_id"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "item_id")
                      }
                    }

                    public var lastSynced: Double {
                      get {
                        return snapshot["lastSynced"]! as! Double
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "lastSynced")
                      }
                    }

                    public var mask: String? {
                      get {
                        return snapshot["mask"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "mask")
                      }
                    }

                    public var name: String {
                      get {
                        return snapshot["name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "name")
                      }
                    }

                    public var officialName: String? {
                      get {
                        return snapshot["official_name"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "official_name")
                      }
                    }

                    public var subtype: String {
                      get {
                        return snapshot["subtype"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "subtype")
                      }
                    }

                    public var type: String {
                      get {
                        return snapshot["type"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "type")
                      }
                    }

                    public struct Balance: GraphQLSelectionSet {
                      public static let possibleTypes = ["FIOFinAccountBalances"]

                      public static let selections: [GraphQLSelection] = [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("available", type: .scalar(Double.self)),
                        GraphQLField("limit", type: .scalar(Double.self)),
                        GraphQLField("current", type: .scalar(Double.self)),
                      ]

                      public var snapshot: Snapshot

                      public init(snapshot: Snapshot) {
                        self.snapshot = snapshot
                      }

                      public init(available: Double? = nil, limit: Double? = nil, current: Double? = nil) {
                        self.init(snapshot: ["__typename": "FIOFinAccountBalances", "available": available, "limit": limit, "current": current])
                      }

                      public var __typename: String {
                        get {
                          return snapshot["__typename"]! as! String
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "__typename")
                        }
                      }

                      public var available: Double? {
                        get {
                          return snapshot["available"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "available")
                        }
                      }

                      public var limit: Double? {
                        get {
                          return snapshot["limit"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "limit")
                        }
                      }

                      public var current: Double? {
                        get {
                          return snapshot["current"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "current")
                        }
                      }
                    }
                  }

                  public struct PaymentMetum: GraphQLSelectionSet {
                    public static let possibleTypes = ["FIOTransactionPaymentMetadata"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("by_order_of", type: .scalar(String.self)),
                      GraphQLField("payee", type: .scalar(String.self)),
                      GraphQLField("payer", type: .scalar(String.self)),
                      GraphQLField("payment_method", type: .scalar(String.self)),
                      GraphQLField("payment_processor", type: .scalar(String.self)),
                      GraphQLField("ppd_id", type: .scalar(String.self)),
                      GraphQLField("reason", type: .scalar(String.self)),
                      GraphQLField("reference_number", type: .scalar(String.self)),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(byOrderOf: String? = nil, payee: String? = nil, payer: String? = nil, paymentMethod: String? = nil, paymentProcessor: String? = nil, ppdId: String? = nil, reason: String? = nil, referenceNumber: String? = nil) {
                      self.init(snapshot: ["__typename": "FIOTransactionPaymentMetadata", "by_order_of": byOrderOf, "payee": payee, "payer": payer, "payment_method": paymentMethod, "payment_processor": paymentProcessor, "ppd_id": ppdId, "reason": reason, "reference_number": referenceNumber])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var byOrderOf: String? {
                      get {
                        return snapshot["by_order_of"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "by_order_of")
                      }
                    }

                    public var payee: String? {
                      get {
                        return snapshot["payee"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payee")
                      }
                    }

                    public var payer: String? {
                      get {
                        return snapshot["payer"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payer")
                      }
                    }

                    public var paymentMethod: String? {
                      get {
                        return snapshot["payment_method"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payment_method")
                      }
                    }

                    public var paymentProcessor: String? {
                      get {
                        return snapshot["payment_processor"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payment_processor")
                      }
                    }

                    public var ppdId: String? {
                      get {
                        return snapshot["ppd_id"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "ppd_id")
                      }
                    }

                    public var reason: String? {
                      get {
                        return snapshot["reason"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "reason")
                      }
                    }

                    public var referenceNumber: String? {
                      get {
                        return snapshot["reference_number"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "reference_number")
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class GetItemStatusQuery: GraphQLQuery {
  public static let operationString =
    "query GetItemStatus($item_id: String, $link_session_id: String) {\n  getItemStatus(item_id: $item_id, link_session_id: $link_session_id) {\n    __typename\n    item_id\n    hasAccessToken\n    flowDateCount\n    oldestFlowDate\n    quantizeStatus\n    itemSetupCompleted\n    webhookSummary {\n      __typename\n      totalTransactionHookCount\n      initialHookDate\n      transactionCountTotal\n      transactionsRemovedCount\n      numberOfTransactionsThatShouldBeInSystem\n      secondsBetweenInitialAndHistoricalHooks\n      historicalTransactionsHook {\n        __typename\n        webhook_type\n        new_transactions\n        item_id\n        webhook_code\n        timestamp\n        error {\n          __typename\n          error_type\n          error_code\n          error_message\n          display_message\n        }\n      }\n      initialTransactionsHook {\n        __typename\n        webhook_type\n        new_transactions\n        item_id\n        webhook_code\n        timestamp\n        error {\n          __typename\n          error_type\n          error_code\n          error_message\n          display_message\n        }\n      }\n    }\n    totalTransactionCount\n    transactionSummary {\n      __typename\n      oldestTransaction\n      transactionCount\n      daysSinceFirst\n      transactions {\n        __typename\n        name\n        friendlyName\n        date\n        amount\n        qioTransactionType\n        transaction_id\n        ...transactionDetails\n      }\n    }\n    accounts {\n      __typename\n      displayName\n      hidden\n      masterAccountId\n      institution_id\n      balances {\n        __typename\n        current\n        limit\n        available\n      }\n      institution_name\n      item_id\n      lastSynced\n      mask\n      name\n      official_name\n      subtype\n      type\n      statementDays {\n        __typename\n        date\n        startingBalance\n        endingBalance\n        interestPaid\n        dpr\n        adbPeriod\n        adb\n        interestTransaction {\n          __typename\n          name\n          friendlyName\n          date\n          amount\n          transaction_id\n          category\n          masterAccountId\n          fioCategoryId\n          ...transactionDetails\n        }\n      }\n    }\n  }\n}"

  public static var requestString: String { return operationString.appending(TransactionDetails.fragmentString) }

  public var item_id: String?
  public var link_session_id: String?

  public init(item_id: String? = nil, link_session_id: String? = nil) {
    self.item_id = item_id
    self.link_session_id = link_session_id
  }

  public var variables: GraphQLMap? {
    return ["item_id": item_id, "link_session_id": link_session_id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getItemStatus", arguments: ["item_id": GraphQLVariable("item_id"), "link_session_id": GraphQLVariable("link_session_id")], type: .object(GetItemStatus.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getItemStatus: GetItemStatus? = nil) {
      self.init(snapshot: ["__typename": "Query", "getItemStatus": getItemStatus.flatMap { $0.snapshot }])
    }

    public var getItemStatus: GetItemStatus? {
      get {
        return (snapshot["getItemStatus"] as? Snapshot).flatMap { GetItemStatus(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getItemStatus")
      }
    }

    public struct GetItemStatus: GraphQLSelectionSet {
      public static let possibleTypes = ["FIOItemStatus"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("item_id", type: .scalar(String.self)),
        GraphQLField("hasAccessToken", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("flowDateCount", type: .scalar(Int.self)),
        GraphQLField("oldestFlowDate", type: .scalar(String.self)),
        GraphQLField("quantizeStatus", type: .nonNull(.scalar(String.self))),
        GraphQLField("itemSetupCompleted", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("webhookSummary", type: .object(WebhookSummary.selections)),
        GraphQLField("totalTransactionCount", type: .scalar(Int.self)),
        GraphQLField("transactionSummary", type: .object(TransactionSummary.selections)),
        GraphQLField("accounts", type: .list(.nonNull(.object(Account.selections)))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(itemId: String? = nil, hasAccessToken: Bool, flowDateCount: Int? = nil, oldestFlowDate: String? = nil, quantizeStatus: String, itemSetupCompleted: Bool, webhookSummary: WebhookSummary? = nil, totalTransactionCount: Int? = nil, transactionSummary: TransactionSummary? = nil, accounts: [Account]? = nil) {
        self.init(snapshot: ["__typename": "FIOItemStatus", "item_id": itemId, "hasAccessToken": hasAccessToken, "flowDateCount": flowDateCount, "oldestFlowDate": oldestFlowDate, "quantizeStatus": quantizeStatus, "itemSetupCompleted": itemSetupCompleted, "webhookSummary": webhookSummary.flatMap { $0.snapshot }, "totalTransactionCount": totalTransactionCount, "transactionSummary": transactionSummary.flatMap { $0.snapshot }, "accounts": accounts.flatMap { $0.map { $0.snapshot } }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var itemId: String? {
        get {
          return snapshot["item_id"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "item_id")
        }
      }

      public var hasAccessToken: Bool {
        get {
          return snapshot["hasAccessToken"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "hasAccessToken")
        }
      }

      public var flowDateCount: Int? {
        get {
          return snapshot["flowDateCount"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "flowDateCount")
        }
      }

      public var oldestFlowDate: String? {
        get {
          return snapshot["oldestFlowDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "oldestFlowDate")
        }
      }

      public var quantizeStatus: String {
        get {
          return snapshot["quantizeStatus"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "quantizeStatus")
        }
      }

      public var itemSetupCompleted: Bool {
        get {
          return snapshot["itemSetupCompleted"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "itemSetupCompleted")
        }
      }

      public var webhookSummary: WebhookSummary? {
        get {
          return (snapshot["webhookSummary"] as? Snapshot).flatMap { WebhookSummary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "webhookSummary")
        }
      }

      public var totalTransactionCount: Int? {
        get {
          return snapshot["totalTransactionCount"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "totalTransactionCount")
        }
      }

      public var transactionSummary: TransactionSummary? {
        get {
          return (snapshot["transactionSummary"] as? Snapshot).flatMap { TransactionSummary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "transactionSummary")
        }
      }

      public var accounts: [Account]? {
        get {
          return (snapshot["accounts"] as? [Snapshot]).flatMap { $0.map { Account(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "accounts")
        }
      }

      public struct WebhookSummary: GraphQLSelectionSet {
        public static let possibleTypes = ["FIOItemStatusWebhookSummary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("totalTransactionHookCount", type: .scalar(Int.self)),
          GraphQLField("initialHookDate", type: .scalar(String.self)),
          GraphQLField("transactionCountTotal", type: .scalar(Int.self)),
          GraphQLField("transactionsRemovedCount", type: .scalar(Int.self)),
          GraphQLField("numberOfTransactionsThatShouldBeInSystem", type: .scalar(Int.self)),
          GraphQLField("secondsBetweenInitialAndHistoricalHooks", type: .scalar(Double.self)),
          GraphQLField("historicalTransactionsHook", type: .object(HistoricalTransactionsHook.selections)),
          GraphQLField("initialTransactionsHook", type: .object(InitialTransactionsHook.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(totalTransactionHookCount: Int? = nil, initialHookDate: String? = nil, transactionCountTotal: Int? = nil, transactionsRemovedCount: Int? = nil, numberOfTransactionsThatShouldBeInSystem: Int? = nil, secondsBetweenInitialAndHistoricalHooks: Double? = nil, historicalTransactionsHook: HistoricalTransactionsHook? = nil, initialTransactionsHook: InitialTransactionsHook? = nil) {
          self.init(snapshot: ["__typename": "FIOItemStatusWebhookSummary", "totalTransactionHookCount": totalTransactionHookCount, "initialHookDate": initialHookDate, "transactionCountTotal": transactionCountTotal, "transactionsRemovedCount": transactionsRemovedCount, "numberOfTransactionsThatShouldBeInSystem": numberOfTransactionsThatShouldBeInSystem, "secondsBetweenInitialAndHistoricalHooks": secondsBetweenInitialAndHistoricalHooks, "historicalTransactionsHook": historicalTransactionsHook.flatMap { $0.snapshot }, "initialTransactionsHook": initialTransactionsHook.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var totalTransactionHookCount: Int? {
          get {
            return snapshot["totalTransactionHookCount"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "totalTransactionHookCount")
          }
        }

        public var initialHookDate: String? {
          get {
            return snapshot["initialHookDate"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "initialHookDate")
          }
        }

        public var transactionCountTotal: Int? {
          get {
            return snapshot["transactionCountTotal"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "transactionCountTotal")
          }
        }

        public var transactionsRemovedCount: Int? {
          get {
            return snapshot["transactionsRemovedCount"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "transactionsRemovedCount")
          }
        }

        public var numberOfTransactionsThatShouldBeInSystem: Int? {
          get {
            return snapshot["numberOfTransactionsThatShouldBeInSystem"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "numberOfTransactionsThatShouldBeInSystem")
          }
        }

        public var secondsBetweenInitialAndHistoricalHooks: Double? {
          get {
            return snapshot["secondsBetweenInitialAndHistoricalHooks"] as? Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "secondsBetweenInitialAndHistoricalHooks")
          }
        }

        public var historicalTransactionsHook: HistoricalTransactionsHook? {
          get {
            return (snapshot["historicalTransactionsHook"] as? Snapshot).flatMap { HistoricalTransactionsHook(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "historicalTransactionsHook")
          }
        }

        public var initialTransactionsHook: InitialTransactionsHook? {
          get {
            return (snapshot["initialTransactionsHook"] as? Snapshot).flatMap { InitialTransactionsHook(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "initialTransactionsHook")
          }
        }

        public struct HistoricalTransactionsHook: GraphQLSelectionSet {
          public static let possibleTypes = ["FIOItemStatusWebhook"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("webhook_type", type: .scalar(String.self)),
            GraphQLField("new_transactions", type: .scalar(Int.self)),
            GraphQLField("item_id", type: .scalar(String.self)),
            GraphQLField("webhook_code", type: .scalar(String.self)),
            GraphQLField("timestamp", type: .scalar(Double.self)),
            GraphQLField("error", type: .object(Error.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(webhookType: String? = nil, newTransactions: Int? = nil, itemId: String? = nil, webhookCode: String? = nil, timestamp: Double? = nil, error: Error? = nil) {
            self.init(snapshot: ["__typename": "FIOItemStatusWebhook", "webhook_type": webhookType, "new_transactions": newTransactions, "item_id": itemId, "webhook_code": webhookCode, "timestamp": timestamp, "error": error.flatMap { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var webhookType: String? {
            get {
              return snapshot["webhook_type"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "webhook_type")
            }
          }

          public var newTransactions: Int? {
            get {
              return snapshot["new_transactions"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "new_transactions")
            }
          }

          public var itemId: String? {
            get {
              return snapshot["item_id"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "item_id")
            }
          }

          public var webhookCode: String? {
            get {
              return snapshot["webhook_code"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "webhook_code")
            }
          }

          public var timestamp: Double? {
            get {
              return snapshot["timestamp"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "timestamp")
            }
          }

          public var error: Error? {
            get {
              return (snapshot["error"] as? Snapshot).flatMap { Error(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "error")
            }
          }

          public struct Error: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOItemStatusWebhookError"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("error_type", type: .scalar(String.self)),
              GraphQLField("error_code", type: .scalar(String.self)),
              GraphQLField("error_message", type: .scalar(String.self)),
              GraphQLField("display_message", type: .scalar(String.self)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(errorType: String? = nil, errorCode: String? = nil, errorMessage: String? = nil, displayMessage: String? = nil) {
              self.init(snapshot: ["__typename": "FIOItemStatusWebhookError", "error_type": errorType, "error_code": errorCode, "error_message": errorMessage, "display_message": displayMessage])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var errorType: String? {
              get {
                return snapshot["error_type"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "error_type")
              }
            }

            public var errorCode: String? {
              get {
                return snapshot["error_code"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "error_code")
              }
            }

            public var errorMessage: String? {
              get {
                return snapshot["error_message"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "error_message")
              }
            }

            public var displayMessage: String? {
              get {
                return snapshot["display_message"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "display_message")
              }
            }
          }
        }

        public struct InitialTransactionsHook: GraphQLSelectionSet {
          public static let possibleTypes = ["FIOItemStatusWebhook"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("webhook_type", type: .scalar(String.self)),
            GraphQLField("new_transactions", type: .scalar(Int.self)),
            GraphQLField("item_id", type: .scalar(String.self)),
            GraphQLField("webhook_code", type: .scalar(String.self)),
            GraphQLField("timestamp", type: .scalar(Double.self)),
            GraphQLField("error", type: .object(Error.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(webhookType: String? = nil, newTransactions: Int? = nil, itemId: String? = nil, webhookCode: String? = nil, timestamp: Double? = nil, error: Error? = nil) {
            self.init(snapshot: ["__typename": "FIOItemStatusWebhook", "webhook_type": webhookType, "new_transactions": newTransactions, "item_id": itemId, "webhook_code": webhookCode, "timestamp": timestamp, "error": error.flatMap { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var webhookType: String? {
            get {
              return snapshot["webhook_type"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "webhook_type")
            }
          }

          public var newTransactions: Int? {
            get {
              return snapshot["new_transactions"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "new_transactions")
            }
          }

          public var itemId: String? {
            get {
              return snapshot["item_id"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "item_id")
            }
          }

          public var webhookCode: String? {
            get {
              return snapshot["webhook_code"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "webhook_code")
            }
          }

          public var timestamp: Double? {
            get {
              return snapshot["timestamp"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "timestamp")
            }
          }

          public var error: Error? {
            get {
              return (snapshot["error"] as? Snapshot).flatMap { Error(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "error")
            }
          }

          public struct Error: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOItemStatusWebhookError"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("error_type", type: .scalar(String.self)),
              GraphQLField("error_code", type: .scalar(String.self)),
              GraphQLField("error_message", type: .scalar(String.self)),
              GraphQLField("display_message", type: .scalar(String.self)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(errorType: String? = nil, errorCode: String? = nil, errorMessage: String? = nil, displayMessage: String? = nil) {
              self.init(snapshot: ["__typename": "FIOItemStatusWebhookError", "error_type": errorType, "error_code": errorCode, "error_message": errorMessage, "display_message": displayMessage])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var errorType: String? {
              get {
                return snapshot["error_type"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "error_type")
              }
            }

            public var errorCode: String? {
              get {
                return snapshot["error_code"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "error_code")
              }
            }

            public var errorMessage: String? {
              get {
                return snapshot["error_message"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "error_message")
              }
            }

            public var displayMessage: String? {
              get {
                return snapshot["display_message"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "display_message")
              }
            }
          }
        }
      }

      public struct TransactionSummary: GraphQLSelectionSet {
        public static let possibleTypes = ["FIOItemStatusTransactionSummary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("oldestTransaction", type: .nonNull(.scalar(String.self))),
          GraphQLField("transactionCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("daysSinceFirst", type: .nonNull(.scalar(Int.self))),
          GraphQLField("transactions", type: .nonNull(.list(.nonNull(.object(Transaction.selections))))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(oldestTransaction: String, transactionCount: Int, daysSinceFirst: Int, transactions: [Transaction]) {
          self.init(snapshot: ["__typename": "FIOItemStatusTransactionSummary", "oldestTransaction": oldestTransaction, "transactionCount": transactionCount, "daysSinceFirst": daysSinceFirst, "transactions": transactions.map { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var oldestTransaction: String {
          get {
            return snapshot["oldestTransaction"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "oldestTransaction")
          }
        }

        public var transactionCount: Int {
          get {
            return snapshot["transactionCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "transactionCount")
          }
        }

        public var daysSinceFirst: Int {
          get {
            return snapshot["daysSinceFirst"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "daysSinceFirst")
          }
        }

        public var transactions: [Transaction] {
          get {
            return (snapshot["transactions"] as! [Snapshot]).map { Transaction(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "transactions")
          }
        }

        public struct Transaction: GraphQLSelectionSet {
          public static let possibleTypes = ["FIOTransaction"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("friendlyName", type: .scalar(String.self)),
            GraphQLField("date", type: .nonNull(.scalar(String.self))),
            GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
            GraphQLField("qioTransactionType", type: .scalar(String.self)),
            GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("account_owner", type: .scalar(String.self)),
            GraphQLField("category_id", type: .scalar(Double.self)),
            GraphQLField("insertTimestamp", type: .scalar(Double.self)),
            GraphQLField("institution_id", type: .scalar(String.self)),
            GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
            GraphQLField("pending", type: .scalar(Bool.self)),
            GraphQLField("pending_transaction_id", type: .scalar(String.self)),
            GraphQLField("transaction_type", type: .scalar(String.self)),
            GraphQLField("account_name", type: .scalar(String.self)),
            GraphQLField("account_institution_name", type: .scalar(String.self)),
            GraphQLField("payment_meta", type: .object(PaymentMetum.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(name: String, friendlyName: String? = nil, date: String, amount: Double, qioTransactionType: String? = nil, transactionId: String, accountOwner: String? = nil, categoryId: Double? = nil, insertTimestamp: Double? = nil, institutionId: String? = nil, itemId: String, pending: Bool? = nil, pendingTransactionId: String? = nil, transactionType: String? = nil, accountName: String? = nil, accountInstitutionName: String? = nil, paymentMeta: PaymentMetum? = nil) {
            self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "date": date, "amount": amount, "qioTransactionType": qioTransactionType, "transaction_id": transactionId, "account_owner": accountOwner, "category_id": categoryId, "insertTimestamp": insertTimestamp, "institution_id": institutionId, "item_id": itemId, "pending": pending, "pending_transaction_id": pendingTransactionId, "transaction_type": transactionType, "account_name": accountName, "account_institution_name": accountInstitutionName, "payment_meta": paymentMeta.flatMap { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var friendlyName: String? {
            get {
              return snapshot["friendlyName"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "friendlyName")
            }
          }

          public var date: String {
            get {
              return snapshot["date"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "date")
            }
          }

          public var amount: Double {
            get {
              return snapshot["amount"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "amount")
            }
          }

          public var qioTransactionType: String? {
            get {
              return snapshot["qioTransactionType"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "qioTransactionType")
            }
          }

          public var transactionId: String {
            get {
              return snapshot["transaction_id"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "transaction_id")
            }
          }

          public var accountOwner: String? {
            get {
              return snapshot["account_owner"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "account_owner")
            }
          }

          public var categoryId: Double? {
            get {
              return snapshot["category_id"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "category_id")
            }
          }

          public var insertTimestamp: Double? {
            get {
              return snapshot["insertTimestamp"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "insertTimestamp")
            }
          }

          public var institutionId: String? {
            get {
              return snapshot["institution_id"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "institution_id")
            }
          }

          public var itemId: String {
            get {
              return snapshot["item_id"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "item_id")
            }
          }

          public var pending: Bool? {
            get {
              return snapshot["pending"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "pending")
            }
          }

          public var pendingTransactionId: String? {
            get {
              return snapshot["pending_transaction_id"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "pending_transaction_id")
            }
          }

          public var transactionType: String? {
            get {
              return snapshot["transaction_type"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "transaction_type")
            }
          }

          public var accountName: String? {
            get {
              return snapshot["account_name"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "account_name")
            }
          }

          public var accountInstitutionName: String? {
            get {
              return snapshot["account_institution_name"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "account_institution_name")
            }
          }

          public var paymentMeta: PaymentMetum? {
            get {
              return (snapshot["payment_meta"] as? Snapshot).flatMap { PaymentMetum(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "payment_meta")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public struct Fragments {
            public var snapshot: Snapshot

            public var transactionDetails: TransactionDetails {
              get {
                return TransactionDetails(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }
          }

          public struct PaymentMetum: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOTransactionPaymentMetadata"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("by_order_of", type: .scalar(String.self)),
              GraphQLField("payee", type: .scalar(String.self)),
              GraphQLField("payer", type: .scalar(String.self)),
              GraphQLField("payment_method", type: .scalar(String.self)),
              GraphQLField("payment_processor", type: .scalar(String.self)),
              GraphQLField("ppd_id", type: .scalar(String.self)),
              GraphQLField("reason", type: .scalar(String.self)),
              GraphQLField("reference_number", type: .scalar(String.self)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(byOrderOf: String? = nil, payee: String? = nil, payer: String? = nil, paymentMethod: String? = nil, paymentProcessor: String? = nil, ppdId: String? = nil, reason: String? = nil, referenceNumber: String? = nil) {
              self.init(snapshot: ["__typename": "FIOTransactionPaymentMetadata", "by_order_of": byOrderOf, "payee": payee, "payer": payer, "payment_method": paymentMethod, "payment_processor": paymentProcessor, "ppd_id": ppdId, "reason": reason, "reference_number": referenceNumber])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var byOrderOf: String? {
              get {
                return snapshot["by_order_of"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "by_order_of")
              }
            }

            public var payee: String? {
              get {
                return snapshot["payee"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "payee")
              }
            }

            public var payer: String? {
              get {
                return snapshot["payer"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "payer")
              }
            }

            public var paymentMethod: String? {
              get {
                return snapshot["payment_method"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "payment_method")
              }
            }

            public var paymentProcessor: String? {
              get {
                return snapshot["payment_processor"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "payment_processor")
              }
            }

            public var ppdId: String? {
              get {
                return snapshot["ppd_id"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "ppd_id")
              }
            }

            public var reason: String? {
              get {
                return snapshot["reason"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "reason")
              }
            }

            public var referenceNumber: String? {
              get {
                return snapshot["reference_number"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "reference_number")
              }
            }
          }
        }
      }

      public struct Account: GraphQLSelectionSet {
        public static let possibleTypes = ["FIOFinAccount"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("displayName", type: .scalar(String.self)),
          GraphQLField("hidden", type: .scalar(Bool.self)),
          GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
          GraphQLField("institution_id", type: .nonNull(.scalar(String.self))),
          GraphQLField("balances", type: .object(Balance.selections)),
          GraphQLField("institution_name", type: .nonNull(.scalar(String.self))),
          GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
          GraphQLField("lastSynced", type: .nonNull(.scalar(Double.self))),
          GraphQLField("mask", type: .scalar(String.self)),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("official_name", type: .scalar(String.self)),
          GraphQLField("subtype", type: .nonNull(.scalar(String.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("statementDays", type: .list(.nonNull(.object(StatementDay.selections)))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(displayName: String? = nil, hidden: Bool? = nil, masterAccountId: String, institutionId: String, balances: Balance? = nil, institutionName: String, itemId: String, lastSynced: Double, mask: String? = nil, name: String, officialName: String? = nil, subtype: String, type: String, statementDays: [StatementDay]? = nil) {
          self.init(snapshot: ["__typename": "FIOFinAccount", "displayName": displayName, "hidden": hidden, "masterAccountId": masterAccountId, "institution_id": institutionId, "balances": balances.flatMap { $0.snapshot }, "institution_name": institutionName, "item_id": itemId, "lastSynced": lastSynced, "mask": mask, "name": name, "official_name": officialName, "subtype": subtype, "type": type, "statementDays": statementDays.flatMap { $0.map { $0.snapshot } }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var displayName: String? {
          get {
            return snapshot["displayName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "displayName")
          }
        }

        public var hidden: Bool? {
          get {
            return snapshot["hidden"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "hidden")
          }
        }

        public var masterAccountId: String {
          get {
            return snapshot["masterAccountId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "masterAccountId")
          }
        }

        public var institutionId: String {
          get {
            return snapshot["institution_id"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "institution_id")
          }
        }

        public var balances: Balance? {
          get {
            return (snapshot["balances"] as? Snapshot).flatMap { Balance(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "balances")
          }
        }

        public var institutionName: String {
          get {
            return snapshot["institution_name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "institution_name")
          }
        }

        public var itemId: String {
          get {
            return snapshot["item_id"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "item_id")
          }
        }

        public var lastSynced: Double {
          get {
            return snapshot["lastSynced"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastSynced")
          }
        }

        public var mask: String? {
          get {
            return snapshot["mask"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "mask")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var officialName: String? {
          get {
            return snapshot["official_name"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "official_name")
          }
        }

        public var subtype: String {
          get {
            return snapshot["subtype"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "subtype")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var statementDays: [StatementDay]? {
          get {
            return (snapshot["statementDays"] as? [Snapshot]).flatMap { $0.map { StatementDay(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "statementDays")
          }
        }

        public struct Balance: GraphQLSelectionSet {
          public static let possibleTypes = ["FIOFinAccountBalances"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("current", type: .scalar(Double.self)),
            GraphQLField("limit", type: .scalar(Double.self)),
            GraphQLField("available", type: .scalar(Double.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(current: Double? = nil, limit: Double? = nil, available: Double? = nil) {
            self.init(snapshot: ["__typename": "FIOFinAccountBalances", "current": current, "limit": limit, "available": available])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var current: Double? {
            get {
              return snapshot["current"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "current")
            }
          }

          public var limit: Double? {
            get {
              return snapshot["limit"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "limit")
            }
          }

          public var available: Double? {
            get {
              return snapshot["available"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "available")
            }
          }
        }

        public struct StatementDay: GraphQLSelectionSet {
          public static let possibleTypes = ["FIOAccountStatementDay"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("date", type: .nonNull(.scalar(String.self))),
            GraphQLField("startingBalance", type: .nonNull(.scalar(Double.self))),
            GraphQLField("endingBalance", type: .nonNull(.scalar(Double.self))),
            GraphQLField("interestPaid", type: .scalar(Double.self)),
            GraphQLField("dpr", type: .scalar(Double.self)),
            GraphQLField("adbPeriod", type: .scalar(Int.self)),
            GraphQLField("adb", type: .scalar(Double.self)),
            GraphQLField("interestTransaction", type: .object(InterestTransaction.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(date: String, startingBalance: Double, endingBalance: Double, interestPaid: Double? = nil, dpr: Double? = nil, adbPeriod: Int? = nil, adb: Double? = nil, interestTransaction: InterestTransaction? = nil) {
            self.init(snapshot: ["__typename": "FIOAccountStatementDay", "date": date, "startingBalance": startingBalance, "endingBalance": endingBalance, "interestPaid": interestPaid, "dpr": dpr, "adbPeriod": adbPeriod, "adb": adb, "interestTransaction": interestTransaction.flatMap { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var date: String {
            get {
              return snapshot["date"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "date")
            }
          }

          public var startingBalance: Double {
            get {
              return snapshot["startingBalance"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "startingBalance")
            }
          }

          public var endingBalance: Double {
            get {
              return snapshot["endingBalance"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "endingBalance")
            }
          }

          public var interestPaid: Double? {
            get {
              return snapshot["interestPaid"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "interestPaid")
            }
          }

          public var dpr: Double? {
            get {
              return snapshot["dpr"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "dpr")
            }
          }

          public var adbPeriod: Int? {
            get {
              return snapshot["adbPeriod"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "adbPeriod")
            }
          }

          public var adb: Double? {
            get {
              return snapshot["adb"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "adb")
            }
          }

          public var interestTransaction: InterestTransaction? {
            get {
              return (snapshot["interestTransaction"] as? Snapshot).flatMap { InterestTransaction(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "interestTransaction")
            }
          }

          public struct InterestTransaction: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOTransaction"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("friendlyName", type: .scalar(String.self)),
              GraphQLField("date", type: .nonNull(.scalar(String.self))),
              GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
              GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
              GraphQLField("category", type: .list(.scalar(String.self))),
              GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
              GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("account_owner", type: .scalar(String.self)),
              GraphQLField("category_id", type: .scalar(Double.self)),
              GraphQLField("insertTimestamp", type: .scalar(Double.self)),
              GraphQLField("institution_id", type: .scalar(String.self)),
              GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
              GraphQLField("pending", type: .scalar(Bool.self)),
              GraphQLField("pending_transaction_id", type: .scalar(String.self)),
              GraphQLField("transaction_type", type: .scalar(String.self)),
              GraphQLField("account_name", type: .scalar(String.self)),
              GraphQLField("account_institution_name", type: .scalar(String.self)),
              GraphQLField("payment_meta", type: .object(PaymentMetum.selections)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(name: String, friendlyName: String? = nil, date: String, amount: Double, transactionId: String, category: [String?]? = nil, masterAccountId: String, fioCategoryId: Int, accountOwner: String? = nil, categoryId: Double? = nil, insertTimestamp: Double? = nil, institutionId: String? = nil, itemId: String, pending: Bool? = nil, pendingTransactionId: String? = nil, transactionType: String? = nil, accountName: String? = nil, accountInstitutionName: String? = nil, paymentMeta: PaymentMetum? = nil) {
              self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "date": date, "amount": amount, "transaction_id": transactionId, "category": category, "masterAccountId": masterAccountId, "fioCategoryId": fioCategoryId, "account_owner": accountOwner, "category_id": categoryId, "insertTimestamp": insertTimestamp, "institution_id": institutionId, "item_id": itemId, "pending": pending, "pending_transaction_id": pendingTransactionId, "transaction_type": transactionType, "account_name": accountName, "account_institution_name": accountInstitutionName, "payment_meta": paymentMeta.flatMap { $0.snapshot }])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var name: String {
              get {
                return snapshot["name"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "name")
              }
            }

            public var friendlyName: String? {
              get {
                return snapshot["friendlyName"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "friendlyName")
              }
            }

            public var date: String {
              get {
                return snapshot["date"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "date")
              }
            }

            public var amount: Double {
              get {
                return snapshot["amount"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "amount")
              }
            }

            public var transactionId: String {
              get {
                return snapshot["transaction_id"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "transaction_id")
              }
            }

            public var category: [String?]? {
              get {
                return snapshot["category"] as? [String?]
              }
              set {
                snapshot.updateValue(newValue, forKey: "category")
              }
            }

            public var masterAccountId: String {
              get {
                return snapshot["masterAccountId"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "masterAccountId")
              }
            }

            public var fioCategoryId: Int {
              get {
                return snapshot["fioCategoryId"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "fioCategoryId")
              }
            }

            public var accountOwner: String? {
              get {
                return snapshot["account_owner"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "account_owner")
              }
            }

            public var categoryId: Double? {
              get {
                return snapshot["category_id"] as? Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "category_id")
              }
            }

            public var insertTimestamp: Double? {
              get {
                return snapshot["insertTimestamp"] as? Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "insertTimestamp")
              }
            }

            public var institutionId: String? {
              get {
                return snapshot["institution_id"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "institution_id")
              }
            }

            public var itemId: String {
              get {
                return snapshot["item_id"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "item_id")
              }
            }

            public var pending: Bool? {
              get {
                return snapshot["pending"] as? Bool
              }
              set {
                snapshot.updateValue(newValue, forKey: "pending")
              }
            }

            public var pendingTransactionId: String? {
              get {
                return snapshot["pending_transaction_id"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "pending_transaction_id")
              }
            }

            public var transactionType: String? {
              get {
                return snapshot["transaction_type"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "transaction_type")
              }
            }

            public var accountName: String? {
              get {
                return snapshot["account_name"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "account_name")
              }
            }

            public var accountInstitutionName: String? {
              get {
                return snapshot["account_institution_name"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "account_institution_name")
              }
            }

            public var paymentMeta: PaymentMetum? {
              get {
                return (snapshot["payment_meta"] as? Snapshot).flatMap { PaymentMetum(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "payment_meta")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }

            public struct Fragments {
              public var snapshot: Snapshot

              public var transactionDetails: TransactionDetails {
                get {
                  return TransactionDetails(snapshot: snapshot)
                }
                set {
                  snapshot += newValue.snapshot
                }
              }
            }

            public struct PaymentMetum: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOTransactionPaymentMetadata"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("by_order_of", type: .scalar(String.self)),
                GraphQLField("payee", type: .scalar(String.self)),
                GraphQLField("payer", type: .scalar(String.self)),
                GraphQLField("payment_method", type: .scalar(String.self)),
                GraphQLField("payment_processor", type: .scalar(String.self)),
                GraphQLField("ppd_id", type: .scalar(String.self)),
                GraphQLField("reason", type: .scalar(String.self)),
                GraphQLField("reference_number", type: .scalar(String.self)),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(byOrderOf: String? = nil, payee: String? = nil, payer: String? = nil, paymentMethod: String? = nil, paymentProcessor: String? = nil, ppdId: String? = nil, reason: String? = nil, referenceNumber: String? = nil) {
                self.init(snapshot: ["__typename": "FIOTransactionPaymentMetadata", "by_order_of": byOrderOf, "payee": payee, "payer": payer, "payment_method": paymentMethod, "payment_processor": paymentProcessor, "ppd_id": ppdId, "reason": reason, "reference_number": referenceNumber])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var byOrderOf: String? {
                get {
                  return snapshot["by_order_of"] as? String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "by_order_of")
                }
              }

              public var payee: String? {
                get {
                  return snapshot["payee"] as? String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "payee")
                }
              }

              public var payer: String? {
                get {
                  return snapshot["payer"] as? String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "payer")
                }
              }

              public var paymentMethod: String? {
                get {
                  return snapshot["payment_method"] as? String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "payment_method")
                }
              }

              public var paymentProcessor: String? {
                get {
                  return snapshot["payment_processor"] as? String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "payment_processor")
                }
              }

              public var ppdId: String? {
                get {
                  return snapshot["ppd_id"] as? String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "ppd_id")
                }
              }

              public var reason: String? {
                get {
                  return snapshot["reason"] as? String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "reason")
                }
              }

              public var referenceNumber: String? {
                get {
                  return snapshot["reference_number"] as? String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "reference_number")
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class GetTransactionsQuery: GraphQLQuery {
  public static let operationString =
    "query GetTransactions($transaction_ids: [String], $returnSummary: Boolean = true) {\n  getTransactions(transaction_ids: $transaction_ids) {\n    __typename\n    name\n    friendlyName\n    date\n    amount\n    transaction_id\n    category\n    masterAccountId\n    fioCategoryId\n    pending\n    ...transactionDetails @skip(if: $returnSummary)\n  }\n}"

  public static var requestString: String { return operationString.appending(TransactionDetails.fragmentString) }

  public var transaction_ids: [String?]?
  public var returnSummary: Bool?

  public init(transaction_ids: [String?]? = nil, returnSummary: Bool? = nil) {
    self.transaction_ids = transaction_ids
    self.returnSummary = returnSummary
  }

  public var variables: GraphQLMap? {
    return ["transaction_ids": transaction_ids, "returnSummary": returnSummary]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getTransactions", arguments: ["transaction_ids": GraphQLVariable("transaction_ids")], type: .list(.nonNull(.object(GetTransaction.selections)))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getTransactions: [GetTransaction]? = nil) {
      self.init(snapshot: ["__typename": "Query", "getTransactions": getTransactions.flatMap { $0.map { $0.snapshot } }])
    }

    public var getTransactions: [GetTransaction]? {
      get {
        return (snapshot["getTransactions"] as? [Snapshot]).flatMap { $0.map { GetTransaction(snapshot: $0) } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "getTransactions")
      }
    }

    public struct GetTransaction: GraphQLSelectionSet {
      public static let possibleTypes = ["FIOTransaction"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("friendlyName", type: .scalar(String.self)),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
        GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
        GraphQLField("category", type: .list(.scalar(String.self))),
        GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
        GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
        GraphQLField("pending", type: .scalar(Bool.self)),
        GraphQLBooleanCondition(variableName: "returnSummary", inverted: true, selections: [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("account_owner", type: .scalar(String.self)),
          GraphQLField("category_id", type: .scalar(Double.self)),
          GraphQLField("insertTimestamp", type: .scalar(Double.self)),
          GraphQLField("institution_id", type: .scalar(String.self)),
          GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
          GraphQLField("pending", type: .scalar(Bool.self)),
          GraphQLField("pending_transaction_id", type: .scalar(String.self)),
          GraphQLField("transaction_type", type: .scalar(String.self)),
          GraphQLField("account_name", type: .scalar(String.self)),
          GraphQLField("account_institution_name", type: .scalar(String.self)),
          GraphQLField("payment_meta", type: .object(PaymentMetum.selections)),
        ]),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(name: String, friendlyName: String? = nil, date: String, amount: Double, transactionId: String, category: [String?]? = nil, masterAccountId: String, fioCategoryId: Int, pending: Bool? = nil, accountOwner: String? = nil, categoryId: Double? = nil, insertTimestamp: Double? = nil, institutionId: String? = nil, itemId: String? = nil, pendingTransactionId: String? = nil, transactionType: String? = nil, accountName: String? = nil, accountInstitutionName: String? = nil, paymentMeta: PaymentMetum? = nil) {
        self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "date": date, "amount": amount, "transaction_id": transactionId, "category": category, "masterAccountId": masterAccountId, "fioCategoryId": fioCategoryId, "pending": pending, "account_owner": accountOwner, "category_id": categoryId, "insertTimestamp": insertTimestamp, "institution_id": institutionId, "item_id": itemId, "pending_transaction_id": pendingTransactionId, "transaction_type": transactionType, "account_name": accountName, "account_institution_name": accountInstitutionName, "payment_meta": paymentMeta.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var friendlyName: String? {
        get {
          return snapshot["friendlyName"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "friendlyName")
        }
      }

      public var date: String {
        get {
          return snapshot["date"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "date")
        }
      }

      public var amount: Double {
        get {
          return snapshot["amount"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "amount")
        }
      }

      public var transactionId: String {
        get {
          return snapshot["transaction_id"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "transaction_id")
        }
      }

      public var category: [String?]? {
        get {
          return snapshot["category"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "category")
        }
      }

      public var masterAccountId: String {
        get {
          return snapshot["masterAccountId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "masterAccountId")
        }
      }

      public var fioCategoryId: Int {
        get {
          return snapshot["fioCategoryId"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "fioCategoryId")
        }
      }

      public var pending: Bool? {
        get {
          return snapshot["pending"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "pending")
        }
      }

      public var accountOwner: String? {
        get {
          return snapshot["account_owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "account_owner")
        }
      }

      public var categoryId: Double? {
        get {
          return snapshot["category_id"] as? Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "category_id")
        }
      }

      public var insertTimestamp: Double? {
        get {
          return snapshot["insertTimestamp"] as? Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "insertTimestamp")
        }
      }

      public var institutionId: String? {
        get {
          return snapshot["institution_id"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "institution_id")
        }
      }

      public var itemId: String? {
        get {
          return snapshot["item_id"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "item_id")
        }
      }

      public var pendingTransactionId: String? {
        get {
          return snapshot["pending_transaction_id"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "pending_transaction_id")
        }
      }

      public var transactionType: String? {
        get {
          return snapshot["transaction_type"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "transaction_type")
        }
      }

      public var accountName: String? {
        get {
          return snapshot["account_name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "account_name")
        }
      }

      public var accountInstitutionName: String? {
        get {
          return snapshot["account_institution_name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "account_institution_name")
        }
      }

      public var paymentMeta: PaymentMetum? {
        get {
          return (snapshot["payment_meta"] as? Snapshot).flatMap { PaymentMetum(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "payment_meta")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var transactionDetails: TransactionDetails {
          get {
            return TransactionDetails(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct PaymentMetum: GraphQLSelectionSet {
        public static let possibleTypes = ["FIOTransactionPaymentMetadata"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("by_order_of", type: .scalar(String.self)),
          GraphQLField("payee", type: .scalar(String.self)),
          GraphQLField("payer", type: .scalar(String.self)),
          GraphQLField("payment_method", type: .scalar(String.self)),
          GraphQLField("payment_processor", type: .scalar(String.self)),
          GraphQLField("ppd_id", type: .scalar(String.self)),
          GraphQLField("reason", type: .scalar(String.self)),
          GraphQLField("reference_number", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(byOrderOf: String? = nil, payee: String? = nil, payer: String? = nil, paymentMethod: String? = nil, paymentProcessor: String? = nil, ppdId: String? = nil, reason: String? = nil, referenceNumber: String? = nil) {
          self.init(snapshot: ["__typename": "FIOTransactionPaymentMetadata", "by_order_of": byOrderOf, "payee": payee, "payer": payer, "payment_method": paymentMethod, "payment_processor": paymentProcessor, "ppd_id": ppdId, "reason": reason, "reference_number": referenceNumber])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var byOrderOf: String? {
          get {
            return snapshot["by_order_of"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "by_order_of")
          }
        }

        public var payee: String? {
          get {
            return snapshot["payee"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "payee")
          }
        }

        public var payer: String? {
          get {
            return snapshot["payer"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "payer")
          }
        }

        public var paymentMethod: String? {
          get {
            return snapshot["payment_method"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "payment_method")
          }
        }

        public var paymentProcessor: String? {
          get {
            return snapshot["payment_processor"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "payment_processor")
          }
        }

        public var ppdId: String? {
          get {
            return snapshot["ppd_id"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "ppd_id")
          }
        }

        public var reason: String? {
          get {
            return snapshot["reason"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "reason")
          }
        }

        public var referenceNumber: String? {
          get {
            return snapshot["reference_number"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "reference_number")
          }
        }
      }
    }
  }
}

public final class PutItemQuery: GraphQLQuery {
  public static let operationString =
    "query PutItem($item: FIOPlaidItemInput!, $force: Boolean, $isUpdate: Boolean) {\n  putItem(item: $item, force: $force, isUpdate: $isUpdate)\n}"

  public var item: FIOPlaidItemInput
  public var force: Bool?
  public var isUpdate: Bool?

  public init(item: FIOPlaidItemInput, force: Bool? = nil, isUpdate: Bool? = nil) {
    self.item = item
    self.force = force
    self.isUpdate = isUpdate
  }

  public var variables: GraphQLMap? {
    return ["item": item, "force": force, "isUpdate": isUpdate]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("putItem", arguments: ["item": GraphQLVariable("item"), "force": GraphQLVariable("force"), "isUpdate": GraphQLVariable("isUpdate")], type: .scalar(Bool.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(putItem: Bool? = nil) {
      self.init(snapshot: ["__typename": "Query", "putItem": putItem])
    }

    public var putItem: Bool? {
      get {
        return snapshot["putItem"] as? Bool
      }
      set {
        snapshot.updateValue(newValue, forKey: "putItem")
      }
    }
  }
}

public final class NewApnTokenMutation: GraphQLMutation {
  public static let operationString =
    "mutation NewApnToken($token: String!, $platform: String!) {\n  newApnToken(token: $token, platform: $platform)\n}"

  public var token: String
  public var platform: String

  public init(token: String, platform: String) {
    self.token = token
    self.platform = platform
  }

  public var variables: GraphQLMap? {
    return ["token": token, "platform": platform]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("newApnToken", arguments: ["token": GraphQLVariable("token"), "platform": GraphQLVariable("platform")], type: .scalar(Bool.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(newApnToken: Bool? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "newApnToken": newApnToken])
    }

    public var newApnToken: Bool? {
      get {
        return snapshot["newApnToken"] as? Bool
      }
      set {
        snapshot.updateValue(newValue, forKey: "newApnToken")
      }
    }
  }
}

public final class RemoveItemQuery: GraphQLQuery {
  public static let operationString =
    "query RemoveItem($item_id: String!) {\n  removeItem(item_id: $item_id)\n}"

  public var item_id: String

  public init(item_id: String) {
    self.item_id = item_id
  }

  public var variables: GraphQLMap? {
    return ["item_id": item_id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("removeItem", arguments: ["item_id": GraphQLVariable("item_id")], type: .scalar(Bool.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(removeItem: Bool? = nil) {
      self.init(snapshot: ["__typename": "Query", "removeItem": removeItem])
    }

    public var removeItem: Bool? {
      get {
        return snapshot["removeItem"] as? Bool
      }
      set {
        snapshot.updateValue(newValue, forKey: "removeItem")
      }
    }
  }
}

public final class DeleteUserQuery: GraphQLQuery {
  public static let operationString =
    "query DeleteUser($dumbString: String) {\n  deleteUser(dummyArgToAvoidClientCrash: $dumbString)\n}"

  public var dumbString: String?

  public init(dumbString: String? = nil) {
    self.dumbString = dumbString
  }

  public var variables: GraphQLMap? {
    return ["dumbString": dumbString]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteUser", arguments: ["dummyArgToAvoidClientCrash": GraphQLVariable("dumbString")], type: .scalar(Bool.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteUser: Bool? = nil) {
      self.init(snapshot: ["__typename": "Query", "deleteUser": deleteUser])
    }

    public var deleteUser: Bool? {
      get {
        return snapshot["deleteUser"] as? Bool
      }
      set {
        snapshot.updateValue(newValue, forKey: "deleteUser")
      }
    }
  }
}

public final class PutSubMutation: GraphQLMutation {
  public static let operationString =
    "mutation PutSub($sub: String!) {\n  putSub(sub: $sub)\n}"

  public var sub: String

  public init(sub: String) {
    self.sub = sub
  }

  public var variables: GraphQLMap? {
    return ["sub": sub]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("putSub", arguments: ["sub": GraphQLVariable("sub")], type: .scalar(Bool.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(putSub: Bool? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "putSub": putSub])
    }

    public var putSub: Bool? {
      get {
        return snapshot["putSub"] as? Bool
      }
      set {
        snapshot.updateValue(newValue, forKey: "putSub")
      }
    }
  }
}

public final class ValidateReceiptMutation: GraphQLMutation {
  public static let operationString =
    "mutation ValidateReceipt($receipt: String!) {\n  validateReceipt(receipt: $receipt) {\n    __typename\n    expires_date_formatted_pst\n    expiresDateSec\n    originalTransactionDateSec\n    latestTransactionDateSec\n    is_trial_period\n    is_in_billing_retry_period\n    auto_renew_status\n    expiration_intent\n  }\n}"

  public var receipt: String

  public init(receipt: String) {
    self.receipt = receipt
  }

  public var variables: GraphQLMap? {
    return ["receipt": receipt]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("validateReceipt", arguments: ["receipt": GraphQLVariable("receipt")], type: .nonNull(.object(ValidateReceipt.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(validateReceipt: ValidateReceipt) {
      self.init(snapshot: ["__typename": "Mutation", "validateReceipt": validateReceipt.snapshot])
    }

    public var validateReceipt: ValidateReceipt {
      get {
        return ValidateReceipt(snapshot: snapshot["validateReceipt"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "validateReceipt")
      }
    }

    public struct ValidateReceipt: GraphQLSelectionSet {
      public static let possibleTypes = ["FIOSubscriptionVerifyResponse"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("expires_date_formatted_pst", type: .scalar(String.self)),
        GraphQLField("expiresDateSec", type: .scalar(Int.self)),
        GraphQLField("originalTransactionDateSec", type: .scalar(Int.self)),
        GraphQLField("latestTransactionDateSec", type: .scalar(Int.self)),
        GraphQLField("is_trial_period", type: .scalar(Bool.self)),
        GraphQLField("is_in_billing_retry_period", type: .scalar(Bool.self)),
        GraphQLField("auto_renew_status", type: .scalar(Int.self)),
        GraphQLField("expiration_intent", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(expiresDateFormattedPst: String? = nil, expiresDateSec: Int? = nil, originalTransactionDateSec: Int? = nil, latestTransactionDateSec: Int? = nil, isTrialPeriod: Bool? = nil, isInBillingRetryPeriod: Bool? = nil, autoRenewStatus: Int? = nil, expirationIntent: Int? = nil) {
        self.init(snapshot: ["__typename": "FIOSubscriptionVerifyResponse", "expires_date_formatted_pst": expiresDateFormattedPst, "expiresDateSec": expiresDateSec, "originalTransactionDateSec": originalTransactionDateSec, "latestTransactionDateSec": latestTransactionDateSec, "is_trial_period": isTrialPeriod, "is_in_billing_retry_period": isInBillingRetryPeriod, "auto_renew_status": autoRenewStatus, "expiration_intent": expirationIntent])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var expiresDateFormattedPst: String? {
        get {
          return snapshot["expires_date_formatted_pst"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "expires_date_formatted_pst")
        }
      }

      public var expiresDateSec: Int? {
        get {
          return snapshot["expiresDateSec"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "expiresDateSec")
        }
      }

      public var originalTransactionDateSec: Int? {
        get {
          return snapshot["originalTransactionDateSec"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "originalTransactionDateSec")
        }
      }

      public var latestTransactionDateSec: Int? {
        get {
          return snapshot["latestTransactionDateSec"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "latestTransactionDateSec")
        }
      }

      public var isTrialPeriod: Bool? {
        get {
          return snapshot["is_trial_period"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "is_trial_period")
        }
      }

      public var isInBillingRetryPeriod: Bool? {
        get {
          return snapshot["is_in_billing_retry_period"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "is_in_billing_retry_period")
        }
      }

      public var autoRenewStatus: Int? {
        get {
          return snapshot["auto_renew_status"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "auto_renew_status")
        }
      }

      public var expirationIntent: Int? {
        get {
          return snapshot["expiration_intent"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "expiration_intent")
        }
      }
    }
  }
}

public final class GetSubscriptionStatusQuery: GraphQLQuery {
  public static let operationString =
    "query GetSubscriptionStatus {\n  getSubscriptionStatus {\n    __typename\n    expires_date_formatted_pst\n    expiresDateSec\n    originalTransactionDateSec\n    latestTransactionDateSec\n    is_trial_period\n    is_in_billing_retry_period\n    auto_renew_status\n    expiration_intent\n    promoGrantUntilTimestamp\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getSubscriptionStatus", type: .object(GetSubscriptionStatus.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getSubscriptionStatus: GetSubscriptionStatus? = nil) {
      self.init(snapshot: ["__typename": "Query", "getSubscriptionStatus": getSubscriptionStatus.flatMap { $0.snapshot }])
    }

    public var getSubscriptionStatus: GetSubscriptionStatus? {
      get {
        return (snapshot["getSubscriptionStatus"] as? Snapshot).flatMap { GetSubscriptionStatus(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getSubscriptionStatus")
      }
    }

    public struct GetSubscriptionStatus: GraphQLSelectionSet {
      public static let possibleTypes = ["FIOSubscriptionVerifyResponse"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("expires_date_formatted_pst", type: .scalar(String.self)),
        GraphQLField("expiresDateSec", type: .scalar(Int.self)),
        GraphQLField("originalTransactionDateSec", type: .scalar(Int.self)),
        GraphQLField("latestTransactionDateSec", type: .scalar(Int.self)),
        GraphQLField("is_trial_period", type: .scalar(Bool.self)),
        GraphQLField("is_in_billing_retry_period", type: .scalar(Bool.self)),
        GraphQLField("auto_renew_status", type: .scalar(Int.self)),
        GraphQLField("expiration_intent", type: .scalar(Int.self)),
        GraphQLField("promoGrantUntilTimestamp", type: .scalar(Double.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(expiresDateFormattedPst: String? = nil, expiresDateSec: Int? = nil, originalTransactionDateSec: Int? = nil, latestTransactionDateSec: Int? = nil, isTrialPeriod: Bool? = nil, isInBillingRetryPeriod: Bool? = nil, autoRenewStatus: Int? = nil, expirationIntent: Int? = nil, promoGrantUntilTimestamp: Double? = nil) {
        self.init(snapshot: ["__typename": "FIOSubscriptionVerifyResponse", "expires_date_formatted_pst": expiresDateFormattedPst, "expiresDateSec": expiresDateSec, "originalTransactionDateSec": originalTransactionDateSec, "latestTransactionDateSec": latestTransactionDateSec, "is_trial_period": isTrialPeriod, "is_in_billing_retry_period": isInBillingRetryPeriod, "auto_renew_status": autoRenewStatus, "expiration_intent": expirationIntent, "promoGrantUntilTimestamp": promoGrantUntilTimestamp])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var expiresDateFormattedPst: String? {
        get {
          return snapshot["expires_date_formatted_pst"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "expires_date_formatted_pst")
        }
      }

      public var expiresDateSec: Int? {
        get {
          return snapshot["expiresDateSec"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "expiresDateSec")
        }
      }

      public var originalTransactionDateSec: Int? {
        get {
          return snapshot["originalTransactionDateSec"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "originalTransactionDateSec")
        }
      }

      public var latestTransactionDateSec: Int? {
        get {
          return snapshot["latestTransactionDateSec"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "latestTransactionDateSec")
        }
      }

      public var isTrialPeriod: Bool? {
        get {
          return snapshot["is_trial_period"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "is_trial_period")
        }
      }

      public var isInBillingRetryPeriod: Bool? {
        get {
          return snapshot["is_in_billing_retry_period"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "is_in_billing_retry_period")
        }
      }

      public var autoRenewStatus: Int? {
        get {
          return snapshot["auto_renew_status"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "auto_renew_status")
        }
      }

      public var expirationIntent: Int? {
        get {
          return snapshot["expiration_intent"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "expiration_intent")
        }
      }

      public var promoGrantUntilTimestamp: Double? {
        get {
          return snapshot["promoGrantUntilTimestamp"] as? Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "promoGrantUntilTimestamp")
        }
      }
    }
  }
}

public final class PromoCodeQuery: GraphQLQuery {
  public static let operationString =
    "query PromoCode($promoCode: String) {\n  promoCode(promoCode: $promoCode) {\n    __typename\n    promoGrantUntilTimestamp\n  }\n}"

  public var promoCode: String?

  public init(promoCode: String? = nil) {
    self.promoCode = promoCode
  }

  public var variables: GraphQLMap? {
    return ["promoCode": promoCode]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("promoCode", arguments: ["promoCode": GraphQLVariable("promoCode")], type: .object(PromoCode.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(promoCode: PromoCode? = nil) {
      self.init(snapshot: ["__typename": "Query", "promoCode": promoCode.flatMap { $0.snapshot }])
    }

    public var promoCode: PromoCode? {
      get {
        return (snapshot["promoCode"] as? Snapshot).flatMap { PromoCode(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "promoCode")
      }
    }

    public struct PromoCode: GraphQLSelectionSet {
      public static let possibleTypes = ["FIOSubscriptionVerifyResponse"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("promoGrantUntilTimestamp", type: .scalar(Double.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(promoGrantUntilTimestamp: Double? = nil) {
        self.init(snapshot: ["__typename": "FIOSubscriptionVerifyResponse", "promoGrantUntilTimestamp": promoGrantUntilTimestamp])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var promoGrantUntilTimestamp: Double? {
        get {
          return snapshot["promoGrantUntilTimestamp"] as? Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "promoGrantUntilTimestamp")
        }
      }
    }
  }
}

public final class GetInstitutionQuery: GraphQLQuery {
  public static let operationString =
    "query GetInstitution($ins_id: String!) {\n  getInstitution(ins_id: $ins_id) {\n    __typename\n    colors {\n      __typename\n      dark\n      darker\n      light\n      primary\n    }\n    brand_name\n    brand_subheading\n    link_health_status\n    name\n    url\n    url_account_locked\n    health_status\n  }\n}"

  public var ins_id: String

  public init(ins_id: String) {
    self.ins_id = ins_id
  }

  public var variables: GraphQLMap? {
    return ["ins_id": ins_id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getInstitution", arguments: ["ins_id": GraphQLVariable("ins_id")], type: .object(GetInstitution.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getInstitution: GetInstitution? = nil) {
      self.init(snapshot: ["__typename": "Query", "getInstitution": getInstitution.flatMap { $0.snapshot }])
    }

    public var getInstitution: GetInstitution? {
      get {
        return (snapshot["getInstitution"] as? Snapshot).flatMap { GetInstitution(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getInstitution")
      }
    }

    public struct GetInstitution: GraphQLSelectionSet {
      public static let possibleTypes = ["QIOInstitution"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("colors", type: .nonNull(.object(Color.selections))),
        GraphQLField("brand_name", type: .nonNull(.scalar(String.self))),
        GraphQLField("brand_subheading", type: .scalar(String.self)),
        GraphQLField("link_health_status", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .nonNull(.scalar(String.self))),
        GraphQLField("url_account_locked", type: .scalar(String.self)),
        GraphQLField("health_status", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(colors: Color, brandName: String, brandSubheading: String? = nil, linkHealthStatus: String, name: String, url: String, urlAccountLocked: String? = nil, healthStatus: String) {
        self.init(snapshot: ["__typename": "QIOInstitution", "colors": colors.snapshot, "brand_name": brandName, "brand_subheading": brandSubheading, "link_health_status": linkHealthStatus, "name": name, "url": url, "url_account_locked": urlAccountLocked, "health_status": healthStatus])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var colors: Color {
        get {
          return Color(snapshot: snapshot["colors"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "colors")
        }
      }

      public var brandName: String {
        get {
          return snapshot["brand_name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "brand_name")
        }
      }

      public var brandSubheading: String? {
        get {
          return snapshot["brand_subheading"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "brand_subheading")
        }
      }

      public var linkHealthStatus: String {
        get {
          return snapshot["link_health_status"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "link_health_status")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var url: String {
        get {
          return snapshot["url"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "url")
        }
      }

      public var urlAccountLocked: String? {
        get {
          return snapshot["url_account_locked"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "url_account_locked")
        }
      }

      public var healthStatus: String {
        get {
          return snapshot["health_status"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "health_status")
        }
      }

      public struct Color: GraphQLSelectionSet {
        public static let possibleTypes = ["QIOInstitution_Colors"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("dark", type: .nonNull(.scalar(String.self))),
          GraphQLField("darker", type: .nonNull(.scalar(String.self))),
          GraphQLField("light", type: .nonNull(.scalar(String.self))),
          GraphQLField("primary", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(dark: String, darker: String, light: String, primary: String) {
          self.init(snapshot: ["__typename": "QIOInstitution_Colors", "dark": dark, "darker": darker, "light": light, "primary": primary])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var dark: String {
          get {
            return snapshot["dark"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "dark")
          }
        }

        public var darker: String {
          get {
            return snapshot["darker"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "darker")
          }
        }

        public var light: String {
          get {
            return snapshot["light"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "light")
          }
        }

        public var primary: String {
          get {
            return snapshot["primary"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "primary")
          }
        }
      }
    }
  }
}

public final class GetUserHomeQuery: GraphQLQuery {
  public static let operationString =
    "query GetUserHome {\n  getUserHome {\n    __typename\n    items {\n      __typename\n      institution_id\n      institution_name\n      item_id\n      needsUpdate\n      env\n      createdDate\n      lastTransactionPull\n      institutionDetails {\n        __typename\n        colors {\n          __typename\n          dark\n          darker\n          light\n          primary\n        }\n        brand_name\n        brand_subheading\n        link_health_status\n        name\n        url\n        url_account_locked\n        health_status\n      }\n      transactionDetails {\n        __typename\n        latestTransactionAmount\n        latestTransactionDate\n        latestTransactionName\n        oldestTransactionDate\n        transactionCount\n      }\n    }\n    accounts {\n      __typename\n      masterAccountId\n      displayName\n      hidden\n      institution_id\n      balances {\n        __typename\n        available\n        current\n        limit\n      }\n      institution_name\n      item_id\n      lastSynced\n      mask\n      name\n      official_name\n      subtype\n      type\n    }\n    transactionOverview {\n      __typename\n      totalIn\n      totalOut\n      oldestTransactionDate\n      transactionCount\n    }\n    spending {\n      __typename\n      totalAmount\n      months {\n        __typename\n        amount\n        month\n      }\n      monthsAnalyzed\n      categories {\n        __typename\n        startDate\n        endDate\n        lookbackDayCount\n        total\n        cats {\n          __typename\n          name\n          description\n          amount\n          percentage\n          emoji\n          id\n          tids\n        }\n      }\n      basicLivingExpenses {\n        __typename\n        estimatedMonthlyAmount\n        summary {\n          __typename\n          categoryId\n          average\n          friendlyName\n          description\n        }\n        months {\n          __typename\n          monthTotal\n          allTids\n          monthStr\n          monthStartDate\n          monthEndDate\n          byCategory {\n            __typename\n            categoryId\n            amount\n            tids\n          }\n        }\n      }\n      daily {\n        __typename\n        averageAmount\n        daysAnalyzed\n      }\n      quantized {\n        __typename\n        isRecurring\n        nameFriendly\n        nameOriginal\n        nameSlug\n        dailyAvg\n        pastTwelveMonths\n        pastThreeMonths\n        twelveMonthTids\n        threeMonthTids\n        fioCategoryId\n        recurringStream {\n          __typename\n          periodSize\n          periodsPerYear\n          streamType\n          amountDistribution {\n            __typename\n            annualEstimate\n            totalAmountEver\n            mean\n            relativeStandardDeviationPct\n            standardDeviation\n            dailyEstimate\n            monthlyEstimate\n            sum\n          }\n          dateDistribution {\n            __typename\n            avgDiffDays\n            daysUntilNext\n            duration\n            firstDate\n            firstDaysAgo\n            lastDate\n            lastDaysAgo\n            relativeStandardDeviationPct\n            standardDeviation\n          }\n          streamTids\n        }\n      }\n    }\n    moneyRental {\n      __typename\n      creditCards {\n        __typename\n        accountMaids\n        costOfOneDollar\n        daysAnalyzed\n        rent {\n          __typename\n          averagePerDay\n          dailyPeriodicRate\n          daysAnalyzed\n          percentOfDailyNet\n          totalInAnalysisPeriod\n        }\n        balance {\n          __typename\n          current {\n            __typename\n            total\n            totalSubjectToLimit\n            totalLimit\n            totalEffectiveBalance\n            utilizationPercentage\n          }\n          historical {\n            __typename\n            daysAnalyzed\n            avgBalance\n            avgMMCarryOver\n            MMCarryOvers\n            dates {\n              __typename\n              date\n              balance\n              utilization\n            }\n          }\n        }\n      }\n    }\n    income {\n      __typename\n      summary {\n        __typename\n        activeDailyEstimate\n        analyzedDepositCount\n        analyzedAccountMaids\n        oldestActiveStreamStartDate\n      }\n      activeStreams {\n        __typename\n        streamType\n        periodSize\n        identifiedIn\n        slug\n        nameFriendly\n        tids\n        amountDistribution {\n          __typename\n          annualEstimate\n          totalAmountEver\n          mean\n          relativeStandardDeviationPct\n          standardDeviation\n          dailyEstimate\n          monthlyEstimate\n          sum\n        }\n        dateDistribution {\n          __typename\n          avgDiffDays\n          daysUntilNext\n          duration\n          firstDate\n          firstDaysAgo\n          lastDate\n          lastDaysAgo\n          relativeStandardDeviationPct\n          standardDeviation\n        }\n      }\n      inactiveStreams {\n        __typename\n        streamType\n        periodSize\n        identifiedIn\n        slug\n        nameFriendly\n        tids\n        amountDistribution {\n          __typename\n          annualEstimate\n          totalAmountEver\n          mean\n          relativeStandardDeviationPct\n          standardDeviation\n          dailyEstimate\n          monthlyEstimate\n          sum\n        }\n        dateDistribution {\n          __typename\n          avgDiffDays\n          daysUntilNext\n          duration\n          firstDate\n          firstDaysAgo\n          lastDate\n          lastDaysAgo\n          relativeStandardDeviationPct\n          standardDeviation\n        }\n      }\n    }\n    financialIndependence {\n      __typename\n      totalCapital\n      safeWithdrawal\n      liquidCushion {\n        __typename\n        current {\n          __typename\n          balance\n          months\n          monthsAsPercentage\n        }\n        historical {\n          __typename\n          months {\n            __typename\n            month\n            bufferAtStartOfMonth\n          }\n          dates {\n            __typename\n            date\n            balance\n          }\n          averageBalance\n          daysAnalyzed\n        }\n        accountMaids\n        consts {\n          __typename\n          targetSafetyMonths\n        }\n      }\n      savingsRate {\n        __typename\n        income_90d\n        income_365d\n        net_365d\n        net_90d\n        dateStr_90d\n        dateStr_365d\n        actualSavingsRate_90d\n        actualSavingsRate_365d\n        potentialSavingsRate_90d\n        potentialSavingsRate_365d\n        depositsSum_90d\n        depositsSum_365d\n        withdrawalsSum_90d\n        withdrawalsSum_365d\n        netLongtermMoney_90d\n        netLongtermMoney_365d\n        depositTids\n        withdrawalTids\n        netsFor365d\n      }\n    }\n    subscriptionStatus {\n      __typename\n      hasSubscription\n      isRenewing\n      isInTrial\n      isInPromo\n    }\n    yesterday {\n      __typename\n      periodId\n      windowSize\n      daysInRange\n      startDate\n      endDate\n      daysRemainingInPeriod\n      dayNets\n      includesEndOfData\n      projection {\n        __typename\n        net\n        incomeTotal\n        spendTotal\n      }\n      periodSummary {\n        __typename\n        spending {\n          __typename\n          actual\n          target\n          projected\n          spendWithoutBle\n          spendBleAmortized\n        }\n        categories {\n          __typename\n          total\n          names\n          percentages\n          descriptions\n          amounts\n        }\n        balances {\n          __typename\n          accountSubtype\n          startingBalance\n          endingBalance\n        }\n        isFillerObject\n        netAmount\n        income\n        transactions {\n          __typename\n          totalAmount\n          deposits {\n            __typename\n            totalAmount\n            transactionIds\n          }\n          debits {\n            __typename\n            totalAmount\n            transactionIds\n            transactions {\n              __typename\n              name\n              friendlyName\n              amount\n              transaction_id\n              fioCategoryId\n              date\n              masterAccountId\n              pending\n            }\n          }\n          transfers {\n            __typename\n            totalAmount\n            transactionIds\n            transactionSummaries {\n              __typename\n              friendlyName\n              transaction_id\n              amount\n              fioCategoryId\n            }\n          }\n          regularIncome {\n            __typename\n            totalAmount\n            transactionIds\n          }\n          creditCardPayments {\n            __typename\n            totalAmount\n            destinationAccountNames\n            sourceAccountNames\n            payments {\n              __typename\n              amount\n              from {\n                __typename\n                name\n                friendlyName\n                date\n                amount\n                transaction_id\n                category\n                masterAccountId\n                fioCategoryId\n                account {\n                  __typename\n                  displayName\n                  hidden\n                  masterAccountId\n                  institution_id\n                  balances {\n                    __typename\n                    available\n                    limit\n                    current\n                  }\n                  institution_name\n                  item_id\n                  lastSynced\n                  mask\n                  name\n                  official_name\n                  subtype\n                  type\n                }\n                ...transactionDetails\n              }\n              to {\n                __typename\n                name\n                friendlyName\n                date\n                amount\n                transaction_id\n                category\n                masterAccountId\n                fioCategoryId\n                account {\n                  __typename\n                  displayName\n                  hidden\n                  masterAccountId\n                  institution_id\n                  balances {\n                    __typename\n                    available\n                    limit\n                    current\n                  }\n                  institution_name\n                  item_id\n                  lastSynced\n                  mask\n                  name\n                  official_name\n                  subtype\n                  type\n                }\n                ...transactionDetails\n              }\n            }\n          }\n        }\n      }\n    }\n    thisMonth {\n      __typename\n      periodId\n      windowSize\n      daysInRange\n      startDate\n      endDate\n      daysRemainingInPeriod\n      dayNets\n      includesEndOfData\n      projection {\n        __typename\n        net\n        incomeTotal\n        spendTotal\n      }\n      periodSummary {\n        __typename\n        spending {\n          __typename\n          actual\n          target\n          projected\n          spendWithoutBle\n          spendBleAmortized\n        }\n        categories {\n          __typename\n          total\n          names\n          percentages\n          descriptions\n          amounts\n        }\n        balances {\n          __typename\n          accountSubtype\n          startingBalance\n          endingBalance\n        }\n        isFillerObject\n        netAmount\n        income\n        transactions {\n          __typename\n          totalAmount\n          deposits {\n            __typename\n            totalAmount\n            transactionIds\n          }\n          debits {\n            __typename\n            totalAmount\n            transactionIds\n            transactions {\n              __typename\n              name\n              friendlyName\n              amount\n              transaction_id\n              fioCategoryId\n              date\n              masterAccountId\n              pending\n            }\n          }\n          transfers {\n            __typename\n            totalAmount\n            transactionIds\n            transactionSummaries {\n              __typename\n              friendlyName\n              transaction_id\n              amount\n              fioCategoryId\n            }\n          }\n          regularIncome {\n            __typename\n            totalAmount\n            transactionIds\n          }\n          creditCardPayments {\n            __typename\n            totalAmount\n            destinationAccountNames\n            sourceAccountNames\n            payments {\n              __typename\n              amount\n              from {\n                __typename\n                name\n                friendlyName\n                date\n                amount\n                transaction_id\n                category\n                masterAccountId\n                fioCategoryId\n                account {\n                  __typename\n                  displayName\n                  hidden\n                  masterAccountId\n                  institution_id\n                  balances {\n                    __typename\n                    available\n                    limit\n                    current\n                  }\n                  institution_name\n                  item_id\n                  lastSynced\n                  mask\n                  name\n                  official_name\n                  subtype\n                  type\n                }\n                ...transactionDetails\n              }\n              to {\n                __typename\n                name\n                friendlyName\n                date\n                amount\n                transaction_id\n                category\n                masterAccountId\n                fioCategoryId\n                account {\n                  __typename\n                  displayName\n                  hidden\n                  masterAccountId\n                  institution_id\n                  balances {\n                    __typename\n                    available\n                    limit\n                    current\n                  }\n                  institution_name\n                  item_id\n                  lastSynced\n                  mask\n                  name\n                  official_name\n                  subtype\n                  type\n                }\n                ...transactionDetails\n              }\n            }\n          }\n        }\n      }\n    }\n    streaks {\n      __typename\n      days {\n        __typename\n        periodCount\n        extendsToBeginningOfData\n      }\n      weeks {\n        __typename\n        periodCount\n        extendsToBeginningOfData\n      }\n      months {\n        __typename\n        periodCount\n        extendsToBeginningOfData\n      }\n    }\n  }\n}"

  public static var requestString: String { return operationString.appending(TransactionDetails.fragmentString) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getUserHome", type: .object(GetUserHome.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getUserHome: GetUserHome? = nil) {
      self.init(snapshot: ["__typename": "Query", "getUserHome": getUserHome.flatMap { $0.snapshot }])
    }

    public var getUserHome: GetUserHome? {
      get {
        return (snapshot["getUserHome"] as? Snapshot).flatMap { GetUserHome(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getUserHome")
      }
    }

    public struct GetUserHome: GraphQLSelectionSet {
      public static let possibleTypes = ["QIOUserHome"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.nonNull(.object(Item.selections)))),
        GraphQLField("accounts", type: .list(.nonNull(.object(Account.selections)))),
        GraphQLField("transactionOverview", type: .object(TransactionOverview.selections)),
        GraphQLField("spending", type: .object(Spending.selections)),
        GraphQLField("moneyRental", type: .object(MoneyRental.selections)),
        GraphQLField("income", type: .object(Income.selections)),
        GraphQLField("financialIndependence", type: .object(FinancialIndependence.selections)),
        GraphQLField("subscriptionStatus", type: .object(SubscriptionStatus.selections)),
        GraphQLField("yesterday", type: .object(Yesterday.selections)),
        GraphQLField("thisMonth", type: .object(ThisMonth.selections)),
        GraphQLField("streaks", type: .object(Streak.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item]? = nil, accounts: [Account]? = nil, transactionOverview: TransactionOverview? = nil, spending: Spending? = nil, moneyRental: MoneyRental? = nil, income: Income? = nil, financialIndependence: FinancialIndependence? = nil, subscriptionStatus: SubscriptionStatus? = nil, yesterday: Yesterday? = nil, thisMonth: ThisMonth? = nil, streaks: Streak? = nil) {
        self.init(snapshot: ["__typename": "QIOUserHome", "items": items.flatMap { $0.map { $0.snapshot } }, "accounts": accounts.flatMap { $0.map { $0.snapshot } }, "transactionOverview": transactionOverview.flatMap { $0.snapshot }, "spending": spending.flatMap { $0.snapshot }, "moneyRental": moneyRental.flatMap { $0.snapshot }, "income": income.flatMap { $0.snapshot }, "financialIndependence": financialIndependence.flatMap { $0.snapshot }, "subscriptionStatus": subscriptionStatus.flatMap { $0.snapshot }, "yesterday": yesterday.flatMap { $0.snapshot }, "thisMonth": thisMonth.flatMap { $0.snapshot }, "streaks": streaks.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item]? {
        get {
          return (snapshot["items"] as? [Snapshot]).flatMap { $0.map { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "items")
        }
      }

      public var accounts: [Account]? {
        get {
          return (snapshot["accounts"] as? [Snapshot]).flatMap { $0.map { Account(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "accounts")
        }
      }

      public var transactionOverview: TransactionOverview? {
        get {
          return (snapshot["transactionOverview"] as? Snapshot).flatMap { TransactionOverview(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "transactionOverview")
        }
      }

      public var spending: Spending? {
        get {
          return (snapshot["spending"] as? Snapshot).flatMap { Spending(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "spending")
        }
      }

      public var moneyRental: MoneyRental? {
        get {
          return (snapshot["moneyRental"] as? Snapshot).flatMap { MoneyRental(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "moneyRental")
        }
      }

      public var income: Income? {
        get {
          return (snapshot["income"] as? Snapshot).flatMap { Income(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "income")
        }
      }

      public var financialIndependence: FinancialIndependence? {
        get {
          return (snapshot["financialIndependence"] as? Snapshot).flatMap { FinancialIndependence(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "financialIndependence")
        }
      }

      public var subscriptionStatus: SubscriptionStatus? {
        get {
          return (snapshot["subscriptionStatus"] as? Snapshot).flatMap { SubscriptionStatus(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "subscriptionStatus")
        }
      }

      public var yesterday: Yesterday? {
        get {
          return (snapshot["yesterday"] as? Snapshot).flatMap { Yesterday(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "yesterday")
        }
      }

      public var thisMonth: ThisMonth? {
        get {
          return (snapshot["thisMonth"] as? Snapshot).flatMap { ThisMonth(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "thisMonth")
        }
      }

      public var streaks: Streak? {
        get {
          return (snapshot["streaks"] as? Snapshot).flatMap { Streak(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "streaks")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["FIOItem"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("institution_id", type: .nonNull(.scalar(String.self))),
          GraphQLField("institution_name", type: .nonNull(.scalar(String.self))),
          GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
          GraphQLField("needsUpdate", type: .scalar(Bool.self)),
          GraphQLField("env", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdDate", type: .nonNull(.scalar(String.self))),
          GraphQLField("lastTransactionPull", type: .nonNull(.scalar(Double.self))),
          GraphQLField("institutionDetails", type: .nonNull(.object(InstitutionDetail.selections))),
          GraphQLField("transactionDetails", type: .object(TransactionDetail.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(institutionId: String, institutionName: String, itemId: String, needsUpdate: Bool? = nil, env: String, createdDate: String, lastTransactionPull: Double, institutionDetails: InstitutionDetail, transactionDetails: TransactionDetail? = nil) {
          self.init(snapshot: ["__typename": "FIOItem", "institution_id": institutionId, "institution_name": institutionName, "item_id": itemId, "needsUpdate": needsUpdate, "env": env, "createdDate": createdDate, "lastTransactionPull": lastTransactionPull, "institutionDetails": institutionDetails.snapshot, "transactionDetails": transactionDetails.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var institutionId: String {
          get {
            return snapshot["institution_id"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "institution_id")
          }
        }

        public var institutionName: String {
          get {
            return snapshot["institution_name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "institution_name")
          }
        }

        public var itemId: String {
          get {
            return snapshot["item_id"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "item_id")
          }
        }

        public var needsUpdate: Bool? {
          get {
            return snapshot["needsUpdate"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "needsUpdate")
          }
        }

        public var env: String {
          get {
            return snapshot["env"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "env")
          }
        }

        public var createdDate: String {
          get {
            return snapshot["createdDate"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdDate")
          }
        }

        public var lastTransactionPull: Double {
          get {
            return snapshot["lastTransactionPull"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastTransactionPull")
          }
        }

        public var institutionDetails: InstitutionDetail {
          get {
            return InstitutionDetail(snapshot: snapshot["institutionDetails"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "institutionDetails")
          }
        }

        public var transactionDetails: TransactionDetail? {
          get {
            return (snapshot["transactionDetails"] as? Snapshot).flatMap { TransactionDetail(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "transactionDetails")
          }
        }

        public struct InstitutionDetail: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOInstitution"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("colors", type: .nonNull(.object(Color.selections))),
            GraphQLField("brand_name", type: .nonNull(.scalar(String.self))),
            GraphQLField("brand_subheading", type: .scalar(String.self)),
            GraphQLField("link_health_status", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("url", type: .nonNull(.scalar(String.self))),
            GraphQLField("url_account_locked", type: .scalar(String.self)),
            GraphQLField("health_status", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(colors: Color, brandName: String, brandSubheading: String? = nil, linkHealthStatus: String, name: String, url: String, urlAccountLocked: String? = nil, healthStatus: String) {
            self.init(snapshot: ["__typename": "QIOInstitution", "colors": colors.snapshot, "brand_name": brandName, "brand_subheading": brandSubheading, "link_health_status": linkHealthStatus, "name": name, "url": url, "url_account_locked": urlAccountLocked, "health_status": healthStatus])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var colors: Color {
            get {
              return Color(snapshot: snapshot["colors"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "colors")
            }
          }

          public var brandName: String {
            get {
              return snapshot["brand_name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "brand_name")
            }
          }

          public var brandSubheading: String? {
            get {
              return snapshot["brand_subheading"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "brand_subheading")
            }
          }

          public var linkHealthStatus: String {
            get {
              return snapshot["link_health_status"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "link_health_status")
            }
          }

          public var name: String {
            get {
              return snapshot["name"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var url: String {
            get {
              return snapshot["url"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "url")
            }
          }

          public var urlAccountLocked: String? {
            get {
              return snapshot["url_account_locked"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "url_account_locked")
            }
          }

          public var healthStatus: String {
            get {
              return snapshot["health_status"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "health_status")
            }
          }

          public struct Color: GraphQLSelectionSet {
            public static let possibleTypes = ["QIOInstitution_Colors"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("dark", type: .nonNull(.scalar(String.self))),
              GraphQLField("darker", type: .nonNull(.scalar(String.self))),
              GraphQLField("light", type: .nonNull(.scalar(String.self))),
              GraphQLField("primary", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(dark: String, darker: String, light: String, primary: String) {
              self.init(snapshot: ["__typename": "QIOInstitution_Colors", "dark": dark, "darker": darker, "light": light, "primary": primary])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var dark: String {
              get {
                return snapshot["dark"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "dark")
              }
            }

            public var darker: String {
              get {
                return snapshot["darker"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "darker")
              }
            }

            public var light: String {
              get {
                return snapshot["light"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "light")
              }
            }

            public var primary: String {
              get {
                return snapshot["primary"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "primary")
              }
            }
          }
        }

        public struct TransactionDetail: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOItem_TransactionDetails"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("latestTransactionAmount", type: .nonNull(.scalar(Double.self))),
            GraphQLField("latestTransactionDate", type: .nonNull(.scalar(String.self))),
            GraphQLField("latestTransactionName", type: .nonNull(.scalar(String.self))),
            GraphQLField("oldestTransactionDate", type: .nonNull(.scalar(String.self))),
            GraphQLField("transactionCount", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(latestTransactionAmount: Double, latestTransactionDate: String, latestTransactionName: String, oldestTransactionDate: String, transactionCount: Int) {
            self.init(snapshot: ["__typename": "QIOItem_TransactionDetails", "latestTransactionAmount": latestTransactionAmount, "latestTransactionDate": latestTransactionDate, "latestTransactionName": latestTransactionName, "oldestTransactionDate": oldestTransactionDate, "transactionCount": transactionCount])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var latestTransactionAmount: Double {
            get {
              return snapshot["latestTransactionAmount"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "latestTransactionAmount")
            }
          }

          public var latestTransactionDate: String {
            get {
              return snapshot["latestTransactionDate"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "latestTransactionDate")
            }
          }

          public var latestTransactionName: String {
            get {
              return snapshot["latestTransactionName"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "latestTransactionName")
            }
          }

          public var oldestTransactionDate: String {
            get {
              return snapshot["oldestTransactionDate"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "oldestTransactionDate")
            }
          }

          public var transactionCount: Int {
            get {
              return snapshot["transactionCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "transactionCount")
            }
          }
        }
      }

      public struct Account: GraphQLSelectionSet {
        public static let possibleTypes = ["FIOFinAccount"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
          GraphQLField("displayName", type: .scalar(String.self)),
          GraphQLField("hidden", type: .scalar(Bool.self)),
          GraphQLField("institution_id", type: .nonNull(.scalar(String.self))),
          GraphQLField("balances", type: .object(Balance.selections)),
          GraphQLField("institution_name", type: .nonNull(.scalar(String.self))),
          GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
          GraphQLField("lastSynced", type: .nonNull(.scalar(Double.self))),
          GraphQLField("mask", type: .scalar(String.self)),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("official_name", type: .scalar(String.self)),
          GraphQLField("subtype", type: .nonNull(.scalar(String.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(masterAccountId: String, displayName: String? = nil, hidden: Bool? = nil, institutionId: String, balances: Balance? = nil, institutionName: String, itemId: String, lastSynced: Double, mask: String? = nil, name: String, officialName: String? = nil, subtype: String, type: String) {
          self.init(snapshot: ["__typename": "FIOFinAccount", "masterAccountId": masterAccountId, "displayName": displayName, "hidden": hidden, "institution_id": institutionId, "balances": balances.flatMap { $0.snapshot }, "institution_name": institutionName, "item_id": itemId, "lastSynced": lastSynced, "mask": mask, "name": name, "official_name": officialName, "subtype": subtype, "type": type])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var masterAccountId: String {
          get {
            return snapshot["masterAccountId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "masterAccountId")
          }
        }

        public var displayName: String? {
          get {
            return snapshot["displayName"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "displayName")
          }
        }

        public var hidden: Bool? {
          get {
            return snapshot["hidden"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "hidden")
          }
        }

        public var institutionId: String {
          get {
            return snapshot["institution_id"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "institution_id")
          }
        }

        public var balances: Balance? {
          get {
            return (snapshot["balances"] as? Snapshot).flatMap { Balance(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "balances")
          }
        }

        public var institutionName: String {
          get {
            return snapshot["institution_name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "institution_name")
          }
        }

        public var itemId: String {
          get {
            return snapshot["item_id"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "item_id")
          }
        }

        public var lastSynced: Double {
          get {
            return snapshot["lastSynced"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastSynced")
          }
        }

        public var mask: String? {
          get {
            return snapshot["mask"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "mask")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var officialName: String? {
          get {
            return snapshot["official_name"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "official_name")
          }
        }

        public var subtype: String {
          get {
            return snapshot["subtype"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "subtype")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public struct Balance: GraphQLSelectionSet {
          public static let possibleTypes = ["FIOFinAccountBalances"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("available", type: .scalar(Double.self)),
            GraphQLField("current", type: .scalar(Double.self)),
            GraphQLField("limit", type: .scalar(Double.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(available: Double? = nil, current: Double? = nil, limit: Double? = nil) {
            self.init(snapshot: ["__typename": "FIOFinAccountBalances", "available": available, "current": current, "limit": limit])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var available: Double? {
            get {
              return snapshot["available"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "available")
            }
          }

          public var current: Double? {
            get {
              return snapshot["current"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "current")
            }
          }

          public var limit: Double? {
            get {
              return snapshot["limit"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "limit")
            }
          }
        }
      }

      public struct TransactionOverview: GraphQLSelectionSet {
        public static let possibleTypes = ["QIOUserHome_TransactionsOverview"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("totalIn", type: .nonNull(.scalar(Double.self))),
          GraphQLField("totalOut", type: .nonNull(.scalar(Double.self))),
          GraphQLField("oldestTransactionDate", type: .nonNull(.scalar(String.self))),
          GraphQLField("transactionCount", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(totalIn: Double, totalOut: Double, oldestTransactionDate: String, transactionCount: Int) {
          self.init(snapshot: ["__typename": "QIOUserHome_TransactionsOverview", "totalIn": totalIn, "totalOut": totalOut, "oldestTransactionDate": oldestTransactionDate, "transactionCount": transactionCount])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var totalIn: Double {
          get {
            return snapshot["totalIn"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "totalIn")
          }
        }

        public var totalOut: Double {
          get {
            return snapshot["totalOut"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "totalOut")
          }
        }

        public var oldestTransactionDate: String {
          get {
            return snapshot["oldestTransactionDate"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "oldestTransactionDate")
          }
        }

        public var transactionCount: Int {
          get {
            return snapshot["transactionCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "transactionCount")
          }
        }
      }

      public struct Spending: GraphQLSelectionSet {
        public static let possibleTypes = ["QIOSpending"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
          GraphQLField("months", type: .nonNull(.list(.nonNull(.object(Month.selections))))),
          GraphQLField("monthsAnalyzed", type: .nonNull(.scalar(Int.self))),
          GraphQLField("categories", type: .nonNull(.object(Category.selections))),
          GraphQLField("basicLivingExpenses", type: .nonNull(.object(BasicLivingExpense.selections))),
          GraphQLField("daily", type: .nonNull(.object(Daily.selections))),
          GraphQLField("quantized", type: .list(.nonNull(.object(Quantized.selections)))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(totalAmount: Double, months: [Month], monthsAnalyzed: Int, categories: Category, basicLivingExpenses: BasicLivingExpense, daily: Daily, quantized: [Quantized]? = nil) {
          self.init(snapshot: ["__typename": "QIOSpending", "totalAmount": totalAmount, "months": months.map { $0.snapshot }, "monthsAnalyzed": monthsAnalyzed, "categories": categories.snapshot, "basicLivingExpenses": basicLivingExpenses.snapshot, "daily": daily.snapshot, "quantized": quantized.flatMap { $0.map { $0.snapshot } }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var totalAmount: Double {
          get {
            return snapshot["totalAmount"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "totalAmount")
          }
        }

        public var months: [Month] {
          get {
            return (snapshot["months"] as! [Snapshot]).map { Month(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "months")
          }
        }

        public var monthsAnalyzed: Int {
          get {
            return snapshot["monthsAnalyzed"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "monthsAnalyzed")
          }
        }

        public var categories: Category {
          get {
            return Category(snapshot: snapshot["categories"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "categories")
          }
        }

        public var basicLivingExpenses: BasicLivingExpense {
          get {
            return BasicLivingExpense(snapshot: snapshot["basicLivingExpenses"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "basicLivingExpenses")
          }
        }

        public var daily: Daily {
          get {
            return Daily(snapshot: snapshot["daily"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "daily")
          }
        }

        public var quantized: [Quantized]? {
          get {
            return (snapshot["quantized"] as? [Snapshot]).flatMap { $0.map { Quantized(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "quantized")
          }
        }

        public struct Month: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOSpending_Month"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
            GraphQLField("month", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(amount: Double, month: String) {
            self.init(snapshot: ["__typename": "QIOSpending_Month", "amount": amount, "month": month])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var amount: Double {
            get {
              return snapshot["amount"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "amount")
            }
          }

          public var month: String {
            get {
              return snapshot["month"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "month")
            }
          }
        }

        public struct Category: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOSpending_Categories"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("startDate", type: .nonNull(.scalar(String.self))),
            GraphQLField("endDate", type: .nonNull(.scalar(String.self))),
            GraphQLField("lookbackDayCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("total", type: .nonNull(.scalar(Double.self))),
            GraphQLField("cats", type: .nonNull(.list(.nonNull(.object(Cat.selections))))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(startDate: String, endDate: String, lookbackDayCount: Int, total: Double, cats: [Cat]) {
            self.init(snapshot: ["__typename": "QIOSpending_Categories", "startDate": startDate, "endDate": endDate, "lookbackDayCount": lookbackDayCount, "total": total, "cats": cats.map { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var startDate: String {
            get {
              return snapshot["startDate"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "startDate")
            }
          }

          public var endDate: String {
            get {
              return snapshot["endDate"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "endDate")
            }
          }

          public var lookbackDayCount: Int {
            get {
              return snapshot["lookbackDayCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "lookbackDayCount")
            }
          }

          public var total: Double {
            get {
              return snapshot["total"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "total")
            }
          }

          public var cats: [Cat] {
            get {
              return (snapshot["cats"] as! [Snapshot]).map { Cat(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "cats")
            }
          }

          public struct Cat: GraphQLSelectionSet {
            public static let possibleTypes = ["QIOSpending_Categories_Item"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .nonNull(.scalar(String.self))),
              GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
              GraphQLField("percentage", type: .nonNull(.scalar(Double.self))),
              GraphQLField("emoji", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(Int.self))),
              GraphQLField("tids", type: .list(.nonNull(.scalar(String.self)))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(name: String, description: String, amount: Double, percentage: Double, emoji: String, id: Int, tids: [String]? = nil) {
              self.init(snapshot: ["__typename": "QIOSpending_Categories_Item", "name": name, "description": description, "amount": amount, "percentage": percentage, "emoji": emoji, "id": id, "tids": tids])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var name: String {
              get {
                return snapshot["name"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "name")
              }
            }

            public var description: String {
              get {
                return snapshot["description"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "description")
              }
            }

            public var amount: Double {
              get {
                return snapshot["amount"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "amount")
              }
            }

            public var percentage: Double {
              get {
                return snapshot["percentage"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "percentage")
              }
            }

            public var emoji: String {
              get {
                return snapshot["emoji"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "emoji")
              }
            }

            public var id: Int {
              get {
                return snapshot["id"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "id")
              }
            }

            public var tids: [String]? {
              get {
                return snapshot["tids"] as? [String]
              }
              set {
                snapshot.updateValue(newValue, forKey: "tids")
              }
            }
          }
        }

        public struct BasicLivingExpense: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOSpending_BasicLivingExpenses"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("estimatedMonthlyAmount", type: .nonNull(.scalar(Double.self))),
            GraphQLField("summary", type: .nonNull(.list(.nonNull(.object(Summary.selections))))),
            GraphQLField("months", type: .nonNull(.list(.nonNull(.object(Month.selections))))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(estimatedMonthlyAmount: Double, summary: [Summary], months: [Month]) {
            self.init(snapshot: ["__typename": "QIOSpending_BasicLivingExpenses", "estimatedMonthlyAmount": estimatedMonthlyAmount, "summary": summary.map { $0.snapshot }, "months": months.map { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var estimatedMonthlyAmount: Double {
            get {
              return snapshot["estimatedMonthlyAmount"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "estimatedMonthlyAmount")
            }
          }

          public var summary: [Summary] {
            get {
              return (snapshot["summary"] as! [Snapshot]).map { Summary(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "summary")
            }
          }

          public var months: [Month] {
            get {
              return (snapshot["months"] as! [Snapshot]).map { Month(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "months")
            }
          }

          public struct Summary: GraphQLSelectionSet {
            public static let possibleTypes = ["QIOSpending_BasicLivingExpenses_Summary"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("categoryId", type: .nonNull(.scalar(String.self))),
              GraphQLField("average", type: .nonNull(.scalar(Double.self))),
              GraphQLField("friendlyName", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(categoryId: String, average: Double, friendlyName: String, description: String) {
              self.init(snapshot: ["__typename": "QIOSpending_BasicLivingExpenses_Summary", "categoryId": categoryId, "average": average, "friendlyName": friendlyName, "description": description])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var categoryId: String {
              get {
                return snapshot["categoryId"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "categoryId")
              }
            }

            public var average: Double {
              get {
                return snapshot["average"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "average")
              }
            }

            public var friendlyName: String {
              get {
                return snapshot["friendlyName"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "friendlyName")
              }
            }

            public var description: String {
              get {
                return snapshot["description"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "description")
              }
            }
          }

          public struct Month: GraphQLSelectionSet {
            public static let possibleTypes = ["QIOSpending_BasicLivingExpenses_Month"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("monthTotal", type: .nonNull(.scalar(Double.self))),
              GraphQLField("allTids", type: .list(.nonNull(.scalar(String.self)))),
              GraphQLField("monthStr", type: .nonNull(.scalar(String.self))),
              GraphQLField("monthStartDate", type: .nonNull(.scalar(String.self))),
              GraphQLField("monthEndDate", type: .nonNull(.scalar(String.self))),
              GraphQLField("byCategory", type: .list(.nonNull(.object(ByCategory.selections)))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(monthTotal: Double, allTids: [String]? = nil, monthStr: String, monthStartDate: String, monthEndDate: String, byCategory: [ByCategory]? = nil) {
              self.init(snapshot: ["__typename": "QIOSpending_BasicLivingExpenses_Month", "monthTotal": monthTotal, "allTids": allTids, "monthStr": monthStr, "monthStartDate": monthStartDate, "monthEndDate": monthEndDate, "byCategory": byCategory.flatMap { $0.map { $0.snapshot } }])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var monthTotal: Double {
              get {
                return snapshot["monthTotal"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "monthTotal")
              }
            }

            public var allTids: [String]? {
              get {
                return snapshot["allTids"] as? [String]
              }
              set {
                snapshot.updateValue(newValue, forKey: "allTids")
              }
            }

            public var monthStr: String {
              get {
                return snapshot["monthStr"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "monthStr")
              }
            }

            public var monthStartDate: String {
              get {
                return snapshot["monthStartDate"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "monthStartDate")
              }
            }

            public var monthEndDate: String {
              get {
                return snapshot["monthEndDate"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "monthEndDate")
              }
            }

            public var byCategory: [ByCategory]? {
              get {
                return (snapshot["byCategory"] as? [Snapshot]).flatMap { $0.map { ByCategory(snapshot: $0) } }
              }
              set {
                snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "byCategory")
              }
            }

            public struct ByCategory: GraphQLSelectionSet {
              public static let possibleTypes = ["QIOSpending_BasicLivingExpenses_Category"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("categoryId", type: .nonNull(.scalar(String.self))),
                GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("tids", type: .list(.nonNull(.scalar(String.self)))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(categoryId: String, amount: Double, tids: [String]? = nil) {
                self.init(snapshot: ["__typename": "QIOSpending_BasicLivingExpenses_Category", "categoryId": categoryId, "amount": amount, "tids": tids])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var categoryId: String {
                get {
                  return snapshot["categoryId"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "categoryId")
                }
              }

              public var amount: Double {
                get {
                  return snapshot["amount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "amount")
                }
              }

              public var tids: [String]? {
                get {
                  return snapshot["tids"] as? [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "tids")
                }
              }
            }
          }
        }

        public struct Daily: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOSpending_Daily"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("averageAmount", type: .nonNull(.scalar(Double.self))),
            GraphQLField("daysAnalyzed", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(averageAmount: Double, daysAnalyzed: Int) {
            self.init(snapshot: ["__typename": "QIOSpending_Daily", "averageAmount": averageAmount, "daysAnalyzed": daysAnalyzed])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var averageAmount: Double {
            get {
              return snapshot["averageAmount"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "averageAmount")
            }
          }

          public var daysAnalyzed: Int {
            get {
              return snapshot["daysAnalyzed"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "daysAnalyzed")
            }
          }
        }

        public struct Quantized: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOSpending_QuantizedSpendStream"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("isRecurring", type: .nonNull(.scalar(Bool.self))),
            GraphQLField("nameFriendly", type: .nonNull(.scalar(String.self))),
            GraphQLField("nameOriginal", type: .nonNull(.scalar(String.self))),
            GraphQLField("nameSlug", type: .nonNull(.scalar(String.self))),
            GraphQLField("dailyAvg", type: .nonNull(.scalar(Double.self))),
            GraphQLField("pastTwelveMonths", type: .nonNull(.scalar(Double.self))),
            GraphQLField("pastThreeMonths", type: .nonNull(.scalar(Double.self))),
            GraphQLField("twelveMonthTids", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("threeMonthTids", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
            GraphQLField("recurringStream", type: .object(RecurringStream.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(isRecurring: Bool, nameFriendly: String, nameOriginal: String, nameSlug: String, dailyAvg: Double, pastTwelveMonths: Double, pastThreeMonths: Double, twelveMonthTids: [String], threeMonthTids: [String], fioCategoryId: Int, recurringStream: RecurringStream? = nil) {
            self.init(snapshot: ["__typename": "QIOSpending_QuantizedSpendStream", "isRecurring": isRecurring, "nameFriendly": nameFriendly, "nameOriginal": nameOriginal, "nameSlug": nameSlug, "dailyAvg": dailyAvg, "pastTwelveMonths": pastTwelveMonths, "pastThreeMonths": pastThreeMonths, "twelveMonthTids": twelveMonthTids, "threeMonthTids": threeMonthTids, "fioCategoryId": fioCategoryId, "recurringStream": recurringStream.flatMap { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var isRecurring: Bool {
            get {
              return snapshot["isRecurring"]! as! Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "isRecurring")
            }
          }

          public var nameFriendly: String {
            get {
              return snapshot["nameFriendly"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nameFriendly")
            }
          }

          public var nameOriginal: String {
            get {
              return snapshot["nameOriginal"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nameOriginal")
            }
          }

          public var nameSlug: String {
            get {
              return snapshot["nameSlug"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nameSlug")
            }
          }

          public var dailyAvg: Double {
            get {
              return snapshot["dailyAvg"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "dailyAvg")
            }
          }

          public var pastTwelveMonths: Double {
            get {
              return snapshot["pastTwelveMonths"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "pastTwelveMonths")
            }
          }

          public var pastThreeMonths: Double {
            get {
              return snapshot["pastThreeMonths"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "pastThreeMonths")
            }
          }

          public var twelveMonthTids: [String] {
            get {
              return snapshot["twelveMonthTids"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "twelveMonthTids")
            }
          }

          public var threeMonthTids: [String] {
            get {
              return snapshot["threeMonthTids"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "threeMonthTids")
            }
          }

          public var fioCategoryId: Int {
            get {
              return snapshot["fioCategoryId"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "fioCategoryId")
            }
          }

          public var recurringStream: RecurringStream? {
            get {
              return (snapshot["recurringStream"] as? Snapshot).flatMap { RecurringStream(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "recurringStream")
            }
          }

          public struct RecurringStream: GraphQLSelectionSet {
            public static let possibleTypes = ["QIOSpending_QuantizedSpendStream_Recurring"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("periodSize", type: .nonNull(.scalar(String.self))),
              GraphQLField("periodsPerYear", type: .nonNull(.scalar(Int.self))),
              GraphQLField("streamType", type: .nonNull(.scalar(String.self))),
              GraphQLField("amountDistribution", type: .nonNull(.object(AmountDistribution.selections))),
              GraphQLField("dateDistribution", type: .nonNull(.object(DateDistribution.selections))),
              GraphQLField("streamTids", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(periodSize: String, periodsPerYear: Int, streamType: String, amountDistribution: AmountDistribution, dateDistribution: DateDistribution, streamTids: [String]) {
              self.init(snapshot: ["__typename": "QIOSpending_QuantizedSpendStream_Recurring", "periodSize": periodSize, "periodsPerYear": periodsPerYear, "streamType": streamType, "amountDistribution": amountDistribution.snapshot, "dateDistribution": dateDistribution.snapshot, "streamTids": streamTids])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var periodSize: String {
              get {
                return snapshot["periodSize"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "periodSize")
              }
            }

            public var periodsPerYear: Int {
              get {
                return snapshot["periodsPerYear"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "periodsPerYear")
              }
            }

            public var streamType: String {
              get {
                return snapshot["streamType"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "streamType")
              }
            }

            public var amountDistribution: AmountDistribution {
              get {
                return AmountDistribution(snapshot: snapshot["amountDistribution"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "amountDistribution")
              }
            }

            public var dateDistribution: DateDistribution {
              get {
                return DateDistribution(snapshot: snapshot["dateDistribution"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "dateDistribution")
              }
            }

            public var streamTids: [String] {
              get {
                return snapshot["streamTids"]! as! [String]
              }
              set {
                snapshot.updateValue(newValue, forKey: "streamTids")
              }
            }

            public struct AmountDistribution: GraphQLSelectionSet {
              public static let possibleTypes = ["FIORecurringStreamAmountDistribution"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("annualEstimate", type: .nonNull(.scalar(Double.self))),
                GraphQLField("totalAmountEver", type: .nonNull(.scalar(Double.self))),
                GraphQLField("mean", type: .nonNull(.scalar(Double.self))),
                GraphQLField("relativeStandardDeviationPct", type: .nonNull(.scalar(Double.self))),
                GraphQLField("standardDeviation", type: .nonNull(.scalar(Double.self))),
                GraphQLField("dailyEstimate", type: .nonNull(.scalar(Double.self))),
                GraphQLField("monthlyEstimate", type: .nonNull(.scalar(Double.self))),
                GraphQLField("sum", type: .nonNull(.scalar(Double.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(annualEstimate: Double, totalAmountEver: Double, mean: Double, relativeStandardDeviationPct: Double, standardDeviation: Double, dailyEstimate: Double, monthlyEstimate: Double, sum: Double) {
                self.init(snapshot: ["__typename": "FIORecurringStreamAmountDistribution", "annualEstimate": annualEstimate, "totalAmountEver": totalAmountEver, "mean": mean, "relativeStandardDeviationPct": relativeStandardDeviationPct, "standardDeviation": standardDeviation, "dailyEstimate": dailyEstimate, "monthlyEstimate": monthlyEstimate, "sum": sum])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var annualEstimate: Double {
                get {
                  return snapshot["annualEstimate"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "annualEstimate")
                }
              }

              public var totalAmountEver: Double {
                get {
                  return snapshot["totalAmountEver"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmountEver")
                }
              }

              public var mean: Double {
                get {
                  return snapshot["mean"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "mean")
                }
              }

              public var relativeStandardDeviationPct: Double {
                get {
                  return snapshot["relativeStandardDeviationPct"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "relativeStandardDeviationPct")
                }
              }

              public var standardDeviation: Double {
                get {
                  return snapshot["standardDeviation"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "standardDeviation")
                }
              }

              public var dailyEstimate: Double {
                get {
                  return snapshot["dailyEstimate"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "dailyEstimate")
                }
              }

              public var monthlyEstimate: Double {
                get {
                  return snapshot["monthlyEstimate"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "monthlyEstimate")
                }
              }

              public var sum: Double {
                get {
                  return snapshot["sum"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "sum")
                }
              }
            }

            public struct DateDistribution: GraphQLSelectionSet {
              public static let possibleTypes = ["FIORecurringStreamDateDistribution"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("avgDiffDays", type: .nonNull(.scalar(Double.self))),
                GraphQLField("daysUntilNext", type: .nonNull(.scalar(Int.self))),
                GraphQLField("duration", type: .nonNull(.scalar(Int.self))),
                GraphQLField("firstDate", type: .nonNull(.scalar(String.self))),
                GraphQLField("firstDaysAgo", type: .nonNull(.scalar(Int.self))),
                GraphQLField("lastDate", type: .nonNull(.scalar(String.self))),
                GraphQLField("lastDaysAgo", type: .nonNull(.scalar(Int.self))),
                GraphQLField("relativeStandardDeviationPct", type: .nonNull(.scalar(Double.self))),
                GraphQLField("standardDeviation", type: .nonNull(.scalar(Double.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(avgDiffDays: Double, daysUntilNext: Int, duration: Int, firstDate: String, firstDaysAgo: Int, lastDate: String, lastDaysAgo: Int, relativeStandardDeviationPct: Double, standardDeviation: Double) {
                self.init(snapshot: ["__typename": "FIORecurringStreamDateDistribution", "avgDiffDays": avgDiffDays, "daysUntilNext": daysUntilNext, "duration": duration, "firstDate": firstDate, "firstDaysAgo": firstDaysAgo, "lastDate": lastDate, "lastDaysAgo": lastDaysAgo, "relativeStandardDeviationPct": relativeStandardDeviationPct, "standardDeviation": standardDeviation])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var avgDiffDays: Double {
                get {
                  return snapshot["avgDiffDays"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "avgDiffDays")
                }
              }

              public var daysUntilNext: Int {
                get {
                  return snapshot["daysUntilNext"]! as! Int
                }
                set {
                  snapshot.updateValue(newValue, forKey: "daysUntilNext")
                }
              }

              public var duration: Int {
                get {
                  return snapshot["duration"]! as! Int
                }
                set {
                  snapshot.updateValue(newValue, forKey: "duration")
                }
              }

              public var firstDate: String {
                get {
                  return snapshot["firstDate"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "firstDate")
                }
              }

              public var firstDaysAgo: Int {
                get {
                  return snapshot["firstDaysAgo"]! as! Int
                }
                set {
                  snapshot.updateValue(newValue, forKey: "firstDaysAgo")
                }
              }

              public var lastDate: String {
                get {
                  return snapshot["lastDate"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "lastDate")
                }
              }

              public var lastDaysAgo: Int {
                get {
                  return snapshot["lastDaysAgo"]! as! Int
                }
                set {
                  snapshot.updateValue(newValue, forKey: "lastDaysAgo")
                }
              }

              public var relativeStandardDeviationPct: Double {
                get {
                  return snapshot["relativeStandardDeviationPct"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "relativeStandardDeviationPct")
                }
              }

              public var standardDeviation: Double {
                get {
                  return snapshot["standardDeviation"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "standardDeviation")
                }
              }
            }
          }
        }
      }

      public struct MoneyRental: GraphQLSelectionSet {
        public static let possibleTypes = ["QIOMoneyRental"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("creditCards", type: .object(CreditCard.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(creditCards: CreditCard? = nil) {
          self.init(snapshot: ["__typename": "QIOMoneyRental", "creditCards": creditCards.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var creditCards: CreditCard? {
          get {
            return (snapshot["creditCards"] as? Snapshot).flatMap { CreditCard(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "creditCards")
          }
        }

        public struct CreditCard: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOMoneyRental_CreditCards"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("accountMaids", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("costOfOneDollar", type: .nonNull(.scalar(Double.self))),
            GraphQLField("daysAnalyzed", type: .nonNull(.scalar(Int.self))),
            GraphQLField("rent", type: .nonNull(.object(Rent.selections))),
            GraphQLField("balance", type: .nonNull(.object(Balance.selections))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(accountMaids: [String], costOfOneDollar: Double, daysAnalyzed: Int, rent: Rent, balance: Balance) {
            self.init(snapshot: ["__typename": "QIOMoneyRental_CreditCards", "accountMaids": accountMaids, "costOfOneDollar": costOfOneDollar, "daysAnalyzed": daysAnalyzed, "rent": rent.snapshot, "balance": balance.snapshot])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var accountMaids: [String] {
            get {
              return snapshot["accountMaids"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "accountMaids")
            }
          }

          public var costOfOneDollar: Double {
            get {
              return snapshot["costOfOneDollar"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "costOfOneDollar")
            }
          }

          public var daysAnalyzed: Int {
            get {
              return snapshot["daysAnalyzed"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "daysAnalyzed")
            }
          }

          public var rent: Rent {
            get {
              return Rent(snapshot: snapshot["rent"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "rent")
            }
          }

          public var balance: Balance {
            get {
              return Balance(snapshot: snapshot["balance"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "balance")
            }
          }

          public struct Rent: GraphQLSelectionSet {
            public static let possibleTypes = ["QIOMoneyRental_CreditCards_Rent"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("averagePerDay", type: .nonNull(.scalar(Double.self))),
              GraphQLField("dailyPeriodicRate", type: .nonNull(.scalar(Double.self))),
              GraphQLField("daysAnalyzed", type: .nonNull(.scalar(Int.self))),
              GraphQLField("percentOfDailyNet", type: .nonNull(.scalar(Double.self))),
              GraphQLField("totalInAnalysisPeriod", type: .nonNull(.scalar(Double.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(averagePerDay: Double, dailyPeriodicRate: Double, daysAnalyzed: Int, percentOfDailyNet: Double, totalInAnalysisPeriod: Double) {
              self.init(snapshot: ["__typename": "QIOMoneyRental_CreditCards_Rent", "averagePerDay": averagePerDay, "dailyPeriodicRate": dailyPeriodicRate, "daysAnalyzed": daysAnalyzed, "percentOfDailyNet": percentOfDailyNet, "totalInAnalysisPeriod": totalInAnalysisPeriod])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var averagePerDay: Double {
              get {
                return snapshot["averagePerDay"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "averagePerDay")
              }
            }

            public var dailyPeriodicRate: Double {
              get {
                return snapshot["dailyPeriodicRate"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "dailyPeriodicRate")
              }
            }

            public var daysAnalyzed: Int {
              get {
                return snapshot["daysAnalyzed"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "daysAnalyzed")
              }
            }

            public var percentOfDailyNet: Double {
              get {
                return snapshot["percentOfDailyNet"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "percentOfDailyNet")
              }
            }

            public var totalInAnalysisPeriod: Double {
              get {
                return snapshot["totalInAnalysisPeriod"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "totalInAnalysisPeriod")
              }
            }
          }

          public struct Balance: GraphQLSelectionSet {
            public static let possibleTypes = ["QIOMoneyRental_CreditCards_Balances"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("current", type: .nonNull(.object(Current.selections))),
              GraphQLField("historical", type: .nonNull(.object(Historical.selections))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(current: Current, historical: Historical) {
              self.init(snapshot: ["__typename": "QIOMoneyRental_CreditCards_Balances", "current": current.snapshot, "historical": historical.snapshot])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var current: Current {
              get {
                return Current(snapshot: snapshot["current"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "current")
              }
            }

            public var historical: Historical {
              get {
                return Historical(snapshot: snapshot["historical"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "historical")
              }
            }

            public struct Current: GraphQLSelectionSet {
              public static let possibleTypes = ["QIOMoneyRental_CreditCards_Balances_Current"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("total", type: .nonNull(.scalar(Double.self))),
                GraphQLField("totalSubjectToLimit", type: .nonNull(.scalar(Double.self))),
                GraphQLField("totalLimit", type: .nonNull(.scalar(Double.self))),
                GraphQLField("totalEffectiveBalance", type: .nonNull(.scalar(Double.self))),
                GraphQLField("utilizationPercentage", type: .nonNull(.scalar(Double.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(total: Double, totalSubjectToLimit: Double, totalLimit: Double, totalEffectiveBalance: Double, utilizationPercentage: Double) {
                self.init(snapshot: ["__typename": "QIOMoneyRental_CreditCards_Balances_Current", "total": total, "totalSubjectToLimit": totalSubjectToLimit, "totalLimit": totalLimit, "totalEffectiveBalance": totalEffectiveBalance, "utilizationPercentage": utilizationPercentage])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var total: Double {
                get {
                  return snapshot["total"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "total")
                }
              }

              public var totalSubjectToLimit: Double {
                get {
                  return snapshot["totalSubjectToLimit"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalSubjectToLimit")
                }
              }

              public var totalLimit: Double {
                get {
                  return snapshot["totalLimit"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalLimit")
                }
              }

              public var totalEffectiveBalance: Double {
                get {
                  return snapshot["totalEffectiveBalance"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalEffectiveBalance")
                }
              }

              public var utilizationPercentage: Double {
                get {
                  return snapshot["utilizationPercentage"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "utilizationPercentage")
                }
              }
            }

            public struct Historical: GraphQLSelectionSet {
              public static let possibleTypes = ["QIOMoneyRental_CreditCards_Balances_Historical"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("daysAnalyzed", type: .nonNull(.scalar(Int.self))),
                GraphQLField("avgBalance", type: .nonNull(.scalar(Double.self))),
                GraphQLField("avgMMCarryOver", type: .nonNull(.scalar(Double.self))),
                GraphQLField("MMCarryOvers", type: .nonNull(.list(.nonNull(.scalar(Double.self))))),
                GraphQLField("dates", type: .nonNull(.list(.nonNull(.object(Date.selections))))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(daysAnalyzed: Int, avgBalance: Double, avgMmCarryOver: Double, mmCarryOvers: [Double], dates: [Date]) {
                self.init(snapshot: ["__typename": "QIOMoneyRental_CreditCards_Balances_Historical", "daysAnalyzed": daysAnalyzed, "avgBalance": avgBalance, "avgMMCarryOver": avgMmCarryOver, "MMCarryOvers": mmCarryOvers, "dates": dates.map { $0.snapshot }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var daysAnalyzed: Int {
                get {
                  return snapshot["daysAnalyzed"]! as! Int
                }
                set {
                  snapshot.updateValue(newValue, forKey: "daysAnalyzed")
                }
              }

              public var avgBalance: Double {
                get {
                  return snapshot["avgBalance"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "avgBalance")
                }
              }

              public var avgMmCarryOver: Double {
                get {
                  return snapshot["avgMMCarryOver"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "avgMMCarryOver")
                }
              }

              public var mmCarryOvers: [Double] {
                get {
                  return snapshot["MMCarryOvers"]! as! [Double]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "MMCarryOvers")
                }
              }

              public var dates: [Date] {
                get {
                  return (snapshot["dates"] as! [Snapshot]).map { Date(snapshot: $0) }
                }
                set {
                  snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "dates")
                }
              }

              public struct Date: GraphQLSelectionSet {
                public static let possibleTypes = ["QIOMoneyRental_CreditCards_Balances_Historical_Date"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("date", type: .nonNull(.scalar(String.self))),
                  GraphQLField("balance", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("utilization", type: .nonNull(.scalar(Double.self))),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(date: String, balance: Double, utilization: Double) {
                  self.init(snapshot: ["__typename": "QIOMoneyRental_CreditCards_Balances_Historical_Date", "date": date, "balance": balance, "utilization": utilization])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var date: String {
                  get {
                    return snapshot["date"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "date")
                  }
                }

                public var balance: Double {
                  get {
                    return snapshot["balance"]! as! Double
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "balance")
                  }
                }

                public var utilization: Double {
                  get {
                    return snapshot["utilization"]! as! Double
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "utilization")
                  }
                }
              }
            }
          }
        }
      }

      public struct Income: GraphQLSelectionSet {
        public static let possibleTypes = ["QIOIncome"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("summary", type: .nonNull(.object(Summary.selections))),
          GraphQLField("activeStreams", type: .list(.nonNull(.object(ActiveStream.selections)))),
          GraphQLField("inactiveStreams", type: .list(.nonNull(.object(InactiveStream.selections)))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(summary: Summary, activeStreams: [ActiveStream]? = nil, inactiveStreams: [InactiveStream]? = nil) {
          self.init(snapshot: ["__typename": "QIOIncome", "summary": summary.snapshot, "activeStreams": activeStreams.flatMap { $0.map { $0.snapshot } }, "inactiveStreams": inactiveStreams.flatMap { $0.map { $0.snapshot } }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var summary: Summary {
          get {
            return Summary(snapshot: snapshot["summary"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "summary")
          }
        }

        public var activeStreams: [ActiveStream]? {
          get {
            return (snapshot["activeStreams"] as? [Snapshot]).flatMap { $0.map { ActiveStream(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "activeStreams")
          }
        }

        public var inactiveStreams: [InactiveStream]? {
          get {
            return (snapshot["inactiveStreams"] as? [Snapshot]).flatMap { $0.map { InactiveStream(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "inactiveStreams")
          }
        }

        public struct Summary: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOIncome_Summary"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("activeDailyEstimate", type: .nonNull(.scalar(Double.self))),
            GraphQLField("analyzedDepositCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("analyzedAccountMaids", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("oldestActiveStreamStartDate", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(activeDailyEstimate: Double, analyzedDepositCount: Int, analyzedAccountMaids: [String], oldestActiveStreamStartDate: String? = nil) {
            self.init(snapshot: ["__typename": "QIOIncome_Summary", "activeDailyEstimate": activeDailyEstimate, "analyzedDepositCount": analyzedDepositCount, "analyzedAccountMaids": analyzedAccountMaids, "oldestActiveStreamStartDate": oldestActiveStreamStartDate])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var activeDailyEstimate: Double {
            get {
              return snapshot["activeDailyEstimate"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "activeDailyEstimate")
            }
          }

          public var analyzedDepositCount: Int {
            get {
              return snapshot["analyzedDepositCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "analyzedDepositCount")
            }
          }

          public var analyzedAccountMaids: [String] {
            get {
              return snapshot["analyzedAccountMaids"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "analyzedAccountMaids")
            }
          }

          public var oldestActiveStreamStartDate: String? {
            get {
              return snapshot["oldestActiveStreamStartDate"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "oldestActiveStreamStartDate")
            }
          }
        }

        public struct ActiveStream: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOIncome_Stream"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("streamType", type: .nonNull(.scalar(String.self))),
            GraphQLField("periodSize", type: .nonNull(.scalar(String.self))),
            GraphQLField("identifiedIn", type: .nonNull(.scalar(String.self))),
            GraphQLField("slug", type: .nonNull(.scalar(String.self))),
            GraphQLField("nameFriendly", type: .nonNull(.scalar(String.self))),
            GraphQLField("tids", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("amountDistribution", type: .nonNull(.object(AmountDistribution.selections))),
            GraphQLField("dateDistribution", type: .nonNull(.object(DateDistribution.selections))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(streamType: String, periodSize: String, identifiedIn: String, slug: String, nameFriendly: String, tids: [String], amountDistribution: AmountDistribution, dateDistribution: DateDistribution) {
            self.init(snapshot: ["__typename": "QIOIncome_Stream", "streamType": streamType, "periodSize": periodSize, "identifiedIn": identifiedIn, "slug": slug, "nameFriendly": nameFriendly, "tids": tids, "amountDistribution": amountDistribution.snapshot, "dateDistribution": dateDistribution.snapshot])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var streamType: String {
            get {
              return snapshot["streamType"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "streamType")
            }
          }

          public var periodSize: String {
            get {
              return snapshot["periodSize"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "periodSize")
            }
          }

          public var identifiedIn: String {
            get {
              return snapshot["identifiedIn"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "identifiedIn")
            }
          }

          public var slug: String {
            get {
              return snapshot["slug"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "slug")
            }
          }

          public var nameFriendly: String {
            get {
              return snapshot["nameFriendly"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nameFriendly")
            }
          }

          public var tids: [String] {
            get {
              return snapshot["tids"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "tids")
            }
          }

          public var amountDistribution: AmountDistribution {
            get {
              return AmountDistribution(snapshot: snapshot["amountDistribution"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "amountDistribution")
            }
          }

          public var dateDistribution: DateDistribution {
            get {
              return DateDistribution(snapshot: snapshot["dateDistribution"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "dateDistribution")
            }
          }

          public struct AmountDistribution: GraphQLSelectionSet {
            public static let possibleTypes = ["FIORecurringStreamAmountDistribution"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("annualEstimate", type: .nonNull(.scalar(Double.self))),
              GraphQLField("totalAmountEver", type: .nonNull(.scalar(Double.self))),
              GraphQLField("mean", type: .nonNull(.scalar(Double.self))),
              GraphQLField("relativeStandardDeviationPct", type: .nonNull(.scalar(Double.self))),
              GraphQLField("standardDeviation", type: .nonNull(.scalar(Double.self))),
              GraphQLField("dailyEstimate", type: .nonNull(.scalar(Double.self))),
              GraphQLField("monthlyEstimate", type: .nonNull(.scalar(Double.self))),
              GraphQLField("sum", type: .nonNull(.scalar(Double.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(annualEstimate: Double, totalAmountEver: Double, mean: Double, relativeStandardDeviationPct: Double, standardDeviation: Double, dailyEstimate: Double, monthlyEstimate: Double, sum: Double) {
              self.init(snapshot: ["__typename": "FIORecurringStreamAmountDistribution", "annualEstimate": annualEstimate, "totalAmountEver": totalAmountEver, "mean": mean, "relativeStandardDeviationPct": relativeStandardDeviationPct, "standardDeviation": standardDeviation, "dailyEstimate": dailyEstimate, "monthlyEstimate": monthlyEstimate, "sum": sum])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var annualEstimate: Double {
              get {
                return snapshot["annualEstimate"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "annualEstimate")
              }
            }

            public var totalAmountEver: Double {
              get {
                return snapshot["totalAmountEver"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "totalAmountEver")
              }
            }

            public var mean: Double {
              get {
                return snapshot["mean"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "mean")
              }
            }

            public var relativeStandardDeviationPct: Double {
              get {
                return snapshot["relativeStandardDeviationPct"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "relativeStandardDeviationPct")
              }
            }

            public var standardDeviation: Double {
              get {
                return snapshot["standardDeviation"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "standardDeviation")
              }
            }

            public var dailyEstimate: Double {
              get {
                return snapshot["dailyEstimate"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "dailyEstimate")
              }
            }

            public var monthlyEstimate: Double {
              get {
                return snapshot["monthlyEstimate"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "monthlyEstimate")
              }
            }

            public var sum: Double {
              get {
                return snapshot["sum"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "sum")
              }
            }
          }

          public struct DateDistribution: GraphQLSelectionSet {
            public static let possibleTypes = ["FIORecurringStreamDateDistribution"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("avgDiffDays", type: .nonNull(.scalar(Double.self))),
              GraphQLField("daysUntilNext", type: .nonNull(.scalar(Int.self))),
              GraphQLField("duration", type: .nonNull(.scalar(Int.self))),
              GraphQLField("firstDate", type: .nonNull(.scalar(String.self))),
              GraphQLField("firstDaysAgo", type: .nonNull(.scalar(Int.self))),
              GraphQLField("lastDate", type: .nonNull(.scalar(String.self))),
              GraphQLField("lastDaysAgo", type: .nonNull(.scalar(Int.self))),
              GraphQLField("relativeStandardDeviationPct", type: .nonNull(.scalar(Double.self))),
              GraphQLField("standardDeviation", type: .nonNull(.scalar(Double.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(avgDiffDays: Double, daysUntilNext: Int, duration: Int, firstDate: String, firstDaysAgo: Int, lastDate: String, lastDaysAgo: Int, relativeStandardDeviationPct: Double, standardDeviation: Double) {
              self.init(snapshot: ["__typename": "FIORecurringStreamDateDistribution", "avgDiffDays": avgDiffDays, "daysUntilNext": daysUntilNext, "duration": duration, "firstDate": firstDate, "firstDaysAgo": firstDaysAgo, "lastDate": lastDate, "lastDaysAgo": lastDaysAgo, "relativeStandardDeviationPct": relativeStandardDeviationPct, "standardDeviation": standardDeviation])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var avgDiffDays: Double {
              get {
                return snapshot["avgDiffDays"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "avgDiffDays")
              }
            }

            public var daysUntilNext: Int {
              get {
                return snapshot["daysUntilNext"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "daysUntilNext")
              }
            }

            public var duration: Int {
              get {
                return snapshot["duration"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "duration")
              }
            }

            public var firstDate: String {
              get {
                return snapshot["firstDate"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "firstDate")
              }
            }

            public var firstDaysAgo: Int {
              get {
                return snapshot["firstDaysAgo"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "firstDaysAgo")
              }
            }

            public var lastDate: String {
              get {
                return snapshot["lastDate"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "lastDate")
              }
            }

            public var lastDaysAgo: Int {
              get {
                return snapshot["lastDaysAgo"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "lastDaysAgo")
              }
            }

            public var relativeStandardDeviationPct: Double {
              get {
                return snapshot["relativeStandardDeviationPct"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "relativeStandardDeviationPct")
              }
            }

            public var standardDeviation: Double {
              get {
                return snapshot["standardDeviation"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "standardDeviation")
              }
            }
          }
        }

        public struct InactiveStream: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOIncome_Stream"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("streamType", type: .nonNull(.scalar(String.self))),
            GraphQLField("periodSize", type: .nonNull(.scalar(String.self))),
            GraphQLField("identifiedIn", type: .nonNull(.scalar(String.self))),
            GraphQLField("slug", type: .nonNull(.scalar(String.self))),
            GraphQLField("nameFriendly", type: .nonNull(.scalar(String.self))),
            GraphQLField("tids", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
            GraphQLField("amountDistribution", type: .nonNull(.object(AmountDistribution.selections))),
            GraphQLField("dateDistribution", type: .nonNull(.object(DateDistribution.selections))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(streamType: String, periodSize: String, identifiedIn: String, slug: String, nameFriendly: String, tids: [String], amountDistribution: AmountDistribution, dateDistribution: DateDistribution) {
            self.init(snapshot: ["__typename": "QIOIncome_Stream", "streamType": streamType, "periodSize": periodSize, "identifiedIn": identifiedIn, "slug": slug, "nameFriendly": nameFriendly, "tids": tids, "amountDistribution": amountDistribution.snapshot, "dateDistribution": dateDistribution.snapshot])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var streamType: String {
            get {
              return snapshot["streamType"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "streamType")
            }
          }

          public var periodSize: String {
            get {
              return snapshot["periodSize"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "periodSize")
            }
          }

          public var identifiedIn: String {
            get {
              return snapshot["identifiedIn"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "identifiedIn")
            }
          }

          public var slug: String {
            get {
              return snapshot["slug"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "slug")
            }
          }

          public var nameFriendly: String {
            get {
              return snapshot["nameFriendly"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nameFriendly")
            }
          }

          public var tids: [String] {
            get {
              return snapshot["tids"]! as! [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "tids")
            }
          }

          public var amountDistribution: AmountDistribution {
            get {
              return AmountDistribution(snapshot: snapshot["amountDistribution"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "amountDistribution")
            }
          }

          public var dateDistribution: DateDistribution {
            get {
              return DateDistribution(snapshot: snapshot["dateDistribution"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "dateDistribution")
            }
          }

          public struct AmountDistribution: GraphQLSelectionSet {
            public static let possibleTypes = ["FIORecurringStreamAmountDistribution"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("annualEstimate", type: .nonNull(.scalar(Double.self))),
              GraphQLField("totalAmountEver", type: .nonNull(.scalar(Double.self))),
              GraphQLField("mean", type: .nonNull(.scalar(Double.self))),
              GraphQLField("relativeStandardDeviationPct", type: .nonNull(.scalar(Double.self))),
              GraphQLField("standardDeviation", type: .nonNull(.scalar(Double.self))),
              GraphQLField("dailyEstimate", type: .nonNull(.scalar(Double.self))),
              GraphQLField("monthlyEstimate", type: .nonNull(.scalar(Double.self))),
              GraphQLField("sum", type: .nonNull(.scalar(Double.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(annualEstimate: Double, totalAmountEver: Double, mean: Double, relativeStandardDeviationPct: Double, standardDeviation: Double, dailyEstimate: Double, monthlyEstimate: Double, sum: Double) {
              self.init(snapshot: ["__typename": "FIORecurringStreamAmountDistribution", "annualEstimate": annualEstimate, "totalAmountEver": totalAmountEver, "mean": mean, "relativeStandardDeviationPct": relativeStandardDeviationPct, "standardDeviation": standardDeviation, "dailyEstimate": dailyEstimate, "monthlyEstimate": monthlyEstimate, "sum": sum])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var annualEstimate: Double {
              get {
                return snapshot["annualEstimate"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "annualEstimate")
              }
            }

            public var totalAmountEver: Double {
              get {
                return snapshot["totalAmountEver"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "totalAmountEver")
              }
            }

            public var mean: Double {
              get {
                return snapshot["mean"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "mean")
              }
            }

            public var relativeStandardDeviationPct: Double {
              get {
                return snapshot["relativeStandardDeviationPct"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "relativeStandardDeviationPct")
              }
            }

            public var standardDeviation: Double {
              get {
                return snapshot["standardDeviation"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "standardDeviation")
              }
            }

            public var dailyEstimate: Double {
              get {
                return snapshot["dailyEstimate"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "dailyEstimate")
              }
            }

            public var monthlyEstimate: Double {
              get {
                return snapshot["monthlyEstimate"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "monthlyEstimate")
              }
            }

            public var sum: Double {
              get {
                return snapshot["sum"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "sum")
              }
            }
          }

          public struct DateDistribution: GraphQLSelectionSet {
            public static let possibleTypes = ["FIORecurringStreamDateDistribution"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("avgDiffDays", type: .nonNull(.scalar(Double.self))),
              GraphQLField("daysUntilNext", type: .nonNull(.scalar(Int.self))),
              GraphQLField("duration", type: .nonNull(.scalar(Int.self))),
              GraphQLField("firstDate", type: .nonNull(.scalar(String.self))),
              GraphQLField("firstDaysAgo", type: .nonNull(.scalar(Int.self))),
              GraphQLField("lastDate", type: .nonNull(.scalar(String.self))),
              GraphQLField("lastDaysAgo", type: .nonNull(.scalar(Int.self))),
              GraphQLField("relativeStandardDeviationPct", type: .nonNull(.scalar(Double.self))),
              GraphQLField("standardDeviation", type: .nonNull(.scalar(Double.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(avgDiffDays: Double, daysUntilNext: Int, duration: Int, firstDate: String, firstDaysAgo: Int, lastDate: String, lastDaysAgo: Int, relativeStandardDeviationPct: Double, standardDeviation: Double) {
              self.init(snapshot: ["__typename": "FIORecurringStreamDateDistribution", "avgDiffDays": avgDiffDays, "daysUntilNext": daysUntilNext, "duration": duration, "firstDate": firstDate, "firstDaysAgo": firstDaysAgo, "lastDate": lastDate, "lastDaysAgo": lastDaysAgo, "relativeStandardDeviationPct": relativeStandardDeviationPct, "standardDeviation": standardDeviation])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var avgDiffDays: Double {
              get {
                return snapshot["avgDiffDays"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "avgDiffDays")
              }
            }

            public var daysUntilNext: Int {
              get {
                return snapshot["daysUntilNext"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "daysUntilNext")
              }
            }

            public var duration: Int {
              get {
                return snapshot["duration"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "duration")
              }
            }

            public var firstDate: String {
              get {
                return snapshot["firstDate"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "firstDate")
              }
            }

            public var firstDaysAgo: Int {
              get {
                return snapshot["firstDaysAgo"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "firstDaysAgo")
              }
            }

            public var lastDate: String {
              get {
                return snapshot["lastDate"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "lastDate")
              }
            }

            public var lastDaysAgo: Int {
              get {
                return snapshot["lastDaysAgo"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "lastDaysAgo")
              }
            }

            public var relativeStandardDeviationPct: Double {
              get {
                return snapshot["relativeStandardDeviationPct"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "relativeStandardDeviationPct")
              }
            }

            public var standardDeviation: Double {
              get {
                return snapshot["standardDeviation"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "standardDeviation")
              }
            }
          }
        }
      }

      public struct FinancialIndependence: GraphQLSelectionSet {
        public static let possibleTypes = ["QIOFinancialIndependence"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("totalCapital", type: .scalar(Double.self)),
          GraphQLField("safeWithdrawal", type: .scalar(Double.self)),
          GraphQLField("liquidCushion", type: .object(LiquidCushion.selections)),
          GraphQLField("savingsRate", type: .object(SavingsRate.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(totalCapital: Double? = nil, safeWithdrawal: Double? = nil, liquidCushion: LiquidCushion? = nil, savingsRate: SavingsRate? = nil) {
          self.init(snapshot: ["__typename": "QIOFinancialIndependence", "totalCapital": totalCapital, "safeWithdrawal": safeWithdrawal, "liquidCushion": liquidCushion.flatMap { $0.snapshot }, "savingsRate": savingsRate.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var totalCapital: Double? {
          get {
            return snapshot["totalCapital"] as? Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "totalCapital")
          }
        }

        public var safeWithdrawal: Double? {
          get {
            return snapshot["safeWithdrawal"] as? Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "safeWithdrawal")
          }
        }

        public var liquidCushion: LiquidCushion? {
          get {
            return (snapshot["liquidCushion"] as? Snapshot).flatMap { LiquidCushion(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "liquidCushion")
          }
        }

        public var savingsRate: SavingsRate? {
          get {
            return (snapshot["savingsRate"] as? Snapshot).flatMap { SavingsRate(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "savingsRate")
          }
        }

        public struct LiquidCushion: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOFinancialIndependence_LiquidCushion"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("current", type: .object(Current.selections)),
            GraphQLField("historical", type: .object(Historical.selections)),
            GraphQLField("accountMaids", type: .list(.nonNull(.scalar(String.self)))),
            GraphQLField("consts", type: .object(Const.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(current: Current? = nil, historical: Historical? = nil, accountMaids: [String]? = nil, consts: Const? = nil) {
            self.init(snapshot: ["__typename": "QIOFinancialIndependence_LiquidCushion", "current": current.flatMap { $0.snapshot }, "historical": historical.flatMap { $0.snapshot }, "accountMaids": accountMaids, "consts": consts.flatMap { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var current: Current? {
            get {
              return (snapshot["current"] as? Snapshot).flatMap { Current(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "current")
            }
          }

          public var historical: Historical? {
            get {
              return (snapshot["historical"] as? Snapshot).flatMap { Historical(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "historical")
            }
          }

          public var accountMaids: [String]? {
            get {
              return snapshot["accountMaids"] as? [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "accountMaids")
            }
          }

          public var consts: Const? {
            get {
              return (snapshot["consts"] as? Snapshot).flatMap { Const(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "consts")
            }
          }

          public struct Current: GraphQLSelectionSet {
            public static let possibleTypes = ["QIOFinancialIndependence_LiquidCushion_Current"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("balance", type: .nonNull(.scalar(Double.self))),
              GraphQLField("months", type: .nonNull(.scalar(Double.self))),
              GraphQLField("monthsAsPercentage", type: .nonNull(.scalar(Double.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(balance: Double, months: Double, monthsAsPercentage: Double) {
              self.init(snapshot: ["__typename": "QIOFinancialIndependence_LiquidCushion_Current", "balance": balance, "months": months, "monthsAsPercentage": monthsAsPercentage])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var balance: Double {
              get {
                return snapshot["balance"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "balance")
              }
            }

            public var months: Double {
              get {
                return snapshot["months"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "months")
              }
            }

            public var monthsAsPercentage: Double {
              get {
                return snapshot["monthsAsPercentage"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "monthsAsPercentage")
              }
            }
          }

          public struct Historical: GraphQLSelectionSet {
            public static let possibleTypes = ["QIOFinancialIndependence_LiquidCushion_Historical"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("months", type: .list(.nonNull(.object(Month.selections)))),
              GraphQLField("dates", type: .list(.nonNull(.object(Date.selections)))),
              GraphQLField("averageBalance", type: .nonNull(.scalar(Double.self))),
              GraphQLField("daysAnalyzed", type: .nonNull(.scalar(Int.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(months: [Month]? = nil, dates: [Date]? = nil, averageBalance: Double, daysAnalyzed: Int) {
              self.init(snapshot: ["__typename": "QIOFinancialIndependence_LiquidCushion_Historical", "months": months.flatMap { $0.map { $0.snapshot } }, "dates": dates.flatMap { $0.map { $0.snapshot } }, "averageBalance": averageBalance, "daysAnalyzed": daysAnalyzed])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var months: [Month]? {
              get {
                return (snapshot["months"] as? [Snapshot]).flatMap { $0.map { Month(snapshot: $0) } }
              }
              set {
                snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "months")
              }
            }

            public var dates: [Date]? {
              get {
                return (snapshot["dates"] as? [Snapshot]).flatMap { $0.map { Date(snapshot: $0) } }
              }
              set {
                snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "dates")
              }
            }

            public var averageBalance: Double {
              get {
                return snapshot["averageBalance"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "averageBalance")
              }
            }

            public var daysAnalyzed: Int {
              get {
                return snapshot["daysAnalyzed"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "daysAnalyzed")
              }
            }

            public struct Month: GraphQLSelectionSet {
              public static let possibleTypes = ["QIOFinancialIndependence_LiquidCushion_Historical_Month"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("month", type: .nonNull(.scalar(String.self))),
                GraphQLField("bufferAtStartOfMonth", type: .nonNull(.scalar(Double.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(month: String, bufferAtStartOfMonth: Double) {
                self.init(snapshot: ["__typename": "QIOFinancialIndependence_LiquidCushion_Historical_Month", "month": month, "bufferAtStartOfMonth": bufferAtStartOfMonth])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var month: String {
                get {
                  return snapshot["month"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "month")
                }
              }

              public var bufferAtStartOfMonth: Double {
                get {
                  return snapshot["bufferAtStartOfMonth"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "bufferAtStartOfMonth")
                }
              }
            }

            public struct Date: GraphQLSelectionSet {
              public static let possibleTypes = ["QIOFinancialIndependence_LiquidCushion_Historical_Date"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("date", type: .nonNull(.scalar(String.self))),
                GraphQLField("balance", type: .nonNull(.scalar(Double.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(date: String, balance: Double) {
                self.init(snapshot: ["__typename": "QIOFinancialIndependence_LiquidCushion_Historical_Date", "date": date, "balance": balance])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var date: String {
                get {
                  return snapshot["date"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "date")
                }
              }

              public var balance: Double {
                get {
                  return snapshot["balance"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "balance")
                }
              }
            }
          }

          public struct Const: GraphQLSelectionSet {
            public static let possibleTypes = ["QIOFinancialIndependence_LiquidCushion_Consts"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("targetSafetyMonths", type: .nonNull(.scalar(Double.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(targetSafetyMonths: Double) {
              self.init(snapshot: ["__typename": "QIOFinancialIndependence_LiquidCushion_Consts", "targetSafetyMonths": targetSafetyMonths])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var targetSafetyMonths: Double {
              get {
                return snapshot["targetSafetyMonths"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "targetSafetyMonths")
              }
            }
          }
        }

        public struct SavingsRate: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOFinancialIndependence_SavingsRate"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("income_90d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("income_365d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("net_365d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("net_90d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("dateStr_90d", type: .nonNull(.scalar(String.self))),
            GraphQLField("dateStr_365d", type: .nonNull(.scalar(String.self))),
            GraphQLField("actualSavingsRate_90d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("actualSavingsRate_365d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("potentialSavingsRate_90d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("potentialSavingsRate_365d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("depositsSum_90d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("depositsSum_365d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("withdrawalsSum_90d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("withdrawalsSum_365d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("netLongtermMoney_90d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("netLongtermMoney_365d", type: .nonNull(.scalar(Double.self))),
            GraphQLField("depositTids", type: .list(.nonNull(.scalar(String.self)))),
            GraphQLField("withdrawalTids", type: .list(.nonNull(.scalar(String.self)))),
            GraphQLField("netsFor365d", type: .list(.nonNull(.scalar(Double.self)))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(income_90d: Double, income_365d: Double, net_365d: Double, net_90d: Double, dateStr_90d: String, dateStr_365d: String, actualSavingsRate_90d: Double, actualSavingsRate_365d: Double, potentialSavingsRate_90d: Double, potentialSavingsRate_365d: Double, depositsSum_90d: Double, depositsSum_365d: Double, withdrawalsSum_90d: Double, withdrawalsSum_365d: Double, netLongtermMoney_90d: Double, netLongtermMoney_365d: Double, depositTids: [String]? = nil, withdrawalTids: [String]? = nil, netsFor365d: [Double]? = nil) {
            self.init(snapshot: ["__typename": "QIOFinancialIndependence_SavingsRate", "income_90d": income_90d, "income_365d": income_365d, "net_365d": net_365d, "net_90d": net_90d, "dateStr_90d": dateStr_90d, "dateStr_365d": dateStr_365d, "actualSavingsRate_90d": actualSavingsRate_90d, "actualSavingsRate_365d": actualSavingsRate_365d, "potentialSavingsRate_90d": potentialSavingsRate_90d, "potentialSavingsRate_365d": potentialSavingsRate_365d, "depositsSum_90d": depositsSum_90d, "depositsSum_365d": depositsSum_365d, "withdrawalsSum_90d": withdrawalsSum_90d, "withdrawalsSum_365d": withdrawalsSum_365d, "netLongtermMoney_90d": netLongtermMoney_90d, "netLongtermMoney_365d": netLongtermMoney_365d, "depositTids": depositTids, "withdrawalTids": withdrawalTids, "netsFor365d": netsFor365d])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var income_90d: Double {
            get {
              return snapshot["income_90d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "income_90d")
            }
          }

          public var income_365d: Double {
            get {
              return snapshot["income_365d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "income_365d")
            }
          }

          public var net_365d: Double {
            get {
              return snapshot["net_365d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "net_365d")
            }
          }

          public var net_90d: Double {
            get {
              return snapshot["net_90d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "net_90d")
            }
          }

          public var dateStr_90d: String {
            get {
              return snapshot["dateStr_90d"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "dateStr_90d")
            }
          }

          public var dateStr_365d: String {
            get {
              return snapshot["dateStr_365d"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "dateStr_365d")
            }
          }

          public var actualSavingsRate_90d: Double {
            get {
              return snapshot["actualSavingsRate_90d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "actualSavingsRate_90d")
            }
          }

          public var actualSavingsRate_365d: Double {
            get {
              return snapshot["actualSavingsRate_365d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "actualSavingsRate_365d")
            }
          }

          public var potentialSavingsRate_90d: Double {
            get {
              return snapshot["potentialSavingsRate_90d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "potentialSavingsRate_90d")
            }
          }

          public var potentialSavingsRate_365d: Double {
            get {
              return snapshot["potentialSavingsRate_365d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "potentialSavingsRate_365d")
            }
          }

          public var depositsSum_90d: Double {
            get {
              return snapshot["depositsSum_90d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "depositsSum_90d")
            }
          }

          public var depositsSum_365d: Double {
            get {
              return snapshot["depositsSum_365d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "depositsSum_365d")
            }
          }

          public var withdrawalsSum_90d: Double {
            get {
              return snapshot["withdrawalsSum_90d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "withdrawalsSum_90d")
            }
          }

          public var withdrawalsSum_365d: Double {
            get {
              return snapshot["withdrawalsSum_365d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "withdrawalsSum_365d")
            }
          }

          public var netLongtermMoney_90d: Double {
            get {
              return snapshot["netLongtermMoney_90d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "netLongtermMoney_90d")
            }
          }

          public var netLongtermMoney_365d: Double {
            get {
              return snapshot["netLongtermMoney_365d"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "netLongtermMoney_365d")
            }
          }

          public var depositTids: [String]? {
            get {
              return snapshot["depositTids"] as? [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "depositTids")
            }
          }

          public var withdrawalTids: [String]? {
            get {
              return snapshot["withdrawalTids"] as? [String]
            }
            set {
              snapshot.updateValue(newValue, forKey: "withdrawalTids")
            }
          }

          public var netsFor365d: [Double]? {
            get {
              return snapshot["netsFor365d"] as? [Double]
            }
            set {
              snapshot.updateValue(newValue, forKey: "netsFor365d")
            }
          }
        }
      }

      public struct SubscriptionStatus: GraphQLSelectionSet {
        public static let possibleTypes = ["QIOSubscriptionStatus"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("hasSubscription", type: .scalar(Bool.self)),
          GraphQLField("isRenewing", type: .scalar(Bool.self)),
          GraphQLField("isInTrial", type: .scalar(Bool.self)),
          GraphQLField("isInPromo", type: .scalar(Bool.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(hasSubscription: Bool? = nil, isRenewing: Bool? = nil, isInTrial: Bool? = nil, isInPromo: Bool? = nil) {
          self.init(snapshot: ["__typename": "QIOSubscriptionStatus", "hasSubscription": hasSubscription, "isRenewing": isRenewing, "isInTrial": isInTrial, "isInPromo": isInPromo])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var hasSubscription: Bool? {
          get {
            return snapshot["hasSubscription"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "hasSubscription")
          }
        }

        public var isRenewing: Bool? {
          get {
            return snapshot["isRenewing"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "isRenewing")
          }
        }

        public var isInTrial: Bool? {
          get {
            return snapshot["isInTrial"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "isInTrial")
          }
        }

        public var isInPromo: Bool? {
          get {
            return snapshot["isInPromo"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "isInPromo")
          }
        }
      }

      public struct Yesterday: GraphQLSelectionSet {
        public static let possibleTypes = ["FIOFlowPeriod"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("periodId", type: .nonNull(.scalar(String.self))),
          GraphQLField("windowSize", type: .nonNull(.scalar(Int.self))),
          GraphQLField("daysInRange", type: .nonNull(.scalar(Int.self))),
          GraphQLField("startDate", type: .nonNull(.scalar(String.self))),
          GraphQLField("endDate", type: .nonNull(.scalar(String.self))),
          GraphQLField("daysRemainingInPeriod", type: .nonNull(.scalar(Int.self))),
          GraphQLField("dayNets", type: .list(.nonNull(.scalar(Double.self)))),
          GraphQLField("includesEndOfData", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("projection", type: .object(Projection.selections)),
          GraphQLField("periodSummary", type: .nonNull(.object(PeriodSummary.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(periodId: String, windowSize: Int, daysInRange: Int, startDate: String, endDate: String, daysRemainingInPeriod: Int, dayNets: [Double]? = nil, includesEndOfData: Bool, projection: Projection? = nil, periodSummary: PeriodSummary) {
          self.init(snapshot: ["__typename": "FIOFlowPeriod", "periodId": periodId, "windowSize": windowSize, "daysInRange": daysInRange, "startDate": startDate, "endDate": endDate, "daysRemainingInPeriod": daysRemainingInPeriod, "dayNets": dayNets, "includesEndOfData": includesEndOfData, "projection": projection.flatMap { $0.snapshot }, "periodSummary": periodSummary.snapshot])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var periodId: String {
          get {
            return snapshot["periodId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "periodId")
          }
        }

        public var windowSize: Int {
          get {
            return snapshot["windowSize"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "windowSize")
          }
        }

        public var daysInRange: Int {
          get {
            return snapshot["daysInRange"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "daysInRange")
          }
        }

        public var startDate: String {
          get {
            return snapshot["startDate"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "startDate")
          }
        }

        public var endDate: String {
          get {
            return snapshot["endDate"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "endDate")
          }
        }

        public var daysRemainingInPeriod: Int {
          get {
            return snapshot["daysRemainingInPeriod"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "daysRemainingInPeriod")
          }
        }

        public var dayNets: [Double]? {
          get {
            return snapshot["dayNets"] as? [Double]
          }
          set {
            snapshot.updateValue(newValue, forKey: "dayNets")
          }
        }

        public var includesEndOfData: Bool {
          get {
            return snapshot["includesEndOfData"]! as! Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "includesEndOfData")
          }
        }

        public var projection: Projection? {
          get {
            return (snapshot["projection"] as? Snapshot).flatMap { Projection(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "projection")
          }
        }

        public var periodSummary: PeriodSummary {
          get {
            return PeriodSummary(snapshot: snapshot["periodSummary"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "periodSummary")
          }
        }

        public struct Projection: GraphQLSelectionSet {
          public static let possibleTypes = ["FIOFlowPeriodProjection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("net", type: .scalar(Double.self)),
            GraphQLField("incomeTotal", type: .scalar(Double.self)),
            GraphQLField("spendTotal", type: .scalar(Double.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(net: Double? = nil, incomeTotal: Double? = nil, spendTotal: Double? = nil) {
            self.init(snapshot: ["__typename": "FIOFlowPeriodProjection", "net": net, "incomeTotal": incomeTotal, "spendTotal": spendTotal])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var net: Double? {
            get {
              return snapshot["net"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "net")
            }
          }

          public var incomeTotal: Double? {
            get {
              return snapshot["incomeTotal"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "incomeTotal")
            }
          }

          public var spendTotal: Double? {
            get {
              return snapshot["spendTotal"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "spendTotal")
            }
          }
        }

        public struct PeriodSummary: GraphQLSelectionSet {
          public static let possibleTypes = ["FIOFlowPeriodDetail"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("spending", type: .nonNull(.object(Spending.selections))),
            GraphQLField("categories", type: .object(Category.selections)),
            GraphQLField("balances", type: .list(.nonNull(.object(Balance.selections)))),
            GraphQLField("isFillerObject", type: .scalar(Bool.self)),
            GraphQLField("netAmount", type: .nonNull(.scalar(Double.self))),
            GraphQLField("income", type: .nonNull(.scalar(Double.self))),
            GraphQLField("transactions", type: .object(Transaction.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(spending: Spending, categories: Category? = nil, balances: [Balance]? = nil, isFillerObject: Bool? = nil, netAmount: Double, income: Double, transactions: Transaction? = nil) {
            self.init(snapshot: ["__typename": "FIOFlowPeriodDetail", "spending": spending.snapshot, "categories": categories.flatMap { $0.snapshot }, "balances": balances.flatMap { $0.map { $0.snapshot } }, "isFillerObject": isFillerObject, "netAmount": netAmount, "income": income, "transactions": transactions.flatMap { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var spending: Spending {
            get {
              return Spending(snapshot: snapshot["spending"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "spending")
            }
          }

          public var categories: Category? {
            get {
              return (snapshot["categories"] as? Snapshot).flatMap { Category(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "categories")
            }
          }

          public var balances: [Balance]? {
            get {
              return (snapshot["balances"] as? [Snapshot]).flatMap { $0.map { Balance(snapshot: $0) } }
            }
            set {
              snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "balances")
            }
          }

          public var isFillerObject: Bool? {
            get {
              return snapshot["isFillerObject"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "isFillerObject")
            }
          }

          public var netAmount: Double {
            get {
              return snapshot["netAmount"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "netAmount")
            }
          }

          public var income: Double {
            get {
              return snapshot["income"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "income")
            }
          }

          public var transactions: Transaction? {
            get {
              return (snapshot["transactions"] as? Snapshot).flatMap { Transaction(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "transactions")
            }
          }

          public struct Spending: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOFlowPeriodSpending"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("actual", type: .nonNull(.scalar(Double.self))),
              GraphQLField("target", type: .nonNull(.scalar(Double.self))),
              GraphQLField("projected", type: .scalar(Double.self)),
              GraphQLField("spendWithoutBle", type: .scalar(Double.self)),
              GraphQLField("spendBleAmortized", type: .scalar(Double.self)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(actual: Double, target: Double, projected: Double? = nil, spendWithoutBle: Double? = nil, spendBleAmortized: Double? = nil) {
              self.init(snapshot: ["__typename": "FIOFlowPeriodSpending", "actual": actual, "target": target, "projected": projected, "spendWithoutBle": spendWithoutBle, "spendBleAmortized": spendBleAmortized])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var actual: Double {
              get {
                return snapshot["actual"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "actual")
              }
            }

            public var target: Double {
              get {
                return snapshot["target"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "target")
              }
            }

            public var projected: Double? {
              get {
                return snapshot["projected"] as? Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "projected")
              }
            }

            public var spendWithoutBle: Double? {
              get {
                return snapshot["spendWithoutBle"] as? Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "spendWithoutBle")
              }
            }

            public var spendBleAmortized: Double? {
              get {
                return snapshot["spendBleAmortized"] as? Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "spendBleAmortized")
              }
            }
          }

          public struct Category: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOSpendCategories"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("total", type: .nonNull(.scalar(Double.self))),
              GraphQLField("names", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              GraphQLField("percentages", type: .nonNull(.list(.nonNull(.scalar(Double.self))))),
              GraphQLField("descriptions", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              GraphQLField("amounts", type: .nonNull(.list(.nonNull(.scalar(Double.self))))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(total: Double, names: [String], percentages: [Double], descriptions: [String], amounts: [Double]) {
              self.init(snapshot: ["__typename": "FIOSpendCategories", "total": total, "names": names, "percentages": percentages, "descriptions": descriptions, "amounts": amounts])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var total: Double {
              get {
                return snapshot["total"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "total")
              }
            }

            public var names: [String] {
              get {
                return snapshot["names"]! as! [String]
              }
              set {
                snapshot.updateValue(newValue, forKey: "names")
              }
            }

            public var percentages: [Double] {
              get {
                return snapshot["percentages"]! as! [Double]
              }
              set {
                snapshot.updateValue(newValue, forKey: "percentages")
              }
            }

            public var descriptions: [String] {
              get {
                return snapshot["descriptions"]! as! [String]
              }
              set {
                snapshot.updateValue(newValue, forKey: "descriptions")
              }
            }

            public var amounts: [Double] {
              get {
                return snapshot["amounts"]! as! [Double]
              }
              set {
                snapshot.updateValue(newValue, forKey: "amounts")
              }
            }
          }

          public struct Balance: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOPeriodBalance"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("accountSubtype", type: .nonNull(.scalar(String.self))),
              GraphQLField("startingBalance", type: .nonNull(.scalar(Double.self))),
              GraphQLField("endingBalance", type: .nonNull(.scalar(Double.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(accountSubtype: String, startingBalance: Double, endingBalance: Double) {
              self.init(snapshot: ["__typename": "FIOPeriodBalance", "accountSubtype": accountSubtype, "startingBalance": startingBalance, "endingBalance": endingBalance])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var accountSubtype: String {
              get {
                return snapshot["accountSubtype"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "accountSubtype")
              }
            }

            public var startingBalance: Double {
              get {
                return snapshot["startingBalance"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "startingBalance")
              }
            }

            public var endingBalance: Double {
              get {
                return snapshot["endingBalance"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "endingBalance")
              }
            }
          }

          public struct Transaction: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOFlowPeriodDetailTransactions"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("totalAmount", type: .scalar(Double.self)),
              GraphQLField("deposits", type: .object(Deposit.selections)),
              GraphQLField("debits", type: .object(Debit.selections)),
              GraphQLField("transfers", type: .object(Transfer.selections)),
              GraphQLField("regularIncome", type: .object(RegularIncome.selections)),
              GraphQLField("creditCardPayments", type: .object(CreditCardPayment.selections)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(totalAmount: Double? = nil, deposits: Deposit? = nil, debits: Debit? = nil, transfers: Transfer? = nil, regularIncome: RegularIncome? = nil, creditCardPayments: CreditCardPayment? = nil) {
              self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactions", "totalAmount": totalAmount, "deposits": deposits.flatMap { $0.snapshot }, "debits": debits.flatMap { $0.snapshot }, "transfers": transfers.flatMap { $0.snapshot }, "regularIncome": regularIncome.flatMap { $0.snapshot }, "creditCardPayments": creditCardPayments.flatMap { $0.snapshot }])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var totalAmount: Double? {
              get {
                return snapshot["totalAmount"] as? Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "totalAmount")
              }
            }

            public var deposits: Deposit? {
              get {
                return (snapshot["deposits"] as? Snapshot).flatMap { Deposit(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "deposits")
              }
            }

            public var debits: Debit? {
              get {
                return (snapshot["debits"] as? Snapshot).flatMap { Debit(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "debits")
              }
            }

            public var transfers: Transfer? {
              get {
                return (snapshot["transfers"] as? Snapshot).flatMap { Transfer(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "transfers")
              }
            }

            public var regularIncome: RegularIncome? {
              get {
                return (snapshot["regularIncome"] as? Snapshot).flatMap { RegularIncome(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "regularIncome")
              }
            }

            public var creditCardPayments: CreditCardPayment? {
              get {
                return (snapshot["creditCardPayments"] as? Snapshot).flatMap { CreditCardPayment(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "creditCardPayments")
              }
            }

            public struct Deposit: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOFlowPeriodDetailTransactionSet"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("transactionIds", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, transactionIds: [String]) {
                self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactionSet", "totalAmount": totalAmount, "transactionIds": transactionIds])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var transactionIds: [String] {
                get {
                  return snapshot["transactionIds"]! as! [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "transactionIds")
                }
              }
            }

            public struct Debit: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOFlowPeriodDetailTransactionSet"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("transactionIds", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
                GraphQLField("transactions", type: .list(.nonNull(.object(Transaction.selections)))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, transactionIds: [String], transactions: [Transaction]? = nil) {
                self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactionSet", "totalAmount": totalAmount, "transactionIds": transactionIds, "transactions": transactions.flatMap { $0.map { $0.snapshot } }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var transactionIds: [String] {
                get {
                  return snapshot["transactionIds"]! as! [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "transactionIds")
                }
              }

              public var transactions: [Transaction]? {
                get {
                  return (snapshot["transactions"] as? [Snapshot]).flatMap { $0.map { Transaction(snapshot: $0) } }
                }
                set {
                  snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "transactions")
                }
              }

              public struct Transaction: GraphQLSelectionSet {
                public static let possibleTypes = ["FIOTransaction"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  GraphQLField("friendlyName", type: .scalar(String.self)),
                  GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
                  GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
                  GraphQLField("date", type: .nonNull(.scalar(String.self))),
                  GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                  GraphQLField("pending", type: .scalar(Bool.self)),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(name: String, friendlyName: String? = nil, amount: Double, transactionId: String, fioCategoryId: Int, date: String, masterAccountId: String, pending: Bool? = nil) {
                  self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "amount": amount, "transaction_id": transactionId, "fioCategoryId": fioCategoryId, "date": date, "masterAccountId": masterAccountId, "pending": pending])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var name: String {
                  get {
                    return snapshot["name"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "name")
                  }
                }

                public var friendlyName: String? {
                  get {
                    return snapshot["friendlyName"] as? String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "friendlyName")
                  }
                }

                public var amount: Double {
                  get {
                    return snapshot["amount"]! as! Double
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "amount")
                  }
                }

                public var transactionId: String {
                  get {
                    return snapshot["transaction_id"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "transaction_id")
                  }
                }

                public var fioCategoryId: Int {
                  get {
                    return snapshot["fioCategoryId"]! as! Int
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "fioCategoryId")
                  }
                }

                public var date: String {
                  get {
                    return snapshot["date"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "date")
                  }
                }

                public var masterAccountId: String {
                  get {
                    return snapshot["masterAccountId"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "masterAccountId")
                  }
                }

                public var pending: Bool? {
                  get {
                    return snapshot["pending"] as? Bool
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "pending")
                  }
                }
              }
            }

            public struct Transfer: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOFlowPeriodDetailTransactionSet"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("transactionIds", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
                GraphQLField("transactionSummaries", type: .list(.nonNull(.object(TransactionSummary.selections)))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, transactionIds: [String], transactionSummaries: [TransactionSummary]? = nil) {
                self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactionSet", "totalAmount": totalAmount, "transactionIds": transactionIds, "transactionSummaries": transactionSummaries.flatMap { $0.map { $0.snapshot } }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var transactionIds: [String] {
                get {
                  return snapshot["transactionIds"]! as! [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "transactionIds")
                }
              }

              public var transactionSummaries: [TransactionSummary]? {
                get {
                  return (snapshot["transactionSummaries"] as? [Snapshot]).flatMap { $0.map { TransactionSummary(snapshot: $0) } }
                }
                set {
                  snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "transactionSummaries")
                }
              }

              public struct TransactionSummary: GraphQLSelectionSet {
                public static let possibleTypes = ["FIOTransaction"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("friendlyName", type: .scalar(String.self)),
                  GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
                  GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(friendlyName: String? = nil, transactionId: String, amount: Double, fioCategoryId: Int) {
                  self.init(snapshot: ["__typename": "FIOTransaction", "friendlyName": friendlyName, "transaction_id": transactionId, "amount": amount, "fioCategoryId": fioCategoryId])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var friendlyName: String? {
                  get {
                    return snapshot["friendlyName"] as? String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "friendlyName")
                  }
                }

                public var transactionId: String {
                  get {
                    return snapshot["transaction_id"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "transaction_id")
                  }
                }

                public var amount: Double {
                  get {
                    return snapshot["amount"]! as! Double
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "amount")
                  }
                }

                public var fioCategoryId: Int {
                  get {
                    return snapshot["fioCategoryId"]! as! Int
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "fioCategoryId")
                  }
                }
              }
            }

            public struct RegularIncome: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOFlowPeriodDetailTransactionSet"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("transactionIds", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, transactionIds: [String]) {
                self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactionSet", "totalAmount": totalAmount, "transactionIds": transactionIds])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var transactionIds: [String] {
                get {
                  return snapshot["transactionIds"]! as! [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "transactionIds")
                }
              }
            }

            public struct CreditCardPayment: GraphQLSelectionSet {
              public static let possibleTypes = ["QIOFlowPeriodCreditCardPayments"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("destinationAccountNames", type: .list(.nonNull(.scalar(String.self)))),
                GraphQLField("sourceAccountNames", type: .list(.nonNull(.scalar(String.self)))),
                GraphQLField("payments", type: .nonNull(.list(.nonNull(.object(Payment.selections))))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, destinationAccountNames: [String]? = nil, sourceAccountNames: [String]? = nil, payments: [Payment]) {
                self.init(snapshot: ["__typename": "QIOFlowPeriodCreditCardPayments", "totalAmount": totalAmount, "destinationAccountNames": destinationAccountNames, "sourceAccountNames": sourceAccountNames, "payments": payments.map { $0.snapshot }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var destinationAccountNames: [String]? {
                get {
                  return snapshot["destinationAccountNames"] as? [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "destinationAccountNames")
                }
              }

              public var sourceAccountNames: [String]? {
                get {
                  return snapshot["sourceAccountNames"] as? [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "sourceAccountNames")
                }
              }

              public var payments: [Payment] {
                get {
                  return (snapshot["payments"] as! [Snapshot]).map { Payment(snapshot: $0) }
                }
                set {
                  snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "payments")
                }
              }

              public struct Payment: GraphQLSelectionSet {
                public static let possibleTypes = ["QIOFlowPeriodCreditCardPaymentItem"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("from", type: .object(From.selections)),
                  GraphQLField("to", type: .object(To.selections)),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(amount: Double, from: From? = nil, to: To? = nil) {
                  self.init(snapshot: ["__typename": "QIOFlowPeriodCreditCardPaymentItem", "amount": amount, "from": from.flatMap { $0.snapshot }, "to": to.flatMap { $0.snapshot }])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var amount: Double {
                  get {
                    return snapshot["amount"]! as! Double
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "amount")
                  }
                }

                public var from: From? {
                  get {
                    return (snapshot["from"] as? Snapshot).flatMap { From(snapshot: $0) }
                  }
                  set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "from")
                  }
                }

                public var to: To? {
                  get {
                    return (snapshot["to"] as? Snapshot).flatMap { To(snapshot: $0) }
                  }
                  set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "to")
                  }
                }

                public struct From: GraphQLSelectionSet {
                  public static let possibleTypes = ["FIOTransaction"]

                  public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                    GraphQLField("friendlyName", type: .scalar(String.self)),
                    GraphQLField("date", type: .nonNull(.scalar(String.self))),
                    GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("category", type: .list(.scalar(String.self))),
                    GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                    GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("account", type: .object(Account.selections)),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("account_owner", type: .scalar(String.self)),
                    GraphQLField("category_id", type: .scalar(Double.self)),
                    GraphQLField("insertTimestamp", type: .scalar(Double.self)),
                    GraphQLField("institution_id", type: .scalar(String.self)),
                    GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pending", type: .scalar(Bool.self)),
                    GraphQLField("pending_transaction_id", type: .scalar(String.self)),
                    GraphQLField("transaction_type", type: .scalar(String.self)),
                    GraphQLField("account_name", type: .scalar(String.self)),
                    GraphQLField("account_institution_name", type: .scalar(String.self)),
                    GraphQLField("payment_meta", type: .object(PaymentMetum.selections)),
                  ]

                  public var snapshot: Snapshot

                  public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                  }

                  public init(name: String, friendlyName: String? = nil, date: String, amount: Double, transactionId: String, category: [String?]? = nil, masterAccountId: String, fioCategoryId: Int, account: Account? = nil, accountOwner: String? = nil, categoryId: Double? = nil, insertTimestamp: Double? = nil, institutionId: String? = nil, itemId: String, pending: Bool? = nil, pendingTransactionId: String? = nil, transactionType: String? = nil, accountName: String? = nil, accountInstitutionName: String? = nil, paymentMeta: PaymentMetum? = nil) {
                    self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "date": date, "amount": amount, "transaction_id": transactionId, "category": category, "masterAccountId": masterAccountId, "fioCategoryId": fioCategoryId, "account": account.flatMap { $0.snapshot }, "account_owner": accountOwner, "category_id": categoryId, "insertTimestamp": insertTimestamp, "institution_id": institutionId, "item_id": itemId, "pending": pending, "pending_transaction_id": pendingTransactionId, "transaction_type": transactionType, "account_name": accountName, "account_institution_name": accountInstitutionName, "payment_meta": paymentMeta.flatMap { $0.snapshot }])
                  }

                  public var __typename: String {
                    get {
                      return snapshot["__typename"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var name: String {
                    get {
                      return snapshot["name"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "name")
                    }
                  }

                  public var friendlyName: String? {
                    get {
                      return snapshot["friendlyName"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "friendlyName")
                    }
                  }

                  public var date: String {
                    get {
                      return snapshot["date"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "date")
                    }
                  }

                  public var amount: Double {
                    get {
                      return snapshot["amount"]! as! Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "amount")
                    }
                  }

                  public var transactionId: String {
                    get {
                      return snapshot["transaction_id"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "transaction_id")
                    }
                  }

                  public var category: [String?]? {
                    get {
                      return snapshot["category"] as? [String?]
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "category")
                    }
                  }

                  public var masterAccountId: String {
                    get {
                      return snapshot["masterAccountId"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "masterAccountId")
                    }
                  }

                  public var fioCategoryId: Int {
                    get {
                      return snapshot["fioCategoryId"]! as! Int
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "fioCategoryId")
                    }
                  }

                  public var account: Account? {
                    get {
                      return (snapshot["account"] as? Snapshot).flatMap { Account(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "account")
                    }
                  }

                  public var accountOwner: String? {
                    get {
                      return snapshot["account_owner"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_owner")
                    }
                  }

                  public var categoryId: Double? {
                    get {
                      return snapshot["category_id"] as? Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "category_id")
                    }
                  }

                  public var insertTimestamp: Double? {
                    get {
                      return snapshot["insertTimestamp"] as? Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "insertTimestamp")
                    }
                  }

                  public var institutionId: String? {
                    get {
                      return snapshot["institution_id"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "institution_id")
                    }
                  }

                  public var itemId: String {
                    get {
                      return snapshot["item_id"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "item_id")
                    }
                  }

                  public var pending: Bool? {
                    get {
                      return snapshot["pending"] as? Bool
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "pending")
                    }
                  }

                  public var pendingTransactionId: String? {
                    get {
                      return snapshot["pending_transaction_id"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "pending_transaction_id")
                    }
                  }

                  public var transactionType: String? {
                    get {
                      return snapshot["transaction_type"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "transaction_type")
                    }
                  }

                  public var accountName: String? {
                    get {
                      return snapshot["account_name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_name")
                    }
                  }

                  public var accountInstitutionName: String? {
                    get {
                      return snapshot["account_institution_name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_institution_name")
                    }
                  }

                  public var paymentMeta: PaymentMetum? {
                    get {
                      return (snapshot["payment_meta"] as? Snapshot).flatMap { PaymentMetum(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "payment_meta")
                    }
                  }

                  public var fragments: Fragments {
                    get {
                      return Fragments(snapshot: snapshot)
                    }
                    set {
                      snapshot += newValue.snapshot
                    }
                  }

                  public struct Fragments {
                    public var snapshot: Snapshot

                    public var transactionDetails: TransactionDetails {
                      get {
                        return TransactionDetails(snapshot: snapshot)
                      }
                      set {
                        snapshot += newValue.snapshot
                      }
                    }
                  }

                  public struct Account: GraphQLSelectionSet {
                    public static let possibleTypes = ["FIOFinAccount"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("displayName", type: .scalar(String.self)),
                      GraphQLField("hidden", type: .scalar(Bool.self)),
                      GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                      GraphQLField("institution_id", type: .nonNull(.scalar(String.self))),
                      GraphQLField("balances", type: .object(Balance.selections)),
                      GraphQLField("institution_name", type: .nonNull(.scalar(String.self))),
                      GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
                      GraphQLField("lastSynced", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("mask", type: .scalar(String.self)),
                      GraphQLField("name", type: .nonNull(.scalar(String.self))),
                      GraphQLField("official_name", type: .scalar(String.self)),
                      GraphQLField("subtype", type: .nonNull(.scalar(String.self))),
                      GraphQLField("type", type: .nonNull(.scalar(String.self))),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(displayName: String? = nil, hidden: Bool? = nil, masterAccountId: String, institutionId: String, balances: Balance? = nil, institutionName: String, itemId: String, lastSynced: Double, mask: String? = nil, name: String, officialName: String? = nil, subtype: String, type: String) {
                      self.init(snapshot: ["__typename": "FIOFinAccount", "displayName": displayName, "hidden": hidden, "masterAccountId": masterAccountId, "institution_id": institutionId, "balances": balances.flatMap { $0.snapshot }, "institution_name": institutionName, "item_id": itemId, "lastSynced": lastSynced, "mask": mask, "name": name, "official_name": officialName, "subtype": subtype, "type": type])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var displayName: String? {
                      get {
                        return snapshot["displayName"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "displayName")
                      }
                    }

                    public var hidden: Bool? {
                      get {
                        return snapshot["hidden"] as? Bool
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "hidden")
                      }
                    }

                    public var masterAccountId: String {
                      get {
                        return snapshot["masterAccountId"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "masterAccountId")
                      }
                    }

                    public var institutionId: String {
                      get {
                        return snapshot["institution_id"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "institution_id")
                      }
                    }

                    public var balances: Balance? {
                      get {
                        return (snapshot["balances"] as? Snapshot).flatMap { Balance(snapshot: $0) }
                      }
                      set {
                        snapshot.updateValue(newValue?.snapshot, forKey: "balances")
                      }
                    }

                    public var institutionName: String {
                      get {
                        return snapshot["institution_name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "institution_name")
                      }
                    }

                    public var itemId: String {
                      get {
                        return snapshot["item_id"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "item_id")
                      }
                    }

                    public var lastSynced: Double {
                      get {
                        return snapshot["lastSynced"]! as! Double
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "lastSynced")
                      }
                    }

                    public var mask: String? {
                      get {
                        return snapshot["mask"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "mask")
                      }
                    }

                    public var name: String {
                      get {
                        return snapshot["name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "name")
                      }
                    }

                    public var officialName: String? {
                      get {
                        return snapshot["official_name"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "official_name")
                      }
                    }

                    public var subtype: String {
                      get {
                        return snapshot["subtype"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "subtype")
                      }
                    }

                    public var type: String {
                      get {
                        return snapshot["type"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "type")
                      }
                    }

                    public struct Balance: GraphQLSelectionSet {
                      public static let possibleTypes = ["FIOFinAccountBalances"]

                      public static let selections: [GraphQLSelection] = [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("available", type: .scalar(Double.self)),
                        GraphQLField("limit", type: .scalar(Double.self)),
                        GraphQLField("current", type: .scalar(Double.self)),
                      ]

                      public var snapshot: Snapshot

                      public init(snapshot: Snapshot) {
                        self.snapshot = snapshot
                      }

                      public init(available: Double? = nil, limit: Double? = nil, current: Double? = nil) {
                        self.init(snapshot: ["__typename": "FIOFinAccountBalances", "available": available, "limit": limit, "current": current])
                      }

                      public var __typename: String {
                        get {
                          return snapshot["__typename"]! as! String
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "__typename")
                        }
                      }

                      public var available: Double? {
                        get {
                          return snapshot["available"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "available")
                        }
                      }

                      public var limit: Double? {
                        get {
                          return snapshot["limit"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "limit")
                        }
                      }

                      public var current: Double? {
                        get {
                          return snapshot["current"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "current")
                        }
                      }
                    }
                  }

                  public struct PaymentMetum: GraphQLSelectionSet {
                    public static let possibleTypes = ["FIOTransactionPaymentMetadata"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("by_order_of", type: .scalar(String.self)),
                      GraphQLField("payee", type: .scalar(String.self)),
                      GraphQLField("payer", type: .scalar(String.self)),
                      GraphQLField("payment_method", type: .scalar(String.self)),
                      GraphQLField("payment_processor", type: .scalar(String.self)),
                      GraphQLField("ppd_id", type: .scalar(String.self)),
                      GraphQLField("reason", type: .scalar(String.self)),
                      GraphQLField("reference_number", type: .scalar(String.self)),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(byOrderOf: String? = nil, payee: String? = nil, payer: String? = nil, paymentMethod: String? = nil, paymentProcessor: String? = nil, ppdId: String? = nil, reason: String? = nil, referenceNumber: String? = nil) {
                      self.init(snapshot: ["__typename": "FIOTransactionPaymentMetadata", "by_order_of": byOrderOf, "payee": payee, "payer": payer, "payment_method": paymentMethod, "payment_processor": paymentProcessor, "ppd_id": ppdId, "reason": reason, "reference_number": referenceNumber])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var byOrderOf: String? {
                      get {
                        return snapshot["by_order_of"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "by_order_of")
                      }
                    }

                    public var payee: String? {
                      get {
                        return snapshot["payee"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payee")
                      }
                    }

                    public var payer: String? {
                      get {
                        return snapshot["payer"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payer")
                      }
                    }

                    public var paymentMethod: String? {
                      get {
                        return snapshot["payment_method"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payment_method")
                      }
                    }

                    public var paymentProcessor: String? {
                      get {
                        return snapshot["payment_processor"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payment_processor")
                      }
                    }

                    public var ppdId: String? {
                      get {
                        return snapshot["ppd_id"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "ppd_id")
                      }
                    }

                    public var reason: String? {
                      get {
                        return snapshot["reason"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "reason")
                      }
                    }

                    public var referenceNumber: String? {
                      get {
                        return snapshot["reference_number"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "reference_number")
                      }
                    }
                  }
                }

                public struct To: GraphQLSelectionSet {
                  public static let possibleTypes = ["FIOTransaction"]

                  public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                    GraphQLField("friendlyName", type: .scalar(String.self)),
                    GraphQLField("date", type: .nonNull(.scalar(String.self))),
                    GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("category", type: .list(.scalar(String.self))),
                    GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                    GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("account", type: .object(Account.selections)),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("account_owner", type: .scalar(String.self)),
                    GraphQLField("category_id", type: .scalar(Double.self)),
                    GraphQLField("insertTimestamp", type: .scalar(Double.self)),
                    GraphQLField("institution_id", type: .scalar(String.self)),
                    GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pending", type: .scalar(Bool.self)),
                    GraphQLField("pending_transaction_id", type: .scalar(String.self)),
                    GraphQLField("transaction_type", type: .scalar(String.self)),
                    GraphQLField("account_name", type: .scalar(String.self)),
                    GraphQLField("account_institution_name", type: .scalar(String.self)),
                    GraphQLField("payment_meta", type: .object(PaymentMetum.selections)),
                  ]

                  public var snapshot: Snapshot

                  public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                  }

                  public init(name: String, friendlyName: String? = nil, date: String, amount: Double, transactionId: String, category: [String?]? = nil, masterAccountId: String, fioCategoryId: Int, account: Account? = nil, accountOwner: String? = nil, categoryId: Double? = nil, insertTimestamp: Double? = nil, institutionId: String? = nil, itemId: String, pending: Bool? = nil, pendingTransactionId: String? = nil, transactionType: String? = nil, accountName: String? = nil, accountInstitutionName: String? = nil, paymentMeta: PaymentMetum? = nil) {
                    self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "date": date, "amount": amount, "transaction_id": transactionId, "category": category, "masterAccountId": masterAccountId, "fioCategoryId": fioCategoryId, "account": account.flatMap { $0.snapshot }, "account_owner": accountOwner, "category_id": categoryId, "insertTimestamp": insertTimestamp, "institution_id": institutionId, "item_id": itemId, "pending": pending, "pending_transaction_id": pendingTransactionId, "transaction_type": transactionType, "account_name": accountName, "account_institution_name": accountInstitutionName, "payment_meta": paymentMeta.flatMap { $0.snapshot }])
                  }

                  public var __typename: String {
                    get {
                      return snapshot["__typename"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var name: String {
                    get {
                      return snapshot["name"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "name")
                    }
                  }

                  public var friendlyName: String? {
                    get {
                      return snapshot["friendlyName"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "friendlyName")
                    }
                  }

                  public var date: String {
                    get {
                      return snapshot["date"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "date")
                    }
                  }

                  public var amount: Double {
                    get {
                      return snapshot["amount"]! as! Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "amount")
                    }
                  }

                  public var transactionId: String {
                    get {
                      return snapshot["transaction_id"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "transaction_id")
                    }
                  }

                  public var category: [String?]? {
                    get {
                      return snapshot["category"] as? [String?]
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "category")
                    }
                  }

                  public var masterAccountId: String {
                    get {
                      return snapshot["masterAccountId"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "masterAccountId")
                    }
                  }

                  public var fioCategoryId: Int {
                    get {
                      return snapshot["fioCategoryId"]! as! Int
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "fioCategoryId")
                    }
                  }

                  public var account: Account? {
                    get {
                      return (snapshot["account"] as? Snapshot).flatMap { Account(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "account")
                    }
                  }

                  public var accountOwner: String? {
                    get {
                      return snapshot["account_owner"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_owner")
                    }
                  }

                  public var categoryId: Double? {
                    get {
                      return snapshot["category_id"] as? Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "category_id")
                    }
                  }

                  public var insertTimestamp: Double? {
                    get {
                      return snapshot["insertTimestamp"] as? Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "insertTimestamp")
                    }
                  }

                  public var institutionId: String? {
                    get {
                      return snapshot["institution_id"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "institution_id")
                    }
                  }

                  public var itemId: String {
                    get {
                      return snapshot["item_id"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "item_id")
                    }
                  }

                  public var pending: Bool? {
                    get {
                      return snapshot["pending"] as? Bool
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "pending")
                    }
                  }

                  public var pendingTransactionId: String? {
                    get {
                      return snapshot["pending_transaction_id"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "pending_transaction_id")
                    }
                  }

                  public var transactionType: String? {
                    get {
                      return snapshot["transaction_type"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "transaction_type")
                    }
                  }

                  public var accountName: String? {
                    get {
                      return snapshot["account_name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_name")
                    }
                  }

                  public var accountInstitutionName: String? {
                    get {
                      return snapshot["account_institution_name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_institution_name")
                    }
                  }

                  public var paymentMeta: PaymentMetum? {
                    get {
                      return (snapshot["payment_meta"] as? Snapshot).flatMap { PaymentMetum(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "payment_meta")
                    }
                  }

                  public var fragments: Fragments {
                    get {
                      return Fragments(snapshot: snapshot)
                    }
                    set {
                      snapshot += newValue.snapshot
                    }
                  }

                  public struct Fragments {
                    public var snapshot: Snapshot

                    public var transactionDetails: TransactionDetails {
                      get {
                        return TransactionDetails(snapshot: snapshot)
                      }
                      set {
                        snapshot += newValue.snapshot
                      }
                    }
                  }

                  public struct Account: GraphQLSelectionSet {
                    public static let possibleTypes = ["FIOFinAccount"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("displayName", type: .scalar(String.self)),
                      GraphQLField("hidden", type: .scalar(Bool.self)),
                      GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                      GraphQLField("institution_id", type: .nonNull(.scalar(String.self))),
                      GraphQLField("balances", type: .object(Balance.selections)),
                      GraphQLField("institution_name", type: .nonNull(.scalar(String.self))),
                      GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
                      GraphQLField("lastSynced", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("mask", type: .scalar(String.self)),
                      GraphQLField("name", type: .nonNull(.scalar(String.self))),
                      GraphQLField("official_name", type: .scalar(String.self)),
                      GraphQLField("subtype", type: .nonNull(.scalar(String.self))),
                      GraphQLField("type", type: .nonNull(.scalar(String.self))),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(displayName: String? = nil, hidden: Bool? = nil, masterAccountId: String, institutionId: String, balances: Balance? = nil, institutionName: String, itemId: String, lastSynced: Double, mask: String? = nil, name: String, officialName: String? = nil, subtype: String, type: String) {
                      self.init(snapshot: ["__typename": "FIOFinAccount", "displayName": displayName, "hidden": hidden, "masterAccountId": masterAccountId, "institution_id": institutionId, "balances": balances.flatMap { $0.snapshot }, "institution_name": institutionName, "item_id": itemId, "lastSynced": lastSynced, "mask": mask, "name": name, "official_name": officialName, "subtype": subtype, "type": type])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var displayName: String? {
                      get {
                        return snapshot["displayName"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "displayName")
                      }
                    }

                    public var hidden: Bool? {
                      get {
                        return snapshot["hidden"] as? Bool
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "hidden")
                      }
                    }

                    public var masterAccountId: String {
                      get {
                        return snapshot["masterAccountId"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "masterAccountId")
                      }
                    }

                    public var institutionId: String {
                      get {
                        return snapshot["institution_id"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "institution_id")
                      }
                    }

                    public var balances: Balance? {
                      get {
                        return (snapshot["balances"] as? Snapshot).flatMap { Balance(snapshot: $0) }
                      }
                      set {
                        snapshot.updateValue(newValue?.snapshot, forKey: "balances")
                      }
                    }

                    public var institutionName: String {
                      get {
                        return snapshot["institution_name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "institution_name")
                      }
                    }

                    public var itemId: String {
                      get {
                        return snapshot["item_id"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "item_id")
                      }
                    }

                    public var lastSynced: Double {
                      get {
                        return snapshot["lastSynced"]! as! Double
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "lastSynced")
                      }
                    }

                    public var mask: String? {
                      get {
                        return snapshot["mask"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "mask")
                      }
                    }

                    public var name: String {
                      get {
                        return snapshot["name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "name")
                      }
                    }

                    public var officialName: String? {
                      get {
                        return snapshot["official_name"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "official_name")
                      }
                    }

                    public var subtype: String {
                      get {
                        return snapshot["subtype"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "subtype")
                      }
                    }

                    public var type: String {
                      get {
                        return snapshot["type"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "type")
                      }
                    }

                    public struct Balance: GraphQLSelectionSet {
                      public static let possibleTypes = ["FIOFinAccountBalances"]

                      public static let selections: [GraphQLSelection] = [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("available", type: .scalar(Double.self)),
                        GraphQLField("limit", type: .scalar(Double.self)),
                        GraphQLField("current", type: .scalar(Double.self)),
                      ]

                      public var snapshot: Snapshot

                      public init(snapshot: Snapshot) {
                        self.snapshot = snapshot
                      }

                      public init(available: Double? = nil, limit: Double? = nil, current: Double? = nil) {
                        self.init(snapshot: ["__typename": "FIOFinAccountBalances", "available": available, "limit": limit, "current": current])
                      }

                      public var __typename: String {
                        get {
                          return snapshot["__typename"]! as! String
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "__typename")
                        }
                      }

                      public var available: Double? {
                        get {
                          return snapshot["available"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "available")
                        }
                      }

                      public var limit: Double? {
                        get {
                          return snapshot["limit"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "limit")
                        }
                      }

                      public var current: Double? {
                        get {
                          return snapshot["current"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "current")
                        }
                      }
                    }
                  }

                  public struct PaymentMetum: GraphQLSelectionSet {
                    public static let possibleTypes = ["FIOTransactionPaymentMetadata"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("by_order_of", type: .scalar(String.self)),
                      GraphQLField("payee", type: .scalar(String.self)),
                      GraphQLField("payer", type: .scalar(String.self)),
                      GraphQLField("payment_method", type: .scalar(String.self)),
                      GraphQLField("payment_processor", type: .scalar(String.self)),
                      GraphQLField("ppd_id", type: .scalar(String.self)),
                      GraphQLField("reason", type: .scalar(String.self)),
                      GraphQLField("reference_number", type: .scalar(String.self)),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(byOrderOf: String? = nil, payee: String? = nil, payer: String? = nil, paymentMethod: String? = nil, paymentProcessor: String? = nil, ppdId: String? = nil, reason: String? = nil, referenceNumber: String? = nil) {
                      self.init(snapshot: ["__typename": "FIOTransactionPaymentMetadata", "by_order_of": byOrderOf, "payee": payee, "payer": payer, "payment_method": paymentMethod, "payment_processor": paymentProcessor, "ppd_id": ppdId, "reason": reason, "reference_number": referenceNumber])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var byOrderOf: String? {
                      get {
                        return snapshot["by_order_of"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "by_order_of")
                      }
                    }

                    public var payee: String? {
                      get {
                        return snapshot["payee"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payee")
                      }
                    }

                    public var payer: String? {
                      get {
                        return snapshot["payer"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payer")
                      }
                    }

                    public var paymentMethod: String? {
                      get {
                        return snapshot["payment_method"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payment_method")
                      }
                    }

                    public var paymentProcessor: String? {
                      get {
                        return snapshot["payment_processor"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payment_processor")
                      }
                    }

                    public var ppdId: String? {
                      get {
                        return snapshot["ppd_id"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "ppd_id")
                      }
                    }

                    public var reason: String? {
                      get {
                        return snapshot["reason"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "reason")
                      }
                    }

                    public var referenceNumber: String? {
                      get {
                        return snapshot["reference_number"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "reference_number")
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      public struct ThisMonth: GraphQLSelectionSet {
        public static let possibleTypes = ["FIOFlowPeriod"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("periodId", type: .nonNull(.scalar(String.self))),
          GraphQLField("windowSize", type: .nonNull(.scalar(Int.self))),
          GraphQLField("daysInRange", type: .nonNull(.scalar(Int.self))),
          GraphQLField("startDate", type: .nonNull(.scalar(String.self))),
          GraphQLField("endDate", type: .nonNull(.scalar(String.self))),
          GraphQLField("daysRemainingInPeriod", type: .nonNull(.scalar(Int.self))),
          GraphQLField("dayNets", type: .list(.nonNull(.scalar(Double.self)))),
          GraphQLField("includesEndOfData", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("projection", type: .object(Projection.selections)),
          GraphQLField("periodSummary", type: .nonNull(.object(PeriodSummary.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(periodId: String, windowSize: Int, daysInRange: Int, startDate: String, endDate: String, daysRemainingInPeriod: Int, dayNets: [Double]? = nil, includesEndOfData: Bool, projection: Projection? = nil, periodSummary: PeriodSummary) {
          self.init(snapshot: ["__typename": "FIOFlowPeriod", "periodId": periodId, "windowSize": windowSize, "daysInRange": daysInRange, "startDate": startDate, "endDate": endDate, "daysRemainingInPeriod": daysRemainingInPeriod, "dayNets": dayNets, "includesEndOfData": includesEndOfData, "projection": projection.flatMap { $0.snapshot }, "periodSummary": periodSummary.snapshot])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var periodId: String {
          get {
            return snapshot["periodId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "periodId")
          }
        }

        public var windowSize: Int {
          get {
            return snapshot["windowSize"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "windowSize")
          }
        }

        public var daysInRange: Int {
          get {
            return snapshot["daysInRange"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "daysInRange")
          }
        }

        public var startDate: String {
          get {
            return snapshot["startDate"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "startDate")
          }
        }

        public var endDate: String {
          get {
            return snapshot["endDate"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "endDate")
          }
        }

        public var daysRemainingInPeriod: Int {
          get {
            return snapshot["daysRemainingInPeriod"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "daysRemainingInPeriod")
          }
        }

        public var dayNets: [Double]? {
          get {
            return snapshot["dayNets"] as? [Double]
          }
          set {
            snapshot.updateValue(newValue, forKey: "dayNets")
          }
        }

        public var includesEndOfData: Bool {
          get {
            return snapshot["includesEndOfData"]! as! Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "includesEndOfData")
          }
        }

        public var projection: Projection? {
          get {
            return (snapshot["projection"] as? Snapshot).flatMap { Projection(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "projection")
          }
        }

        public var periodSummary: PeriodSummary {
          get {
            return PeriodSummary(snapshot: snapshot["periodSummary"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "periodSummary")
          }
        }

        public struct Projection: GraphQLSelectionSet {
          public static let possibleTypes = ["FIOFlowPeriodProjection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("net", type: .scalar(Double.self)),
            GraphQLField("incomeTotal", type: .scalar(Double.self)),
            GraphQLField("spendTotal", type: .scalar(Double.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(net: Double? = nil, incomeTotal: Double? = nil, spendTotal: Double? = nil) {
            self.init(snapshot: ["__typename": "FIOFlowPeriodProjection", "net": net, "incomeTotal": incomeTotal, "spendTotal": spendTotal])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var net: Double? {
            get {
              return snapshot["net"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "net")
            }
          }

          public var incomeTotal: Double? {
            get {
              return snapshot["incomeTotal"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "incomeTotal")
            }
          }

          public var spendTotal: Double? {
            get {
              return snapshot["spendTotal"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "spendTotal")
            }
          }
        }

        public struct PeriodSummary: GraphQLSelectionSet {
          public static let possibleTypes = ["FIOFlowPeriodDetail"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("spending", type: .nonNull(.object(Spending.selections))),
            GraphQLField("categories", type: .object(Category.selections)),
            GraphQLField("balances", type: .list(.nonNull(.object(Balance.selections)))),
            GraphQLField("isFillerObject", type: .scalar(Bool.self)),
            GraphQLField("netAmount", type: .nonNull(.scalar(Double.self))),
            GraphQLField("income", type: .nonNull(.scalar(Double.self))),
            GraphQLField("transactions", type: .object(Transaction.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(spending: Spending, categories: Category? = nil, balances: [Balance]? = nil, isFillerObject: Bool? = nil, netAmount: Double, income: Double, transactions: Transaction? = nil) {
            self.init(snapshot: ["__typename": "FIOFlowPeriodDetail", "spending": spending.snapshot, "categories": categories.flatMap { $0.snapshot }, "balances": balances.flatMap { $0.map { $0.snapshot } }, "isFillerObject": isFillerObject, "netAmount": netAmount, "income": income, "transactions": transactions.flatMap { $0.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var spending: Spending {
            get {
              return Spending(snapshot: snapshot["spending"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "spending")
            }
          }

          public var categories: Category? {
            get {
              return (snapshot["categories"] as? Snapshot).flatMap { Category(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "categories")
            }
          }

          public var balances: [Balance]? {
            get {
              return (snapshot["balances"] as? [Snapshot]).flatMap { $0.map { Balance(snapshot: $0) } }
            }
            set {
              snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "balances")
            }
          }

          public var isFillerObject: Bool? {
            get {
              return snapshot["isFillerObject"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "isFillerObject")
            }
          }

          public var netAmount: Double {
            get {
              return snapshot["netAmount"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "netAmount")
            }
          }

          public var income: Double {
            get {
              return snapshot["income"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "income")
            }
          }

          public var transactions: Transaction? {
            get {
              return (snapshot["transactions"] as? Snapshot).flatMap { Transaction(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "transactions")
            }
          }

          public struct Spending: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOFlowPeriodSpending"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("actual", type: .nonNull(.scalar(Double.self))),
              GraphQLField("target", type: .nonNull(.scalar(Double.self))),
              GraphQLField("projected", type: .scalar(Double.self)),
              GraphQLField("spendWithoutBle", type: .scalar(Double.self)),
              GraphQLField("spendBleAmortized", type: .scalar(Double.self)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(actual: Double, target: Double, projected: Double? = nil, spendWithoutBle: Double? = nil, spendBleAmortized: Double? = nil) {
              self.init(snapshot: ["__typename": "FIOFlowPeriodSpending", "actual": actual, "target": target, "projected": projected, "spendWithoutBle": spendWithoutBle, "spendBleAmortized": spendBleAmortized])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var actual: Double {
              get {
                return snapshot["actual"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "actual")
              }
            }

            public var target: Double {
              get {
                return snapshot["target"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "target")
              }
            }

            public var projected: Double? {
              get {
                return snapshot["projected"] as? Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "projected")
              }
            }

            public var spendWithoutBle: Double? {
              get {
                return snapshot["spendWithoutBle"] as? Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "spendWithoutBle")
              }
            }

            public var spendBleAmortized: Double? {
              get {
                return snapshot["spendBleAmortized"] as? Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "spendBleAmortized")
              }
            }
          }

          public struct Category: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOSpendCategories"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("total", type: .nonNull(.scalar(Double.self))),
              GraphQLField("names", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              GraphQLField("percentages", type: .nonNull(.list(.nonNull(.scalar(Double.self))))),
              GraphQLField("descriptions", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              GraphQLField("amounts", type: .nonNull(.list(.nonNull(.scalar(Double.self))))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(total: Double, names: [String], percentages: [Double], descriptions: [String], amounts: [Double]) {
              self.init(snapshot: ["__typename": "FIOSpendCategories", "total": total, "names": names, "percentages": percentages, "descriptions": descriptions, "amounts": amounts])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var total: Double {
              get {
                return snapshot["total"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "total")
              }
            }

            public var names: [String] {
              get {
                return snapshot["names"]! as! [String]
              }
              set {
                snapshot.updateValue(newValue, forKey: "names")
              }
            }

            public var percentages: [Double] {
              get {
                return snapshot["percentages"]! as! [Double]
              }
              set {
                snapshot.updateValue(newValue, forKey: "percentages")
              }
            }

            public var descriptions: [String] {
              get {
                return snapshot["descriptions"]! as! [String]
              }
              set {
                snapshot.updateValue(newValue, forKey: "descriptions")
              }
            }

            public var amounts: [Double] {
              get {
                return snapshot["amounts"]! as! [Double]
              }
              set {
                snapshot.updateValue(newValue, forKey: "amounts")
              }
            }
          }

          public struct Balance: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOPeriodBalance"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("accountSubtype", type: .nonNull(.scalar(String.self))),
              GraphQLField("startingBalance", type: .nonNull(.scalar(Double.self))),
              GraphQLField("endingBalance", type: .nonNull(.scalar(Double.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(accountSubtype: String, startingBalance: Double, endingBalance: Double) {
              self.init(snapshot: ["__typename": "FIOPeriodBalance", "accountSubtype": accountSubtype, "startingBalance": startingBalance, "endingBalance": endingBalance])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var accountSubtype: String {
              get {
                return snapshot["accountSubtype"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "accountSubtype")
              }
            }

            public var startingBalance: Double {
              get {
                return snapshot["startingBalance"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "startingBalance")
              }
            }

            public var endingBalance: Double {
              get {
                return snapshot["endingBalance"]! as! Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "endingBalance")
              }
            }
          }

          public struct Transaction: GraphQLSelectionSet {
            public static let possibleTypes = ["FIOFlowPeriodDetailTransactions"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("totalAmount", type: .scalar(Double.self)),
              GraphQLField("deposits", type: .object(Deposit.selections)),
              GraphQLField("debits", type: .object(Debit.selections)),
              GraphQLField("transfers", type: .object(Transfer.selections)),
              GraphQLField("regularIncome", type: .object(RegularIncome.selections)),
              GraphQLField("creditCardPayments", type: .object(CreditCardPayment.selections)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(totalAmount: Double? = nil, deposits: Deposit? = nil, debits: Debit? = nil, transfers: Transfer? = nil, regularIncome: RegularIncome? = nil, creditCardPayments: CreditCardPayment? = nil) {
              self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactions", "totalAmount": totalAmount, "deposits": deposits.flatMap { $0.snapshot }, "debits": debits.flatMap { $0.snapshot }, "transfers": transfers.flatMap { $0.snapshot }, "regularIncome": regularIncome.flatMap { $0.snapshot }, "creditCardPayments": creditCardPayments.flatMap { $0.snapshot }])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var totalAmount: Double? {
              get {
                return snapshot["totalAmount"] as? Double
              }
              set {
                snapshot.updateValue(newValue, forKey: "totalAmount")
              }
            }

            public var deposits: Deposit? {
              get {
                return (snapshot["deposits"] as? Snapshot).flatMap { Deposit(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "deposits")
              }
            }

            public var debits: Debit? {
              get {
                return (snapshot["debits"] as? Snapshot).flatMap { Debit(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "debits")
              }
            }

            public var transfers: Transfer? {
              get {
                return (snapshot["transfers"] as? Snapshot).flatMap { Transfer(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "transfers")
              }
            }

            public var regularIncome: RegularIncome? {
              get {
                return (snapshot["regularIncome"] as? Snapshot).flatMap { RegularIncome(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "regularIncome")
              }
            }

            public var creditCardPayments: CreditCardPayment? {
              get {
                return (snapshot["creditCardPayments"] as? Snapshot).flatMap { CreditCardPayment(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "creditCardPayments")
              }
            }

            public struct Deposit: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOFlowPeriodDetailTransactionSet"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("transactionIds", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, transactionIds: [String]) {
                self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactionSet", "totalAmount": totalAmount, "transactionIds": transactionIds])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var transactionIds: [String] {
                get {
                  return snapshot["transactionIds"]! as! [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "transactionIds")
                }
              }
            }

            public struct Debit: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOFlowPeriodDetailTransactionSet"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("transactionIds", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
                GraphQLField("transactions", type: .list(.nonNull(.object(Transaction.selections)))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, transactionIds: [String], transactions: [Transaction]? = nil) {
                self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactionSet", "totalAmount": totalAmount, "transactionIds": transactionIds, "transactions": transactions.flatMap { $0.map { $0.snapshot } }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var transactionIds: [String] {
                get {
                  return snapshot["transactionIds"]! as! [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "transactionIds")
                }
              }

              public var transactions: [Transaction]? {
                get {
                  return (snapshot["transactions"] as? [Snapshot]).flatMap { $0.map { Transaction(snapshot: $0) } }
                }
                set {
                  snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "transactions")
                }
              }

              public struct Transaction: GraphQLSelectionSet {
                public static let possibleTypes = ["FIOTransaction"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  GraphQLField("friendlyName", type: .scalar(String.self)),
                  GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
                  GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
                  GraphQLField("date", type: .nonNull(.scalar(String.self))),
                  GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                  GraphQLField("pending", type: .scalar(Bool.self)),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(name: String, friendlyName: String? = nil, amount: Double, transactionId: String, fioCategoryId: Int, date: String, masterAccountId: String, pending: Bool? = nil) {
                  self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "amount": amount, "transaction_id": transactionId, "fioCategoryId": fioCategoryId, "date": date, "masterAccountId": masterAccountId, "pending": pending])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var name: String {
                  get {
                    return snapshot["name"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "name")
                  }
                }

                public var friendlyName: String? {
                  get {
                    return snapshot["friendlyName"] as? String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "friendlyName")
                  }
                }

                public var amount: Double {
                  get {
                    return snapshot["amount"]! as! Double
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "amount")
                  }
                }

                public var transactionId: String {
                  get {
                    return snapshot["transaction_id"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "transaction_id")
                  }
                }

                public var fioCategoryId: Int {
                  get {
                    return snapshot["fioCategoryId"]! as! Int
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "fioCategoryId")
                  }
                }

                public var date: String {
                  get {
                    return snapshot["date"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "date")
                  }
                }

                public var masterAccountId: String {
                  get {
                    return snapshot["masterAccountId"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "masterAccountId")
                  }
                }

                public var pending: Bool? {
                  get {
                    return snapshot["pending"] as? Bool
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "pending")
                  }
                }
              }
            }

            public struct Transfer: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOFlowPeriodDetailTransactionSet"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("transactionIds", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
                GraphQLField("transactionSummaries", type: .list(.nonNull(.object(TransactionSummary.selections)))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, transactionIds: [String], transactionSummaries: [TransactionSummary]? = nil) {
                self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactionSet", "totalAmount": totalAmount, "transactionIds": transactionIds, "transactionSummaries": transactionSummaries.flatMap { $0.map { $0.snapshot } }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var transactionIds: [String] {
                get {
                  return snapshot["transactionIds"]! as! [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "transactionIds")
                }
              }

              public var transactionSummaries: [TransactionSummary]? {
                get {
                  return (snapshot["transactionSummaries"] as? [Snapshot]).flatMap { $0.map { TransactionSummary(snapshot: $0) } }
                }
                set {
                  snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "transactionSummaries")
                }
              }

              public struct TransactionSummary: GraphQLSelectionSet {
                public static let possibleTypes = ["FIOTransaction"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("friendlyName", type: .scalar(String.self)),
                  GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
                  GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(friendlyName: String? = nil, transactionId: String, amount: Double, fioCategoryId: Int) {
                  self.init(snapshot: ["__typename": "FIOTransaction", "friendlyName": friendlyName, "transaction_id": transactionId, "amount": amount, "fioCategoryId": fioCategoryId])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var friendlyName: String? {
                  get {
                    return snapshot["friendlyName"] as? String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "friendlyName")
                  }
                }

                public var transactionId: String {
                  get {
                    return snapshot["transaction_id"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "transaction_id")
                  }
                }

                public var amount: Double {
                  get {
                    return snapshot["amount"]! as! Double
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "amount")
                  }
                }

                public var fioCategoryId: Int {
                  get {
                    return snapshot["fioCategoryId"]! as! Int
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "fioCategoryId")
                  }
                }
              }
            }

            public struct RegularIncome: GraphQLSelectionSet {
              public static let possibleTypes = ["FIOFlowPeriodDetailTransactionSet"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("transactionIds", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, transactionIds: [String]) {
                self.init(snapshot: ["__typename": "FIOFlowPeriodDetailTransactionSet", "totalAmount": totalAmount, "transactionIds": transactionIds])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var transactionIds: [String] {
                get {
                  return snapshot["transactionIds"]! as! [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "transactionIds")
                }
              }
            }

            public struct CreditCardPayment: GraphQLSelectionSet {
              public static let possibleTypes = ["QIOFlowPeriodCreditCardPayments"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalAmount", type: .nonNull(.scalar(Double.self))),
                GraphQLField("destinationAccountNames", type: .list(.nonNull(.scalar(String.self)))),
                GraphQLField("sourceAccountNames", type: .list(.nonNull(.scalar(String.self)))),
                GraphQLField("payments", type: .nonNull(.list(.nonNull(.object(Payment.selections))))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalAmount: Double, destinationAccountNames: [String]? = nil, sourceAccountNames: [String]? = nil, payments: [Payment]) {
                self.init(snapshot: ["__typename": "QIOFlowPeriodCreditCardPayments", "totalAmount": totalAmount, "destinationAccountNames": destinationAccountNames, "sourceAccountNames": sourceAccountNames, "payments": payments.map { $0.snapshot }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var totalAmount: Double {
                get {
                  return snapshot["totalAmount"]! as! Double
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalAmount")
                }
              }

              public var destinationAccountNames: [String]? {
                get {
                  return snapshot["destinationAccountNames"] as? [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "destinationAccountNames")
                }
              }

              public var sourceAccountNames: [String]? {
                get {
                  return snapshot["sourceAccountNames"] as? [String]
                }
                set {
                  snapshot.updateValue(newValue, forKey: "sourceAccountNames")
                }
              }

              public var payments: [Payment] {
                get {
                  return (snapshot["payments"] as! [Snapshot]).map { Payment(snapshot: $0) }
                }
                set {
                  snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "payments")
                }
              }

              public struct Payment: GraphQLSelectionSet {
                public static let possibleTypes = ["QIOFlowPeriodCreditCardPaymentItem"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("from", type: .object(From.selections)),
                  GraphQLField("to", type: .object(To.selections)),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(amount: Double, from: From? = nil, to: To? = nil) {
                  self.init(snapshot: ["__typename": "QIOFlowPeriodCreditCardPaymentItem", "amount": amount, "from": from.flatMap { $0.snapshot }, "to": to.flatMap { $0.snapshot }])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var amount: Double {
                  get {
                    return snapshot["amount"]! as! Double
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "amount")
                  }
                }

                public var from: From? {
                  get {
                    return (snapshot["from"] as? Snapshot).flatMap { From(snapshot: $0) }
                  }
                  set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "from")
                  }
                }

                public var to: To? {
                  get {
                    return (snapshot["to"] as? Snapshot).flatMap { To(snapshot: $0) }
                  }
                  set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "to")
                  }
                }

                public struct From: GraphQLSelectionSet {
                  public static let possibleTypes = ["FIOTransaction"]

                  public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                    GraphQLField("friendlyName", type: .scalar(String.self)),
                    GraphQLField("date", type: .nonNull(.scalar(String.self))),
                    GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("category", type: .list(.scalar(String.self))),
                    GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                    GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("account", type: .object(Account.selections)),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("account_owner", type: .scalar(String.self)),
                    GraphQLField("category_id", type: .scalar(Double.self)),
                    GraphQLField("insertTimestamp", type: .scalar(Double.self)),
                    GraphQLField("institution_id", type: .scalar(String.self)),
                    GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pending", type: .scalar(Bool.self)),
                    GraphQLField("pending_transaction_id", type: .scalar(String.self)),
                    GraphQLField("transaction_type", type: .scalar(String.self)),
                    GraphQLField("account_name", type: .scalar(String.self)),
                    GraphQLField("account_institution_name", type: .scalar(String.self)),
                    GraphQLField("payment_meta", type: .object(PaymentMetum.selections)),
                  ]

                  public var snapshot: Snapshot

                  public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                  }

                  public init(name: String, friendlyName: String? = nil, date: String, amount: Double, transactionId: String, category: [String?]? = nil, masterAccountId: String, fioCategoryId: Int, account: Account? = nil, accountOwner: String? = nil, categoryId: Double? = nil, insertTimestamp: Double? = nil, institutionId: String? = nil, itemId: String, pending: Bool? = nil, pendingTransactionId: String? = nil, transactionType: String? = nil, accountName: String? = nil, accountInstitutionName: String? = nil, paymentMeta: PaymentMetum? = nil) {
                    self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "date": date, "amount": amount, "transaction_id": transactionId, "category": category, "masterAccountId": masterAccountId, "fioCategoryId": fioCategoryId, "account": account.flatMap { $0.snapshot }, "account_owner": accountOwner, "category_id": categoryId, "insertTimestamp": insertTimestamp, "institution_id": institutionId, "item_id": itemId, "pending": pending, "pending_transaction_id": pendingTransactionId, "transaction_type": transactionType, "account_name": accountName, "account_institution_name": accountInstitutionName, "payment_meta": paymentMeta.flatMap { $0.snapshot }])
                  }

                  public var __typename: String {
                    get {
                      return snapshot["__typename"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var name: String {
                    get {
                      return snapshot["name"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "name")
                    }
                  }

                  public var friendlyName: String? {
                    get {
                      return snapshot["friendlyName"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "friendlyName")
                    }
                  }

                  public var date: String {
                    get {
                      return snapshot["date"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "date")
                    }
                  }

                  public var amount: Double {
                    get {
                      return snapshot["amount"]! as! Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "amount")
                    }
                  }

                  public var transactionId: String {
                    get {
                      return snapshot["transaction_id"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "transaction_id")
                    }
                  }

                  public var category: [String?]? {
                    get {
                      return snapshot["category"] as? [String?]
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "category")
                    }
                  }

                  public var masterAccountId: String {
                    get {
                      return snapshot["masterAccountId"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "masterAccountId")
                    }
                  }

                  public var fioCategoryId: Int {
                    get {
                      return snapshot["fioCategoryId"]! as! Int
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "fioCategoryId")
                    }
                  }

                  public var account: Account? {
                    get {
                      return (snapshot["account"] as? Snapshot).flatMap { Account(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "account")
                    }
                  }

                  public var accountOwner: String? {
                    get {
                      return snapshot["account_owner"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_owner")
                    }
                  }

                  public var categoryId: Double? {
                    get {
                      return snapshot["category_id"] as? Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "category_id")
                    }
                  }

                  public var insertTimestamp: Double? {
                    get {
                      return snapshot["insertTimestamp"] as? Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "insertTimestamp")
                    }
                  }

                  public var institutionId: String? {
                    get {
                      return snapshot["institution_id"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "institution_id")
                    }
                  }

                  public var itemId: String {
                    get {
                      return snapshot["item_id"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "item_id")
                    }
                  }

                  public var pending: Bool? {
                    get {
                      return snapshot["pending"] as? Bool
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "pending")
                    }
                  }

                  public var pendingTransactionId: String? {
                    get {
                      return snapshot["pending_transaction_id"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "pending_transaction_id")
                    }
                  }

                  public var transactionType: String? {
                    get {
                      return snapshot["transaction_type"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "transaction_type")
                    }
                  }

                  public var accountName: String? {
                    get {
                      return snapshot["account_name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_name")
                    }
                  }

                  public var accountInstitutionName: String? {
                    get {
                      return snapshot["account_institution_name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_institution_name")
                    }
                  }

                  public var paymentMeta: PaymentMetum? {
                    get {
                      return (snapshot["payment_meta"] as? Snapshot).flatMap { PaymentMetum(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "payment_meta")
                    }
                  }

                  public var fragments: Fragments {
                    get {
                      return Fragments(snapshot: snapshot)
                    }
                    set {
                      snapshot += newValue.snapshot
                    }
                  }

                  public struct Fragments {
                    public var snapshot: Snapshot

                    public var transactionDetails: TransactionDetails {
                      get {
                        return TransactionDetails(snapshot: snapshot)
                      }
                      set {
                        snapshot += newValue.snapshot
                      }
                    }
                  }

                  public struct Account: GraphQLSelectionSet {
                    public static let possibleTypes = ["FIOFinAccount"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("displayName", type: .scalar(String.self)),
                      GraphQLField("hidden", type: .scalar(Bool.self)),
                      GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                      GraphQLField("institution_id", type: .nonNull(.scalar(String.self))),
                      GraphQLField("balances", type: .object(Balance.selections)),
                      GraphQLField("institution_name", type: .nonNull(.scalar(String.self))),
                      GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
                      GraphQLField("lastSynced", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("mask", type: .scalar(String.self)),
                      GraphQLField("name", type: .nonNull(.scalar(String.self))),
                      GraphQLField("official_name", type: .scalar(String.self)),
                      GraphQLField("subtype", type: .nonNull(.scalar(String.self))),
                      GraphQLField("type", type: .nonNull(.scalar(String.self))),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(displayName: String? = nil, hidden: Bool? = nil, masterAccountId: String, institutionId: String, balances: Balance? = nil, institutionName: String, itemId: String, lastSynced: Double, mask: String? = nil, name: String, officialName: String? = nil, subtype: String, type: String) {
                      self.init(snapshot: ["__typename": "FIOFinAccount", "displayName": displayName, "hidden": hidden, "masterAccountId": masterAccountId, "institution_id": institutionId, "balances": balances.flatMap { $0.snapshot }, "institution_name": institutionName, "item_id": itemId, "lastSynced": lastSynced, "mask": mask, "name": name, "official_name": officialName, "subtype": subtype, "type": type])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var displayName: String? {
                      get {
                        return snapshot["displayName"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "displayName")
                      }
                    }

                    public var hidden: Bool? {
                      get {
                        return snapshot["hidden"] as? Bool
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "hidden")
                      }
                    }

                    public var masterAccountId: String {
                      get {
                        return snapshot["masterAccountId"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "masterAccountId")
                      }
                    }

                    public var institutionId: String {
                      get {
                        return snapshot["institution_id"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "institution_id")
                      }
                    }

                    public var balances: Balance? {
                      get {
                        return (snapshot["balances"] as? Snapshot).flatMap { Balance(snapshot: $0) }
                      }
                      set {
                        snapshot.updateValue(newValue?.snapshot, forKey: "balances")
                      }
                    }

                    public var institutionName: String {
                      get {
                        return snapshot["institution_name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "institution_name")
                      }
                    }

                    public var itemId: String {
                      get {
                        return snapshot["item_id"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "item_id")
                      }
                    }

                    public var lastSynced: Double {
                      get {
                        return snapshot["lastSynced"]! as! Double
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "lastSynced")
                      }
                    }

                    public var mask: String? {
                      get {
                        return snapshot["mask"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "mask")
                      }
                    }

                    public var name: String {
                      get {
                        return snapshot["name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "name")
                      }
                    }

                    public var officialName: String? {
                      get {
                        return snapshot["official_name"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "official_name")
                      }
                    }

                    public var subtype: String {
                      get {
                        return snapshot["subtype"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "subtype")
                      }
                    }

                    public var type: String {
                      get {
                        return snapshot["type"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "type")
                      }
                    }

                    public struct Balance: GraphQLSelectionSet {
                      public static let possibleTypes = ["FIOFinAccountBalances"]

                      public static let selections: [GraphQLSelection] = [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("available", type: .scalar(Double.self)),
                        GraphQLField("limit", type: .scalar(Double.self)),
                        GraphQLField("current", type: .scalar(Double.self)),
                      ]

                      public var snapshot: Snapshot

                      public init(snapshot: Snapshot) {
                        self.snapshot = snapshot
                      }

                      public init(available: Double? = nil, limit: Double? = nil, current: Double? = nil) {
                        self.init(snapshot: ["__typename": "FIOFinAccountBalances", "available": available, "limit": limit, "current": current])
                      }

                      public var __typename: String {
                        get {
                          return snapshot["__typename"]! as! String
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "__typename")
                        }
                      }

                      public var available: Double? {
                        get {
                          return snapshot["available"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "available")
                        }
                      }

                      public var limit: Double? {
                        get {
                          return snapshot["limit"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "limit")
                        }
                      }

                      public var current: Double? {
                        get {
                          return snapshot["current"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "current")
                        }
                      }
                    }
                  }

                  public struct PaymentMetum: GraphQLSelectionSet {
                    public static let possibleTypes = ["FIOTransactionPaymentMetadata"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("by_order_of", type: .scalar(String.self)),
                      GraphQLField("payee", type: .scalar(String.self)),
                      GraphQLField("payer", type: .scalar(String.self)),
                      GraphQLField("payment_method", type: .scalar(String.self)),
                      GraphQLField("payment_processor", type: .scalar(String.self)),
                      GraphQLField("ppd_id", type: .scalar(String.self)),
                      GraphQLField("reason", type: .scalar(String.self)),
                      GraphQLField("reference_number", type: .scalar(String.self)),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(byOrderOf: String? = nil, payee: String? = nil, payer: String? = nil, paymentMethod: String? = nil, paymentProcessor: String? = nil, ppdId: String? = nil, reason: String? = nil, referenceNumber: String? = nil) {
                      self.init(snapshot: ["__typename": "FIOTransactionPaymentMetadata", "by_order_of": byOrderOf, "payee": payee, "payer": payer, "payment_method": paymentMethod, "payment_processor": paymentProcessor, "ppd_id": ppdId, "reason": reason, "reference_number": referenceNumber])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var byOrderOf: String? {
                      get {
                        return snapshot["by_order_of"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "by_order_of")
                      }
                    }

                    public var payee: String? {
                      get {
                        return snapshot["payee"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payee")
                      }
                    }

                    public var payer: String? {
                      get {
                        return snapshot["payer"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payer")
                      }
                    }

                    public var paymentMethod: String? {
                      get {
                        return snapshot["payment_method"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payment_method")
                      }
                    }

                    public var paymentProcessor: String? {
                      get {
                        return snapshot["payment_processor"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payment_processor")
                      }
                    }

                    public var ppdId: String? {
                      get {
                        return snapshot["ppd_id"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "ppd_id")
                      }
                    }

                    public var reason: String? {
                      get {
                        return snapshot["reason"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "reason")
                      }
                    }

                    public var referenceNumber: String? {
                      get {
                        return snapshot["reference_number"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "reference_number")
                      }
                    }
                  }
                }

                public struct To: GraphQLSelectionSet {
                  public static let possibleTypes = ["FIOTransaction"]

                  public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                    GraphQLField("friendlyName", type: .scalar(String.self)),
                    GraphQLField("date", type: .nonNull(.scalar(String.self))),
                    GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("category", type: .list(.scalar(String.self))),
                    GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                    GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("account", type: .object(Account.selections)),
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("account_owner", type: .scalar(String.self)),
                    GraphQLField("category_id", type: .scalar(Double.self)),
                    GraphQLField("insertTimestamp", type: .scalar(Double.self)),
                    GraphQLField("institution_id", type: .scalar(String.self)),
                    GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pending", type: .scalar(Bool.self)),
                    GraphQLField("pending_transaction_id", type: .scalar(String.self)),
                    GraphQLField("transaction_type", type: .scalar(String.self)),
                    GraphQLField("account_name", type: .scalar(String.self)),
                    GraphQLField("account_institution_name", type: .scalar(String.self)),
                    GraphQLField("payment_meta", type: .object(PaymentMetum.selections)),
                  ]

                  public var snapshot: Snapshot

                  public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                  }

                  public init(name: String, friendlyName: String? = nil, date: String, amount: Double, transactionId: String, category: [String?]? = nil, masterAccountId: String, fioCategoryId: Int, account: Account? = nil, accountOwner: String? = nil, categoryId: Double? = nil, insertTimestamp: Double? = nil, institutionId: String? = nil, itemId: String, pending: Bool? = nil, pendingTransactionId: String? = nil, transactionType: String? = nil, accountName: String? = nil, accountInstitutionName: String? = nil, paymentMeta: PaymentMetum? = nil) {
                    self.init(snapshot: ["__typename": "FIOTransaction", "name": name, "friendlyName": friendlyName, "date": date, "amount": amount, "transaction_id": transactionId, "category": category, "masterAccountId": masterAccountId, "fioCategoryId": fioCategoryId, "account": account.flatMap { $0.snapshot }, "account_owner": accountOwner, "category_id": categoryId, "insertTimestamp": insertTimestamp, "institution_id": institutionId, "item_id": itemId, "pending": pending, "pending_transaction_id": pendingTransactionId, "transaction_type": transactionType, "account_name": accountName, "account_institution_name": accountInstitutionName, "payment_meta": paymentMeta.flatMap { $0.snapshot }])
                  }

                  public var __typename: String {
                    get {
                      return snapshot["__typename"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var name: String {
                    get {
                      return snapshot["name"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "name")
                    }
                  }

                  public var friendlyName: String? {
                    get {
                      return snapshot["friendlyName"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "friendlyName")
                    }
                  }

                  public var date: String {
                    get {
                      return snapshot["date"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "date")
                    }
                  }

                  public var amount: Double {
                    get {
                      return snapshot["amount"]! as! Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "amount")
                    }
                  }

                  public var transactionId: String {
                    get {
                      return snapshot["transaction_id"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "transaction_id")
                    }
                  }

                  public var category: [String?]? {
                    get {
                      return snapshot["category"] as? [String?]
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "category")
                    }
                  }

                  public var masterAccountId: String {
                    get {
                      return snapshot["masterAccountId"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "masterAccountId")
                    }
                  }

                  public var fioCategoryId: Int {
                    get {
                      return snapshot["fioCategoryId"]! as! Int
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "fioCategoryId")
                    }
                  }

                  public var account: Account? {
                    get {
                      return (snapshot["account"] as? Snapshot).flatMap { Account(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "account")
                    }
                  }

                  public var accountOwner: String? {
                    get {
                      return snapshot["account_owner"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_owner")
                    }
                  }

                  public var categoryId: Double? {
                    get {
                      return snapshot["category_id"] as? Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "category_id")
                    }
                  }

                  public var insertTimestamp: Double? {
                    get {
                      return snapshot["insertTimestamp"] as? Double
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "insertTimestamp")
                    }
                  }

                  public var institutionId: String? {
                    get {
                      return snapshot["institution_id"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "institution_id")
                    }
                  }

                  public var itemId: String {
                    get {
                      return snapshot["item_id"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "item_id")
                    }
                  }

                  public var pending: Bool? {
                    get {
                      return snapshot["pending"] as? Bool
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "pending")
                    }
                  }

                  public var pendingTransactionId: String? {
                    get {
                      return snapshot["pending_transaction_id"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "pending_transaction_id")
                    }
                  }

                  public var transactionType: String? {
                    get {
                      return snapshot["transaction_type"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "transaction_type")
                    }
                  }

                  public var accountName: String? {
                    get {
                      return snapshot["account_name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_name")
                    }
                  }

                  public var accountInstitutionName: String? {
                    get {
                      return snapshot["account_institution_name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "account_institution_name")
                    }
                  }

                  public var paymentMeta: PaymentMetum? {
                    get {
                      return (snapshot["payment_meta"] as? Snapshot).flatMap { PaymentMetum(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "payment_meta")
                    }
                  }

                  public var fragments: Fragments {
                    get {
                      return Fragments(snapshot: snapshot)
                    }
                    set {
                      snapshot += newValue.snapshot
                    }
                  }

                  public struct Fragments {
                    public var snapshot: Snapshot

                    public var transactionDetails: TransactionDetails {
                      get {
                        return TransactionDetails(snapshot: snapshot)
                      }
                      set {
                        snapshot += newValue.snapshot
                      }
                    }
                  }

                  public struct Account: GraphQLSelectionSet {
                    public static let possibleTypes = ["FIOFinAccount"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("displayName", type: .scalar(String.self)),
                      GraphQLField("hidden", type: .scalar(Bool.self)),
                      GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
                      GraphQLField("institution_id", type: .nonNull(.scalar(String.self))),
                      GraphQLField("balances", type: .object(Balance.selections)),
                      GraphQLField("institution_name", type: .nonNull(.scalar(String.self))),
                      GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
                      GraphQLField("lastSynced", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("mask", type: .scalar(String.self)),
                      GraphQLField("name", type: .nonNull(.scalar(String.self))),
                      GraphQLField("official_name", type: .scalar(String.self)),
                      GraphQLField("subtype", type: .nonNull(.scalar(String.self))),
                      GraphQLField("type", type: .nonNull(.scalar(String.self))),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(displayName: String? = nil, hidden: Bool? = nil, masterAccountId: String, institutionId: String, balances: Balance? = nil, institutionName: String, itemId: String, lastSynced: Double, mask: String? = nil, name: String, officialName: String? = nil, subtype: String, type: String) {
                      self.init(snapshot: ["__typename": "FIOFinAccount", "displayName": displayName, "hidden": hidden, "masterAccountId": masterAccountId, "institution_id": institutionId, "balances": balances.flatMap { $0.snapshot }, "institution_name": institutionName, "item_id": itemId, "lastSynced": lastSynced, "mask": mask, "name": name, "official_name": officialName, "subtype": subtype, "type": type])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var displayName: String? {
                      get {
                        return snapshot["displayName"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "displayName")
                      }
                    }

                    public var hidden: Bool? {
                      get {
                        return snapshot["hidden"] as? Bool
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "hidden")
                      }
                    }

                    public var masterAccountId: String {
                      get {
                        return snapshot["masterAccountId"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "masterAccountId")
                      }
                    }

                    public var institutionId: String {
                      get {
                        return snapshot["institution_id"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "institution_id")
                      }
                    }

                    public var balances: Balance? {
                      get {
                        return (snapshot["balances"] as? Snapshot).flatMap { Balance(snapshot: $0) }
                      }
                      set {
                        snapshot.updateValue(newValue?.snapshot, forKey: "balances")
                      }
                    }

                    public var institutionName: String {
                      get {
                        return snapshot["institution_name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "institution_name")
                      }
                    }

                    public var itemId: String {
                      get {
                        return snapshot["item_id"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "item_id")
                      }
                    }

                    public var lastSynced: Double {
                      get {
                        return snapshot["lastSynced"]! as! Double
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "lastSynced")
                      }
                    }

                    public var mask: String? {
                      get {
                        return snapshot["mask"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "mask")
                      }
                    }

                    public var name: String {
                      get {
                        return snapshot["name"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "name")
                      }
                    }

                    public var officialName: String? {
                      get {
                        return snapshot["official_name"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "official_name")
                      }
                    }

                    public var subtype: String {
                      get {
                        return snapshot["subtype"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "subtype")
                      }
                    }

                    public var type: String {
                      get {
                        return snapshot["type"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "type")
                      }
                    }

                    public struct Balance: GraphQLSelectionSet {
                      public static let possibleTypes = ["FIOFinAccountBalances"]

                      public static let selections: [GraphQLSelection] = [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("available", type: .scalar(Double.self)),
                        GraphQLField("limit", type: .scalar(Double.self)),
                        GraphQLField("current", type: .scalar(Double.self)),
                      ]

                      public var snapshot: Snapshot

                      public init(snapshot: Snapshot) {
                        self.snapshot = snapshot
                      }

                      public init(available: Double? = nil, limit: Double? = nil, current: Double? = nil) {
                        self.init(snapshot: ["__typename": "FIOFinAccountBalances", "available": available, "limit": limit, "current": current])
                      }

                      public var __typename: String {
                        get {
                          return snapshot["__typename"]! as! String
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "__typename")
                        }
                      }

                      public var available: Double? {
                        get {
                          return snapshot["available"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "available")
                        }
                      }

                      public var limit: Double? {
                        get {
                          return snapshot["limit"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "limit")
                        }
                      }

                      public var current: Double? {
                        get {
                          return snapshot["current"] as? Double
                        }
                        set {
                          snapshot.updateValue(newValue, forKey: "current")
                        }
                      }
                    }
                  }

                  public struct PaymentMetum: GraphQLSelectionSet {
                    public static let possibleTypes = ["FIOTransactionPaymentMetadata"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("by_order_of", type: .scalar(String.self)),
                      GraphQLField("payee", type: .scalar(String.self)),
                      GraphQLField("payer", type: .scalar(String.self)),
                      GraphQLField("payment_method", type: .scalar(String.self)),
                      GraphQLField("payment_processor", type: .scalar(String.self)),
                      GraphQLField("ppd_id", type: .scalar(String.self)),
                      GraphQLField("reason", type: .scalar(String.self)),
                      GraphQLField("reference_number", type: .scalar(String.self)),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(byOrderOf: String? = nil, payee: String? = nil, payer: String? = nil, paymentMethod: String? = nil, paymentProcessor: String? = nil, ppdId: String? = nil, reason: String? = nil, referenceNumber: String? = nil) {
                      self.init(snapshot: ["__typename": "FIOTransactionPaymentMetadata", "by_order_of": byOrderOf, "payee": payee, "payer": payer, "payment_method": paymentMethod, "payment_processor": paymentProcessor, "ppd_id": ppdId, "reason": reason, "reference_number": referenceNumber])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var byOrderOf: String? {
                      get {
                        return snapshot["by_order_of"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "by_order_of")
                      }
                    }

                    public var payee: String? {
                      get {
                        return snapshot["payee"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payee")
                      }
                    }

                    public var payer: String? {
                      get {
                        return snapshot["payer"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payer")
                      }
                    }

                    public var paymentMethod: String? {
                      get {
                        return snapshot["payment_method"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payment_method")
                      }
                    }

                    public var paymentProcessor: String? {
                      get {
                        return snapshot["payment_processor"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "payment_processor")
                      }
                    }

                    public var ppdId: String? {
                      get {
                        return snapshot["ppd_id"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "ppd_id")
                      }
                    }

                    public var reason: String? {
                      get {
                        return snapshot["reason"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "reason")
                      }
                    }

                    public var referenceNumber: String? {
                      get {
                        return snapshot["reference_number"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "reference_number")
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      public struct Streak: GraphQLSelectionSet {
        public static let possibleTypes = ["QIOUserHomeStreaks"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("days", type: .nonNull(.object(Day.selections))),
          GraphQLField("weeks", type: .nonNull(.object(Week.selections))),
          GraphQLField("months", type: .nonNull(.object(Month.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(days: Day, weeks: Week, months: Month) {
          self.init(snapshot: ["__typename": "QIOUserHomeStreaks", "days": days.snapshot, "weeks": weeks.snapshot, "months": months.snapshot])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var days: Day {
          get {
            return Day(snapshot: snapshot["days"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "days")
          }
        }

        public var weeks: Week {
          get {
            return Week(snapshot: snapshot["weeks"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "weeks")
          }
        }

        public var months: Month {
          get {
            return Month(snapshot: snapshot["months"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "months")
          }
        }

        public struct Day: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOUserHomeStreak"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("periodCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("extendsToBeginningOfData", type: .nonNull(.scalar(Bool.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(periodCount: Int, extendsToBeginningOfData: Bool) {
            self.init(snapshot: ["__typename": "QIOUserHomeStreak", "periodCount": periodCount, "extendsToBeginningOfData": extendsToBeginningOfData])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var periodCount: Int {
            get {
              return snapshot["periodCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "periodCount")
            }
          }

          public var extendsToBeginningOfData: Bool {
            get {
              return snapshot["extendsToBeginningOfData"]! as! Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "extendsToBeginningOfData")
            }
          }
        }

        public struct Week: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOUserHomeStreak"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("periodCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("extendsToBeginningOfData", type: .nonNull(.scalar(Bool.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(periodCount: Int, extendsToBeginningOfData: Bool) {
            self.init(snapshot: ["__typename": "QIOUserHomeStreak", "periodCount": periodCount, "extendsToBeginningOfData": extendsToBeginningOfData])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var periodCount: Int {
            get {
              return snapshot["periodCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "periodCount")
            }
          }

          public var extendsToBeginningOfData: Bool {
            get {
              return snapshot["extendsToBeginningOfData"]! as! Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "extendsToBeginningOfData")
            }
          }
        }

        public struct Month: GraphQLSelectionSet {
          public static let possibleTypes = ["QIOUserHomeStreak"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("periodCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("extendsToBeginningOfData", type: .nonNull(.scalar(Bool.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(periodCount: Int, extendsToBeginningOfData: Bool) {
            self.init(snapshot: ["__typename": "QIOUserHomeStreak", "periodCount": periodCount, "extendsToBeginningOfData": extendsToBeginningOfData])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var periodCount: Int {
            get {
              return snapshot["periodCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "periodCount")
            }
          }

          public var extendsToBeginningOfData: Bool {
            get {
              return snapshot["extendsToBeginningOfData"]! as! Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "extendsToBeginningOfData")
            }
          }
        }
      }
    }
  }
}

public struct TransactionSearchResult: GraphQLFragment {
  public static let fragmentString =
    "fragment transactionSearchResult on FIOTransaction {\n  __typename\n  date\n  masterAccountId\n  transaction_type\n  institution_id\n  item_id\n  amount\n  fioCategoryId\n  category_id\n  transaction_id\n  name\n  friendlyName\n}"

  public static let possibleTypes = ["FIOTransaction"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("date", type: .nonNull(.scalar(String.self))),
    GraphQLField("masterAccountId", type: .nonNull(.scalar(String.self))),
    GraphQLField("transaction_type", type: .scalar(String.self)),
    GraphQLField("institution_id", type: .scalar(String.self)),
    GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("amount", type: .nonNull(.scalar(Double.self))),
    GraphQLField("fioCategoryId", type: .nonNull(.scalar(Int.self))),
    GraphQLField("category_id", type: .scalar(Double.self)),
    GraphQLField("transaction_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("friendlyName", type: .scalar(String.self)),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(date: String, masterAccountId: String, transactionType: String? = nil, institutionId: String? = nil, itemId: String, amount: Double, fioCategoryId: Int, categoryId: Double? = nil, transactionId: String, name: String, friendlyName: String? = nil) {
    self.init(snapshot: ["__typename": "FIOTransaction", "date": date, "masterAccountId": masterAccountId, "transaction_type": transactionType, "institution_id": institutionId, "item_id": itemId, "amount": amount, "fioCategoryId": fioCategoryId, "category_id": categoryId, "transaction_id": transactionId, "name": name, "friendlyName": friendlyName])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  public var date: String {
    get {
      return snapshot["date"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "date")
    }
  }

  public var masterAccountId: String {
    get {
      return snapshot["masterAccountId"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "masterAccountId")
    }
  }

  public var transactionType: String? {
    get {
      return snapshot["transaction_type"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "transaction_type")
    }
  }

  public var institutionId: String? {
    get {
      return snapshot["institution_id"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "institution_id")
    }
  }

  public var itemId: String {
    get {
      return snapshot["item_id"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "item_id")
    }
  }

  public var amount: Double {
    get {
      return snapshot["amount"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "amount")
    }
  }

  public var fioCategoryId: Int {
    get {
      return snapshot["fioCategoryId"]! as! Int
    }
    set {
      snapshot.updateValue(newValue, forKey: "fioCategoryId")
    }
  }

  public var categoryId: Double? {
    get {
      return snapshot["category_id"] as? Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "category_id")
    }
  }

  public var transactionId: String {
    get {
      return snapshot["transaction_id"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "transaction_id")
    }
  }

  public var name: String {
    get {
      return snapshot["name"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "name")
    }
  }

  public var friendlyName: String? {
    get {
      return snapshot["friendlyName"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "friendlyName")
    }
  }
}

public struct TransactionDetails: GraphQLFragment {
  public static let fragmentString =
    "fragment transactionDetails on FIOTransaction {\n  __typename\n  account_owner\n  category_id\n  insertTimestamp\n  institution_id\n  item_id\n  pending\n  pending_transaction_id\n  transaction_type\n  account_name\n  account_institution_name\n  payment_meta {\n    __typename\n    by_order_of\n    payee\n    payer\n    payment_method\n    payment_processor\n    ppd_id\n    reason\n    reference_number\n  }\n}"

  public static let possibleTypes = ["FIOTransaction"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("account_owner", type: .scalar(String.self)),
    GraphQLField("category_id", type: .scalar(Double.self)),
    GraphQLField("insertTimestamp", type: .scalar(Double.self)),
    GraphQLField("institution_id", type: .scalar(String.self)),
    GraphQLField("item_id", type: .nonNull(.scalar(String.self))),
    GraphQLField("pending", type: .scalar(Bool.self)),
    GraphQLField("pending_transaction_id", type: .scalar(String.self)),
    GraphQLField("transaction_type", type: .scalar(String.self)),
    GraphQLField("account_name", type: .scalar(String.self)),
    GraphQLField("account_institution_name", type: .scalar(String.self)),
    GraphQLField("payment_meta", type: .object(PaymentMetum.selections)),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(accountOwner: String? = nil, categoryId: Double? = nil, insertTimestamp: Double? = nil, institutionId: String? = nil, itemId: String, pending: Bool? = nil, pendingTransactionId: String? = nil, transactionType: String? = nil, accountName: String? = nil, accountInstitutionName: String? = nil, paymentMeta: PaymentMetum? = nil) {
    self.init(snapshot: ["__typename": "FIOTransaction", "account_owner": accountOwner, "category_id": categoryId, "insertTimestamp": insertTimestamp, "institution_id": institutionId, "item_id": itemId, "pending": pending, "pending_transaction_id": pendingTransactionId, "transaction_type": transactionType, "account_name": accountName, "account_institution_name": accountInstitutionName, "payment_meta": paymentMeta.flatMap { $0.snapshot }])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  public var accountOwner: String? {
    get {
      return snapshot["account_owner"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "account_owner")
    }
  }

  public var categoryId: Double? {
    get {
      return snapshot["category_id"] as? Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "category_id")
    }
  }

  public var insertTimestamp: Double? {
    get {
      return snapshot["insertTimestamp"] as? Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "insertTimestamp")
    }
  }

  public var institutionId: String? {
    get {
      return snapshot["institution_id"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "institution_id")
    }
  }

  public var itemId: String {
    get {
      return snapshot["item_id"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "item_id")
    }
  }

  public var pending: Bool? {
    get {
      return snapshot["pending"] as? Bool
    }
    set {
      snapshot.updateValue(newValue, forKey: "pending")
    }
  }

  public var pendingTransactionId: String? {
    get {
      return snapshot["pending_transaction_id"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "pending_transaction_id")
    }
  }

  public var transactionType: String? {
    get {
      return snapshot["transaction_type"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "transaction_type")
    }
  }

  public var accountName: String? {
    get {
      return snapshot["account_name"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "account_name")
    }
  }

  public var accountInstitutionName: String? {
    get {
      return snapshot["account_institution_name"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "account_institution_name")
    }
  }

  public var paymentMeta: PaymentMetum? {
    get {
      return (snapshot["payment_meta"] as? Snapshot).flatMap { PaymentMetum(snapshot: $0) }
    }
    set {
      snapshot.updateValue(newValue?.snapshot, forKey: "payment_meta")
    }
  }

  public struct PaymentMetum: GraphQLSelectionSet {
    public static let possibleTypes = ["FIOTransactionPaymentMetadata"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("by_order_of", type: .scalar(String.self)),
      GraphQLField("payee", type: .scalar(String.self)),
      GraphQLField("payer", type: .scalar(String.self)),
      GraphQLField("payment_method", type: .scalar(String.self)),
      GraphQLField("payment_processor", type: .scalar(String.self)),
      GraphQLField("ppd_id", type: .scalar(String.self)),
      GraphQLField("reason", type: .scalar(String.self)),
      GraphQLField("reference_number", type: .scalar(String.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(byOrderOf: String? = nil, payee: String? = nil, payer: String? = nil, paymentMethod: String? = nil, paymentProcessor: String? = nil, ppdId: String? = nil, reason: String? = nil, referenceNumber: String? = nil) {
      self.init(snapshot: ["__typename": "FIOTransactionPaymentMetadata", "by_order_of": byOrderOf, "payee": payee, "payer": payer, "payment_method": paymentMethod, "payment_processor": paymentProcessor, "ppd_id": ppdId, "reason": reason, "reference_number": referenceNumber])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var byOrderOf: String? {
      get {
        return snapshot["by_order_of"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "by_order_of")
      }
    }

    public var payee: String? {
      get {
        return snapshot["payee"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "payee")
      }
    }

    public var payer: String? {
      get {
        return snapshot["payer"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "payer")
      }
    }

    public var paymentMethod: String? {
      get {
        return snapshot["payment_method"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "payment_method")
      }
    }

    public var paymentProcessor: String? {
      get {
        return snapshot["payment_processor"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "payment_processor")
      }
    }

    public var ppdId: String? {
      get {
        return snapshot["ppd_id"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "ppd_id")
      }
    }

    public var reason: String? {
      get {
        return snapshot["reason"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "reason")
      }
    }

    public var referenceNumber: String? {
      get {
        return snapshot["reference_number"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "reference_number")
      }
    }
  }
}