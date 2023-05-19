//
//  URLSession+Extension.swift
//  Tillamook
//
//  Created by Thomas Purnell-Fisher on 6/15/19.
//  Copyright © 2019 Flow Capital, LLC. All rights reserved.
//

import Foundation

extension URLSession {
	
	class func downloadImage(atURL url: URL, withCompletionHandler completionHandler: @escaping (Data?, NSError?) -> Void) {
		let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
			completionHandler(data, nil)
		}
		dataTask.resume()
	}
	
	func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
		return dataTask(with: url) { (data, response, error) in
			if let error = error {
				result(.failure(error))
				return
			}
			guard let response = response, let data = data else {
				let error = NSError(domain: "error", code: 0, userInfo: nil)
				result(.failure(error))
				return
			}
			result(.success((response, data)))
		}
	}
	
}
