//
//  NetworkManager.swift
//  ReachabilityApp
//
//  Created by Ehab on 05/10/2023.
//

import Foundation

public class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    private var reachability:Reachability?
    
    override init() {
        super.init()
        self.start()
    }
    
    private func start(){
        self.reachability = try? Reachability()
        self.isConnected = reachability?.connection != .unavailable
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    public var isConnected:Bool = false
    
    public func reachabilityNotifier(callback:((Bool) -> Void)?){
        self.start()
        reachability?.whenReachable = { reachability in
            callback?(true)
        }
        reachability?.whenUnreachable = { _ in
            callback?(false)
        }
    }
    
    
    public func stop(){
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability?.stopNotifier()
        reachability = nil
    }
    
}
