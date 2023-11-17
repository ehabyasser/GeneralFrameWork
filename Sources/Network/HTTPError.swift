//
//  HTTPError.swift
//  study
//
//  Created by Aamal Holding Android on 20/04/2023.
//

import Foundation
public enum HTTPError {
    case invalidURL
    case invalidParameters
    case invalidResponse
    case invalidData
    case requestFailed
    case jsonParsingFailure
    case jsonParsingMessageFailure(String)
    case responseUnsuccessful(statusCode: Int, message: String?)
    case badRequest // 400
    case unauthorized // 401
    case forbidden // 403
    case notFound // 404
    case methodNotAllowed // 405
    case requestTimeout // 408
    case conflict // 409
    case gone // 410
    case lengthRequired // 411
    case preconditionFailed // 412
    case payloadTooLarge // 413
    case uriTooLong // 414
    case unsupportedMediaType // 415
    case rangeNotSatisfiable // 416
    case expectationFailed // 417
    case teapot // 418
    case tooManyRequests // 429
    case serverError // 500
    case badGateway // 502
    case serviceUnavailable // 503
    case gatewayTimeout // 504
    case unknown(Int)
    case NoInternet
}

public struct RequestError<T: Decodable>:Error {
    public let httpError:HTTPError
    public let data:T?
}
