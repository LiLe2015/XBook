//
//  LLBookTitleView.swift
//  XBook
//
//  Created by LiLe on 16/1/3.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

// objc的协议中的方法是可选的，但是swift的协议中的方法是必须实现的(比较危险)
@objc protocol BookTitleViewDelegate {
    optional func choiceCover()
}

class LLBookTitleView: UIView {

    var BookCover:UIButton?
    
    var BookName:JVFloatLabeledTextField?
    
    var BookEditor:JVFloatLabeledTextField?
    
    weak var delegate:BookTitleViewDelegate?
    
    // 重载初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.BookCover = UIButton(frame: CGRectMake(10, 8, 110, 141))
        self.BookCover?.setImage(UIImage(named: "Cover"), forState: .Normal)
        self.addSubview(self.BookCover!)
        self.BookCover?.addTarget(self, action: Selector("choiceCover"), forControlEvents: .TouchUpInside)
        
        self.BookName = JVFloatLabeledTextField(frame: CGRectMake(128, 8+40, SCREEN_WIDTH-128-15, 30))
        self.BookEditor = JVFloatLabeledTextField(frame: CGRectMake(128, 8+70+40, SCREEN_WIDTH-128-15, 30))
        
        self.BookName?.placeholder = "书名"
        self.BookEditor?.placeholder = "作者"
        
        self.BookName?.floatingLabelFont = UIFont(name: MY_FONT, size: 14)
        self.BookEditor?.floatingLabelFont = UIFont(name: MY_FONT, size: 14)
        
        self.BookName?.font = UIFont(name: MY_FONT, size: 14)
        self.BookEditor?.font = UIFont(name: MY_FONT, size: 14)
        
        self.addSubview(self.BookName!)
        self.addSubview(self.BookEditor!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not implemeted")
    }
    
    func choiceCover() {
        self.delegate?.choiceCover?()
    }

}
