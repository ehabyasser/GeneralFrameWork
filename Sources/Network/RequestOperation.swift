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
        NetworkManager.shared.startMonitoring()
        
    }
    
    @objc private func networkChanged(){
        if !NetworkManager.shared.isConnected {
            completion(.failure(.NoInternet))
            if #available(iOS 13.0, *) {
                ToastBanner.shared.show(message: "Check your internet connection.", style: .error, position: .Bottom)
            } else {
                print("Check your internet connection.")
            }
        }
    }
    
    override func main() {
        NetworkManager.shared.startMonitoring()
        request()
        NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: .networkStatusChanged, object: nil)
    }
    


    
    public func request() {
        if !NetworkManager.shared.isConnected {
            completion(.failure(.NoInternet))
            if #available(iOS 13.0, *) {
                ToastBanner.shared.show(message: "Check your internet connection.", style: .error, position: .Bottom)
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
        
        let task = URLSession.shared.dataTask(with: request) { [weak self]  data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self?.completion(.failure(.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    guard let data = data else {self?.completion(.failure(.invalidData)); return}
                    let model = try JSONDecoder().decode(T.self, from: data)
                    self!.completion(.success(model))
                } catch {
                    self?.completion(.failure(.jsonParsingFailure))
                }
                break
            case 400:
                self?.completion(.failure(.badRequest))
                break
            case 401:
                self?.completion(.failure(.unauthorized))
                break
            case 403:
                self?.completion(.failure(.forbidden))
                break
            case 404:
                self?.completion(.failure(.notFound))
                break
            case 405:
                self?.completion(.failure(.methodNotAllowed))
                break
            case 408:
                self?.completion(.failure(.requestTimeout))
                break
            case 409:
                self?.completion(.failure(.conflict))
                break
            case 410:
                self?.completion(.failure(.gone))
                break
            case 411:
                self?.completion(.failure(.lengthRequired))
                break
            case 412:
                self?.completion(.failure(.preconditionFailed))
                break
            case 413:
                self?.completion(.failure(.payloadTooLarge))
                break
            case 414:
                self?.completion(.failure(.uriTooLong))
                break
            case 415:
                self?.completion(.failure(.unsupportedMediaType))
                break
            case 416:
                self?.completion(.failure(.rangeNotSatisfiable))
                break
            case 417:
                self?.completion(.failure(.expectationFailed))
                break
            case 418:
                self?.completion(.failure(.teapot))
                break
            case 429:
                self?.completion(.failure(.tooManyRequests))
                break
            case 500:
                self?.completion(.failure(.serverError))
                break
            case 502:
                self?.completion(.failure(.badGateway))
                break
            case 503:
                self?.completion(.failure(.serviceUnavailable))
                break
            case 504:
                self?.completion(.failure(.gatewayTimeout))
                break
            default:
                self?.completion(.failure(.unknown(httpResponse.statusCode)))
                break
            }
            
        }
        task.resume()
    }
    
}
