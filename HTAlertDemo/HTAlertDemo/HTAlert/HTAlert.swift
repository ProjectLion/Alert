//
//  HTAlert.swift
//  HTAlertDemo
//
//  Created by Ht on 2018/6/25.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit


protocol HTAlertDelegate {
    func closeBlock(complete: @escaping () -> Void)
}

/// HTAlert
class HTAlert: NSObject {
    ///
    static let shared = HTAlert()
    private override init() {}
    
    /// mainWindow
    var mainWindow: UIWindow!
    
    /// window
    var alertWindow: HTAlertWindow = {
        let window = HTAlertWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.backgroundColor = .clear
        window.windowLevel = .alert
        window.isHidden = true
        return window
    }()
    
    /// queueArray
    var queueArray: Array<HTAlertConfig> = []
    
    /// viewController
    var viewController: HTAlertBaseViewController!
    
    /// alert
    class func alert() -> HTAlertConfig {
        let config = HTAlertConfig()
        config.type = .alert
        return config
    }
    
    /// sheet
    class func sheet() -> HTAlertConfig {
        let config = HTAlertConfig()
        config.type = .sheet
        config.config.isClickBackgroundClose(true)
        return config
    }
    
    /// 获取alert window
    class func getAlertWindow() -> HTAlertWindow {
        return HTAlert.shared.alertWindow
    }
    
    /// 设置alert window
    class func setupMainWindow(_ window: UIWindow) {
        HTAlert.shared.mainWindow = window
    }
    
    /// 继续队列显示
    class func continueQueueDisplay() {
        if !HTAlert.shared.queueArray.isEmpty {
            HTAlert.shared.queueArray.last?.config.configFinish()
        }
    }
    
    /// 清空队列
    class func clearQueue() {
        if !HTAlert.shared.queueArray.isEmpty {
            HTAlert.shared.queueArray.removeAll()
        }
    }
    
    /// 关闭
    class func close(_ complete: @escaping () -> Void) {
        if !HTAlert.shared.queueArray.isEmpty {
            if let config = HTAlert.shared.queueArray.last {
                config.closeBlock(complete: complete)
            }
        }
    }
    
}
