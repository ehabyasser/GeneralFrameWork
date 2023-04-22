//
//  Loader.swift
//  study
//
//  Created by Aamal Holding Android on 20/04/2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public class Loader {
    
    public static let shared = Loader()
    
    private var activityIndicatorView: CustomActivityIndicatorView?
    private var backgroundView: UIView?
    private var animationName:String = ""
    
    public func setAnimationName(name:String){
        self.animationName = name
    }
    private init() {}
    
    public func showLoader() {
        if activityIndicatorView == nil {
            activityIndicatorView = CustomActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            activityIndicatorView?.animationName = animationName
            //activityIndicatorView?.hidesWhenStopped = true
        }
        
        if backgroundView == nil {
            backgroundView = UIView(frame: UIScreen.main.bounds)
            backgroundView?.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
        }
        
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                return
            }
            window.addSubview(self.backgroundView!)
            window.addSubview(self.activityIndicatorView!)
            self.activityIndicatorView?.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            self.activityIndicatorView?.startAnimating()
            window.isUserInteractionEnabled = false
        }
    }
    
    public func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicatorView?.stopAnimating()
            self.backgroundView?.removeFromSuperview()
            self.activityIndicatorView?.removeFromSuperview()
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                return
            }
            window.isUserInteractionEnabled = true
        }
    }
    
}
