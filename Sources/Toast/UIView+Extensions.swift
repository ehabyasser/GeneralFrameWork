//
//  File.swift
//  
//
//  Created by Ihab yasser on 16/07/2023.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable
    public var isShimmering: Bool {
        get {
            return layer.mask?.animation(forKey: shimmerAnimationKey) != nil
        }
        set {
            if newValue {
                startShimmering()
            } else {
                stopShimmering()
            }
        }
    }
    
    private var shimmerAnimationKey: String {
        return "shimmer"
    }
    

    
    private func startShimmering() {
        backgroundColor = UIColor.lightGray
        let white = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        let alpha = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        let width = bounds.width
        let height = bounds.height
        
        let gradient = CAGradientLayer()
        gradient.colors = [white, alpha, white]
        gradient.startPoint = CGPoint(x: 0.0, y: 0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0)
        gradient.locations = [0, 1]
        gradient.frame = CGRect(x: -width, y: 0, width: width*3, height: height)
        layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 2
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: shimmerAnimationKey)
    }
    
    private func stopShimmering() {
        layer.mask = nil
        self.backgroundColor = .clear
    }


    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
    }
}

