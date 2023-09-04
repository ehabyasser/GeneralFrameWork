//
//  File.swift
//
//
//  Created by Ihab yasser on 21/04/2023.
//

import Foundation
import UIKit


@available(iOS 13.0, *)
class CustomActivityIndicatorView: UIView {
    
    private let animationView = LottieAnimationView()
    var animationName:String?{
        didSet{
            configure()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configure()  {
        backgroundColor = .systemBackground
        self.layer.cornerRadius = 5
        let animation = LottieAnimation.named(animationName ?? "")
        animationView.animation = animation
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        addSubview(animationView)
        
        // Add constraints to make the animation view fill the entire view
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func startAnimating() {
        animationView.play()
    }
    
    func stopAnimating() {
        animationView.stop()
    }
}
