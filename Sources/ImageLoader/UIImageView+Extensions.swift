//
//  UIImageView+Extensions.swift
//  Talent
//
//  Created by Ihab yasser on 05/08/2023.
//

import Foundation
import UIKit

public extension UIImageView{
    
    private static var taskKey: UInt8 = 0
    
    private var currentTask: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionDataTask
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    

    public func download(imagePath:String , size:CGSize, placeholder:UIImage? = UIImage(named: "logo")) {
        currentTask?.cancel()
        self.image = placeholder
        if let image = ImageCacheManager.shared.image(forKey: imagePath) {
            self.image = image
            return
        }
        guard let url = URL(string: imagePath) else {return}
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, let img = UIImage(data: data)?.scaleImage(toSize: size), let self = self else { return }
            let cacheImgBlock = BlockOperation()
            cacheImgBlock.addExecutionBlock {
                ImageCacheManager.shared.setImage(img, forKey: imagePath)
            }
            let loadCachedImgBlock = BlockOperation()
            loadCachedImgBlock.addExecutionBlock {
                DispatchQueue.main.async {
                    UIView.transition(with: self,
                                      duration: 0.75,
                                      options: .transitionCrossDissolve,
                                      animations: { self.image = ImageCacheManager.shared.imageFromMemory(forKey: imagePath) },
                                      completion: nil)
                }
            }
            loadCachedImgBlock.addDependency(cacheImgBlock)
            
            let queue = OperationQueue()
            queue.addOperations([cacheImgBlock , loadCachedImgBlock], waitUntilFinished: true)
        }
        task.resume()
        currentTask = task
    }
    
}

public extension UIImage {
   public func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}


