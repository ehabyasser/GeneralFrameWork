//
//  ToastBanner.swift
//  ToolTip
//
//  Created by Ihab yasser on 13/07/2023.
//

import UIKit

@available(iOS 13.0, *)
public protocol BannerTheme {
    var icon : UIImage? {get}
    var backgorundColor:UIColor {get}
    var iconColor:UIColor {get}
    var textColor:UIColor {get}
    var messageFont:UIFont {get}
    var titleFont:UIFont {get}
    var time:Int {get}
    var iconSize:CGFloat {get}
    var style:BannerStyle{ get set }
}
@available(iOS 13.0, *)
public enum BannerStyle{
    case error
    case warning
    case info
}

@available(iOS 13.0, *)
public enum BannerPosition{
    case Top
    case Bottom
}

@available(iOS 13.0, *)
public struct BannerSettings{
    var theme:BannerTheme
    var position:BannerPosition = .Bottom
}

@available(iOS 13.0, *)
public class ToastBanner {
    public static let shared:ToastBanner = ToastBanner()
    var settings:BannerSettings?
    private let stack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let icon:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let iconView:UIView = {
        let img = UIView()
        img.backgroundColor = .clear
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let contentStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let contentView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let titleLbl:LocalizedLable = {
        let lbl = LocalizedLable()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let messageLbl:LocalizedLable = {
        let lbl = LocalizedLable()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private var banner:UIView? = nil
    func show(title:String = "" , message:String , style:BannerStyle , position:BannerPosition){
        guard let window = getWindowView() else {return}
        if settings == nil {
            settings = BannerSettings(theme: BannerStyleManager())
        }
        settings?.position = position
        settings?.theme.style = style
        if banner != nil {
            banner?.removeFromSuperview()
        }
        banner = design()
        window.addSubview(banner!)
        banner!.leadingAnchor.constraint(equalTo: window.leadingAnchor , constant: 20).isActive = true
        banner!.trailingAnchor.constraint(equalTo: window.trailingAnchor , constant: -20).isActive = true
        banner!.heightAnchor.constraint(equalToConstant: 90).isActive = true
        if title.isEmpty {
            titleLbl.isHidden = true
        }
        if message.isEmpty {
            messageLbl.isHidden = true
        }
        switch settings?.position {
        case .Bottom:
            banner!.bottomAnchor.constraint(equalTo: window.bottomAnchor , constant: 90).isActive = true
            break
        case .Top:
            banner!.topAnchor.constraint(equalTo: window.topAnchor , constant: -90).isActive = true
            break
        case .none:
            break
        }
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                self.banner!.transform = CGAffineTransform(translationX: 0, y: self.settings!.position == .Bottom ?  self.banner!.frame.origin.y - 120 : self.banner!.frame.origin.y + 120)
                let time = DispatchTimeInterval.seconds(self.settings?.theme.time ?? 3)
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    self.dismiss()
                }
            })
        titleLbl.text = title
        messageLbl.text = message
        
    }
    
    func dismiss(){
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: [],
            animations: {
                self.banner!.transform = CGAffineTransform(translationX: 0, y: self.banner!.frame.origin.y)
            }) { isEnded in
                if isEnded{
                    self.banner?.removeFromSuperview()
                }
            }
        
    }
    
    fileprivate func getWindowView() -> UIView?{
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first?.rootViewController?.view {
            return window
        }
        return nil
    }
    
    fileprivate func design() -> UIView{
        //design banner useing settings theme
        let view = UIView()
        view.backgroundColor = settings?.theme.backgorundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.dropShadow()
        view.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -10).isActive = true
        stack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stack.addArrangedSubview(iconView)
        iconView.widthAnchor.constraint(equalToConstant: settings?.theme.iconSize ?? 32).isActive = true
        
        iconView.addSubview(icon)
        icon.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: settings?.theme.iconSize ?? 24).isActive = true
        icon.heightAnchor.constraint(equalToConstant: settings?.theme.iconSize ?? 24).isActive = true
        
        stack.addArrangedSubview(contentView)
        contentView.addSubview(contentStack)
        contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -6).isActive = true
        contentStack.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 6).isActive = true
        contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -6).isActive = true
       
        contentStack.addArrangedSubview(titleLbl)
        contentStack.addArrangedSubview(messageLbl)
        titleLbl.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        icon.image = settings?.theme.icon?.withRenderingMode(.alwaysTemplate).withTintColor(settings?.theme.iconColor ?? .label)
        icon.tintColor = settings?.theme.iconColor ?? .label
        titleLbl.textColor = settings?.theme.textColor
        titleLbl.font = settings?.theme.titleFont
        messageLbl.textColor = settings?.theme.textColor
        messageLbl.font = settings?.theme.messageFont
        return view
    }
    
    class LocalizedLable: UILabel {
        override func layoutSubviews() {
            if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                textAlignment = .right
            }else{
                textAlignment = .left
            }
        }
    }
    
    
}

extension UIView {
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
    }
}

@available(iOS 13.0, *)
class BannerStyleManager: BannerTheme {
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
