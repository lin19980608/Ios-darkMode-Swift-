//
//  WoUIImageExtension.swift
//  Wohand
//
//  Created by 林文峰 on 2022/1/17.
//  Copyright © 2022 Zhichen Li. All rights reserved.
//

import UIKit

extension UIButton {
    enum WoButtonType {
        case WoButtonTypeImageNormal
        case WoButtonTypeImageHighlighted
        case WoButtonTypeImageDisabled
        case WoButtonTypeImageSelected
        case WoButtonTypeBackgroundImageNormal
        case WoButtonTypeBackgroundImageHighlighted
        case WoButtonTypeBackgroundImageDisabled
        case WoButtonTypeBackgroundImageSelected
        case WoButtonTypeTitleColorNormal
        case WoButtonTypeTitleColorHighlighted
        case WoButtonTypeTitleColorDisabled
        case WoButtonTypeTitleColorSelected
    }
    
    fileprivate struct AssociatedKeys {
        static var sk_btn_isObserverSkinKey: String = "sk_btn_isObserverSkinKey"
        static var sk_btn_observerDictionaryKey: String = "sk_btn_observerDictionaryKey"
    }

    // 是否添加观察
    fileprivate var sk_btn_isObserverSkin: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_btn_isObserverSkinKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_btn_isObserverSkinKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 字典存储观察的属性
    fileprivate var sk_btn_observerDictionary : Dictionary<WoButtonType, String> {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_btn_observerDictionaryKey) as? Dictionary ?? Dictionary()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_btn_observerDictionaryKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func sk_btn_addObserver() {
        if self.sk_btn_isObserverSkin == false {
            self.sk_btn_isObserverSkin = true
            NotificationCenter.default.addObserver(self, selector: #selector(sk_btn_skinDidChange), name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        }
    }
    
    //    MARK: 更新控件存储的观察字段
    fileprivate func sk_btn_updateObserverDictionaryWith(observerType: WoButtonType, value: String) {
        self.sk_btn_addObserver()
        self.sk_btn_observerDictionary.updateValue(value, forKey: observerType)
        self.sk_btn_updateUIWith(type: observerType, value: value)
    }
    
    //    MARK: 刷新View
    fileprivate func sk_btn_updateUIWith(type: WoButtonType, value: String) {
        switch type {
        case .WoButtonTypeImageNormal:
            self.setImage(XXSkinManager.shared.getImageWithNameKey(key: value), for: .normal)
            break
        case .WoButtonTypeImageHighlighted:
            self.setImage(XXSkinManager.shared.getImageWithNameKey(key: value), for: .highlighted)
            break
        case .WoButtonTypeImageDisabled:
            self.setImage(XXSkinManager.shared.getImageWithNameKey(key: value), for: .disabled)
            break
        case .WoButtonTypeImageSelected:
            self.setImage(XXSkinManager.shared.getImageWithNameKey(key: value), for: .selected)
            break
        case .WoButtonTypeBackgroundImageNormal:
            self.setBackgroundImage(XXSkinManager.shared.getImageWithNameKey(key: value), for: .normal)
            break
        case .WoButtonTypeBackgroundImageHighlighted:
            self.setBackgroundImage(XXSkinManager.shared.getImageWithNameKey(key: value), for: .highlighted)
            break
        case .WoButtonTypeBackgroundImageDisabled:
            self.setBackgroundImage(XXSkinManager.shared.getImageWithNameKey(key: value), for: .disabled)
            break
        case .WoButtonTypeBackgroundImageSelected:
            self.setBackgroundImage(XXSkinManager.shared.getImageWithNameKey(key: value), for: .selected)
            break
        case .WoButtonTypeTitleColorNormal,.WoButtonTypeTitleColorHighlighted,.WoButtonTypeTitleColorDisabled,.WoButtonTypeTitleColorSelected:
            var state:UIControl.State = .normal
            switch type {
            case .WoButtonTypeTitleColorNormal:
                state = .normal
            case .WoButtonTypeTitleColorHighlighted:
                state = .highlighted
            case .WoButtonTypeTitleColorDisabled:
                state = .disabled
            case .WoButtonTypeTitleColorSelected:
                state = .selected
            default:
                state = .normal
            }
            if value.contains("、") {
                let splitedArray = value.split{$0 == "、"}.map(String.init)
//                self.setTitleColor(XXSkinManager.shared.getColorValueWith(key: splitedArray.first ?? "").withAlphaComponent(CGFloat((splitedArray.last! as NSString).floatValue)), for: state)
                let color = XXSkinManager.shared.getColorValueWith(key: splitedArray.first ?? "").withAlphaComponent(CGFloat((splitedArray.last! as NSString).floatValue))
                       self.setTitleColor(color, for: state)
            } else {
                self.setTitleColor(XXSkinManager.shared.getColorValueWith(key: value), for: state)
            }
            break
//        case .WoButtonTypeTitleColorHighlighted:
//            self.setTitleColor(XXSkinManager.shared.getColorValueWith(key: value), for: .highlighted)
//            break
//        case .WoButtonTypeTitleColorDisabled:
//            self.setTitleColor(XXSkinManager.shared.getColorValueWith(key: value), for: .disabled)
//            break
//        case .WoButtonTypeTitleColorSelected:
//            self.setTitleColor(XXSkinManager.shared.getColorValueWith(key: value), for: .selected)
//            break
        }
    }
    
    //    MARK: 接受通知刷新UI
    @objc fileprivate func sk_btn_skinDidChange() {
        for (key,value) in self.sk_btn_observerDictionary {
            self.sk_btn_updateUIWith(type: key, value: value)
        }
    }
}

//MARK: public
extension UIButton {
    public func XX_setImage(named: String, `for`: UIControl.State) {
        switch `for` {
        case .normal:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeImageNormal, value: named)
        case .highlighted:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeImageHighlighted, value: named)
        case .disabled:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeImageDisabled, value: named)
        case .selected:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeImageSelected, value: named)
        default:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeImageNormal, value: named)
        }
    }
    
    public func XX_setBackgroundImage(named: String, `for`: UIControl.State) {
        switch `for` {
        case .normal:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeBackgroundImageNormal, value: named)
        case .highlighted:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeBackgroundImageHighlighted, value: named)
        case .disabled:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeBackgroundImageDisabled, value: named)
        case .selected:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeBackgroundImageSelected, value: named)
        default:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeBackgroundImageNormal, value: named)
        }
    }
    
    public func XX_setTitleColor(_ key: XXColorType,_ alpha: CGFloat? = nil, `for`: UIControl.State) {
        var keyString = key.rawValue
        if let alpha = alpha {
            keyString = key.rawValue.appending("、\(alpha)")
        }
        switch `for` {
        case .normal:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeTitleColorNormal, value: keyString)
        case .highlighted:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeTitleColorHighlighted, value: keyString)
        case .disabled:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeTitleColorDisabled, value: keyString)
        case .selected:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeTitleColorSelected, value: keyString)
        default:
            self.sk_btn_updateObserverDictionaryWith(observerType: .WoButtonTypeTitleColorNormal, value: keyString)
        }
    }
    
    public func XX_cleanButtonSkinDynamic() {
        self.sk_btn_isObserverSkin = false
        self.sk_btn_observerDictionary.removeAll()
    }
}
