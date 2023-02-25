//
//  XXSkinManager.swift
//  Wohand
//
//  Created by 林文峰 on 2022/1/13.
//  Copyright © 2022 Zhichen Li. All rights reserved.
//

import Foundation
import UIKit

enum XXSkinType: String {
    case XXSkinTypeSystem = "system"
    case XXSkinTypeLight = "light"
    case XXSkinTypeDark = "dark"
}

class XXSkinManager: NSObject {

    fileprivate var currentType: XXSkinType!
    fileprivate var showType: XXSkinType!
    
    static let shared : XXSkinManager = {
        let instance = XXSkinManager()
        return instance
    }()
    
    private override init() {
        super.init()
        let type: String = UserDefaults.standard.value(forKey: "XX_skinType") as? String ?? "system"
        
        self.currentType = XXSkinType.init(rawValue: type)

        self.showType = getShowTypeWithCurrentType(type: self.currentType)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ApplicationDidBecomeActiveNotification), name:UIApplication.didBecomeActiveNotification, object: nil)
    }
    
//    MARK: 皮肤改变
    private func skinDidChange() {
        //做loading操作
        self.reloadNavigationBar()
        //改变时传递当前模式
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: XXSkinManager.shared.isDarkMode())
        }
    }
    
    private func reloadNavigationBar() {
        //TODO: 状态栏
        if #available(iOS 13.0, *) {
           
        }
    }
    
//    MARK: 当前模式转展示模式
    private func getShowTypeWithCurrentType(type: XXSkinType) ->XXSkinType {
        if type != .XXSkinTypeSystem {
            return type
        } else {
            if #available(iOS 13.0, *) {
                var systemType:XXSkinType = .XXSkinTypeLight
                let mode:UIUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
                if mode == UIUserInterfaceStyle.light {
                    systemType = .XXSkinTypeLight
                } else if mode == UIUserInterfaceStyle.dark {
                    systemType = .XXSkinTypeDark
                } else {
                    systemType = .XXSkinTypeLight
                }
                return systemType
            } else {
                // 默认
                return .XXSkinTypeLight
            }
        }
    }
    
//    MARK: 在后台切换暗夜/白天 进入前台时刷新
    @objc private func ApplicationDidBecomeActiveNotification(_ notification: Notification) {
        //系统颜色切换后刷新
        if self.currentType != .XXSkinTypeSystem { return }
        
        if #available(iOS 13.0, *) {
            var systemType:XXSkinType = .XXSkinTypeLight
            let mode:UIUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            if mode == UIUserInterfaceStyle.light {
                systemType = .XXSkinTypeLight
            } else if mode == UIUserInterfaceStyle.dark {
                systemType = .XXSkinTypeDark
            } else {
                systemType = .XXSkinTypeLight
            }
            //刷新
            if systemType != self.showType {
                self.showType = getShowTypeWithCurrentType(type: currentType!)
                self.skinDidChange()
            }
        }
    }
}

//MARK: 根据key找映射
extension XXSkinManager {
    func getImageWithColorKey(key: String) -> UIImage {
        return XXSkinHelper.getImageWithColorKey(key: key, skinType: self.showType)
    }
    
    func getImageWithNameKey(key: String) -> UIImage {
        return XXSkinHelper.getImageWithNameKey(key: key, skinType: self.showType)
    }
    
    func getColorValueWith(key: String) -> UIColor {
        return XXSkinHelper.getColorValueWith(key: key, skinType: self.showType)
    }
}



//MARK: UIColor+
extension UIColor {
    class func getColor(with key:XXColorType) -> UIColor {
        return XXSkinManager.shared.getColorValueWith(key: key.rawValue)
    }
}

//MARK: public
extension XXSkinManager {
    //    MARK: 外部设置皮肤
    public func setAppSkinType(type: XXSkinType) {
        //        存储到本地下次启动用
        UserDefaults.standard.setValue(type.rawValue, forKey: "XX_skinType")
        self.currentType = type
        self.showType = getShowTypeWithCurrentType(type: type)
        
        self.skinDidChange()
    }
    
    /// 返回当前是否暗夜模式
    /// - Returns: true 是 false 不是
    public func isDarkMode() -> Bool {
        return self.showType == .XXSkinTypeDark
    }
    
    /// 返回当前设置模式
    /// - Returns: 白天、暗夜、跟随系统
    public func getCurrentMode() -> XXSkinType {
        return self.currentType ?? .XXSkinTypeLight
    }
    
    /// 返回当前展示模式，这个方法不会返回跟随系统
    /// - Returns: 白天、黑夜
    public func getShowType() -> XXSkinType {
        return self.showType ?? .XXSkinTypeLight
    }
}
