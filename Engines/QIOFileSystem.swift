//
//  QIOFileSystem.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 3/13/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

class QIOFileSystem {
	
	public static func fileTimeStamp(forLocalFileName: String) throws -> Date? {
		let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(forLocalFileName)
		//		print(fileURL.path)
		do {
			let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
			
			let modificationDate = attributes[FileAttributeKey.modificationDate]
			
			if let modDate = modificationDate {
				return modDate as? Date
			} else {
				return nil
			}
		} catch CocoaError.fileReadNoSuchFile {
			//			print("Error: file doesn't exist at: " + fileURL.path)
			return nil
		} catch {
			print("Error in localStoreTimeStamp: \(error).")
			throw error
		}
	}
	
	public static func fileIsFresh(fileName: String) -> Bool {
		do {
			if let localFileDate = try fileTimeStamp(forLocalFileName: fileName) {
				let b = localFileDate.timeIntervalSince(Date.todayNightlyBatch_Eastern_withOffset()) > 0
				print("Local \(fileName) object is " + (b ? "FRESH" : "STALE"))
				return b
			} else {
				print("Local \(fileName) object doesn't exist")
				return false
			}
		} catch {
			print("Error in localCopyIsFresh() with \(fileName): \(error).")
			return false
		}
	}
	
	public static func deleteFile(fileName: String) {
		do {
			print("DELETING local file: \(fileName)")
			let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
			try FileManager.default.removeItem(at: fileURL)
		}
		catch {
			print("FAILED to deleteFile \(fileName). \(error)")
		}
	}
	
	public static func enumerateFilesInTempDir() {
		let tempDirectoryPath = NSTemporaryDirectory()
		do {
			let fileURLs = try FileManager.default.contentsOfDirectory(atPath: tempDirectoryPath)
			fileURLs.forEach { print($0) }
		} catch {
			print("Error while enumerating files \(tempDirectoryPath): \(error.localizedDescription)")
		}
	}
	
}
