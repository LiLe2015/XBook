//
//  LLGeneralFactory.swift
//  XBook
//
//  Created by LiLe on 16/1/3.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

enum LLIncrement {
    case love, cancelLove, scan, discuss
}

class LLGeneralFactory: NSObject {

    /**
    static修饰的方法是静态的，相当于类方法
    */
    static func addTitleWithTitle(target:UIViewController, title1:String = "关闭", title2:String = "确定") {
        
        let btn1 = UIButton(frame: CGRectMake(10, 20, 40, 20))
        btn1.setTitle(title1, forState: .Normal)
        btn1.contentHorizontalAlignment = .Left
        btn1.setTitleColor(MAIN_RED, forState: .Normal)
        btn1.titleLabel?.font = UIFont(name: MY_FONT, size: 14)
        btn1.tag = 1234
        target.view.addSubview(btn1)
        
        let btn2 = UIButton(frame: CGRectMake(SCREEN_WIDTH - 50, 20, 40, 20))
        btn2.setTitle(title2, forState: .Normal)
        btn2.contentHorizontalAlignment = .Right
        btn2.setTitleColor(MAIN_RED, forState: .Normal)
        btn2.titleLabel?.font = UIFont(name: MY_FONT, size: 14)
        btn2.tag = 1235
        target.view.addSubview(btn2)
        
        btn1.addTarget(target, action: Selector("close"), forControlEvents: .TouchUpInside)
        btn2.addTarget(target, action: Selector("sure"), forControlEvents: .TouchUpInside)
    }
    
    static func addIncrementkey(book:AVObject, type:LLIncrement) {
        switch type {
        case .love:
            book.incrementKey("loveNumber", byAmount: NSNumber(int: 1))
            break
        case .cancelLove:
            book.incrementKey("loveNumber", byAmount: NSNumber(int: -1))
            break
        case .discuss:
            book.incrementKey("discussNumber", byAmount: NSNumber(int: 1))
            break
        default:
            book.incrementKey("scanNumber", byAmount: NSNumber(int: 1))
            break
        }
        book.saveInBackground()
    }
}
