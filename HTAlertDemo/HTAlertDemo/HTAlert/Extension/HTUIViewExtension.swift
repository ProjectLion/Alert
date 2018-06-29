//
//  HTUIViewExtension.swift
//  HTDevelopTool_Swift
//
//  Created by HT on 2017/12/15.
//  Copyright © 2017年 HT. All rights reserved.
//

import Foundation
import UIKit

/**
 *   properties
 */
extension UIView {
    /// view的x
    var ht_x: CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    /// view的y
    var ht_y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    /// view的宽
    var ht_width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            self.frame.size.width = newValue
        }
    }
    /// view的高
    var ht_height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            self.frame.size.height = newValue
        }
    }
    /// view的上
    var ht_top: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    /// view的下
    var ht_bottom: CGFloat{
        get{
            return self.frame.origin.y + self.frame.size.height
        }
        set{
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }
    /// view的左
    var ht_left: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    /// view的右
    var ht_right: CGFloat{
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set{
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }
    /// view的中心
    var ht_center: CGPoint{
        get{
            return self.center
        }
        set{
            self.center = newValue
        }
    }
    /// view的X轴中心
    var ht_centerX: CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center.x = newValue
        }
    }
    /// view的Y轴中心
    var ht_centerY: CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center.y = newValue
        }
    }
}

/**
 *   Method
 */
extension UIView {
    
    /// 创建一个view
    ///
    /// - Parameters:
    ///   - x: x
    ///   - y: y
    ///   - width: width
    ///   - height: height
    ///   - backGroundColor: 背景色
    convenience init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, backGroundColor: UIColor = .white){
        self.init(frame: CGRect(x: x, y: y, width: width, height: height))
        self.backgroundColor = backGroundColor
    }
    
    /// 收尾
    open func ht_end() {
        
    }
    
    /// 添加边框、颜色及切圆角 (默认为灰色1.5宽的边框,圆角半径为5)
    ///
    /// - Parameters:
    ///   - borderWith: 边框宽
    ///   - borderColor: 边框颜色
    ///   - cornerRadius: 圆角半径
    open func ht_add(borderWith: CGFloat = 1.5, borderColor: UIColor = .gray, cornerRadius: CGFloat = 5) -> UIView {
        self.layer.borderWidth = borderWith
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        if cornerRadius > 0 {
            self.clipsToBounds = true
        }
        return self
    }
    
    /// 对当前view截图
    ///
    /// - Returns: 返回UIImage or nil
    open func shot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        if self.responds(to: #selector(drawHierarchy(in:afterScreenUpdates:))) {
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        } else {
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        let shotImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return shotImg
    }
}





