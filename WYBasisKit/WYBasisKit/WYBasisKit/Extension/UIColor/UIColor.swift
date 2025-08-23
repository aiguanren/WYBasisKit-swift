//
//  UIColor.swift
//  WYBasisKit
//
//  Created by 官人 on 2020/8/29.
//  Copyright © 2020 官人. All rights reserved.
//

import UIKit

public extension UIColor {
    
    /// RGB(A) convert UIColor
    class func wy_rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ aplha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: aplha)
    }
    
    /// hexColor convert UIColor
    class func wy_hex(_ hexColor: String, _ alpha: CGFloat = 1.0) -> UIColor {
        var colorStr = hexColor.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // 长度检查
        if colorStr.count < 6 {
            return UIColor.clear
        }
        
        // 去掉前缀
        if colorStr.hasPrefix("0X") || colorStr.hasPrefix("0x") {
            colorStr = String(colorStr.dropFirst(2))
        }
        if colorStr.hasPrefix("#") {
            colorStr = String(colorStr.dropFirst(1))
        }
        
        if colorStr.count != 6 {
            return UIColor.clear
        }
        
        // 获取 R/G/B 子字符串
        let redStr = String(colorStr.prefix(2))
        let greenStr = String(colorStr[colorStr.index(colorStr.startIndex, offsetBy: 2)..<colorStr.index(colorStr.startIndex, offsetBy: 4)])
        let blueStr = String(colorStr.suffix(2))
        
        // 扫描十六进制数
        var R: UInt64 = 0, G: UInt64 = 0, B: UInt64 = 0
        Scanner(string: redStr).scanHexInt64(&R)
        Scanner(string: greenStr).scanHexInt64(&G)
        Scanner(string: blueStr).scanHexInt64(&B)
        
        return UIColor(red: CGFloat(R)/255.0, green: CGFloat(G)/255.0, blue: CGFloat(B)/255.0, alpha: alpha)
    }
    
    /// hexColor convert UIColor
    class func wy_hex(_ hexColor: UInt, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(
            red: CGFloat((hexColor & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexColor & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexColor & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    /// randomColor
    class var wy_random: UIColor {
        return UIColor(
            red:   CGFloat.random(in: 0...255) / 255.0,
            green: CGFloat.random(in: 0...255) / 255.0,
            blue:  CGFloat.random(in: 0...255) / 255.0,
            alpha: 1.0
        )
    }
    
    /// 动态颜色
    class func wy_dynamic(_ light: UIColor, _ dark: UIColor) -> UIColor {
        let dynamicColor = UIColor { (trainCollection) -> UIColor in
            if trainCollection.userInterfaceStyle == UIUserInterfaceStyle.light {
                return light
            }else {
                return dark
            }
        }
        return dynamicColor
    }
}
