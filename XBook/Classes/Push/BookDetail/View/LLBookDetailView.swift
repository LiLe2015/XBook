//
//  LLBookDetailView.swift
//  XBook
//
//  Created by LiLe on 16/2/23.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

class LLBookDetailView: UIView {
    
    var w:CGFloat!
    var h:CGFloat!
    
    var bookName:UILabel?
    var editor:UILabel?
    var userName:UILabel?
    var date:UILabel?
    var more:UILabel?
    var score:LDXScore?
    
    var cover:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.w = frame.size.width
        self.h = frame.size.height
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.cover = UIImageView(frame: CGRectMake(8, 8, (h - 16)/1.273, h - 16))
        self.addSubview(self.cover!)
        
        self.bookName = UILabel(frame: CGRectMake((h - 16)/1.273 + 16, 8, w - (h - 16)/1.273 - 16, h / 4))
        self.bookName?.font = UIFont(name: MY_FONT, size: 18)
        self.addSubview(self.bookName!)
        
        self.editor = UILabel(frame: CGRectMake((h - 16)/1.273 + 16, 8 + h/4, w - (h - 16)/1.273 - 16, h / 4))
        self.editor?.font = UIFont(name: MY_FONT, size: 18)
        self.addSubview(self.editor!)
        
        self.userName = UILabel(frame: CGRectMake((h - 16)/1.273 + 16, 24 + h/4 + h/6, w - (h - 16)/1.273 - 16, h / 6))
        self.userName?.font = UIFont(name: MY_FONT, size: 13)
        self.addSubview(self.userName!)
        
        self.date = UILabel(frame: CGRectMake((h - 16)/1.273+16,16+h/4+h/6*2,80,h/6))
        self.date?.font = UIFont(name: MY_FONT, size: 13)
        self.date?.textColor = UIColor.grayColor()
        self.addSubview(self.date!)
        
        self.score = LDXScore(frame: CGRectMake((h - 16)/1.273+16+80,16+h/4+h/6*2,80,h/6))
        self.score?.isSelect = false
        self.score?.normalImg = UIImage(named: "btn_star_evaluation_normal")
        self.score?.highlightImg = UIImage(named: "btn_star_evaluation_press")
        self.score?.max_star = 5
        self.score?.show_star = 5
        self.addSubview(self.score!)
        
        self.more = UILabel(frame: CGRectMake((h - 16)/1.273+16,8+h/4+h/6*3,w - (h - 16)/1.273 - 16,h/6))
        self.more?.textColor = UIColor.grayColor()
        self.more?.font = UIFont(name: MY_FONT, size: 13)
        self.addSubview(self.more!)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.5)
        CGContextSetRGBStrokeColor(context, 321/255.0, 321/255.0, 321/255.0, 1)
        CGContextMoveToPoint(context, 8, h - 2)
        CGContextAddLineToPoint(context, w - 8, h - 2)
        CGContextStrokePath(context)
    }

}
