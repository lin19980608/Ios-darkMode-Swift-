//
//  WoUIImageExtension.swift
//  Wohand
//
//  Created by 林文峰 on 2022/1/17.
//  Copyright © 2022 Zhichen Li. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    enum WoNavigationBarType {
        case WoNavigationBarTypeImageFromColor
    }
    
    fileprivate struct AssociatedKeys {
        static var sk_navigationBar_isObserverSkinKey: String = "sk_navigationBar_isObserverSkinKey"
        static var sk_navigationBar_observerDictionaryKey: String = "sk_navigationBar_observerDictionaryKey"
    }

    // 是否添加观察
    fileprivate var sk_navigationBar_isObserverSkin: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_navigationBar_isObserverSkinKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_navigationBar_isObserverSkinKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 字典存储观察的属性
    fileprivate var sk_navigationBar_observerDictionary : Dictionary<WoNavigationBarType, String> {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_navigationBar_observerDictionaryKey) as? Dictionary ?? Dictionary()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_navigationBar_observerDictionaryKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func sk_navigationBar_addObserver() {
        if self.sk_navigationBar_isObserverSkin == false {
            self.sk_navigationBar_isObserverSkin = true
            NotificationCenter.default.addObserver(self, selector: #selector(sk_navigationBar_skinDidChange), name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        }
    }
    
    fileprivate func sk_navigationBar_setImageFromColor(key: String) {
        self.sk_navigationBar_updateObserverDictionaryWith(observerType: .WoNavigationBarTypeImageFromColor, value: key)
    }
    
    //    MARK: 更新控件存储的观察字段
    fileprivate func sk_navigationBar_updateObserverDictionaryWith(observerType: WoNavigationBarType, value: String) {
        self.sk_navigationBar_addObserver()
        self.sk_navigationBar_observerDictionary.updateValue(value, forKey: observerType)
        self.sk_navigationBar_updateUIWith(type: observerType, value: value)
    }
    
    //    MARK: 刷新View
    fileprivate func sk_navigationBar_updateUIWith(type: WoNavigationBarType, value: String) {
        switch type {
        case .WoNavigationBarTypeImageFromColor:
            self.setBackgroundImage(XXSkinManager.shared.getImageWithColorKey(key: value), for: .default)
            let titleTextColor = UIColor.getColor(with: .Color_333844)
            self.tintColor = titleTextColor
            self.titleTextAttributes =
                convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: titleTextColor])
            
            if #available(iOS 15.0, *) {//UINavigationBarAppearance属性从iOS13开始
                let navBarAppearance = UINavigationBarAppearance()
                // 背景色
                navBarAppearance.backgroundColor = XXSkinManager.shared.getColorValueWith(key: value)
                // 去掉半透明效果
                navBarAppearance.backgroundEffect = nil
                // 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
                navBarAppearance.shadowColor = UIColor.clear
                // 字体颜色
                navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleTextColor]
                self.scrollEdgeAppearance = navBarAppearance
                self.standardAppearance = navBarAppearance
            }
            break
        }
    }
    
    //    MARK: 接受通知刷新UI
    @objc fileprivate func sk_navigationBar_skinDidChange() {
        for (key,value) in self.sk_navigationBar_observerDictionary {
            self.sk_navigationBar_updateUIWith(type: key, value: value)
        }
    }
}

fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

//MARK: public
extension UINavigationBar {
    public func XX_setBackgroundImage_FromColor(named: String) {
        self.sk_navigationBar_setImageFromColor(key: named)
    }
    
    public func XX_cleanNavigationBarSkinDynamic() {
        self.sk_navigationBar_isObserverSkin = false
        self.sk_navigationBar_observerDictionary.removeAll()
    }
}
