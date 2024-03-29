//
//  MemoryManager.swift
//  Celebrate
//
//  Created by Ihab yasser on 02/11/2023.
//

import Foundation
import UIKit

public class MemoryManager {
    public static let shared = MemoryManager()
    
   public func start(){
        subscribeToMemoryWarningNotifications()
    }
    
    deinit {
        unsubscribeFromMemoryWarningNotifications()
    }
    
    private func subscribeToMemoryWarningNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    private func unsubscribeFromMemoryWarningNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    @objc private func didReceiveMemoryWarning() {
        ImageCacheManager.shared.clearCache()
    }
}
