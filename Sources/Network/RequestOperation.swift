//
//  File.swift
//  
//
//  Created by Ihab yasser on 23/07/2023.
//

import Foundation

class RequestOperation<T:Decodable>:Operation {
    
    let url: String
    let method: HttpMethod
    let headers: [String: String]?
    let body: Data?
    let completion: CompletionHandler<T>
    
    init(url: String, method: HttpMethod = .get, headers: [String : String]? = nil, body: Data? = nil, completion: @escaping CompletionHandler<T>) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
        self.completion = completion
        
    }
    
   
    
    override func main() {
        request(completion: completion)
    }
    
    public func request(completion: @escaping CompletionHandler<T>) {
        if !NetworkManager.shared.isConnected {
            completion(.failure(.NoInternet))
            if #available(iOS 13.0, *) {
                DispatchQueue.main.async {
                    ToastBanner.shared.show(message: "Check your internet connection.", style: .error, position: .Bottom)
                }
            } else {
                print("Check your internet connection.")
            }
            return
        }
        guard let url = URL(string: url) else {  completion(.failure(.invalidURL)); return}
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    guard let data = data else {completion(.failure(.invalidData)); return}
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                     completion(.failure(.jsonParsingFailure))
                }
                break
            case 400:
                 completion(.failure(.badRequest))
                break
            case 401:
                 completion(.failure(.unauthorized))
                break
            case 403:
                 completion(.failure(.forbidden))
                break
            case 404:
                 completion(.failure(.notFound))
                break
            case 405:
                 completion(.failure(.methodNotAllowed))
                break
            case 408:
                 completion(.failure(.requestTimeout))
                break
            case 409:
                 completion(.failure(.conflict))
                break
            case 410:
                 completion(.failure(.gone))
                break
            case 411:
                 completion(.failure(.lengthRequired))
                break
            case 412:
                 completion(.failure(.preconditionFailed))
                break
            case 413:
                 completion(.failure(.payloadTooLarge))
                break
            case 414:
                 completion(.failure(.uriTooLong))
                break
            case 415:
                 completion(.failure(.unsupportedMediaType))
                break
            case 416:
                 completion(.failure(.rangeNotSatisfiable))
                break
            case 417:
                 completion(.failure(.expectationFailed))
                break
            case 418:
                 completion(.failure(.teapot))
                break
            case 429:
                 completion(.failure(.tooManyRequests))
                break
            case 500:
                 completion(.failure(.serverError))
                break
            case 502:
                 completion(.failure(.badGateway))
                break
            case 503:
                 completion(.failure(.serviceUnavailable))
                break
            case 504:
                 completion(.failure(.gatewayTimeout))
                break
            default:
                 completion(.failure(.unknown(httpResponse.statusCode)))
                break
            }
            
        }
        task.resume()
    }
    
}
