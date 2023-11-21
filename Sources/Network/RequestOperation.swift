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
    let completion: (Result<T?, RequestError<T>>) -> Void
    
    init(url: String, method: HttpMethod = .get, headers: [String : String]? = nil, body: Data? = nil, completion: @escaping (Result<T?, RequestError<T>>) -> Void) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
        self.completion = completion
        
    }
    
    override func main() {
        request(completion: completion)
    }
    
    public func request(completion: @escaping (Result<T?, RequestError<T>>) -> Void) {
        if !NetworkManager.shared.isConnected {
            completion(.failure(RequestError(httpError: .NoInternet, data: nil)))
            if #available(iOS 13.0, *) {
                DispatchQueue.main.async {
                    ToastBanner.shared.show(message: "Check your internet connection.", style: .noInternet, position: .Bottom)
                }
            } else {
                Logger.log(.info, message: "Check your internet connection.")
            }
            return
        }
        guard let url = URL(string: url) else {  completion(.failure(RequestError(httpError: .invalidURL, data: nil))); return}
        Logger.log(.info, message: url)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        if let data  = body {
            Logger.log(.info, message: "Body \(String(decoding: data, as: UTF8.self))")
        }
        
        if let headers = headers {
            Logger.log(.info, message: "Headers \(headers)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(RequestError(httpError: .invalidResponse, data: nil)))
                Logger.log(.info, message: "invalid response")
                return
            }
            Logger.log(.info, message: "\(httpResponse.statusCode) \(httpResponse.url?.absoluteString ?? "")")
            if let data = data {
                Logger.log(.info, message: String(decoding: data, as: UTF8.self))
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                completion(.success(self.getData(data: data)))
                break
            case 400:
                completion(.failure(RequestError(httpError: .badRequest, data: self.getData(data: data))))
                break
            case 401:
                completion(.failure(RequestError(httpError: .unauthorized, data: self.getData(data: data))))
                break
            case 403:
                completion(.failure(RequestError(httpError: .forbidden, data: self.getData(data: data))))
                break
            case 404:
                completion(.failure(RequestError(httpError: .notFound, data: nil)))
                break
            case 405:
                completion(.failure(RequestError(httpError: .methodNotAllowed, data: self.getData(data: data))))
                break
            case 408:
                completion(.failure(RequestError(httpError: .requestTimeout, data: self.getData(data: data))))
                break
            case 409:
                completion(.failure(RequestError(httpError: .conflict, data: self.getData(data: data))))
                break
            case 410:
                completion(.failure(RequestError(httpError: .gone, data: self.getData(data: data))))
                break
            case 411:
                completion(.failure(RequestError(httpError: .lengthRequired, data: self.getData(data: data))))
                break
            case 412:
                completion(.failure(RequestError(httpError: .preconditionFailed, data: self.getData(data: data))))
                break
            case 413:
                completion(.failure(RequestError(httpError: .payloadTooLarge, data: self.getData(data: data))))
                break
            case 414:
                completion(.failure(RequestError(httpError: .uriTooLong, data: self.getData(data: data))))
                break
            case 415:
                completion(.failure(RequestError(httpError: .unsupportedMediaType, data: self.getData(data: data))))
                break
            case 416:
                completion(.failure(RequestError(httpError: .rangeNotSatisfiable, data: self.getData(data: data))))
                break
            case 417:
                completion(.failure(RequestError(httpError: .expectationFailed, data: self.getData(data: data))))
                break
            case 418:
                completion(.failure(RequestError(httpError: .teapot, data: self.getData(data: data))))
                break
            case 429:
                completion(.failure(RequestError(httpError: .tooManyRequests, data: self.getData(data: data))))
                break
            case 500:
                completion(.failure(RequestError(httpError: .serverError, data: self.getData(data: data))))
                break
            case 502:
                completion(.failure(RequestError(httpError: .badGateway, data: self.getData(data: data))))
                break
            case 503:
                completion(.failure(RequestError(httpError: .serviceUnavailable, data: self.getData(data: data))))
                break
            case 504:
                completion(.failure(RequestError(httpError: .gatewayTimeout, data: self.getData(data: data))))
                break
            default:
                completion(.failure(RequestError(httpError: .unknown(httpResponse.statusCode), data: self.getData(data: data))))
                break
            }
            
        }
        task.resume()
    }
    
    func getData(data:Data?) -> T?{
        do {
            guard let data = data else {completion(.failure(RequestError(httpError: .invalidData, data: nil))); return nil}
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            completion(.failure(RequestError(httpError: .jsonParsingFailure, data: nil)))
        }
        return nil
    }
    
}
