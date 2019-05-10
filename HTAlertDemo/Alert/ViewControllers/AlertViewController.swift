//
//  AlertViewController.swift
//  AlertDemo
//
//  Created by Ht on 2018/6/26.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

class AlertViewController: AlertBaseViewController {
    
    private var containerView: UIView?
    
    private var alertItemArray: Array<AnyObject> = {
        let arr: Array<AnyObject> = []
        return arr
    }()
    
    private var alertActionArray: Array<ActionButton> = {
        let arr = Array<ActionButton>()
        return arr
    }()
    
    private var alertView: UIScrollView? = {
        let alert = UIScrollView()
        alert.isDirectionalLockEnabled = true
        alert.bounces = false
        alert.showsHorizontalScrollIndicator = false
        alert.showsVerticalScrollIndicator = false
//        alert.isUserInteractionEnabled = true
        return alert
    }()
    
    private var alertView_H: CGFloat = 0
    private var keyBorderFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var isShowingKeyborder = false
    
    deinit {
        print(message: "AlertViewController deinit")
        alertView = nil
        containerView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            alertView?.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        alertView?.backgroundColor = config.headerColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerTapAction(tap:)))
        tap.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
//        alertView?.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBorderWillChange(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        setupAlert()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isShowing && !isClosing {
            updateLayout()
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
        }
        updateLayout()
    }
    /// 更新布局
    private func updateLayout() {
        updateLayout(width: view.frame.width, height: view.frame.height)
    }
    
    private func updateLayout(width: CGFloat, height: CGFloat) {
        let alertMaxW = config.maxWidth(orientationType)
        let alertMaxH = config.maxHeight(orientationType)
        
        if isShowingKeyborder {
            if keyBorderFrame.size.height > 0 {
                updateAlertItemsLayout()
                let keyborderY = keyBorderFrame.origin.y
//                var alertViewFrame = (alertView?.frame)!
                
                let tempAlertViewH = keyborderY - alertView_H < 20 ? keyborderY - 20 : alertView_H
                let tempAlertViewY = keyborderY - tempAlertViewH - 10
                
                let originalAlertViewY = (height - (alertView?.height)!) * 0.5
                
                alertView?.height = tempAlertViewH
                alertView?.width = alertMaxW
                
                containerView?.width = (alertView?.width)!
                containerView?.height = (alertView?.height)!
                containerView?.x = (width - alertMaxW) * 0.5
                containerView?.y = tempAlertViewY < originalAlertViewY ? tempAlertViewY : originalAlertViewY
                
                alertView?.scrollRectToVisible((findFirstResponder(view: alertView!)?.frame)!, animated: true)
            }
        } else {
            updateAlertItemsLayout()
            
            alertView?.height = alertView_H > alertMaxH ? alertMaxH : alertView_H
            alertView?.width = alertMaxW
            
            containerView?.width = (alertView?.width)!
            containerView?.height = (alertView?.height)!
            containerView?.x = (width - alertMaxW) * 0.5
            containerView?.y = (height - (alertView?.height)!) * 0.5
        }
    }
    
    /// 更新item的布局   (ps: 下面👇这个方法要写图了！变量名一脸懵逼,Xcode不会代码提示，简直吐血)
    private func updateAlertItemsLayout() {
        UIView.setAnimationsEnabled(false)
        alertView_H = 0
        let alertMaxW = config.maxWidth(orientationType)
        for (idx, item) in alertItemArray.enumerated() {
            if idx == 0 {
                alertView_H += config.headerInsets.top
            }
            /// 根据不同类型的view设置frame
            if item.isKind(of: ItemLabel.self) {
                
                let view = item as! ItemLabel
                
                view.x = config.headerInsets.left + view.item.insets.left + viewSafeaInsets(view: view).left
                view.y = alertView_H + view.item.insets.top
                view.width = alertMaxW - view.x - config.headerInsets.right - view.item.insets.right - viewSafeaInsets(view: view).left - viewSafeaInsets(view: view).right
                view.height = item.sizeThatFits(CGSize(width: view.width, height: CGFloat(MAXFLOAT))).height
                
                alertView_H += view.height + view.item.insets.top + view.item.insets.bottom
                
            } else if item.isKind(of: ItemTextField.self) {
                let view = item as! ItemTextField
                
                view.x = config.headerInsets.left + view.item.insets.left + viewSafeaInsets(view: view).left
                view.y = alertView_H + view.item.insets.top
                view.width = alertMaxW - view.x - config.headerInsets.right - view.item.insets.right - viewSafeaInsets(view: view).left - viewSafeaInsets(view: view).right
                view.height = 40
                
                alertView_H += view.height + view.item.insets.top + view.item.insets.bottom
            } else if item.isKind(of: CustomView.self) {
                let custom = item as! CustomView
                
                if custom.isAutoWidth {
                    custom.position = .center
                    custom.view.width = alertMaxW - config.headerInsets.left - custom.item.insets.left - config.headerInsets.right - custom.item.insets.right
                }
                switch custom.position {
                case .center:
                    custom.view.x = (alertMaxW - custom.view.width) / 2
                case .left:
                    custom.view.x = config.headerInsets.left + custom.item.insets.left
                case .right:
                    custom.view.x = alertMaxW - config.headerInsets.right - custom.item.insets.right - custom.view.width
                }
                custom.view.y = alertView_H + custom.item.insets.top
                alertView_H += custom.view.height + custom.item.insets.top + custom.item.insets.bottom
            }
            
            if idx == alertItemArray.count - 1 {
                alertView_H += config.headerInsets.bottom
            }
            
        }
        for actionBtn in alertActionArray {
            
            actionBtn.x = (actionBtn.action?.insets.left)!
            
            actionBtn.y = alertView_H + (actionBtn.action?.insets.top)!
            
            actionBtn.width = alertMaxW - (actionBtn.action?.insets.left)! - (actionBtn.action?.insets.right)!
            
            alertView_H += actionBtn.height + (actionBtn.action?.insets.top)! + (actionBtn.action?.insets.bottom)!
        }
        /// 只有两个action时,横向布局成一排
        if alertActionArray.count == 2 {
            let btnA = (alertActionArray.count == config.actionArray.count) ? alertActionArray.first : alertActionArray.last
            let btnB = (alertActionArray.count == config.actionArray.count) ? alertActionArray.last : alertActionArray.first
            
            let btnAInsets = (btnA?.action?.insets)!
            let btnBInsets = (btnB?.action?.insets)!
            
            let btnA_H = (btnA?.height)! + btnAInsets.top + btnAInsets.bottom
            let btnB_H = (btnB?.height)! + btnBInsets.top + btnBInsets.bottom
            
            let min_H = btnA_H < btnB_H ? btnA_H : btnB_H
            
            let min_Y = ((btnA?.y)! - btnAInsets.top) > ((btnB?.y)! - btnBInsets.top) ? ((btnB?.y)! - btnBInsets.top) : ((btnA?.y)! - btnAInsets.top)
            
            btnA?.action.borderPosition = .right
            
            btnA?.frame = CGRect(x: btnAInsets.left, y: min_Y + btnAInsets.top, width: alertMaxW / 2 - btnAInsets.left - btnAInsets.right, height: (btnA?.height)!)
            
            btnB?.frame = CGRect(x: alertMaxW / 2 + btnBInsets.left, y: min_Y + btnBInsets.top, width: alertMaxW / 2 - btnBInsets.left - btnBInsets.right, height: (btnB?.height)!)
//            btnB?.act
            alertView_H -= min_H
            
        }
        alertView?.contentSize = CGSize(width: alertMaxW, height: alertView_H)
        containerView?.height = alertView_H
        UIView.setAnimationsEnabled(true)
    }
    
    /// 布局
    private func setupAlert() {
        containerView = UIView()
        view.addSubview(containerView!)
        containerView?.addSubview(alertView!)
        containerView?.layer.shadowOffset = config.shadowOffset
        containerView?.layer.shadowRadius = config.shadowRadius
        containerView?.layer.shadowOpacity = config.shadowOpacity
        containerView?.layer.shadowColor = config.shadowColor.cgColor
        
        alertView?.layer.cornerRadius = config.cornerRadius
        
        for (idx, obj) in config.itemArray.enumerated() {
            let itemBlock = obj
            
            let item = Item()
            
            itemBlock(item)
            
            /// 如果你设置了 config.itemInsets(_ insets: UIEdgeInsets) 则按照你的设置的偏移量设置,没有设置则为默认偏移量, 默认 UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            if let insets = config.itemInsetsInfo["\(idx)"] {
                item.insets = insets
            }
            
            switch item.type {
            case .title:
                let label = ItemLabel()
                alertView?.addSubview(label)
                alertItemArray.append(label)
                label.textAlignment = .center
                label.font = UIFont.boldSystemFont(ofSize: 18)
                label.textColor = .black
                label.numberOfLines = 0
                
                item.labelBlock(label)
                
                label.item = item
                
                label.textChangeBlock = {
                    [weak self] in
                    self?.updateLayout()
                }
            case .content:
                let label = ItemLabel()
                alertView?.addSubview(label)
                alertItemArray.append(label)
                label.textAlignment = .center
                label.font = UIFont.boldSystemFont(ofSize: 14)
                label.textColor = .black
                label.numberOfLines = 0
                
                item.labelBlock(label)
                
                label.item = item
                
                label.textChangeBlock = {
                    [weak self] in
                    self?.updateLayout()
                }
            case .textField:
                let textField = ItemTextField()
                alertView?.addSubview(textField)
                alertItemArray.append(textField)
                textField.borderStyle = .roundedRect
                item.textFieldBlock(textField)
                textField.item = item
            case .customView:
                let custom = CustomView()
                item.customViewBlock(custom)
                alertView?.addSubview(custom.view)
                alertItemArray.append(custom)
                custom.item = item
                custom.sizeChangedBlock = {
                    [weak self] in
                    self?.updateLayout()
                }
            }
        }
        
        for (idx, obj) in config.actionArray.enumerated() {
            let action = Action()
            obj(action)

            let btn = ActionButton()
            
            if action.borderPosition.rawValue == 1 {
                if config.actionArray.count == 2 {
                    // 修复只有两个action项时，右边action有右边框的bug
                    if idx == 0 {
                        action.borderPosition = [.top, .right]
                    } else {
                        action.borderPosition = [.top]
                    }
                } else {
                    action.borderPosition = [.top]
                }
            }
            
            btn.action = action
            
            btn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            alertView?.addSubview(btn)
            alertActionArray.append(btn)
            btn.heightChangeBlock = {
                [weak self] in
                self?.updateLayout()
            }
        }
        updateLayout()
        show {
            [weak self] in
            self?.updateLayout()
        }
    }
    
    /// start animation
    override func show(completeBlock: @escaping () -> Void) {
        super.show(completeBlock: completeBlock)
        if isShowing {
            return
        }
        
        isShowing = true
        
        let style = config.openAnimationStyle
        
        if style.contains(.none) {
            containerView?.x = (view.width - (containerView?.width)!) / 2
            containerView?.y = (view.height - (containerView?.height)!) / 2
        }
        
        if style.contains(.top) {
            containerView?.x = (view.width - (containerView?.width)!) / 2
            containerView?.y = -((containerView?.height)!)
        }
        
        if style.contains(.bottom) {
            containerView?.x = (view.width - (containerView?.width)!) / 2
            containerView?.y = view.height
        }
        
        if style.contains(.left) {
            containerView?.x = -((containerView?.width)!)
            containerView?.y = (view.height - (containerView?.height)!) / 2
        }
        
        if style.contains(.right) {
            containerView?.x = view.width
            containerView?.y = (view.height - (containerView?.height)!) / 2
        }
        
        if style.contains(.fade) {
            containerView?.alpha = 0
        }
        
        if style.contains(.magnify) {
            containerView?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
        
        if style.contains(.shrink) {
            containerView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
//        switch config.openAnimationStyle {
//        case .none:
//
//        case .top:
//
//        case .bottom:
//
//        case .left:
//
//        case .right:
//
//        case .fade:
//
//        case .magnify:
//
//        case .shrink:
//
//        default:
//            break
//        }
        
        config.openAnimationBlock({
            [weak self] in
            switch (self?.config.backgroundStyle)! {
            case .translucent:
                self?.view.backgroundColor = self?.view.backgroundColor?.withAlphaComponent((self?.config.backgroundStyleColorAlpha)!)
            case .blur:
                self?.backgroundEffectView?.effect = UIBlurEffect(style: (self?.config.backgroundBlurStyle)!)
            }
            self?.containerView?.x = ((self?.view.width)! - (self?.containerView?.width)!) / 2
            self?.containerView?.y = ((self?.view.height)! - (self?.containerView?.height)!) / 2
            
            self?.containerView?.alpha = 1
            self?.containerView?.transform = .identity
        }) {
            [weak self] in
            if self == nil {
                return
            }
            
            self?.isShowing = false
            
            self?.view.isUserInteractionEnabled = true
            
            self?.openFinishBlock()
            
            completeBlock()
            
        }
    }
    
    override func close(completeBlock: @escaping () -> Void) {
        super.close(completeBlock: completeBlock)
        
        if isClosing {
            return
        }
        
        isClosing = true
        
        config.closeAnimationBlock({
            [weak self] in
            if self == nil {
                return
            }
            
            switch (self?.config.backgroundStyle)! {
            case .blur:
                self?.backgroundEffectView?.alpha = 0
            case .translucent:
                self?.view.backgroundColor = self?.view.backgroundColor?.withAlphaComponent(0)
            }
            
            let view_W = (self?.view.width)!
            let view_H = (self?.view.height)!
            
            let container_W = (self?.containerView?.width)!
            let container_H = (self?.containerView?.height)!
            
            let style = (self?.config.closeAnimationStyle)!
            
            if style.contains(.none) {
                self?.containerView?.alpha = 0
                self?.containerView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            
            if style.contains(.top) {
                self?.containerView?.x = (view_W - container_W) / 2
                self?.containerView?.y = -container_H
            }
            
            if style.contains(.bottom) {
                self?.containerView?.x = (view_W - container_W) / 2
                self?.containerView?.y = view_H
            }
            
            if style.contains(.left) {
                self?.containerView?.x = -container_W
                self?.containerView?.y = (view_H - container_H) / 2
            }
            
            if style.contains(.right) {
                self?.containerView?.x = view_W
                self?.containerView?.y = (view_H - container_H) / 2
            }
            
            if style.contains(.fade) {
                self?.containerView?.alpha = 0
            }
            
            if style.contains(.magnify) {
                self?.containerView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            
            if style.contains(.shrink) {
                self?.containerView?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }
            
        }) {
            [weak self] in
            
            self?.isClosing = false
            
            self?.closeFinishBlock()
            
            completeBlock()
            
        }
        
    }
    
    //MARK: ^^^^^^^^^^^^^^^ headerTapAction ^^^^^^^^^^^^^^^
    @objc private func headerTapAction(tap: UITapGestureRecognizer) {
        if config.isClickHeaderClose {
            close {
                
            }
        }
    }
    //MARK: ^^^^^^^^^^^^^^^ 键盘通知 ^^^^^^^^^^^^^^^
    @objc private func keyBorderWillChange(noti: Notification) {
        if config.isAvoidKeyboard {
            let duration = noti.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Float
            keyBorderFrame = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            isShowingKeyborder = keyBorderFrame.origin.y < Scrren_H
            
            UIView.beginAnimations("keyboardWillChangeFrame", context: nil)
            UIView.setAnimationDuration(TimeInterval(duration))
            updateLayout()
            UIView.commitAnimations()
        }
    }
    
    /// action响应方法
    @objc private func buttonAction(sender: UIButton) {
        var isClose = false
        var clickBlock = {
            
        }
        
        for btn in alertActionArray {
            if btn == sender {
                switch (btn.action?.type)! {
                case .cancel:
                    isClose = true
                case .defualt:
                    isClose = (btn.action?.isClickClose)!
                case .destructive:
                    isClose = true
                }
                clickBlock = (btn.action?.clickBlock)!
            }
        }
        
        if isClose {
            close {
                clickBlock()
            }
        } else {
            clickBlock()
        }
        
    }
    
    /// 寻找第一响应者
    private func findFirstResponder(view: UIView) -> UIView? {
        
        if view.isFirstResponder {
            return view
        }
        
        for sub in view.subviews {
            let first = findFirstResponder(view: sub)
            if first != nil {
                return first
            }
        }
        return nil
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
}
