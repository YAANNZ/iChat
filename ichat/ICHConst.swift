//
//  ICHConst.swift
//  ichat
//
//  Created by ZHUYN on 2018/11/18.
//  Copyright © 2018年 iChat. All rights reserved.
//

import Foundation
import UIKit

// 扩展部分
extension UIColor {
    // 16进制 转 RGBA
    class func rgbaColorFromHex(rgb:Int, alpha: CGFloat) ->UIColor {
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: alpha)
    }
    
    //16进制 转 RGB
    class func rgbColorFromHex(rgb:Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
    
    // RGB
    class func rgbColor(r :CGFloat, g :CGFloat, b :CGFloat) ->UIColor{
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}
