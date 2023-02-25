//
//  String+.swift
//  SwiftUIKitDarkMode
//
//  Created by 林文峰 on 2023/2/25.
//
import UIKit
extension UIColor {
    
    // MARK: 扩充构造方法
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        if(r<0){r=0}
        if(g<0){g=0}
        if(b<0){b=0}
        if(a<0){a=0}
        //print("%d %d %d %d",r,g,b,a)
        let rgb:Int = (Int)(r*0xff)<<16 | (Int)(g*0xff)<<8 | (Int)(b*0xff)<<0
        let alpha:Int = (Int)(a*0x10)<<0
        return NSString(format:"%06x%02x", rgb, alpha) as String
    }
    
    class func colorContainAlphaWithHexString(hex:String) -> UIColor {
        
        // 1.将字符串转成大写
        var hexTempString = hex.uppercased()
        
        // 2.判断字符串是否以 ## 0X 0x 开头(因为美工给的颜色16进制表示不同,有的以0X开头,有的以##开头)
        if(hexTempString.hasPrefix("##") || hexTempString.hasPrefix("0X") || hexTempString.hasPrefix("0x")){
            // 从第2个字符的位置开始截取
            hexTempString = (hexTempString as NSString).substring(from: 2)
        }
        
        // 3.判断字符串是否以 # 开头
        if(hexTempString.hasPrefix("#")){
            // 从第1个字符的位置开始截取
            hexTempString = (hexTempString as NSString).substring(from: 1)
        }
        
        // 4.判断字符串的长度是否大于等于6(格式正确才解析)
        guard hex.count >= 8 else {
            return UIColor.red
        }
        
        // 5.获取RGB分别对应的16进制
        var range = NSRange(location: 0, length: 2)
        let rHex = (hexTempString as NSString).substring(with: range)
        range.location = 2
        let gHex = (hexTempString as NSString).substring(with: range)
        range.location = 4
        let bHex = (hexTempString as NSString).substring(with: range)
        range.location = 6
        let aHex = (hexTempString as NSString).substring(with: range)
        
        // 6.将16进制转成数值
        // UInt32 表示无符号的int32.就是不能是负数
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        var a: UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        Scanner(string: aHex).scanHexInt32(&a)
    
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 15.0)
    }
    
    class func colorWithHexString(hex:String) -> UIColor {
        
        // 1.将字符串转成大写
        var hexTempString = hex.uppercased()
        
        // 2.判断字符串是否以 ## 0X 0x 开头(因为美工给的颜色16进制表示不同,有的以0X开头,有的以##开头)
        if(hexTempString.hasPrefix("##") || hexTempString.hasPrefix("0X") || hexTempString.hasPrefix("0x")){
            // 从第2个字符的位置开始截取
            hexTempString = (hexTempString as NSString).substring(from: 2)
        }
        
        // 3.判断字符串是否以 # 开头
        if(hexTempString.hasPrefix("#")){
            // 从第1个字符的位置开始截取
            hexTempString = (hexTempString as NSString).substring(from: 1)
        }
        
        // 4.判断字符串的长度是否大于等于6(格式正确才解析)
        guard hex.count >= 6 else {
            return UIColor.red
        }
        
        // 5.获取RGB分别对应的16进制
        var range = NSRange(location: 0, length: 2)
        let rHex = (hexTempString as NSString).substring(with: range)
        range.location = 2
        let gHex = (hexTempString as NSString).substring(with: range)
        range.location = 4
        let bHex = (hexTempString as NSString).substring(with: range)
        
        // 6.将16进制转成数值
        // UInt32 表示无符号的int32.就是不能是负数
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        return UIColor.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
    
    class func colorWithHexAndAlphaString(hex:String,alpha:CGFloat) -> UIColor {
        
        // 1.将字符串转成大写
        var hexTempString = hex.uppercased()
        
        // 2.判断字符串是否以 ## 0X 0x 开头(因为美工给的颜色16进制表示不同,有的以0X开头,有的以##开头)
        if(hexTempString.hasPrefix("##") || hexTempString.hasPrefix("0X") || hexTempString.hasPrefix("0x")){
            // 从第2个字符的位置开始截取
            hexTempString = (hexTempString as NSString).substring(from: 2)
        }
        
        // 3.判断字符串是否以 # 开头
        if(hexTempString.hasPrefix("#")){
            // 从第1个字符的位置开始截取
            hexTempString = (hexTempString as NSString).substring(from: 1)
        }
        
        // 4.判断字符串的长度是否大于等于6(格式正确才解析)
        guard hex.count >= 6 else {
            return UIColor.red
        }
        
        // 5.获取RGB分别对应的16进制(FF0022 -> r:FF g:00 b:22)
        var range = NSRange(location: 0, length: 2)
        let rHex = (hexTempString as NSString).substring(with: range)
        range.location = 2
        let gHex = (hexTempString as NSString).substring(with: range)
        range.location = 4
        let bHex = (hexTempString as NSString).substring(with: range)
        
        // 6.将16进制转成数值
        // UInt32 表示无符号的int32.就是不能是负数
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    func getRed() -> CGFloat {
        let compoents = self.cgColor.components ?? []
        if compoents.count > 0 {
            return compoents[0]
        } else {
            return 0
        }
    }
    
    func getGreen() -> CGFloat {
        let compoents = self.cgColor.components ?? []
        if compoents.count > 1 {
            return compoents[1]
        } else {
            return 0
        }
    }
    
    func getBlue() -> CGFloat {
        let compoents = self.cgColor.components ?? []
        if compoents.count > 2 {
            return compoents[2]
        } else {
            return 0
        }
    }

    func getRedNumber() -> CGFloat {
        let compoents = self.cgColor.components ?? []
        if compoents.count > 0 {
            return compoents[0]*255
        } else {
            return 0
        }
    }
    
    func getGreenNumber() -> CGFloat {
        let compoents = self.cgColor.components ?? []
        if compoents.count > 1 {
            return compoents[1]*255
        } else {
            return 0
        }
    }
    
    func getBlueNumber() -> CGFloat {
        let compoents = self.cgColor.components ?? []
        if compoents.count > 2 {
            return compoents[2]*255
        } else {
            return 0
        }
    }
    
    func getAlpha() -> CGFloat {
        let compoents = self.cgColor.components ?? []
        if compoents.count > 3 {
            return compoents[3]
        } else {
            return 1.0
        }
    }
    
    // MARK: 扩充类方法
    class func getRandomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
}
