//
//  Logger.swift
//  ReusableTableView
//
//  Created by Ihab yasser on 29/08/2023.
//

import Foundation


open class Logger: NSObject {
    
    enum Level{
        case trace
        case debug
        case info
        case notice
        case warning
        case error
        case critical
        
        func toIcon() -> String{
            switch self {
            case .trace:
                return "📣"
            case .debug:
                return "🐛"
            case .info:
                return "ℹ️"
            case .notice:
                return "📖"
            case .warning:
                return "⚠️"
            case .error:
                return "❌"
            case .critical:
                return "🔥"
            }
        }
    }
    
    static func log(_ level:Level , message:Any){
        if message is Codable {
            debugPrint(level.toIcon() , (message as? Codable)?.convertToString ?? "")
        }else if message is String {
            debugPrint(level.toIcon() , (message as? String) ?? "")
        }else {
            debugPrint(level.toIcon() , message)
        }
    }
}
