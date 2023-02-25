//
//  WoUIImageExtension.swift
//  Wohand
//
//  Created by 林文峰 on 2022/1/17.
//  Copyright © 2022 Zhichen Li. All rights reserved.
//

import UIKit

extension UITextView {
    
    enum WoTextViewType {
        case WoTextViewTypeTextColor
    }
    
    fileprivate struct AssociatedKeys {
        static var sk_textView_isObserverSkinKey: String = "sk_textView_isObserverSkinKey"
        static var sk_textView_observerDictionaryKey: String = "sk_textView_observerDictionaryKey"
    }

    // 是否添加观察
    fileprivate var sk_textView_isObserverSkin: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_textView_isObserverSkinKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_textView_isObserverSkinKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 字典存储观察的属性
    fileprivate var sk_textView_observerDictionary : Dictionary<WoTextViewType, String> {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_textView_observerDictionaryKey) as? Dictionary ?? Dictionary()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_textView_observerDictionaryKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func sk_textView_addObserver() {
        if self.sk_textView_isObserverSkin == false {
            self.sk_textView_isObserverSkin = true
            NotificationCenter.default.addObserver(self, selector: #selector(sk_textView_skinDidChange), name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        }
    }
    
    //    MARK: 更新控件存储的观察字段
    fileprivate func sk_textView_updateObserverDictionaryWith(observerType: WoTextViewType, value: String) {
        self.sk_textView_addObserver()
        self.sk_textView_observerDictionary.updateValue(value, forKey: observerType)
        self.sk_textView_updateUIWith(type: observerType, value: value)
    }
    
    //    MARK: 刷新View
    fileprivate func sk_textView_updateUIWith(type: WoTextViewType, value: String) {
        switch type {
        case .WoTextViewTypeTextColor:
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
    @objc fileprivate func sk_textView_skinDidChange() {
        for (key,value) in self.sk_textView_observerDictionary {
            self.sk_textView_updateUIWith(type: key, value: value)
        }
    }
    
    fileprivate func sk_textView_setTextColor(key: String) {
        self.sk_textView_updateObserverDictionaryWith(observerType: .WoTextViewTypeTextColor, value: key)
    }
}

//MARK: public
extension UITextView {
    public func XX_setTextColor(_ key: XXColorType, _ alpha: CGFloat? = nil) {
        var keyString = key.rawValue
        if let alpha = alpha {
            keyString = key.rawValue.appending("、\(alpha)")
        }
        self.sk_textView_setTextColor(key: keyString)
    }
    
    public func XX_cleanTextViewSkinDynamic() {
        self.sk_textView_isObserverSkin = false
        self.sk_textView_observerDictionary.removeAll()
    }
}
