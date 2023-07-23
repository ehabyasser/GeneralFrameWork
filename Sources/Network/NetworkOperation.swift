//
//  File.swift
//  
//
//  Created by Ihab yasser on 23/07/2023.
//

import Foundation

class NetworkOperation:AsyncOpration {
    
    var isConnected:Bool = true
    
    override func performAsyncTask() {
        super.performAsyncTask()
        NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: .networkStatusChanged, object: nil)
        NetworkManager.shared.startMonitoring()
    }
    
    @objc func networkChanged(){
        isConnected = NetworkManager.shared.isConnected
        finish()
    }
}
