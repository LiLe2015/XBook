//
//  LLTitleViewController.swift
//  XBook
//
//  Created by LiLe on 16/1/4.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

// 声明一个闭包
typealias LLTitleCallBack = (title:String)->Void

class LLTitleViewController: UIViewController {

    var textField:UITextField?
    var callBack:LLTitleCallBack?
    
    /**
     实现回调：
     1.Block
     2.Delegate
     3.NSNotification
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.textField = UITextField(frame: CGRectMake(15, 60, SCREEN_WIDTH - 30, 30))
        self.textField?.borderStyle = .RoundedRect // 带圆角的边框
        self.textField?.placeholder = "书评标题"
        self.textField?.font = UIFont(name: MY_FONT, size: 15)
        self.view.addSubview(self.textField!)
        
        self.textField?.becomeFirstResponder()
    }
    

    func sure() {
        self.callBack?(title:self.textField!.text!)
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func close() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

}
