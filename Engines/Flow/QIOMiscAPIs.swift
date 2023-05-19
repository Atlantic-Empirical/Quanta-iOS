//
//  QIOMiscAPIs.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 7/19/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Foundation

class QIOMiscAPIs {

	func logoUrlForString(_ logoString: String, completion: @escaping QIOStringOptCompletion) {
		guard let u = URL(string: "https://api.chedda.io/logo?q=" + logoString) else { return }
		URLSession.shared.dataTask(with: u) { result in
			switch result {
			case .success(let response, let data):
				//				print(response)
				completion(QIOClearBitLogoResponse(data).firstUrl)
				break
			case .failure(let error):
				print(error.localizedDescription)
				completion(nil)
				break
			}
			}.resume()
	}
	
	class QIOClearBitLogoResponse: Codable {
		
		// Sample response:
		//		[{"name":"Amazon","domain":"amazon.com","logo":"https://logo.clearbit.com/amazon.com"},{"name":"Amazon UK","domain":"amazon.jobs","logo":"https://logo.clearbit.com/amazon.jobs"},{"name":"Amazon MTurk","domain":"mturk.com","logo":"https://logo.clearbit.com/mturk.com"},{"name":"Amazon","domain":"aboutamazon.com","logo":"https://logo.clearbit.com/aboutamazon.com"},{"name":"Amazon","domain":"amazon.de","logo":"https://logo.clearbit.com/amazon.de"}]
		
		var items: [QIOClearBitLogoResponseItem]?
		var firstUrl: String?
		
		init(_ data: Data) {
			//			print(#function)
			//			print(String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed")
			let decoder = JSONDecoder()
			do {
				items = try decoder.decode([QIOClearBitLogoResponseItem].self, from: data)
				//				print(items as Any)
				firstUrl = self.items?.first?.logo ?? ""
			} catch {
				print(error.localizedDescription)
			}
		}
		
	}
	
	struct QIOClearBitLogoResponseItem: Codable {
		var name: String
		var domain: String
		var logo: String
	}

}

// MARK: - Singleton

extension QIOMiscAPIs {
	
	struct Static { static var instance: QIOMiscAPIs? }
	
	class var s: QIOMiscAPIs {
		if Static.instance == nil {
			Static.instance = QIOMiscAPIs()
		}
		return Static.instance!
	}
	
	func dispose() {
		QIOMiscAPIs.Static.instance = nil
		print("Disposed Singleton instance QIOMiscAPIs")
	}
	
}
