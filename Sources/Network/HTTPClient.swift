//
//  File.swift
//  study
//
//  Created by Aamal Holding Android on 20/04/2023.
//

import Foundation

public typealias CompletionHandler<T: Decodable> = (Result<T, HTTPError>) -> Void

public class HTTPClient {
    public static let shared = HTTPClient()
    let queue = OperationQueue()
    public func request<T: Decodable>(url: String,
                                      method: HttpMethod = .get,
                                      headers: [String: String]? = nil,
                                      body: Data? = nil,
                                      completion: @escaping CompletionHandler<T>) {
        DispatchQueue.global().async {
            let requestOperation = RequestOperation<T>(url: url , method: method , headers: headers , body: body , completion: completion)
            self.queue.addOperations([requestOperation], waitUntilFinished: true)
        }
    }
    
}
