//
//  WoUIImageExtension.swift
//  Wohand
//
//  Created by 林文峰 on 2022/1/17.
//  Copyright © 2022 Zhichen Li. All rights reserved.
//

import UIKit

extension CALayer {
    
    enum WoCALayerType {
        case WoCALayerTypeBorderColor
    }
    
    fileprivate struct AssociatedKeys {
        static var sk_CALayer_isObserverSkinKey: String = "sk_CALayer_isObserverSkinKey"
        static var sk_CALayer_observerDictionaryKey: String = "sk_CALayer_observerDictionaryKey"
    }

    // 是否添加观察
    fileprivate var sk_CALayer_isObserverSkin: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_CALayer_isObserverSkinKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_CALayer_isObserverSkinKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 字典存储观察的属性
    fileprivate var sk_CALayer_observerDictionary : Dictionary<WoCALayerType, String> {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_CALayer_observerDictionaryKey) as? Dictionary ?? Dictionary()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_CALayer_observerDictionaryKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func sk_CALayer_addObserver() {
        if self.sk_CALayer_isObserverSkin == false {
            self.sk_CALayer_isObserverSkin = true
            NotificationCenter.default.addObserver(self, selector: #selector(sk_CALayer_skinDidChange), name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        }
    }
    
    //    MARK: 更新控件存储的观察字段
    fileprivate func sk_CALayer_updateObserverDictionaryWith(observerType: WoCALayerType, value: String) {
        self.sk_CALayer_addObserver()
        self.sk_CALayer_observerDictionary.updateValue(value, forKey: observerType)
        self.sk_CALayer_updateUIWith(type: observerType, value: value)
    }
    
    //    MARK: 刷新View
    fileprivate func sk_CALayer_updateUIWith(type: WoCALayerType, value: String) {
        switch type {
        case .WoCALayerTypeBorderColor:
            if value.contains("、") {
                let splitedArray = value.split{$0 == "、"}.map(String.init)
                self.borderColor = (XXSkinManager.shared.getColorValueWith(key: splitedArray.first ?? "").withAlphaComponent(CGFloat((splitedArray.last! as NSString).floatValue))).cgColor
            } else {
                self.borderColor = XXSkinManager.shared.getColorValueWith(key: value).cgColor
            }
            break
        }
    }
    
    //    MARK: 接受通知刷新UI
    @objc fileprivate func sk_CALayer_skinDidChange() {
        for (key,value) in self.sk_CALayer_observerDictionary {
            self.sk_CALayer_updateUIWith(type: key, value: value)
        }
    }
}

//MARK: public
extension CALayer {
    public func XX_setBorderColor(_ key: XXColorType, _ alpha: CGFloat? = nil) {
        var keyString = key.rawValue
        if let alpha = alpha {
            keyString = key.rawValue.appending("、\(alpha)")
        }
        self.sk_CALayer_updateUIWith(type: .WoCALayerTypeBorderColor, value: keyString)
    }
    
    public func XX_cleanLayerSkinDynamic() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        
        self.sk_CALayer_isObserverSkin = false
        self.sk_CALayer_observerDictionary.removeAll()
    }
}
