//
//  ActionButton.swift
//  AlertDemo
//
//  Created by Ht on 2018/6/26.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

public class ActionButton: UIButton {
    
    public var heightChangeBlock: () -> Void = {
        
    }
    
    /// 边框颜色 默认 darkGray
    public var borderColor: UIColor = .darkGray
    /// 边框宽度 默认 1
    public var borderWidth: CGFloat = 1
    /// 上边框
    public var topLayer: CALayer?
    /// 下边框
    public var bottomLayer: CALayer?
    /// 左边框
    public var leftLayer: CALayer?
    /// 右边框
    public var rightLayer: CALayer?
    
    public var action: Action! {
        didSet{
            self.clipsToBounds = true
            
            setTitle(action.title, for: .normal)
            titleLabel?.font = action.font
            setTitleColor(action.color, for: .normal)
            if !action.highlightTitle.isEmpty {
                setTitle(action.highlightTitle, for: .highlighted)
            }
            if let att = action.attributedTitle {
                let mutableAtt = NSMutableAttributedString(attributedString: att)
                if att.attribute(.foregroundColor, at: 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: att.string.count)) == nil {  // 如果用户没有对富文本设置颜色，则将标题颜色设置上
                    mutableAtt.addAttributes([NSAttributedString.Key.foregroundColor :action.color], range: NSRange(location: 0, length: att.string.count))
                }
                setAttributedTitle(mutableAtt, for: .normal)
            }
            if let attHighlight = action.attributedHighlightTitle {
                let mutableAtt = NSMutableAttributedString(attributedString: attHighlight)
                if attHighlight.attribute(.foregroundColor, at: 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: attHighlight.string.count)) == nil {    // 如果用户没有对富文本设置颜色，则将标题颜色设置上
                    mutableAtt.addAttributes([NSAttributedString.Key.foregroundColor :action.highlightColor], range: NSRange(location: 0, length: attHighlight.string.count))
                }
                setAttributedTitle(mutableAtt, for: .highlighted)
            }
            
            if action.type.rawValue != 0 {
                setTitleColor(.red, for: .normal)
            }
            
            setBackgroundImage(getImage(color: action.backgroundColor), for: .normal)
            setBackgroundImage(getImage(color: action.highlightBackgroundColor), for: .highlighted)
            if let bgImage = action.backgroundImage {
                setBackgroundImage(bgImage, for: .normal)
            }
            if let highLightBgImage = action.highlightBackgroundImage {
                setBackgroundImage(highLightBgImage, for: .highlighted)
            }
            borderColor = action.borderColor
            borderWidth = action.borderWidth < 0 ? 0 : action.borderWidth
            
            setImage(action.image, for: .normal)
            setImage(action.highlightImage, for: .highlighted)
            
            setupActionHeight(height: action.height)
            layer.cornerRadius = action.cornerRadius
            
            imageEdgeInsets = action.imageInsets
            titleEdgeInsets = action.titleInsets
            
            let position = action.borderPosition
            // 先将所有的边框移除一遍 再添加
            removeBorder(type: position)
            
            addBorder(type: position)
            
            action.updateBlock = {
                [weak self]
                act in
                self?.action = act
            }
        }
    }
    
    private func setupActionHeight(height: CGFloat) {
        let isChange = frame.size.height == height ? false : true
        frame.size.height = height
        if isChange {
            heightChangeBlock()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if let top = topLayer {
            top.frame = CGRect(x: 0, y: 0, width: width, height: borderWidth)
        }
        if let bottom = bottomLayer {
            bottom.frame = CGRect(x: 0, y: height - borderWidth, width: width, height: borderWidth)
        }
        if let left = leftLayer {
            left.frame = CGRect(x: 0, y: 0, width: borderWidth, height: height)
        }
        if let right = rightLayer {
            right.frame = CGRect(x: width - borderWidth, y: 0, width: borderWidth, height: height)
        }
    }
    
    /// 添加边框
    ///
    /// - Parameter type: 边框位置
    private func addBorder(type: Action.ActionBorderPosition) {
        
        // 根据配置的边框位置类型添加边框
        if type.contains(.all) {
            layer.backgroundColor = action.borderColor.cgColor
            layer.borderWidth = action.borderWidth
        }
        
        if type.contains(.top) {
            topLayer = CALayer()
            topLayer?.backgroundColor = borderColor.cgColor
            layer.addSublayer(topLayer!)
        }
        
        if type.contains(.bottom) {
            bottomLayer = CALayer()
            bottomLayer?.backgroundColor = borderColor.cgColor
            layer.addSublayer(bottomLayer!)
        }
        
        if type.contains(.left) {
            leftLayer = CALayer()
            leftLayer?.backgroundColor = borderColor.cgColor
            layer.addSublayer(leftLayer!)
        }
        
        if type.contains(.right) {
            rightLayer = CALayer()
            rightLayer?.backgroundColor = borderColor.cgColor
            layer.addSublayer(rightLayer!)
        }
    }
    
    /// 移除边框
    ///
    /// - Parameter type: 边框位置
    private func removeBorder(type: Action.ActionBorderPosition) {
        
        if type.contains(.all) {
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        } else if type.contains(.top) {
            if let top = topLayer {
                top.removeFromSuperlayer()
                topLayer = nil
            }
        } else if type.contains(.bottom) {
            if let bottom = bottomLayer {
                bottom.removeFromSuperlayer()
                bottomLayer = nil
            }
        } else if type.contains(.left) {
            if let left = leftLayer {
                left.removeFromSuperlayer()
                leftLayer = nil
            }
        } else if type.contains(.right) {
            if let right = rightLayer {
                right.removeFromSuperlayer()
                rightLayer = nil
            }
        }
    }
    
    /// 获取纯色图片
    ///
    /// - Parameter color: 图片颜色
    /// - Returns: UIImage对象
    private func getImage(color: UIColor) -> UIImage? {
        self.adjustsImageWhenHighlighted = false
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
}
