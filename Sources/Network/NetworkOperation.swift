//
//  File.swift
//  
//
//  Created by Ihab yasser on 23/07/2023.
//

import Foundation
class NetworkOperation:Operation {
    
    override func main() {
        NetworkManager.shared.startMonitoring()
        NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: .networkStatusChanged, object: nil)
    }
    
    
    @objc private func networkChanged(){
        if !NetworkManager.shared.isConnected {
            if #available(iOS 13.0, *) {
                DispatchQueue.main.async {
                    ToastBanner.shared.show(message: "Check your internet connection.", style: .error, position: .Bottom)
                }
            } else {
                print("Check your internet connection.")
            }
        }
    }
}
