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
        let currentShimmerLayer = layer.sublayers?.first(where: { $0.name == shimmerAnimationKey })
        if currentShimmerLayer != nil { return }
        
        let baseShimmeringColor: UIColor? = .lightGray//UIColor(red: 202/255, green: 201/255, blue: 206/255, alpha: 1)
        guard let color = baseShimmeringColor else {
            print("⚠️ Warning: `viewBackgroundColor` can not be nil while calling `setShimmeringAnimation`")
            return
        }
        
        // MARK: - Shimmering Layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = shimmerAnimationKey
        gradientLayer.frame = getFrame()
        gradientLayer.cornerRadius = min(bounds.height / 2, 0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        let gradientColorOne = color.withAlphaComponent(0.5).cgColor
        let gradientColorTwo = color.withAlphaComponent(0.8).cgColor
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)
        gradientLayer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        // MARK: - Shimmer Animation
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 2
        gradientLayer.add(animation, forKey: animation.keyPath)
    }
    
    private func stopShimmering() {
        let currentShimmerLayer = layer.sublayers?.first(where: { $0.name == shimmerAnimationKey })
        currentShimmerLayer?.removeFromSuperlayer()
    }
    
    private func getFrame() -> CGRect {
        return bounds
    }

    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
    }
}

