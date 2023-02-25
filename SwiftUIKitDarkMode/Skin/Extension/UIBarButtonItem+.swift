//
//  WoUIImageExtension.swift
//  Wohand
//
//  Created by 林文峰 on 2022/1/17.
//  Copyright © 2022 Zhichen Li. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    enum WoBarButtonItemType {
        case WoBarButtonItemTypeImage
    }
    
    fileprivate struct AssociatedKeys {
        static var sk_barButtonItem_isObserverSkinKey: String = "sk_barButtonItem_isObserverSkinKey"
        static var sk_barButtonItem_observerDictionaryKey: String = "sk_barButtonItem_observerDictionaryKey"
    }

    // 是否添加观察
    fileprivate var sk_barButtonItem_isObserverSkin: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_barButtonItem_isObserverSkinKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_barButtonItem_isObserverSkinKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 字典存储观察的属性
    fileprivate var sk_barButtonItem_observerDictionary : Dictionary<WoBarButtonItemType, String> {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_barButtonItem_observerDictionaryKey) as? Dictionary ?? Dictionary()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_barButtonItem_observerDictionaryKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func sk_barButtonItem_addObserver() {
        if self.sk_barButtonItem_isObserverSkin == false {
            self.sk_barButtonItem_isObserverSkin = true
            NotificationCenter.default.addObserver(self, selector: #selector(sk_barButtonItem_skinDidChange), name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        }
    }
    
    //    MARK: 更新控件存储的观察字段
    fileprivate func sk_barButtonItem_updateObserverDictionaryWith(observerType: WoBarButtonItemType, value: String) {
        self.sk_barButtonItem_addObserver()
        self.sk_barButtonItem_observerDictionary.updateValue(value, forKey: observerType)
        self.sk_barButtonItem_updateUIWith(type: observerType, value: value)
    }
    
    //    MARK: 刷新View
    fileprivate func sk_barButtonItem_updateUIWith(type: WoBarButtonItemType, value: String) {
        switch type {
        case .WoBarButtonItemTypeImage:
            self.image = XXSkinManager.shared.getImageWithNameKey(key: value)
            break
        }
    }
    
    //    MARK: 接受通知刷新UI
    @objc fileprivate func sk_barButtonItem_skinDidChange() {
        for (key,value) in self.sk_barButtonItem_observerDictionary {
            self.sk_barButtonItem_updateUIWith(type: key, value: value)
        }
    }
}

//MARK: public
extension UIBarButtonItem {
    public func XX_setImage(named: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        self.sk_barButtonItem_updateObserverDictionaryWith(observerType: .WoBarButtonItemTypeImage, value:named)
    }
    
    public func XX_cleanBarButtonSkinDynamic() {
        self.sk_barButtonItem_isObserverSkin = false
        self.sk_barButtonItem_observerDictionary.removeAll()
    }
}
