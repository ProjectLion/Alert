//
//  Item.swift
//  AlertDemo
//
//  Created by Ht on 2018/6/25.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

public class Item: NSObject {
    
    /// 展示项类型
    public enum ItemType {
        /// 标题
        case title
        /// 内容
        case content
        /// 输入框
        case textField
        /// 自定义view
        case customView
    }
    
    /// item类型 默认标题
    public var type: Item.ItemType = .title
    
    /// item间距 (偏移量) 默认 UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    public var insets = DefaultEdgInsets
    
    /***** item设置视图的闭包 *****/
    /// label
    public var labelBlock: (UILabel) -> Void = {
        label in
    }
    /// textField
    public var textFieldBlock: (UITextField) -> Void = {
        textField in
    }
    /// customView
    public var customViewBlock: (CustomView) -> Void = {
        custom in
    }
    /******************/
    
    public var updateBlock: (Item) -> Void = {
        item in
    }
    
    public func update() {
        updateBlock(self)
    }
    
    override init() {
        super.init()
    }
    
}
