//
//  HTAlertConfig.swift
//  HTAlertDemo
//
//  Created by Ht on 2018/6/25.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

/// 配置管理类
class HTAlertConfig: NSObject {
    
    /// 配置模型
    public lazy var config: HTAlertConfigModel = {
        let config = HTAlertConfigModel()
        return config
    }()
    
    /// alert的类型
    public var type: HTAlertType = .alert 
    
    override init() {
        super.init()
        config.configFinish = {
//            [weak self] in
//            if self == nil {
//                return
//            }
            if !HTAlert.shared.queueArray.isEmpty {
                let last = (HTAlert.shared.queueArray.last)!
                if !self.config.isQueue && last.config.queuePriorty > self.config.queuePriorty {
                    return
                }
                
                if !last.config.isQueue && last.config.queuePriorty <= self.config.queuePriorty {
                    HTAlert.shared.queueArray.removeLast()
                }
                
                if !HTAlert.shared.queueArray.contains(self) {
                    HTAlert.shared.queueArray.append(self)
                    HTAlert.shared.queueArray.sort(by: { (A, B) -> Bool in
                        return A.config.queuePriorty > B.config.queuePriorty
                    })
                }
                
                if HTAlert.shared.queueArray.last == self {
                    self.show()
                }
            } else {
                self.show()
                HTAlert.shared.queueArray.append(self)
            }
        }
    }
    
    deinit {
        ht_print(message: "HTAlertConfig deinit")
    }
    
}

//MARK: ^^^^^^^^^^^^^^^ HTAlertDelegate ^^^^^^^^^^^^^^^
extension HTAlertConfig: HTAlertDelegate {
    func closeBlock(complete: @escaping () -> Void) {
        if HTAlert.shared.viewController != nil {
            HTAlert.shared.viewController.close(completeBlock: complete)
        }
    }
}

//MARK: ^^^^^^^^^^^^^^^ show ^^^^^^^^^^^^^^^
extension HTAlertConfig {
    
    private func show() {
        switch type {
        case .alert:
            HTAlert.shared.viewController = HTAlertViewController()
            config.maxWidth(290)
                .configMaxHeight { (scrrenType) -> CGFloat in
                    return Scrren_H - 40 - viewSafeaInsets(view: HTAlert.getAlertWindow()).top - viewSafeaInsets(view: HTAlert.getAlertWindow()).bottom
            }
        case .sheet:
            HTAlert.shared.viewController = HTActionSheetViewController()
            config.openAnimationStyle([.bottom, .fade])
            .closeAnimationStyle([.bottom, .fade])
                .configMaxWidth(block: { (scrrenType) -> CGFloat in
                    switch scrrenType {
                    case .horizontal:
                        return Scrren_H - viewSafeaInsets(view: HTAlert.getAlertWindow()).top - viewSafeaInsets(view: HTAlert.getAlertWindow()).bottom - 20
                    case .vertical:
                        return Scrren_W - viewSafeaInsets(view: HTAlert.getAlertWindow()).left - viewSafeaInsets(view: HTAlert.getAlertWindow()).right - 20
                    }
                })
                .configMaxHeight { (scrrenType) -> CGFloat in
                    return Scrren_H - 40 - viewSafeaInsets(view: HTAlert.getAlertWindow()).top - viewSafeaInsets(view: HTAlert.getAlertWindow()).bottom
            }
        }
        
        HTAlert.shared.viewController.config = config
        
        HTAlert.shared.alertWindow.rootViewController = HTAlert.shared.viewController
        
        HTAlert.shared.alertWindow.windowLevel = config.windowLevel
        
        HTAlert.shared.alertWindow.isHidden = false
        
        HTAlert.shared.alertWindow.makeKeyAndVisible()
        
        HTAlert.shared.viewController.openFinishBlock = {
            
        }
        
        HTAlert.shared.viewController.closeFinishBlock = {
            [weak self] in
            
            if self == nil {
                return
            }
            
            if HTAlert.shared.queueArray.last == self {
                HTAlert.shared.alertWindow.isHidden = true
                HTAlert.shared.alertWindow.resignKey()
                HTAlert.shared.alertWindow.rootViewController = nil
                HTAlert.shared.viewController = nil
                HTAlert.shared.queueArray = HTAlert.shared.queueArray.filter({ (conf) -> Bool in
                    return conf != self
                })
                /// 继续显示队列中的alert
                if (self?.config.isContinueQueueDisplay)! {
                    HTAlert.continueQueueDisplay()
                }
            } else {
                HTAlert.shared.queueArray = HTAlert.shared.queueArray.filter({ (conf) -> Bool in
                    return conf != self
                })
            }
            
            self?.config.closeComplete()
            
        }
        
    }
    
}
