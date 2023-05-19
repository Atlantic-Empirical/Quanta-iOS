//
//  UNNotificationAttachment+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/15/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import UserNotifications

extension UNNotificationAttachment {
	
	static func saveImageToDisk(
		fileIdentifier: String,
		data: NSData,
		options: [NSObject : AnyObject]?
	) -> UNNotificationAttachment? {
		
		let fileManager = FileManager.default
		let folderName = ProcessInfo.processInfo.globallyUniqueString
		let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
		do {
			try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
			let fileURL = folderURL?.appendingPathComponent(fileIdentifier)
			try data.write(to: fileURL!, options: [])
			let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: fileURL!, options: options)
			return attachment
		} catch let error {
			print("Error: \(error) in \(#function) \(#file)")
		}
		return nil
	}
	
}
