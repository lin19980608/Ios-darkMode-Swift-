//
//  WoUIImageExtension.swift
//  Wohand
//
//  Created by 林文峰 on 2022/1/17.
//  Copyright © 2022 Zhichen Li. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    
    enum WoRefreshControlType {
        case WoRefreshControlTypeTintColor
    }
    
    fileprivate struct AssociatedKeys {
        static var sk_refreshControl_isObserverSkinKey: String = "sk_refreshControl_isObserverSkinKey"
        static var sk_refreshControl_observerDictionaryKey: String = "sk_refreshControl_observerDictionaryKey"
    }

    // 是否添加观察
    fileprivate var sk_refreshControl_isObserverSkin: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_refreshControl_isObserverSkinKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_refreshControl_isObserverSkinKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 字典存储观察的属性
    fileprivate var sk_refreshControl_observerDictionary : Dictionary<WoRefreshControlType, String> {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_refreshControl_observerDictionaryKey) as? Dictionary ?? Dictionary()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_refreshControl_observerDictionaryKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func sk_refreshControl_addObserver() {
        if self.sk_refreshControl_isObserverSkin == false {
            self.sk_refreshControl_isObserverSkin = true
            NotificationCenter.default.addObserver(self, selector: #selector(sk_refreshControl_skinDidChange), name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        }
    }
    
    fileprivate func sk_refreshControl_setTintColor(key: String!) {
        self.sk_refreshControl_updateObserverDictionaryWith(observerType: .WoRefreshControlTypeTintColor, value: key)
    }
    
    //    MARK: 更新控件存储的观察字段
    fileprivate func sk_refreshControl_updateObserverDictionaryWith(observerType: WoRefreshControlType, value: String) {
        self.sk_refreshControl_addObserver()
        self.sk_refreshControl_observerDictionary.updateValue(value, forKey: observerType)
        self.sk_refreshControl_updateUIWith(type: observerType, value: value)
    }
    
    //    MARK: 刷新View
    fileprivate func sk_refreshControl_updateUIWith(type: WoRefreshControlType, value: String) {
        switch type {
        case .WoRefreshControlTypeTintColor:
            if value.contains("、") {
                let splitedArray = value.split{$0 == "、"}.map(String.init)
                self.tintColor = XXSkinManager.shared.getColorValueWith(key: splitedArray.first ?? "").withAlphaComponent(CGFloat((splitedArray.last! as NSString).floatValue))
            } else {
                self.tintColor = XXSkinManager.shared.getColorValueWith(key: value)
            }
            break
        }
    }
    
    //    MARK: 接受通知刷新UI
    @objc fileprivate func sk_refreshControl_skinDidChange() {
        for (key,value) in self.sk_refreshControl_observerDictionary {
            self.sk_refreshControl_updateUIWith(type: key, value: value)
        }
    }
}

//MARK: public
extension UIRefreshControl {
    public func XX_setTintColor(_ key: XXColorType, _ alpha: CGFloat? = nil) {
        var keyString = key.rawValue
        if let alpha = alpha {
            keyString = key.rawValue.appending("、\(alpha)")
        }
        self.sk_refreshControl_setTintColor(key: keyString)
    }
    
    public func XX_cleanRefreshControlSkinDynamic() {
        self.sk_refreshControl_isObserverSkin = false
        self.sk_refreshControl_observerDictionary.removeAll()
    }
}
