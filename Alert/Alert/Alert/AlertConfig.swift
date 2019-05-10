//
//  AlertConfig.swift
//  AlertDemo
//
//  Created by Ht on 2018/6/25.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

/// 配置管理类
public class AlertConfig: NSObject {
    
    /// 配置模型
    public var config: AlertConfigModel = {
        let config = AlertConfigModel()
        return config
    }()
    
    /// alert的类型
    public var type: AlertType = .alert 
    
    override init() {
        super.init()
        config.configFinish = {
            if !Alert.shared.queueArray.isEmpty {
                let last = (Alert.shared.queueArray.last)!
                if !self.config.isQueue && last.config.queuePriorty > self.config.queuePriorty {
                    return
                }
                
                if !last.config.isQueue && last.config.queuePriorty <= self.config.queuePriorty {
                    Alert.shared.queueArray.removeLast()
                }
                
                if !Alert.shared.queueArray.contains(self) {
                    Alert.shared.queueArray.append(self)
                    Alert.shared.queueArray.sort(by: { (A, B) -> Bool in
                        return A.config.queuePriorty > B.config.queuePriorty
                    })
                }
                
                if Alert.shared.queueArray.last == self {
                    self.show()
                }
            } else {
                self.show()
                Alert.shared.queueArray.append(self)
            }
        }
    }
    
    deinit {
        print(message: "AlertConfig deinit")
    }
    
}

//MARK: ^^^^^^^^^^^^^^^ AlertDelegate ^^^^^^^^^^^^^^^
extension AlertConfig: AlertDelegate {
    public func closeBlock(complete: @escaping () -> Void) {
        if Alert.shared.viewController != nil {
            Alert.shared.viewController.close(completeBlock: complete)
        }
    }
}

//MARK: ^^^^^^^^^^^^^^^ show ^^^^^^^^^^^^^^^
extension AlertConfig {
    
    private func show() {
        switch type {
        case .alert:
            Alert.shared.viewController = AlertViewController()
            config.maxWidth(290)
                .configMaxHeight { (scrrenType) -> CGFloat in
                    return Scrren_H - 40 - viewSafeaInsets(view: Alert.getAlertWindow()).top - viewSafeaInsets(view: Alert.getAlertWindow()).bottom
            }
        case .sheet:
            Alert.shared.viewController = ActionSheetViewController()
            config.openAnimationStyle([.bottom, .fade])
            .closeAnimationStyle([.bottom, .fade])
                .configMaxWidth(block: { (scrrenType) -> CGFloat in
                    switch scrrenType {
                    case .horizontal:
                        return Scrren_H - viewSafeaInsets(view: Alert.getAlertWindow()).top - viewSafeaInsets(view: Alert.getAlertWindow()).bottom - 20
                    case .vertical:
                        return Scrren_W - viewSafeaInsets(view: Alert.getAlertWindow()).left - viewSafeaInsets(view: Alert.getAlertWindow()).right - 20
                    }
                })
                .configMaxHeight { (scrrenType) -> CGFloat in
                    return Scrren_H - 40 - viewSafeaInsets(view: Alert.getAlertWindow()).top - viewSafeaInsets(view: Alert.getAlertWindow()).bottom
            }
        }
        
        Alert.shared.viewController.config = config
        
        Alert.shared.alertWindow.rootViewController = Alert.shared.viewController
        
        Alert.shared.alertWindow.windowLevel = config.windowLevel
        
        Alert.shared.alertWindow.isHidden = false
        
        Alert.shared.alertWindow.makeKeyAndVisible()
        
        Alert.shared.viewController.openFinishBlock = {
            
        }
        
        Alert.shared.viewController.closeFinishBlock = {
            [weak self] in
            
            if self == nil {
                return
            }
            
            if Alert.shared.queueArray.last == self {
                Alert.shared.alertWindow.isHidden = true
                Alert.shared.alertWindow.resignKey()
                Alert.shared.alertWindow.rootViewController = nil
                Alert.shared.viewController = nil
                Alert.shared.queueArray = Alert.shared.queueArray.filter({ (conf) -> Bool in
                    return conf != self
                })
                /// 继续显示队列中的alert
                if (self?.config.isContinueQueueDisplay)! {
                    Alert.continueQueueDisplay()
                }
            } else {
                Alert.shared.queueArray = Alert.shared.queueArray.filter({ (conf) -> Bool in
                    return conf != self
                })
            }
            
            self?.config.closeComplete()
            
        }
        
    }
    
}
