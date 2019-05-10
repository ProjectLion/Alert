//
//  Action.swift
//  AlertDemo
//
//  Created by Ht on 2018/6/25.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

/// Alert的action类。属性均有默认值
public class Action: NSObject {
    
    /// action类型 默认 default
    public var type: Action.ActionType = .defualt
    
    /// action标题 默认 “title”
    public var title = "title"
    
    /// action高亮标题 默认 “”
    public var highlightTitle = ""
    
    /// action富文本标题(attributed) 默认没有。PS: 确定为NSAttributedString类型是为了让用户在外部设置的时候更灵活
    public var attributedTitle: NSAttributedString?
    
    /// action富文本高亮标题 默认没有。PS: 确定为NSAttributedString类型是为了让用户在外部设置的时候更灵活
    public var attributedHighlightTitle: NSAttributedString?
    
    /// action字体 默认 系统14号字体
    public var font = DefaultFont
    
    /// action标题颜色 默认 UIColor(red: 70 / 255, green: 170 / 255, blue: 230 / 255, alpha: 1)
    public var color: UIColor = UIColor(red: 70 / 255, green: 170 / 255, blue: 230 / 255, alpha: 1)
    
    /// action高亮标题颜色 默认 蓝色
    public var highlightColor: UIColor = .blue
    
    /// action背景色 默认 白色
    public var backgroundColor: UIColor = .white
    
    /// action高亮背景色 默认 UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1)
    public var highlightBackgroundColor: UIColor = UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 0.7)
    
    /// action背景图片 默认 无
    public var backgroundImage: UIImage?
    
    /// action高亮背景图片 默认 无
    public var highlightBackgroundImage: UIImage?
    
    /// action图片 默认 无 (ps: 图片大小过大会导致图片显示出错,另外设置了图片需要设置一下imageInsets)
    public var image: UIImage?
    
    /// action高亮图片 默认 无
    public var highlightImage: UIImage?
    
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
    public var borderPosition: Action.ActionBorderPosition = [.defaults]
    
    /// action点击关闭(仅适用于defualt类型) 默认 true
    public var isClickClose = true
    
    /// action点击事件回调
    public var clickBlock: () -> Void = {
        
    }
    
    /// 更新事件的回调
    public var updateBlock: (Action) -> Void = {
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

extension Action {
    /// Action类型枚举
    public enum ActionType: Int {
        /// 默认
        case defualt = 0
        /// 取消
        case cancel
        /// 销毁
        case destructive
    }
    
    public struct ActionBorderPosition: OptionSet {
        
        public var rawValue: Int
        public init(rawValue: ActionBorderPosition.RawValue) {
            self.rawValue = rawValue
        }
        
        public typealias RawValue = Int
        
        /// 默认
        public static var defaults: ActionBorderPosition = {
            return ActionBorderPosition(rawValue: 1)
        }()
        /// 上
        public static var top: ActionBorderPosition = {
            return ActionBorderPosition(rawValue: 2)
        }()
        /// 下
        public static var bottom: ActionBorderPosition = {
            return ActionBorderPosition(rawValue: 4)
        }()
        /// 左
        public static var left: ActionBorderPosition = {
            return ActionBorderPosition(rawValue: 8)
        }()
        /// 右
        public static var right: ActionBorderPosition = {
            return ActionBorderPosition(rawValue: 16)
        }()
        /// 所有方向
        public static var all: ActionBorderPosition = {
            return ActionBorderPosition(rawValue: 32)
        }()
    }
}
