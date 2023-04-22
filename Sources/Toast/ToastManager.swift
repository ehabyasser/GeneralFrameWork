//
//  ToastManager.swift
//  study
//
//  Created by Aamal Holding Android on 20/04/2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public class ToastManager {
    public static let shared = ToastManager()
    
    private init() { }
    
    public func showToast(message: String, duration: TimeInterval = 2.0) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        let toastView = AppleToastView(message: message, duration: duration)
        window.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toastView.centerXAnchor.constraint(equalTo: window.centerXAnchor)
        ])
        
        UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut) {
            toastView.alpha = 0.0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
}
