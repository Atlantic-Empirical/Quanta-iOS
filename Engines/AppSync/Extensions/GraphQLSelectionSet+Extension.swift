//
//  Ass.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 1/10/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import AWSAppSync

extension GraphQLSelectionSet {

	public init(fromLocalFileName: String) throws {
		do {
			let userHomeFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fromLocalFileName)
//			print(userHomeFileURL)
			let readData = try Data(contentsOf: userHomeFileURL)
//			print(readData)
			let jsonStringIn = String(data: readData, encoding: .utf8)!
//				print(jsonStringIn as Any)
			let jsonObjIn = jsonStringIn.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
//			print(jsonObjIn)
			let jsonObject = try JSONSerializationFormat.deserialize(data: jsonObjIn) as! JSONObject
//			print(jsonObject)
			try self.init(jsonObject: jsonObject)
		} catch {
			print("Error in init(fromLocalFileName:): \(error)")
			throw error
		}
	}

	public func writeToLocalStore(fileName: String) throws {
		do {
			let userHomeFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
//			print(userHomeFileURL)
//				let b = JSONSerialization.isValidJSONObject(uh.jsonObject)
//				print(b)
			let jsonData = try JSONSerialization.data(withJSONObject: self.jsonObject)
//			print(jsonData)
//				let jsonStringForConfirmation = String(data: jsonData, encoding: .utf8)
//				print(jsonStringForConfirmation as Any)
			try jsonData.write(to: userHomeFileURL)
			print("Object stored to \(fileName)")
		} catch {
			print("Error in writeToLocalStore(): \(error).")
			throw error
		}
	}
	
}

extension Array where Element == GraphQLSelectionSet {

	public init<T: GraphQLSelectionSet>(fromLocalFileName: String, ofType: T.Type) throws {
		do {
			let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fromLocalFileName)
			//			print(fileURL)
			let readData = try Data(contentsOf: fileURL)
			//			print(readData)
			let jsonStringIn = String(data: readData, encoding: .utf8)!
			//				print(jsonStringIn as Any)
			let jsonObjIn = jsonStringIn.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
			//			print(jsonObjIn)
			let jsonObjectArray = try JSONSerializationFormat.deserialize(data: jsonObjIn) as! [JSONObject]
			//			print(jsonObject)
			let qlMap = GraphQLMap(uniqueKeysWithValues: [("returnSummary", true)]) // HARD WON LEARNING
			/// this is required for serialization of transactions and does not disrupt serialization of flow periods.
			/// also had to make a customized version of this T init to support passing of variables.
			/// BRITTLE! When the AppSync/Apollo library is updated it will remove this custom initializer.
			/// It is preserved below for later use, as needed in GraphQLSelectionSet.swift
//			self = try jsonObjectArray.map { try T(jsonObject: $0, variables: qlMap) }
			self = [] // fixme
		} catch {
			print("Error in init(fromLocalFileName:): \(error)")
			throw error
		}
	}
	
	func batchWriteToSingleFile(fileName: String) throws {
		do {
			let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
			//			print(fileURL)
			//				let b = JSONSerialization.isValidJSONObject(uh.jsonObject)
			//				print(b)
			let jsonObjectArray: [JSONObject] = self.map { $0.jsonObject }
			let jsonData = try JSONSerialization.data(withJSONObject: jsonObjectArray)
			//			print(jsonData)
			//				let jsonStringForConfirmation = String(data: jsonData, encoding: .utf8)
			//				print(jsonStringForConfirmation as Any)
			try jsonData.write(to: fileURL)
			print("Object array stored to \(fileName)")
		} catch {
			print("Error in batchWriteToSingleFile(): \(error).")
			throw error
		}
	}
	
}

/// !IMPORTANT! KEEP
//init(jsonObject: JSONObject, variables: GraphQLMap?) throws {
//	let executor = GraphQLExecutor { object, info in
//		.result(.success(object[info.responseKeyForField]))
//	}
//	executor.shouldComputeCachePath = false
//	self = try executor.execute(selections: Self.selections, on: jsonObject, variables: variables, accumulator: GraphQLSelectionSetMapper<Self>()).await()
//}
