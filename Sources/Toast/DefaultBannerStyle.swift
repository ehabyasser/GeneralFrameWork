//
//  File.swift
//  
//
//  Created by Ihab yasser on 16/07/2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class DefaultBannerStyle: BannerTheme {
    var style: BannerStyle = .info
    
    var icon:UIImage?{
        switch style {
        case .error:
            return UIImage(systemName: "wrongwaysign")
        case .warning:
            return UIImage(systemName: "exclamationmark.triangle")
        case .info:
            return UIImage(systemName: "info.circle")
        }
    }
    
    var color:UIColor{
        switch style {
        case .error:
            return .white
        case .warning:
            return .white
        case .info:
            return .white
        }
    }
    
    var backgorundColor: UIColor {
        switch style {
        case .error:
            return .systemRed
        case .warning:
            return .systemYellow
        case .info:
            return .label
        }
    }
    
    var iconColor: UIColor{
        switch style {
        case .error:
            return .white
        case .warning:
            return .white
        case .info:
            return .systemBackground
        }
    }
    
    var textColor: UIColor{
        switch style {
        case .error:
            return .white
        case .warning:
            return .white
        case .info:
            return .systemBackground
        }
    }
    
    var messageFont: UIFont{
        switch style {
        default :
            return UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    var titleFont: UIFont{
        switch style {
        default :
            return UIFont.systemFont(ofSize: 14, weight: .medium)
        }
    }
    var time: Int = 3
    
    var iconSize: CGFloat = 32
    
}
