//
//  HTActionSheetViewController.swift
//  HTAlertDemo
//
//  Created by Ht on 2018/6/26.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

class HTActionSheetViewController: HTAlertBaseViewController {
    
    public var containerView: UIView?
    
    public var sheetItemArray: Array<AnyObject> = {
        let arr: Array<AnyObject> = []
        return arr
    }()
    
    public var sheetActionArray: Array<HTActionButton> = {
        let arr = Array<HTActionButton>()
        return arr
    }()
    
    public var sheetView: UIScrollView? = {
        let alert = UIScrollView()
        alert.contentInsetAdjustmentBehavior = .never
        alert.isDirectionalLockEnabled = true
        alert.bounces = false
        alert.showsHorizontalScrollIndicator = false
        alert.showsVerticalScrollIndicator = false
        //        alert.isUserInteractionEnabled = true
        return alert
    }()
    
    private var sheetView_H: CGFloat = 0
    private var keyBorderFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var isShowingKeyborder = false
    
    
    private var sheetCancelSpaceView: UIView?
    private var sheetCancelActionBtn: HTActionButton?
    
    deinit {
        ht_print(message: "HTAlertViewController deinit")
        sheetView = nil
        containerView = nil
        sheetCancelSpaceView = nil
        sheetCancelActionBtn = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sheetView?.backgroundColor = config.headerColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerTapAction(tap:)))
        tap.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        //        sheetView?.addGestureRecognizer(tap)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBorderWillChange(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        setupSheet()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isShowing && !isClosing {
            updateLayout()
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        updateLayout()
    }
    /// 更新布局
    private func updateLayout() {
        updateLayout(width: view.frame.width, height: view.frame.height)
    }
    
    private func updateLayout(width: CGFloat, height: CGFloat) {
        let alertMaxW = config.maxWidth(orientationType)
        let alertMaxH = config.maxHeight(orientationType)
        
        /// sheet类型没有做添加textField，规避键盘先暂时放一放，if条件下的代码不会执行
        if isShowingKeyborder {
            if keyBorderFrame.size.height > 0 {
                updateAlertItemsLayout()
                let keyborderY = keyBorderFrame.origin.y
                //                var sheetViewFrame = (sheetView?.frame)!
                
                let tempAlertViewH = keyborderY - sheetView_H < 20 ? keyborderY - 20 : sheetView_H
                let tempAlertViewY = keyborderY - tempAlertViewH - 10
                
                let originalAlertViewY = (height - (sheetView?.ht_height)!) * 0.5
                
                sheetView?.ht_height = tempAlertViewH
                sheetView?.ht_width = alertMaxW
                
                containerView?.ht_width = alertMaxW
                containerView?.ht_height = (sheetView?.ht_height)!
                containerView?.ht_x = (width - alertMaxW) * 0.5
                containerView?.ht_y = tempAlertViewY < originalAlertViewY ? tempAlertViewY : originalAlertViewY
                
                sheetView?.scrollRectToVisible((findFirstResponder(view: sheetView!)?.frame)!, animated: true)
            }
        } else {
            updateAlertItemsLayout()
            
            sheetView?.ht_height = sheetView_H > alertMaxH ? alertMaxH : sheetView_H
            sheetView?.ht_width = alertMaxW
            
            containerView?.ht_width = alertMaxW
            containerView?.ht_height = sheetCancelActionBtn == nil ? (sheetView?.ht_height)! : (sheetView?.ht_height)! + (sheetCancelActionBtn?.ht_height)! + config.actionSheetCancelSpaceHeight
            containerView?.ht_x = (width - alertMaxW) * 0.5
            containerView?.ht_y = height - (containerView?.ht_height)! - config.actionSheetBottomMargin
            
            if sheetCancelActionBtn != nil {
                
                sheetCancelSpaceView?.ht_x = 0
                sheetCancelSpaceView?.ht_y = (sheetView?.ht_bottom)!
                sheetCancelSpaceView?.ht_width = alertMaxW
                sheetCancelSpaceView?.ht_height = config.actionSheetCancelSpaceHeight
                
                sheetCancelActionBtn?.ht_x = 0
                sheetCancelActionBtn?.ht_y = (sheetCancelSpaceView?.ht_bottom)!
                sheetCancelActionBtn?.ht_width = alertMaxW
                sheetCancelActionBtn?.layer.cornerRadius = config.cornerRadius
                sheetCancelActionBtn?.layer.masksToBounds = true
            }
            
        }
    }
    
    /// 更新item的布局   (ps: 下面👇这个方法要写图了！变量名一脸懵逼,Xcode不会代码提示，简直吐血)
    private func updateAlertItemsLayout() {
        UIView.setAnimationsEnabled(false)
        sheetView_H = 0
        let alertMaxW = config.maxWidth(orientationType)
        for (idx, item) in sheetItemArray.enumerated() {
            if idx == 0 {
                sheetView_H += config.headerInsets.top
            }
            /// 根据不同类型的view设置frame
            if item.isKind(of: HTItemLabel.self) {
                
                let view = item as! HTItemLabel
                
                view.ht_x = config.headerInsets.left + view.item.insets.left + viewSafeaInsets(view: view).left
                view.ht_y = sheetView_H + view.item.insets.top
                view.ht_width = alertMaxW - view.ht_x - config.headerInsets.right - view.item.insets.right - viewSafeaInsets(view: view).left - viewSafeaInsets(view: view).right
                view.ht_height = item.sizeThatFits(CGSize(width: view.ht_width, height: CGFloat(MAXFLOAT))).height
                
                sheetView_H += view.ht_height + view.item.insets.top + view.item.insets.bottom
                
            } else if item.isKind(of: HTItemTextField.self) {
                let view = item as! HTItemTextField
                
                view.ht_x = config.headerInsets.left + view.item.insets.left + viewSafeaInsets(view: view).left
                view.ht_y = sheetView_H + view.item.insets.top
                view.ht_width = alertMaxW - view.ht_x - config.headerInsets.right - view.item.insets.right - viewSafeaInsets(view: view).left - viewSafeaInsets(view: view).right
                view.ht_height = 40
                
                sheetView_H += view.ht_height + view.item.insets.top + view.item.insets.bottom
            } else if item.isKind(of: HTCustomView.self) {
                let custom = item as! HTCustomView
                
                if custom.isAutoWidth {
                    custom.position = .center
                    custom.view.ht_width = alertMaxW - config.headerInsets.left - custom.item.insets.left - config.headerInsets.right - custom.item.insets.right
                }
                switch custom.position {
                case .center:
                    custom.view.ht_x = (alertMaxW - custom.view.ht_width) / 2
                case .left:
                    custom.view.ht_x = config.headerInsets.left + custom.item.insets.left
                case .right:
                    custom.view.ht_x = alertMaxW - config.headerInsets.right - custom.item.insets.right - custom.view.ht_width
                }
                custom.view.ht_y = sheetView_H + custom.item.insets.top
                sheetView_H += custom.view.ht_height + custom.item.insets.top + custom.item.insets.bottom
            }
            
            if idx == sheetItemArray.count - 1 {
                sheetView_H += config.headerInsets.bottom
            }
            
        }
        for actionBtn in sheetActionArray {
            
            actionBtn.ht_x = (actionBtn.action?.insets.left)!
            
            actionBtn.ht_y = sheetView_H + (actionBtn.action?.insets.top)!
            
            actionBtn.ht_width = alertMaxW - (actionBtn.action?.insets.left)! - (actionBtn.action?.insets.right)!
            
            sheetView_H += actionBtn.ht_height + (actionBtn.action?.insets.top)! + (actionBtn.action?.insets.bottom)!
        }
        /// 只有两个action时,横向布局成一排
        if sheetActionArray.count == 2 {
//            let btnA = sheetActionArray.count == config.actionArray?.count ? sheetActionArray.first : sheetActionArray.last
//            let btnB = sheetActionArray.count == config.actionArray?.count ? sheetActionArray.last : sheetActionArray.first
//
//            let btnAInsets = (btnA?.action?.insets)!
//            let btnBInsets = (btnB?.action?.insets)!
//
//            let btnA_H = (btnA?.ht_height)! + btnAInsets.top + btnAInsets.bottom
//            let btnB_H = (btnB?.ht_height)! + btnBInsets.top + btnBInsets.bottom
//
//            let min_H = btnA_H < btnB_H ? btnA_H : btnB_H
//
//            let min_Y = ((btnA?.ht_y)! - btnAInsets.top) > ((btnB?.ht_y)! - btnBInsets.top) ? ((btnB?.ht_y)! - btnBInsets.top) : ((btnA?.ht_y)! - btnAInsets.top)
//
//            btnA?.action.borderPosition = .right
//
//            btnA?.frame = CGRect(x: btnAInsets.left, y: min_Y + btnAInsets.top, width: alertMaxW / 2 - btnAInsets.left - btnAInsets.right, height: (btnA?.ht_height)!)
//
//            btnB?.frame = CGRect(x: alertMaxW / 2 + btnBInsets.left, y: min_Y + btnBInsets.top, width: alertMaxW / 2 - btnBInsets.left - btnBInsets.right, height: (btnB?.ht_height)!)
//            //            btnB?.act
//            sheetView_H -= min_H
            
        }
        sheetView?.contentSize = CGSize(width: alertMaxW, height: sheetView_H)
        containerView?.ht_height = sheetView_H
        UIView.setAnimationsEnabled(true)
    }
    
    /// 布局
    private func setupSheet() {
        containerView = UIView()
        view.addSubview(containerView!)
        containerView?.addSubview(sheetView!)
        containerView?.layer.shadowOffset = config.shadowOffset
        containerView?.layer.shadowRadius = config.shadowRadius
        containerView?.layer.shadowOpacity = config.shadowOpacity
        containerView?.layer.shadowColor = config.shadowColor.cgColor
        
        sheetView?.layer.cornerRadius = config.cornerRadius
        
        for (idx, obj) in (config.itemArray?.enumerated())! {
            let itemBlock = obj
            
            let item = HTItem()
            
            itemBlock(item)
            
            /// 如果你设置了 config.itemInsets(_ insets: UIEdgeInsets) 则按照你的设置的偏移量设置,没有设置则为默认偏移量, 默认 UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            if let insets = config.itemInsetsInfo["\(idx)"] {
                item.insets = insets
            }
            
            switch item.type {
            case .title:
                let label = HTItemLabel()
                sheetView?.addSubview(label)
                sheetItemArray.append(label)
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
                let label = HTItemLabel()
                sheetView?.addSubview(label)
                sheetItemArray.append(label)
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
            case .textField:        /// sheet暂时不支持输入框
//                let textField = HTItemTextField()
//                sheetView?.addSubview(textField)
//                sheetItemArray.append(textField)
//                textField.borderStyle = .roundedRect
//                item.textFieldBlock(textField)
//                textField.item = item
                break
            case .customView:
                let custom = HTCustomView()
                item.customViewBlock(custom)
                sheetView?.addSubview(custom.view)
                sheetItemArray.append(custom)
                custom.item = item
                custom.sizeChangedBlock = {
                    [weak self] in
                    self?.updateLayout()
                }
            }
        }
        
        for (_, obj) in (config.actionArray?.enumerated())! {
            let action = HTAction()
            obj(action)
            let btn = HTActionButton()
            if action.type == .cancel {
                btn.addTarget(self, action: #selector(cancelAction(sender:)), for: .touchUpInside)
                btn.backgroundColor = action.backgroundColor
                sheetCancelActionBtn = btn
                containerView?.addSubview(sheetCancelActionBtn!)
                sheetCancelSpaceView = UIView()
                sheetCancelSpaceView?.backgroundColor = config.actionSheetBackgroundColor
                containerView?.addSubview(sheetCancelSpaceView!)
            } else {
                if action.borderPosition.rawValue == 1 {
                    action.borderPosition = [.top]
                }
                btn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
                sheetView?.addSubview(btn)
                sheetActionArray.append(btn)
            }
            
            btn.action = action
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
            containerView?.ht_x = (view.ht_width - (containerView?.ht_width)!) / 2
            containerView?.ht_y = view.ht_width - (containerView?.ht_height)! - config.actionSheetBottomMargin
        }
        
        if style.contains(.top) {
            containerView?.ht_x = (view.ht_width - (containerView?.ht_width)!) / 2
            containerView?.ht_y = -((containerView?.ht_height)!)
        }
        
        if style.contains(.bottom) {
            containerView?.ht_x = (view.ht_width - (containerView?.ht_width)!) / 2
            containerView?.ht_y = view.ht_height
        }
        
        if style.contains(.left) {
            containerView?.ht_x = -((containerView?.ht_width)!)
            containerView?.ht_y = view.ht_width - (containerView?.ht_height)! - config.actionSheetBottomMargin
        }
        
        if style.contains(.right) {
            containerView?.ht_x = view.ht_width
            containerView?.ht_y = view.ht_width - (containerView?.ht_height)! - config.actionSheetBottomMargin
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
        
        config.openAnimationBlock({
            [weak self] in
            switch (self?.config.backgroundStyle)! {
            case .translucent:
                self?.view.backgroundColor = self?.view.backgroundColor?.withAlphaComponent((self?.config.backgroundStyleColorAlpha)!)
            case .blur:
                self?.backgroundEffectView?.effect = UIBlurEffect(style: (self?.config.backgroundBlurStyle)!)
            }
            self?.containerView?.ht_x = ((self?.view.ht_width)! - (self?.containerView?.ht_width)!) / 2
            self?.containerView?.ht_y = (self?.view.ht_height)! - (self?.containerView?.ht_height)! - (self?.config.actionSheetBottomMargin)!
            
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
            
            let view_W = (self?.view.ht_width)!
            let view_H = (self?.view.ht_height)!
            
            let container_W = (self?.containerView?.ht_width)!
            let container_H = (self?.containerView?.ht_height)!
            
            let style = (self?.config.closeAnimationStyle)!
            
            if style.contains(.none) {
                self?.containerView?.alpha = 0
                self?.containerView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            
            if style.contains(.top) {
                self?.containerView?.ht_x = (view_W - container_W) / 2
                self?.containerView?.ht_y = -container_H
            }
            
            if style.contains(.bottom) {
                self?.containerView?.ht_x = (view_W - container_W) / 2
                self?.containerView?.ht_y = view_H
            }
            
            if style.contains(.left) {
                self?.containerView?.ht_x = -container_W
                self?.containerView?.ht_y = (view_H - container_H) / 2
            }
            
            if style.contains(.right) {
                self?.containerView?.ht_x = view_W
                self?.containerView?.ht_y = (view_H - container_H) / 2
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
//        if config.isAvoidKeyboard {
//            let duration = noti.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Float
//            keyBorderFrame = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//            isShowingKeyborder = keyBorderFrame.origin.y < Scrren_H
//
//            UIView.beginAnimations("keyboardWillChangeFrame", context: nil)
//            UIView.setAnimationDuration(TimeInterval(duration))
//            updateLayout()
//            UIView.commitAnimations()
//        }
    }
    
    /// action响应方法
    @objc private func buttonAction(sender: UIButton) {
        var isClose = false
        var clickBlock = {
            
        }
        
        for btn in sheetActionArray {
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
    
    /// cancelAction的相应方法
    @objc private func cancelAction(sender: HTActionButton) {
        close {
            
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
