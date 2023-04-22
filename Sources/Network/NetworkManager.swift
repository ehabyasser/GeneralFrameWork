//
//  NetworkManager.swift
//  study
//
//  Created by Aamal Holding Android on 20/04/2023.
//
import Foundation
import SystemConfiguration

public class NetworkManager {
    public static let shared = NetworkManager()
    
    private var wifiReachability: SCNetworkReachability?
    private var cellularReachability: SCNetworkReachability?
    public var isConnected:Bool = false
    private init() {
        setupReachability()
    }
    
    private func setupReachability() {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        wifiReachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
        cellularReachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
    }
    
    public func startMonitoring() {
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        
        if let wifiReachability = wifiReachability {
            SCNetworkReachabilitySetCallback(wifiReachability, { (reachability, flags, info) in
                guard let info = info else {
                    return
                }
                
                let networkManager = Unmanaged<NetworkManager>.fromOpaque(info).takeUnretainedValue()
                networkManager.networkStatusChanged(flags: flags)
            }, &context)
            
            SCNetworkReachabilitySetDispatchQueue(wifiReachability, DispatchQueue.main)
        }else if let cellularReachability = cellularReachability {
            SCNetworkReachabilitySetCallback(cellularReachability, { (reachability, flags, info) in
                guard let info = info else {
                    return
                }
                
                let networkManager = Unmanaged<NetworkManager>.fromOpaque(info).takeUnretainedValue()
                networkManager.networkStatusChanged(flags: flags)
            }, &context)
            
            SCNetworkReachabilitySetDispatchQueue(cellularReachability, DispatchQueue.main)
        }
    }
    
    private func networkStatusChanged(flags: SCNetworkReachabilityFlags) {
        DispatchQueue.main.async {
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
            let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
            let isNetworkReachable = isReachable && (!needsConnection || canConnectWithoutUserInteraction)
            if self.isConnected != isNetworkReachable {
                self.isConnected = isNetworkReachable
                NotificationCenter.default.post(name: .networkStatusChanged, object: nil)
            }
        }
    }
}
public extension Notification.Name {
    static let networkStatusChanged = Notification.Name("NetworkStatusChanged")
}
