//
//  UIViewExtension.swift
//  AlertDemo
//
//  Created by HT on 2017/12/15.
//  Copyright © 2017年 Ht. All rights reserved.
//

import Foundation
import UIKit

/**
 *   properties
 */
extension UIView {
    /// 边框线位置
    public struct BorderPosition : OptionSet {
        
        public let rawValue: Int
        
        public static let left = BorderPosition(rawValue: 1 << 0)
        
        public static let top = BorderPosition(rawValue: 1 << 1)
        
        public static let right = BorderPosition(rawValue: 1 << 2)
        
        public static let bottom = BorderPosition(rawValue: 1 << 3)
        
        public static let all: BorderPosition = [.top, .right, .left, .bottom]
        
        
        
        public init(rawValue: Int) {
            
            self.rawValue = rawValue;
            
        }
    }
    
    /// view的x
    var x: CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    /// view的y
    var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    /// view的宽
    var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            self.frame.size.width = newValue
        }
    }
    /// view的高
    var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            self.frame.size.height = newValue
        }
    }
    /// view的上
    var top: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    /// view的下
    var bottom: CGFloat{
        get{
            return self.frame.origin.y + self.frame.size.height
        }
        set{
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }
    /// view的左
    var left: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    /// view的右
    var right: CGFloat{
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set{
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }
    /// view的X轴中心
    var centerX: CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center.x = newValue
        }
    }
    /// view的Y轴中心
    var centerY: CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center.y = newValue
        }
    }
}

/**
 *   Method
 */
extension UIView {

    ///画虚线边框

    func drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5, corners: BorderPosition) {

        let shapeLayer = CAShapeLayer()

        shapeLayer.bounds = self.bounds
        
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        shapeLayer.fillColor = UIColor.blue.cgColor
        
        shapeLayer.strokeColor = strokeColor.cgColor
        
        
        
        shapeLayer.lineWidth = lineWidth
        
        shapeLayer.lineJoin = CAShapeLayerLineJoin.miter
        
        
        
        //每一段虚线长度 和 每两段虚线之间的间隔
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        
        
        let path = CGMutablePath()
        
        if corners.contains(.left) {
            
            path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
            
            path.addLine(to: CGPoint(x: 0, y: 0))
            
        }
        
        if corners.contains(.top){
            
            path.move(to: CGPoint(x: 0, y: 0))
            
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
            
        }
        
        if corners.contains(.right){
            
            path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
            
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            
        }
        
        if corners.contains(.bottom){
            
            path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            
            path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
            
        }
        
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    ///画实线边框
    
    func drawLine(strokeColor: UIColor, lineWidth: CGFloat = 1, corners: BorderPosition) {
        
        if corners == BorderPosition.all {
            
            self.layer.borderWidth = lineWidth
            
            self.layer.borderColor = strokeColor.cgColor
            
        }else{
            
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.bounds = self.bounds
            
            shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
            
            shapeLayer.fillColor = UIColor.blue.cgColor
            
            shapeLayer.strokeColor = strokeColor.cgColor
            
            shapeLayer.lineWidth = lineWidth
//            shapeLayer.lineJoin
            
            let path = CGMutablePath()
            
            if corners.contains(.left) {
                path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: 0))
            }
            if corners.contains(.top){
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
            }
            if corners.contains(.right){
                path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            }
            if corners.contains(.bottom){
                path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
            }
            shapeLayer.path = path
            self.layer.addSublayer(shapeLayer)
        }
    }
    
}





