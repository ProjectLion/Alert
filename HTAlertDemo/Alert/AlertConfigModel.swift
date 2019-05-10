//
//  AlertConfigModel.swift
//  AlertDemo
//
//  Created by Ht on 2018/6/25.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

/// 配置模型管理类
public class AlertConfigModel: NSObject {
    
    /*****      publicProperties      ******/
    
    public var actionArray: [ConfigToAction] = []
    
    public var itemArray: [ConfigToItem] = []
    
    public lazy var itemInsetsInfo: Dictionary<String, UIEdgeInsets> = {
        let dict: Dictionary<String, UIEdgeInsets> = [:]
        return dict
    }()
    
    /// 圆角半径 默认 15
    public var cornerRadius: CGFloat = 15
    
    /// 阴影颜色
    public var shadowColor: UIColor = .clear
    
    /// 阴影透明度 默认 0.3
    public var shadowOpacity: Float = 0.3
    
    /// 阴影半径 默认 5
    public var shadowRadius: CGFloat = 5
    
    /// 阴影偏移量 默认 CGSize(width: 0, height: 0)
    public var shadowOffset = CGSize(width: 0, height: 0)
    
    /// header的颜色 默认 white
    public var headerColor: UIColor = .white
    
    /// 背景样式 默认 半透明 translucent
    public var backgroundStyle: BackgroundStyle = .translucent
    
    /// 背景模糊效果 默认 drak
    public var backgroundBlurStyle: UIBlurEffect.Style = .dark
    
    /// 背景色
    public var backgroundColor: UIColor = .black
    
    /// header间距 默认 UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    public var headerInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    /// 打开动画时长 默认 0.3
    public var openAnimationDuration: Double = 0.3
    
    /// 关闭动画时长 默认 0.2
    public var closeAnimationDuration: Double = 0.2
    
    /// 自定义背景样式的透明度 默认为半透明样式 透明度 0.45
    public var backgroundStyleColorAlpha: CGFloat = 0.45
    
    /// window层级 默认 alert
    public var windowLevel = UIWindow.Level.alert
    
    /// 队列优先级 默认 0 (大于0时才会加入队列)
    public var queuePriorty = 0
    
    /// actionSheet背景色 默认 clear
    public var actionSheetBackgroundColor: UIColor = .clear
    
    /// actionSheet取消按钮间隔颜色 默认 clear
    public var actionSheetCancelSpaceColor: UIColor = .clear
    
    /// actionSheet取消按钮间隔大小 默认 10
    public var actionSheetCancelSpaceHeight: CGFloat = 10
    
    /// actionSheet距离屏幕底部的大小 默认 10
    public var actionSheetBottomMargin: CGFloat = 10
    
    /// 点击背景空白处是否关闭 默认 false
    public var isClickBackgroundClose = false
    
    /// 点击header是否关闭 默认 false
    public var isClickHeaderClose = false
    
    /// 是否自动旋转 默认 true
    public var isAutorotate = true
    
    /// 是否加入队列 默认 false
    public var isQueue = false
    
    /// 是否继续显示队列中的alert 默认 true
    public var isContinueQueueDisplay = true
    
    /// 是否规避键盘 默认 true
    public var isAvoidKeyboard = true
    
    /// alert支持显示的方向 默认 所有方向
    public var supportedInterfaceOrientations = UIInterfaceOrientationMask.all
    
    /// 最大宽度回调 (默认值是在AlertConfig.Swfit文件的# line 75 的方法中设置的)
    public var maxWidth: ConfigToCGFloatBlock = {
        type in
        return 0
    }
    
    /// 最大高度回调 (默认值是在AlertConfig.Swfit文件的# line 75 的方法中设置的)
    public var maxHeight: ConfigToCGFloatBlock = {
        type in
        return 0
    }
    
    /// 打开动画回调
    public var openAnimationBlock: ConfigToBlockAndBlock!
    
    /// 关闭动画回调
    public var closeAnimationBlock: ConfigToBlockAndBlock!
    
    /// 开启动画类型
    public var openAnimationStyle: AlertConfigModel.AnimationStyle = [.fade, .none, .magnify]
    
    /// 关闭动画类型
    public var closeAnimationStyle: AlertConfigModel.AnimationStyle = [.fade, .none, .shrink]
    
    /// 配置完成回调
    public var configFinish: () -> Void = {
        
    }
    
    /// 关闭完成回调
    public var closeComplete: () -> Void = {
        
    }
    
    /// 标识符 默认 "Alert_Identifier"
    public var identifier = "Alert_Identifier"
    
    /**************************/
    
    override init() {
        super.init()
        openAnimationBlock = {
            (_ animatingBlock: @escaping () -> Void, _ animatedBlock: @escaping () -> Void) -> Void in
            UIView.animate(withDuration: self.openAnimationDuration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                animatingBlock()
            }, completion: { (finish) in
                if finish {
                    animatedBlock()
                }
            })
        }
        
        closeAnimationBlock = {
            (_ animatingBlock: @escaping () -> Void, _ animatedBlock: @escaping () -> Void) -> Void in
            UIView.animate(withDuration: self.closeAnimationDuration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                animatingBlock()
            }, completion: { (finish) in
                if finish {
                    animatedBlock()
                }
            })
        }
    }
    deinit {
        print(message: "AlertConfigModel对象销毁了")
        actionArray.removeAll()
        itemArray.removeAll()
    }
    
}

//MARK: ^^^^^^^^^^^^^^^ publicMethod ^^^^^^^^^^^^^^^

extension AlertConfigModel {
    
    /// 设置标题
    ///
    /// - Parameter title: 标题
    /// - Returns: self
    @discardableResult public func title(_ title: String) -> AlertConfigModel {
        addTitle { (label) in
            label.text = title
            label.textColor = .darkGray
        }
        return self
    }
    
    
    /// 设置内容
    ///
    /// - Parameter content: 内容
    /// - Returns: self
    @discardableResult public func content(_ content: String) -> AlertConfigModel {
        addContent { (label) in
            label.text = content
            label.textColor = .gray
        }
        return self
    }
    
    
    /// 设置自定义视图
    ///
    /// - Parameter view: 自定义视图对象 UIView
    /// - Returns: self
    @discardableResult public func customView(_ view: UIView) -> AlertConfigModel {
        addCustomView { (custom) in
            custom.view = view
            custom.position = .center
        }
        return self
    }
    
    
    /// 设置默认响应项
    ///
    /// - Parameters:
    ///   - title: action标题
    ///   - block: action点击事件的回调
    /// - Returns: self
    @discardableResult public func action(_ title: String, block: @escaping () -> Void) -> AlertConfigModel {
        addAction { (action) in
            action.type = .defualt
            action.title = title
            action.clickBlock = block
        }
        return self
    }
    
    
    /// 设置取消响应项
    ///
    /// - Parameters:
    ///   - title: 取消类型action的标题
    ///   - block: 点击事件的回调
    /// - Returns: self
    @discardableResult public func cancelAction(_ title: String, block: @escaping () -> Void) -> AlertConfigModel {
        addAction { (action) in
            action.type = .cancel
            action.title = title
            action.clickBlock = block
        }
        return self
    }
    
    
    /// 设置销毁响应项
    ///
    /// - Parameters:
    ///   - title: 销毁类型action的标题
    ///   - block: 点击事件的回调
    /// - Returns: self
    @discardableResult public func destructiveAction(_ title: String, block: @escaping () -> Void) -> AlertConfigModel {
        addAction { (action) in
            action.type = .destructive
            action.title = title
            action.clickBlock = block
        }
        return self
    }
    
    
    /// 设置header的间距
    ///
    /// - Parameter insets: UIEdgeInsets对象
    /// - Returns: self
    @discardableResult public func headerInsets(_ insets: UIEdgeInsets) -> AlertConfigModel {
        var tempInsets = insets
        if tempInsets.top < 0 { tempInsets.top = 0 }
        if tempInsets.bottom < 0 { tempInsets.bottom = 0 }
        if tempInsets.left < 0 { tempInsets.left = 0 }
        if tempInsets.right < 0 { tempInsets.right = 0 }
        headerInsets = insets
        return self
    }
    
    
    /// 设置上一项的间距 默认 UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    ///
    /// - Parameter insets: UIEdgeInsets对象
    /// - Returns: self
    @discardableResult public func itemInsets(_ insets: UIEdgeInsets) -> AlertConfigModel {
        if !itemArray.isEmpty {
            var tempInsets = insets
            if tempInsets.top < 0 { tempInsets.top = 0 }
            if tempInsets.bottom < 0 { tempInsets.bottom = 0 }
            if tempInsets.left < 0 { tempInsets.left = 0 }
            if tempInsets.right < 0 { tempInsets.right = 0 }
            //                itemInsetsInfo.updateValue(tempInsets, forKey: "\(arr.count - 1)")
            itemInsetsInfo["\(itemArray.count-1)"] = tempInsets
        } else {
            assert(true, "请在添加的某一项后面设置间距")
        }
        return self
    }
    
    
    /// 设置最大宽度
    ///
    /// - Parameter block: 回调
    /// - Returns: self
    @discardableResult public func configMaxWidth(block: @escaping ConfigToCGFloatBlock) -> AlertConfigModel {
        maxWidth = block
        return self
    }
    
    
    /// 设置最大高度
    ///
    /// - Parameter block: 回调
    /// - Returns: self
    @discardableResult public func configMaxHeight(block: @escaping ConfigToCGFloatBlock) -> AlertConfigModel {
        maxHeight = block
        return self
    }
    
    
    /// 最大宽度
    ///
    /// - Parameter width: 最大宽度值
    /// - Returns: self
    @discardableResult public func maxWidth(_ width: CGFloat) -> AlertConfigModel {
        configMaxWidth { (type) -> CGFloat in
            return width
        }
        return self
    }
    
    
    /// 最大高度
    ///
    /// - Parameter hieght: 最大高度值
    /// - Returns: self
    @discardableResult public func maxHeight(_ height: CGFloat) -> AlertConfigModel {
        configMaxHeight { (type) -> CGFloat in
            return height
        }
        return self
    }
    
    
    /// 圆角半径
    ///
    /// - Parameter radius: 半径大小
    /// - Returns: self
    @discardableResult public func cornerRadius(_ radius: CGFloat) -> AlertConfigModel {
        cornerRadius = radius
        return self
    }
    
    /// 颜色
    ///
    /// - Parameter color: 颜色 UIColor对象
    /// - Returns: self
    @discardableResult public func headerColor(_ color: UIColor) -> AlertConfigModel {
        headerColor = color
        return self
    }
    
    /// 背景色
    ///
    /// - Parameter color: UIColor对象
    /// - Returns: self
    @discardableResult public func backgroundColor(_ color: UIColor) -> AlertConfigModel {
        backgroundColor = color
        return self
    }
    
    /// 半透明样式背景的透明度
    ///
    /// - Parameter alpha: 透明度
    /// - Returns: self
    @discardableResult public func backgroundStyleTranslucent(_ alpha: CGFloat) -> AlertConfigModel {
        backgroundStyle = .translucent
        backgroundStyleColorAlpha = alpha
        return self
    }
    
    /// 背景模糊样式
    ///
    /// - Parameter style: 样式 (Swift 4.2 UIBlurEffect.Style--- Swift 4.1 UIBlurEffectStyle)
    /// - Returns: self
    @discardableResult public func backgroundStyleBlur(_ style: UIBlurEffect.Style) -> AlertConfigModel {
        backgroundStyle = .blur
        backgroundBlurStyle = style
        return self
    }
    
    /// 点击header是否关闭
    ///
    /// - Parameter bool: false or true
    /// - Returns: self
    @discardableResult public func isClickHeaderClose(_ bool: Bool) -> AlertConfigModel {
        isClickHeaderClose = bool
        return self
    }
    
    /// 点击背景空白处是否关闭
    ///
    /// - Parameter bool: false or true
    /// - Returns: self
    @discardableResult public func isClickBackgroundClose(_ bool: Bool) -> AlertConfigModel {
        isClickBackgroundClose = bool
        return self
    }
    
    /// 统一设置阴影的相关属性
    ///
    /// - Parameters:
    ///   - offset: 偏移量
    ///   - opacity: 透明度
    ///   - radius: 圆角半径
    ///   - color: 颜色
    /// - Returns: self
    @discardableResult public func shadow(_ offset: CGSize, _ opacity: Float, _ radius: CGFloat, _ color: UIColor) -> AlertConfigModel {
        shadowOffset = offset
        shadowOpacity = opacity
        shadowRadius = radius
        shadowColor = color
        return self
    }
    
    /// 阴影偏移量
    ///
    /// - Parameter size: 偏移大小
    /// - Returns: self
    @discardableResult public func shadowOffset(_ size: CGSize) -> AlertConfigModel {
        shadowOffset = size
        return self
    }
    
    /// 阴影透明度
    ///
    /// - Parameter opacity: 透明度
    /// - Returns: self
    @discardableResult public func shadowOpacity(_ opacity: Float) -> AlertConfigModel {
        if opacity > 1 {
            shadowOpacity = 1
        } else if opacity < 0 {
            shadowOpacity = 0
        } else {
            shadowOpacity = opacity
        }
        return self
    }
    
    /// 阴影颜色
    ///
    /// - Parameter color: 颜色
    /// - Returns: self
    @discardableResult public func shadowColor(_ color: UIColor) -> AlertConfigModel {
        shadowColor = color
        return self
    }
    
    /// 阴影圆角半径
    ///
    /// - Parameter radius: 半径
    /// - Returns: self
    @discardableResult public func shadowRadius(_ radius: CGFloat) -> AlertConfigModel {
        shadowRadius = radius
        return self
    }
    
    /// 标识符
    ///
    /// - Parameter id: 标识符
    /// - Returns: self
    @discardableResult public func identifier(_ id: String) -> AlertConfigModel {
        identifier = id
        return self
    }
    
    /// 是否加入到队列
    ///
    /// - Parameter bool: 是否加入队列
    /// - Returns: self
    @discardableResult public func queue(_ bool: Bool) -> AlertConfigModel {
        isQueue = bool
        return self
    }
    
    /// 队列优先级
    ///
    /// - Parameter level: 优先级
    /// - Returns: self
    @discardableResult public func queuePriority(_ level: Int) -> AlertConfigModel {
        queuePriorty = level
        return self
    }
    
    /// 是否继续队列显示
    ///
    /// - Parameter bool: 是否继续队列显示
    /// - Returns: self
    @discardableResult public func continueQueueDisplay(_ bool: Bool) -> AlertConfigModel {
        isContinueQueueDisplay = bool
        return self
    }
    
    /// window层级
    ///
    /// - Parameter level: 层级
    /// - Returns: self
    @discardableResult public func windowLevel(_ level: UIWindow.Level) -> AlertConfigModel {
        windowLevel = level
        return self
    }
    
    /// 是否支持自动旋转
    ///
    /// - Parameter bool: 是否支持自动旋转
    /// - Returns: self
    @discardableResult public func autorotate(_ bool: Bool) -> AlertConfigModel {
        isAutorotate = bool
        return self
    }
    
    /// 屏幕支持的方向
    ///
    /// - Parameter mask: 方向
    /// - Returns: self
    @discardableResult public func supportedInterfaceOrientations(_ mask: UIInterfaceOrientationMask) ->  AlertConfigModel {
        supportedInterfaceOrientations = mask
        return self
    }
    
    /// 自定义开启动画
    ///
    /// - Parameter animation: 动画 使用UIView.animation....
    /// - Returns: self
    @discardableResult public func openAnimationConfig(animation: @escaping (_ animating: @escaping () -> Void, _ animated: @escaping () -> Void) -> Void) ->AlertConfigModel {
        openAnimationBlock = animation
        return self
    }
    
    /// 自定义关闭动画
    ///
    /// - Parameter animation: 动画
    /// - Returns: self
    @discardableResult public func closeAnimationConfig(animation: @escaping (_ animating: @escaping () -> Void, _ animated: @escaping () -> Void) -> Void) -> AlertConfigModel {
        closeAnimationBlock = animation
        return self
    }
    
    /// 开启动画类型
    ///
    /// - Parameter style: 类型
    /// - Returns: self
    @discardableResult public func openAnimationStyle(_ styles: AlertConfigModel.AnimationStyle) -> AlertConfigModel {
        openAnimationStyle = styles
        return self
    }
    
    /// 关闭动画类型
    ///
    /// - Parameter style: 类型 HTAnimationStyle
    /// - Returns: self
    @discardableResult public func closeAnimationStyle(_ styles: AlertConfigModel.AnimationStyle) -> AlertConfigModel {
        closeAnimationStyle = styles
        return self
    }
    
    /// 动画时长,一句代码配置开启动画时长和关闭动画时长
    ///
    /// - Parameters:
    ///   - open: 开启动画时长
    ///   - close: 关闭动画时长
    /// - Returns: self
    @discardableResult public func animationDuration(open: Double, close: Double) -> AlertConfigModel {
        openAnimationDuration = open
        closeAnimationDuration = close
        return self
    }
    
    /// 是否规避键盘
    ///
    /// - Parameter bool: 是否规避键盘
    /// - Returns: self
    @discardableResult public func avoidKeyboard(_ bool: Bool) -> AlertConfigModel {
        isAvoidKeyboard = bool
        return self
    }
    
    /// 显示出来
    public func show() {
        configFinish()
    }
    
    /// 关闭回调
    public func closeComplete(block: @escaping () -> Void) {
        closeComplete = block
    }
    
    /// 最笨的办法去除Swift不使用返回值时的警告⚠️   也可以加上@discardableResult关键字 忽略返回值
    public func end() {}
}

//MARK: ^^^^^^^^^^^^^^^ addXXX method ^^^^^^^^^^^^^^^
extension AlertConfigModel {
    
    /// 添加item
    ///
    /// - Parameter config: 回调
    /// - Returns: self
    @discardableResult public func addItem(config: @escaping ConfigToItem) -> AlertConfigModel {
        itemArray.append(config)
        return self
    }
    
    /// 添加action
    ///
    /// - Parameter config: 回调
    /// - Returns: self
    @discardableResult public func addAction(config: @escaping ConfigToAction) -> AlertConfigModel {
        actionArray.append(config)
        return self
    }
    
    /// 添加标题
    ///
    /// - Parameter config: 回调
    /// - Returns: self
    @discardableResult public func addTitle(config: @escaping ConfigToLabel) -> AlertConfigModel {
        addItem { (item) in
            item.type = .title
            item.insets = DefaultEdgInsets
            item.labelBlock = config
        }
        return self
    }
    
    /// 添加内容
    ///
    /// - Parameter config: 回调
    /// - Returns: self
    @discardableResult public func addContent(config: @escaping ConfigToLabel) -> AlertConfigModel {
        addItem { (item) in
            item.type = .content
            item.insets = DefaultEdgInsets
            item.labelBlock = config
        }
        return self
    }
    
    /// 添加自定义视图
    ///
    /// - Parameter config: 回调
    /// - Returns: self
    @discardableResult public func addCustomView(config: @escaping ConfigToCustomView) -> AlertConfigModel {
        addItem { (item) in
            item.type = .customView
            item.insets = DefaultEdgInsets
            item.customViewBlock = config
        }
        return self
    }
    
    /// 添加一个输入框
    ///
    /// - Parameter block: 回调方法
    /// - Returns: self
    @discardableResult public func addTextField(config: @escaping ConfigToTextField) -> AlertConfigModel {
        addItem { (item) in
            item.type = .textField
            item.textFieldBlock = config
        }
        return self
    }
}

//MARK: ^^^^^^^^^^^^^^^ AlertSheet config ^^^^^^^^^^^^^^^
extension AlertConfigModel {
    
    /// sheet 取消动作的间隔
    ///
    /// - Parameter height: 间隔大小
    /// - Returns: self
    @discardableResult public func sheetCancelActionSpace(_ height: CGFloat) -> AlertConfigModel {
        actionSheetCancelSpaceHeight = height
        return self
    }
    
    /// sheetAction的背景色
    ///
    /// - Parameter color: 颜色 UIColor
    /// - Returns: self
    @discardableResult public func sheetActionBackgroundColor(_ color: UIColor) -> AlertConfigModel {
        actionSheetBackgroundColor = color
        return self
    }
    
    /// sheet 取消动作的间隔颜色
    ///
    /// - Parameter color: 颜色 UIColor
    /// - Returns: self
    @discardableResult public func sheetCancelActionSpace(_ color: UIColor) -> AlertConfigModel {
        actionSheetCancelSpaceColor = color
        return self
    }
    
    /// sheet距离屏幕底部的间距
    ///
    /// - Parameter margin: 间距
    /// - Returns: self
    @discardableResult public func sheetActionBottomMargin(_ margin: CGFloat) -> AlertConfigModel {
        actionSheetBottomMargin = margin
        return self
    }
    
}

extension AlertConfigModel {
    /// 动画类型
    public struct AnimationStyle: OptionSet {
        
        public var rawValue: Int
        public init(rawValue: AnimationStyle.RawValue) {
            self.rawValue = rawValue
        }
        
        public typealias RawValue = Int
        /// 默认
        public static var none: AnimationStyle = {
            return AnimationStyle(rawValue: 1)
        }()
        /// 上
        public static var top: AnimationStyle = {
            return AnimationStyle(rawValue: 2)
        }()
        /// 下
        public static var bottom: AnimationStyle = {
            return AnimationStyle(rawValue: 4)
        }()
        /// 左
        public static var left: AnimationStyle = {
            return AnimationStyle(rawValue: 8)
        }()
        /// 右
        public static var right: AnimationStyle = {
            return AnimationStyle(rawValue: 16)
        }()
        /// 淡出淡入
        public static var fade: AnimationStyle = {
            return AnimationStyle(rawValue: 32)
        }()
        /// 放大
        public static var magnify: AnimationStyle = {
            return AnimationStyle(rawValue: 64)
        }()
        /// 缩小
        public static var shrink: AnimationStyle = {
            return AnimationStyle(rawValue: 128)
        }()
        
    }
}
