//
//  CustomAlertViewController.swift
//  HTAlertDemo
//
//  Created by escher on 2020/2/14.
//  Copyright © 2020 Ht. All rights reserved.
//

import UIKit

class CustomAlertViewController: AlertBaseViewController {
    
    public var containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerTapAction(tap:)))
        tap.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    private func setup() {
        containerView = config.customAlert.view
        view.addSubview(containerView)
        containerView.layer.shadowOffset = config.shadowOffset
        containerView.layer.shadowRadius = config.shadowRadius
        containerView.layer.shadowOpacity = config.shadowOpacity
        containerView.layer.shadowColor = config.shadowColor.cgColor
        show {
            
        }
    }
    
    override func show(completeBlock: @escaping () -> Void) {
        if isShowing {
            return
        }
        
        isShowing = true
        
        let style = config.openAnimationStyle
        
        if style.contains(.none) {
            containerView.x = (view.width - containerView.width) / 2
            containerView.y = (view.height - containerView.height) / 2 - config.customAlert.centerEdge
        }
        
        if style.contains(.top) {
            containerView.x = (view.width - containerView.width) / 2
            containerView.y = -(containerView.height)
        }
        
        if style.contains(.bottom) {
            containerView.x = (view.width - containerView.width) / 2
            containerView.y = view.height
        }
        
        if style.contains(.left) {
            containerView.x = -(containerView.width)
            containerView.y = (view.height - containerView.height) / 2 - config.customAlert.centerEdge
        }
        
        if style.contains(.right) {
            containerView.x = view.width
            containerView.y = (view.height - containerView.height) / 2 - config.customAlert.centerEdge
        }
        
        if style.contains(.fade) {
            containerView.alpha = 0
        }
        
        if style.contains(.magnify) {
            containerView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
        
        if style.contains(.shrink) {
            containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        config.openAnimationBlock({
            [weak self] in
            switch (self?.config.backgroundStyle)! {
            case .translucent:
                self?.view.backgroundColor = self?.view.backgroundColor?.withAlphaComponent((self?.config.backgroundStyleColorAlpha)!)
            case .blur:
                self?.backgroundEffectView?.effect = UIBlurEffect(style: (self?.config.backgroundBlurStyle)!)
            }
            self?.containerView.x = ((self?.view.width)! - (self?.containerView.width)!) / 2
            self?.containerView.y = ((self?.view.height)! - (self?.containerView.height)!) / 2 - (self?.config.customAlert.centerEdge)!
            
            self?.containerView.alpha = 1
            self?.containerView.transform = .identity
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
            
            let container_W = (self?.containerView.width)!
            let container_H = (self?.containerView.height)!
            
            let style = (self?.config.closeAnimationStyle)!
            
            if style.contains(.none) {
                self?.containerView.alpha = 0
                self?.containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            
            if style.contains(.top) {
                self?.containerView.x = (view_W - container_W) / 2
                self?.containerView.y = -container_H
            }
            
            if style.contains(.bottom) {
                self?.containerView.x = (view_W - container_W) / 2
                self?.containerView.y = view_H
            }
            
            if style.contains(.left) {
                self?.containerView.x = -container_W
                self?.containerView.y = ((self?.view.height)! - (self?.containerView.height)!) / 2 - (self?.config.customAlert.centerEdge)!
            }
            
            if style.contains(.right) {
                self?.containerView.x = view_W
                self?.containerView.y = ((self?.view.height)! - (self?.containerView.height)!) / 2 - (self?.config.customAlert.centerEdge)!
            }
            
            if style.contains(.fade) {
                self?.containerView.alpha = 0
            }
            
            if style.contains(.magnify) {
                self?.containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            
            if style.contains(.shrink) {
                self?.containerView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
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
    
}

