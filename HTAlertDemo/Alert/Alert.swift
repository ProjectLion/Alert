//
//  Alert.swift
//  AlertDemo
//
//  Created by Ht on 2018/6/25.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit


public protocol AlertDelegate {
    func closeBlock(complete: @escaping () -> Void)
}

/// Alert
public class Alert: NSObject {
    ///
    static let shared = Alert()
    private override init() {}
    
    /// mainWindow
    var mainWindow: UIWindow!
    
    /// window
    var alertWindow: AlertWindow = {
        let window = AlertWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.backgroundColor = .clear
        window.windowLevel = .alert
        window.isHidden = true
        return window
    }()
    
    /// queueArray
    var queueArray: Array<AlertConfig> = []
    
    /// viewController
    var viewController: AlertBaseViewController!
    
    /// alert
//    class func alert() -> AlertConfig {
//        let config = AlertConfig()
//        config.type = .alert
//        return config
//    }
    static var alert: AlertConfig {
        get {
            let config = AlertConfig()
            config.type = .alert
            return config
        }
    }
    
    /// sheet
//    class func sheet() -> AlertConfig {
//        let config = AlertConfig()
//        config.type = .sheet
//        config.config.isClickBackgroundClose(true)
//        return config
//    }
    static var sheet: AlertConfig {
        get {
            let config = AlertConfig()
            config.type = .sheet
            config.config.isClickBackgroundClose(true)
            return config
        }
    }
    
    /// 获取alert window
    class func getAlertWindow() -> AlertWindow {
        return Alert.shared.alertWindow
    }
    
    /// 设置alert window
    class func setupMainWindow(_ window: UIWindow) {
        Alert.shared.mainWindow = window
    }
    
    /// 继续队列显示
    class func continueQueueDisplay() {
        if !Alert.shared.queueArray.isEmpty {
            Alert.shared.queueArray.last?.config.configFinish()
        }
    }
    
    /// 清空队列
    class func clearQueue() {
        if !Alert.shared.queueArray.isEmpty {
            Alert.shared.queueArray.removeAll()
        }
    }
    
    /// 关闭
    class func close(_ complete: @escaping () -> Void) {
        if !Alert.shared.queueArray.isEmpty {
            if let config = Alert.shared.queueArray.last {
                config.closeBlock(complete: complete)
            }
        }
    }
    
}
