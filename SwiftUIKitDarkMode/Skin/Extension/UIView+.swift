//
//  WoSkinExtension.swift
//  Wohand
//
//  Created by 林文峰 on 2022/1/13.
//  Copyright © 2022 Zhichen Li. All rights reserved.
//

import UIKit

extension UIView {
    
    enum WoViewType {
        case WoViewTypeBackground
        case WoViewTypeBlock
    }
    
    public typealias skinDidChangeBlock = (UIView)->(Void)
    
    fileprivate struct AssociatedKeys {
        static var sk_view_isObserverSkinKey: String = "sk_view_isObserverSkinKey"
        static var sk_view_observerDictionaryKey: String = "sk_view_observerDictionaryKey"
        static var sk_view_skinDidChangeBlock: String = "sk_view_skinDidChangeBlock"
    }
    
    // 是否添加观察
    fileprivate var sk_view_isObserverSkin: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_view_isObserverSkinKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_view_isObserverSkinKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 字典存储观察的属性
    fileprivate var sk_view_observerDictionary : Dictionary<WoViewType, String> {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_view_observerDictionaryKey) as? Dictionary ?? Dictionary()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_view_observerDictionaryKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var sk_view_skinDidChangeBlock : skinDidChangeBlock? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sk_view_skinDidChangeBlock) as? skinDidChangeBlock ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sk_view_skinDidChangeBlock, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func sk_view_addObserver() {
        if self.sk_view_isObserverSkin == false {
            self.sk_view_isObserverSkin = true
            NotificationCenter.default.addObserver(self, selector: #selector(sk_view_skinDidChange), name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        }
    }
    
    fileprivate func sk_view_setBackgroundColor(key: String) {
        self.sk_view_updateObserverDictionaryWith(observerType: .WoViewTypeBackground, value: key)
    }
    
    fileprivate func sk_view_setBlock(key: String) {
        self.sk_view_updateObserverDictionaryWith(observerType: .WoViewTypeBlock, value: key)
    }
    
    //    MARK: 更新控件存储的观察字段
    fileprivate func sk_view_updateObserverDictionaryWith(observerType: WoViewType, value: String) {
        self.sk_view_addObserver()
        self.sk_view_observerDictionary.updateValue(value, forKey: observerType)
        self.sk_view_updateUIWith(type: observerType, value: value)
    }
    
    //    MARK: 刷新View
    fileprivate func sk_view_updateUIWith(type: WoViewType, value: String) {
        switch type {
        case .WoViewTypeBackground:
            if value.contains("、") {
                let splitedArray = value.split{$0 == "、"}.map(String.init)
                self.backgroundColor = XXSkinManager.shared.getColorValueWith(key: splitedArray.first ?? "").withAlphaComponent(CGFloat((splitedArray.last! as NSString).floatValue))
            } else {
                self.backgroundColor = XXSkinManager.shared.getColorValueWith(key: value)
            }
            break
        case .WoViewTypeBlock:
            self.sk_view_skinDidChangeBlock?(self)
            break
        }
    }
    
    //    MARK: 接受通知刷新UI
    @objc fileprivate func sk_view_skinDidChange() {
        for (key,value) in self.sk_view_observerDictionary {
            self.sk_view_updateUIWith(type: key, value: value)
        }
    }
}

//MARK: public
extension UIView {
    public func XX_setBackgroundColor(_ key: XXColorType, _ alpha: CGFloat? = nil) {
        var keyString = key.rawValue
        if let alpha = alpha {
            keyString = key.rawValue.appending("、\(alpha)")
        }
        self.sk_view_setBackgroundColor(key: keyString)
    }
    
    public func XX_skinDidChangeBlock(_ updateBlock:skinDidChangeBlock?) {
        guard let updateBlock = updateBlock else { return }
        self.sk_view_skinDidChangeBlock = updateBlock
        self.sk_view_setBlock(key: "defalutKey")
    }
    
    
    public func XX_cleanAllSkinDynamic() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "XX_skinDidChange"), object: nil)
        
        self.sk_view_skinDidChangeBlock = nil
        self.XX_cleanViewSkinDynamic()
        if let label = self as? UILabel {
            label.XX_cleanLabelSkinDynamic()
        }else if let imageView = self as? UIImageView {
            imageView.XX_cleanImageViewSkinDynamic()
        }else if let button = self as? UIButton {
            button.XX_cleanButtonSkinDynamic()
        }else if let textField = self as? UITextField {
            textField.XX_cleanTextFieldSkinDynamic()
        }else if let navigationBar = self as? UINavigationBar {
            navigationBar.XX_cleanNavigationBarSkinDynamic()
        }else if let textView = self as? UITextView {
            textView.XX_cleanTextViewSkinDynamic()
        }else if let refresh = self as? UIRefreshControl {
            refresh.XX_cleanRefreshControlSkinDynamic()
        }
        
        self.layer.XX_cleanLayerSkinDynamic()
    }
    
    public func XX_cleanViewSkinDynamic() {
        self.sk_view_isObserverSkin = false
        self.sk_view_observerDictionary.removeAll()
    }
}
