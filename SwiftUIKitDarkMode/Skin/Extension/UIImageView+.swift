//
//  WoUIImageExtension.swift
//  Wohand
//
//  Created by 林文峰 on 2022/1/17.
//  Copyright © 2022 Zhichen Li. All rights reserved.
//

import UIKit

extension UIImageView {
    
    enum WoImageType {
        case WoImageTypeImageFromPic
    }
    
    fileprivate struct AssociatedKeys {
        static var sk_image_isObserverSkinKey: String = "sk_image_isObserverSkinKey"
        static var sk_image_observerDictionaryKey: String = "sk_image_observerDictionaryKey"
    }

    // 是否添加观察
    fileprivate var sk_image_isObserverSkin: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_image_isObserverSkinKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_image_isObserverSkinKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 字典存储观察的属性
    fileprivate var sk_image_observerDictionary : Dictionary<WoImageType, String> {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_image_observerDictionaryKey) as? Dictionary ?? Dictionary()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_image_observerDictionaryKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func sk_image_addObserver() {
        if self.sk_image_isObserverSkin == false {
            self.sk_image_isObserverSkin = true
            NotificationCenter.default.addObserver(self, selector: #selector(sk_image_skinDidChange), name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        }
    }
    
    //    MARK: 更新控件存储的观察字段
    fileprivate func sk_image_updateObserverDictionaryWith(observerType: WoImageType, value: String) {
        self.sk_image_addObserver()
        self.sk_image_observerDictionary.updateValue(value, forKey: observerType)
        self.sk_image_updateUIWith(type: observerType, value: value)
    }
    
    //    MARK: 刷新View
    fileprivate func sk_image_updateUIWith(type: WoImageType, value: String) {
        switch type {
        case .WoImageTypeImageFromPic:
            self.image = XXSkinManager.shared.getImageWithNameKey(key: value)
            break
        }
    }
    
    //    MARK: 接受通知刷新UI
    @objc fileprivate func sk_image_skinDidChange() {
        for (key,value) in self.sk_image_observerDictionary {
            self.sk_image_updateUIWith(type: key, value: value)
        }
    }
}


//MARK: public
extension UIImageView {
    public func XX_setImage(named: String) {
        self.sk_image_updateObserverDictionaryWith(observerType: .WoImageTypeImageFromPic, value:named)
    }
    
    public func XX_cleanImageViewSkinDynamic() {
        self.sk_image_isObserverSkin = false
        self.sk_image_observerDictionary.removeAll()
    }
}
 
