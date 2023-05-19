//
//  QIOCache.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 4/18/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Cache

class QIOCache {

	private var storage: Storage<Data>?
	
	init() {
		storage = try? Storage(
			diskConfig: DiskConfig(name: "Floppy"),
			memoryConfig: MemoryConfig(expiry: .never),
			transformer: TransformerFactory.forCodable(ofType: Data.self)
		)
	}

	func setImage(_ image: UIImage, _ key: String) {
		guard let s = storage else { return }
		do {
			let imageStorage = s.transformImage()
			try imageStorage.setObject(image, forKey: key)
		} catch {
			print("ERROR putting image into cache: \(error)")
		}
	}
	
	func image(_ key: String) -> UIImage? {
//		print("QIOCache image forKey: " + key)
		guard let s = storage else { return nil }
		do {
			let imageStorage = s.transformImage()
			let out = try imageStorage.object(forKey: key)
			return out
		} catch {
			// Just a cache miss. NBD.
//			print("ERROR getting image from cache: \(error)")
			return nil
		}
	}
	
}

// MARK: - Singleton

extension QIOCache {
	
	struct Static { static var instance: QIOCache? }
	
	class var sharedInstance: QIOCache {
		if Static.instance == nil {
			Static.instance = QIOCache()
		}
		return Static.instance!
	}
	
	public func dispose() {
		QIOCache.Static.instance = nil
		print("Disposed Singleton instance QIOCache")
	}
	
}
