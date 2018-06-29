//
//  HTItemLabel.swift
//  HTAlertDemo
//
//  Created by Ht on 2018/6/27.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

class HTItemLabel: UILabel {
    
    public var item: HTItem = HTItem()
    
    public var textChangeBlock: () -> Void = {
        
    }
    
    override var text: String? {
        didSet{
            textChangeBlock()
        }
    }
    
    override var attributedText: NSAttributedString? {
        didSet{
            textChangeBlock()
        }
    }
    
    override var font: UIFont! {
        didSet{
            textChangeBlock()
        }
    }
    
    override var numberOfLines: Int {
        didSet{
            textChangeBlock()
        }
    }
    
}
