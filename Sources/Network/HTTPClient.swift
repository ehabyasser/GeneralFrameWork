//
//  File.swift
//  study
//
//  Created by Aamal Holding Android on 20/04/2023.
//

import Foundation
import UIKit


public typealias CompletionHandler<T: Decodable> = (Result<T, HTTPError>) -> Void

public class HTTPClient {
    public static let shared = HTTPClient()
    private let queue = OperationQueue()
    public func request<T: Decodable>(url: String,
                                      method: HttpMethod = .get,
                                      headers: [String: String]? = nil,
                                      body: Data? = nil,
                                      completion: @escaping CompletionHandler<T>) {
        DispatchQueue.global().async {
            let networkOperation = NetworkOperation()
            let requestOperation = RequestOperation<T>(url: url , method: method , headers: headers , body: body , completion: completion)
//            networkOperation.completionBlock = {
//                if networkOperation.isConnected {
//                    requestOperation.start()
//                }else{
//                    if #available(iOS 13.0, *) {
//                        ToastBanner.shared.show(message: "No Internet connection", style: .error, position: .Bottom)
//                    } else {
//                        print("no internet connection")
//                    }
//                    completion(.failure(.NoInternet))
//                    requestOperation.cancel()
//                }
//            }
            requestOperation.addDependency(networkOperation)
            self.queue.addOperations([networkOperation , requestOperation], waitUntilFinished: true)
        }
    }
    
}





