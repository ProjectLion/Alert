//
//  ItemLabel.swift
//  AlertDemo
//
//  Created by Ht on 2018/6/27.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

public class ItemLabel: UILabel {
    
    public var item: Item = Item()
    
    public var textChangeBlock: () -> Void = {
        
    }
    
    override public var text: String? {
        didSet{
            textChangeBlock()
        }
    }
    
    override public var attributedText: NSAttributedString? {
        didSet{
            textChangeBlock()
        }
    }
    
    override public var font: UIFont! {
        didSet{
            textChangeBlock()
        }
    }
    
    override public var numberOfLines: Int {
        didSet{
            textChangeBlock()
        }
    }
    
}
