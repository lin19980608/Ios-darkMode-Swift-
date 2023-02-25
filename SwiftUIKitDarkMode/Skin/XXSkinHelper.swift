//
//  WoResourceHelper.swift
//  Wohand
//
//  Created by 林文峰 on 2022/1/13.
//  Copyright © 2022 Zhichen Li. All rights reserved.
//

import UIKit

public enum XXColorType: String {
    case Color_333844 = "Color_333844"  //
    case Color_9CA1A4 = "Color_9CA1A4"
    case Color_FEFEFE = "Color_FEFEFE"
    case Color_E0393A = "Color_E0393A"
    case Color_477EEF = "Color_477EEF"
    case Color_00D668 = "Color_00D668"
    case Color_F7F8F8 = "Color_F7F8F8"  //
    case Color_FFFFFF = "Color_FFFFFF"  //
    case Color_DADDDF = "Color_DADDDF"  //
    case Color_DADDDF_6C717C = "Color_DADDDF_6C717C"  //
    case Color_DADDDD = "Color_DADDDD"  // 瞄边
    case Color_000000 = "Color_000000"  // 分割线
    case Color_000001 = "Color_000001"  // 弹窗
    case Color_E1E7F3 = "Color_E1E7F3"
    case Color_FDECED = "Color_FDECED"
    case Color_ECECEC = "Color_ECECEC"  //
    case Color_E8E8E8 = "Color_E8E8E8"
    case Color_FBEBEB = "Color_FBEBEB"
    case Color_2C3849 = "Color_2C3849"  //
    case Color_Clear = "Color_Clear"
    case Color_6C717C = "Color_6C717C" //添加页面headerview titile
    
}

class XXSkinHelper: NSObject {
    
    class func getColorValueWith(key: String, skinType: XXSkinType) -> UIColor {
        switch key {
        case "Color_333844":
            return skinType == .XXSkinTypeDark ? UIColor.colorWithHexString(hex: "DADDDF") : UIColor.colorWithHexString(hex: "333844")
        case "Color_F7F8F8":
            return skinType == .XXSkinTypeDark ? UIColor.colorWithHexString(hex: "111925") : UIColor.colorWithHexString(hex: "F7F8F8")
        case "Color_FFFFFF":
            return skinType == .XXSkinTypeDark ? UIColor.colorWithHexString(hex: "263242") : UIColor.colorWithHexString(hex: "FFFFFF")
        case "Color_DADDDF":
            return skinType == .XXSkinTypeDark ? UIColor.colorWithHexString(hex: "111925") : UIColor.colorWithHexString(hex: "DADDDF")
        case "Color_DADDDF_6C717C":
            return skinType == .XXSkinTypeDark ? UIColor.colorWithHexString(hex: "6C717C") : UIColor.colorWithHexString(hex: "DADDDF")
        case "Color_DADDDD":
            return UIColor.colorWithHexString(hex: "DADDDF")
        case "Color_000000":
            return skinType == .XXSkinTypeDark ? UIColor.colorWithHexAndAlphaString(hex: "DADDDF", alpha: 0.1) : UIColor.colorWithHexAndAlphaString(hex: "000000", alpha: 0.1)
        case "Color_000001":
            return skinType == .XXSkinTypeDark ? UIColor.colorWithHexAndAlphaString(hex: "000000", alpha: 0.5) : UIColor.colorWithHexAndAlphaString(hex: "000000", alpha: 0.3)
        case "Color_ECECEC":
            return skinType == .XXSkinTypeDark ? UIColor.colorWithHexAndAlphaString(hex: "ECECEC", alpha: 1.0) : UIColor.colorWithHexAndAlphaString(hex: "ECECEC", alpha: 0.0)
        case "Color_2C3849":
            return skinType == .XXSkinTypeDark ? UIColor.colorWithHexAndAlphaString(hex: "2C3849", alpha: 0.2) : UIColor.colorWithHexAndAlphaString(hex: "2C3849", alpha: 0.0)
        case "Color_6C717C":
            return UIColor.colorWithHexAndAlphaString(hex: "6C717C", alpha: 1)
        default:
            break
        }
        let splitedArray = key.split{$0 == "_"}.map(String.init)
        if let hex = splitedArray.last {
            if hex == "Clear" { return UIColor.clear }
            return UIColor.colorWithHexString(hex: hex)
        }
        return UIColor.clear
    }
    
    class func getImageWithColorKey(key: String, skinType: XXSkinType) -> UIImage {
        return UIImage.imageFromColor(color: XXSkinHelper.getColorValueWith(key: key, skinType: skinType))
    }
    
    class func getImageWithNameKey(key: String, skinType: XXSkinType) -> UIImage {
        if XXSkinManager.shared.isDarkMode() {
            let image = UIImage(named: key + "_darkMode")
            if image == nil {
                return UIImage(named: key) ?? UIImage()
            } else {
                return image ?? UIImage()
            }
        } else {
            return UIImage(named: key) ?? UIImage()
        }
    }
    
}

extension UIImage {
    class func imageFromColor(color: UIColor) -> UIImage {
        //创建1像素区域并开始图片绘图
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        //创建画板并填充颜色和区域
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        //从画板上获取图片并关闭图片绘图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
