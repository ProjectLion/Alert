//
//  HTAlertBaseViewController.swift
//  HTAlertDemo
//
//  Created by Ht on 2018/6/26.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

class HTAlertBaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    public var config: HTAlertConfigModel!
    
    private var tempWindow: UIWindow?
    
    public var currentKeyWindow: UIWindow? {
        set{
            tempWindow = newValue
        }
        get{
            if tempWindow == nil {
                tempWindow = HTAlert.shared.mainWindow
            }
            if tempWindow == nil {
                tempWindow = UIApplication.shared.keyWindow
            }
            
            if tempWindow?.windowLevel != .normal {
                tempWindow = UIApplication.shared.windows.first(where: { $0.windowLevel == .normal && !$0.isHidden })
            }
            
            if tempWindow != nil && HTAlert.shared.mainWindow == nil {
                HTAlert.shared.mainWindow = tempWindow
            }
            return tempWindow
        }
    }
    
    public var backgroundEffectView: UIVisualEffectView?
    
    public var orientationType: HTScreenOrientationType = .vertical
    
    public var customView: HTCustomView?
    
    public var isShowing = false
    
    public var isClosing = false
    
    public var openFinishBlock: () -> Void = {
        
    }
    
    public  var closeFinishBlock: () -> Void = {
        
    }
    
    deinit {
        ht_print(message: "HTAlertBaseViewController deinit")
        config = nil
        currentKeyWindow = nil
        tempWindow = nil
        backgroundEffectView = nil
        customView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top
        extendedLayoutIncludesOpaqueBars = false
        
        
        
//        if #available(iOS 11, *) {
//            automaticallyAdjustsScrollViewInsets = false
//        }
        if config.backgroundStyle == .blur {
            backgroundEffectView = UIVisualEffectView(effect: nil)
            backgroundEffectView?.frame = view.frame
            view.addSubview(backgroundEffectView!)
        }
        view.backgroundColor = config.backgroundColor.withAlphaComponent(0)
        orientationType = Scrren_H > Scrren_W ? HTScreenOrientationType.vertical : HTScreenOrientationType.horizontal
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if config.isClickBackgroundClose {
            close {}
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if backgroundEffectView != nil {
            backgroundEffectView?.frame = view.frame
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        orientationType = size.height < size.width ? .horizontal : .vertical
    }
    
    override var shouldAutorotate: Bool {
        get{
            return config.isAutorotate
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get{
            return config.supportedInterfaceOrientations
        }
    }
    
    func show(completeBlock: @escaping () -> Void) {
        currentKeyWindow?.endEditing(true)
        view.isUserInteractionEnabled = false
    }
    
    func close(completeBlock: @escaping () -> Void) {
        HTAlert.shared.alertWindow.endEditing(true)
    }

}
