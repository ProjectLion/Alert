//
//  HTAction.swift
//  HTAlertDemo
//
//  Created by Ht on 2018/6/25.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

/// HTAlert的action类。属性均有默认值
class HTAction: NSObject {
    
    /// Action类型枚举
    public enum HTActionType {
        /// 默认
        case defualt
        /// 取消
        case cancel
        /// 销毁
        case destructive
    }
    
    /// Action边框位置枚举
//    public enum HTActionBorderPosition {
//        /// 上
//        case top
//        /// 下
//        case bottom
//        /// 左
//        case left
//        /// 右
//        case right
//    }
    
    public struct HTActionBorderPosition: OptionSet {
        public let rawValue: Int
        /// 默认
        public static var defaults = HTActionBorderPosition(rawValue: 1)
        /// 上
        public static var top = HTActionBorderPosition(rawValue: 2)
        /// 下
        public static var bottom = HTActionBorderPosition(rawValue: 4)
        /// 左
        public static var left = HTActionBorderPosition(rawValue: 8)
        /// 右
        public static var right = HTActionBorderPosition(rawValue: 32)
        /// 所有方向
        public static var all = HTActionBorderPosition(rawValue: 64)
    }
    
    /// action类型 默认 default
    public var type: HTAction.HTActionType = .defualt
    
    /// action标题 默认 “”
    public var title = ""
    
    /// action高亮标题 默认 “”
    public var highLightTitle = ""
    
    /// action富文本标题(attributed) 默认 “”
    public var attributedTitle: NSAttributedString = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
    
    /// action富文本高亮标题 默认 “这是富文本高亮标题”
    public var attributedHighLightTitlt: NSAttributedString = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
    
    /// action字体 默认 系统14号字体
    public var font = DefaultFont
    
    /// action标题颜色 默认 UIColor(red: 70 / 255, green: 170 / 255, blue: 230 / 255, alpha: 1)
    public var color: UIColor = UIColor(red: 70 / 255, green: 170 / 255, blue: 230 / 255, alpha: 1)
    
    /// action高亮标题颜色 默认 蓝色
    public var highLightColor: UIColor = .blue
    
    /// action背景色 默认 白色
    public var backgroundColor: UIColor = .white
    
    /// action高亮背景色 默认 UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1)
    public var highLightBackgroundColor: UIColor = UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1)
    
    /// action背景图片 默认 无
    public var backgroundImage: UIImage?
    
    /// action高亮背景图片 默认 无
    public var highLightBackgroundImage: UIImage?
    
    /// action图片 默认 无 (ps: 图片大小过大会导致图片显示出错,另外设置了图片需要设置一下imageInsets)
    public var image: UIImage?
    
    /// action高亮图片 默认 无
    public var highLightImage: UIImage?
    
    /// action间距(偏移量) 默认 UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    public var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    /// action图片间距(偏移量) 默认 UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    public var imageInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    /// action标题间距(偏移量) 默认 UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    public var titleInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    /// action圆角半径 默认 0
    public var cornerRadius: CGFloat = 0
    
    /// action高度 默认 45
    public var height: CGFloat = 45
    
    /// action边框宽度
    public var borderWidth: CGFloat = DefaultBorder_W
    
    /// action边框颜色 默认 darkGray
    public var borderColor = UIColor.darkGray
    
    /// action边框位置 默认 defaults
    public var borderPosition: HTAction.HTActionBorderPosition = [.defaults]
    
    /// action点击关闭(仅适用于cancel类型) 默认 true
    public var isClickClose = true
    
    /// action点击事件回调
    public var clickBlock: () -> Void = {
        
    }
    
    /// 更新事件的回调
    public var updateBlock: (HTAction) -> Void = {
        action in
    }
    
    /// 更新
    public func update() {
        updateBlock(self)
    }
    
    override init() {
        super.init()
    }
}
