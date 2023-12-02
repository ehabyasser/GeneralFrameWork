//
//  File.swift
//  
//
//  Created by Ihab yasser on 29/08/2023.
//

import Foundation



@propertyWrapper
public struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
   public init(key: String , defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as?T ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}

@propertyWrapper
public struct CodableUserDefault<T:Codable> {
    let key: String
    let defaultValue: T
    
    public init(key: String , defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    
    public var wrappedValue: T {
        get {
            let string = UserDefaults.standard.string(forKey: key) ?? ""
            let objc = try? JSONDecoder().decode(T.self, from: string.data(using: .utf8)!)
            return objc ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue.convertToString, forKey: key)
        }
    }
}



extension Encodable {
   public var convertToString: String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
