//
//  CustomView.swift
//  AlertDemo
//
//  Created by Ht on 2018/6/25.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

/// 自定义视图对象
public class CustomView: NSObject {
    
    /// 视图对象
    public var view: UIView!
    
    /// 自定义视图位置
    public var position: CustomViewPosition = .center
    
    /// 是否自适应宽 默认 true
    public var isAutoWidth = true
    
    public var item: Item = Item()
    
    private var size = CGSize.zero
    
    public var sizeChangedBlock: () -> Void = {}{
        didSet{
            print(message: "调用了sizeChangedBlock")
            view.layoutSubviews()
            size = view.frame.size
            view.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    
    override init() {
        super.init()
    }
    
    deinit {
        print(message: "HTCustomView对象销毁了")
        view.removeObserver(self, forKeyPath: "frame")
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let view = object as! UIView
        
        if !size.equalTo(view.frame.size) {
            size = view.frame.size
            sizeChangedBlock()
        }
    }
    
}
