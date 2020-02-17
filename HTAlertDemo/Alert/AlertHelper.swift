//
//  AlertHelper.swift
//  AlertDemo
//
//  Created by Ht on 2018/6/25.
//  Copyright © 2018年 Ht. All rights reserved.
//

import Foundation
import UIKit

/// Debug输出
public func print<T>(message: T, file: String = #file, line: Int = #line, method: String = #function) {
    #if DEBUG
    print("\((file as NSString).lastPathComponent)文件第\(line)行,\(method)方法,logMessage: \(message)")
    #endif
}

//MARK: ^^^^^^^^^^^^^^^ 全局常量及方法 ^^^^^^^^^^^^^^^
/// 默认偏移量
public let DefaultEdgInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
/// 默认字体
public let DefaultFont = UIFont.systemFont(ofSize: 16)

public let Scrren_W = UIScreen.main.bounds.width
public let Scrren_H = UIScreen.main.bounds.height
/// 默认边框宽度
public let DefaultBorder_W: CGFloat = 1 / UIScreen.main.scale + 0.02

public func viewSafeaInsets(view: UIView) -> UIEdgeInsets {
    if #available(iOS 11, *) {
        return view.safeAreaInsets
    } else {
        return .zero
    }
}
/**************************/

//MARK: ^^^^^^^^^^^^^^^ 别名 ^^^^^^^^^^^^^^^

public typealias Config = () -> Void

public typealias ConfigToCustomAlert = (CustomAlert) -> Void

public typealias ConfigToBool = (Bool) -> Void

public typealias ConfigToInt = (Int) -> Void

public typealias ConfigToCGFloat = (CGFloat) -> Void

public typealias ConfigToString = (String) -> Void

public typealias ConfigToView = (UIView) -> Void

public typealias ConfigToColor = (UIColor) -> Void

public typealias ConfigToSize = (CGSize) -> Void

public typealias ConfigToEdgeInsets = (UIEdgeInsets) -> Void

public typealias ConfigToEffectStyle = (UIBlurEffect.Style) -> Void

public typealias ConfigToInterfaceOrientationMask = (UIInterfaceOrientationMask) -> Void

public typealias ConfigToCGFloatBlock = (ScreenOrientationType) -> CGFloat

public typealias ConfigToAction = (Action) -> Void

public typealias ConfigToCustomView = (CustomView) -> Void

public typealias ConfigToStringAndBlock = (String, () -> Void) -> Void

public typealias ConfigToLabel = (UILabel) -> Void

public typealias ConfigToTextField = (UITextField) -> Void

public typealias ConfigToItem = (Item) -> Void

public typealias ConfigToBlock = () -> Void

public typealias ConfigToBlockAndBlock = (_ animatingBlock: @escaping () -> Void,_ animatedBlock: @escaping () -> Void) -> Void

/**************************/

//MARK: ^^^^^^^^^^^^^^^ 枚举 ^^^^^^^^^^^^^^^

/// 背景样式
public enum BackgroundStyle {
    /// 模糊
    case blur
    /// 半透明
    case translucent
}

/// 自定义view的位置
public enum CustomViewPosition {
    /// 居中
    case center
    /// 居左
    case left
    /// 居右
    case right
}

/// alert类型
public enum AlertType {
    case alert
    case sheet
    case custom
}

/// 屏幕方向
public enum ScreenOrientationType {
    /// 横屏
    case horizontal
    /// 竖屏
    case vertical
}

