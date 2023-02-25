//
//  WoUIImageExtension.swift
//  Wohand
//
//  Created by 林文峰 on 2022/1/17.
//  Copyright © 2022 Zhichen Li. All rights reserved.
//

import UIKit

extension UITextField {
    
    enum WoTextFieldType {
        case WoTextFieldTypeTextColor
    }
    
    fileprivate struct AssociatedKeys {
        static var sk_textField_isObserverSkinKey: String = "sk_textField_isObserverSkinKey"
        static var sk_textField_observerDictionaryKey: String = "sk_textField_observerDictionaryKey"
    }

    // 是否添加观察
    fileprivate var sk_textField_isObserverSkin: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_textField_isObserverSkinKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_textField_isObserverSkinKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 字典存储观察的属性
    fileprivate var sk_textField_observerDictionary : Dictionary<WoTextFieldType, String> {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_textField_observerDictionaryKey) as? Dictionary ?? Dictionary()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_textField_observerDictionaryKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func sk_textField_addObserver() {
        if self.sk_textField_isObserverSkin == false {
            self.sk_textField_isObserverSkin = true
            NotificationCenter.default.addObserver(self, selector: #selector(sk_textField_skinDidChange), name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        }
    }
    
    //    MARK: 更新控件存储的观察字段
    fileprivate func sk_textField_updateObserverDictionaryWith(observerType: WoTextFieldType, value: String) {
        self.sk_textField_addObserver()
        self.sk_textField_observerDictionary.updateValue(value, forKey: observerType)
        self.sk_textField_updateUIWith(type: observerType, value: value)
    }
    
    //    MARK: 刷新View
    fileprivate func sk_textField_updateUIWith(type: WoTextFieldType, value: String) {
        switch type {
        case .WoTextFieldTypeTextColor:
            if value.contains("、") {
                let splitedArray = value.split{$0 == "、"}.map(String.init)
                self.textColor = XXSkinManager.shared.getColorValueWith(key: splitedArray.first ?? "").withAlphaComponent(CGFloat((splitedArray.last! as NSString).floatValue))
            } else {
                self.textColor = XXSkinManager.shared.getColorValueWith(key: value)
            }
            if XXSkinManager.shared.isDarkMode() {
                self.keyboardAppearance = .dark
            }else {
                self.keyboardAppearance = .light
            }
            break
        }
    }
    
    //    MARK: 接受通知刷新UI
    @objc fileprivate func sk_textField_skinDidChange() {
        for (key,value) in self.sk_textField_observerDictionary {
            self.sk_textField_updateUIWith(type: key, value: value)
        }
    }
    
    fileprivate func sk_textField_setTextColor(key: String) {
        self.sk_textField_updateObserverDictionaryWith(observerType: .WoTextFieldTypeTextColor, value: key)
    }
}

//MARK: public
extension UITextField {
    public func XX_setTextColor(_ key: XXColorType, _ alpha: CGFloat? = nil) {
        var keyString = key.rawValue
        if let alpha = alpha {
            keyString = key.rawValue.appending("、\(alpha)")
        }
        self.sk_textField_setTextColor(key: keyString)
    }
    
    public func XX_cleanTextFieldSkinDynamic() {
        self.sk_textField_isObserverSkin = false
        self.sk_textField_observerDictionary.removeAll()
    }
}
