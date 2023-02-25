//
//  WoUILableExtension.swift
//  Wohand
//
//  Created by 林文峰 on 2022/1/13.
//  Copyright © 2022 Zhichen Li. All rights reserved.
//

import UIKit

extension UILabel {
    
    enum WoLableType {
        case WoLableTypeTextColor
    }
    
    fileprivate struct AssociatedKeys {
        static var sk_lab_isObserverSkinKey: String = "sk_lab_isObserverSkinKey"
        static var sk_lab_observerDictionaryKey: String = "sk_lab_observerDictionaryKey"
    }

    // 是否添加观察
    fileprivate var sk_lab_isObserverSkin: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_lab_isObserverSkinKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_lab_isObserverSkinKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 字典存储观察的属性
    fileprivate var sk_lab_observerDictionary : Dictionary<WoLableType, String> {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_lab_observerDictionaryKey) as? Dictionary ?? Dictionary()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_lab_observerDictionaryKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func sk_lab_addObserver() {
        if self.sk_lab_isObserverSkin == false {
            self.sk_lab_isObserverSkin = true
            NotificationCenter.default.addObserver(self, selector: #selector(sk_lab_skinDidChange), name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        }
    }
    
    fileprivate func sk_lab_setTextColor(key: String) {
        self.sk_lab_updateObserverDictionaryWith(observerType: .WoLableTypeTextColor, value: key)
    }
    
    //    MARK: 更新控件存储的观察字段
    fileprivate func sk_lab_updateObserverDictionaryWith(observerType: WoLableType, value: String) {
        self.sk_lab_addObserver()
        self.sk_lab_observerDictionary.updateValue(value, forKey: observerType)
        self.sk_lab_updateUIWith(type: observerType, value: value)
    }
    
    //    MARK: 刷新View
    fileprivate func sk_lab_updateUIWith(type: WoLableType, value: String) {
        switch type {
        case .WoLableTypeTextColor:
            if value.contains("、") {
                let splitedArray = value.split{$0 == "、"}.map(String.init)
                self.textColor = XXSkinManager.shared.getColorValueWith(key: splitedArray.first ?? "").withAlphaComponent(CGFloat((splitedArray.last! as NSString).floatValue))
            } else {
                self.textColor = XXSkinManager.shared.getColorValueWith(key: value)
            }
            break
        }
    }
    
    //    MARK: 接受通知刷新UI
    @objc fileprivate func sk_lab_skinDidChange() {
        for (key,value) in self.sk_lab_observerDictionary {
            self.sk_lab_updateUIWith(type: key, value: value)
        }
    }
}

//MARK: public
extension UILabel {
    public func XX_setTextColor(_ key: XXColorType, _ alpha: CGFloat? = nil) {
        var keyString = key.rawValue
        if let alpha = alpha {
            keyString = key.rawValue.appending("、\(alpha)")
        }
        self.sk_lab_setTextColor(key: keyString)
    }
    
    public func XX_cleanLabelSkinDynamic() {
        self.sk_lab_isObserverSkin = false
        self.sk_lab_observerDictionary.removeAll()
    }
}
