//
//  LLPushBook.swift
//  XBook
//
//  Created by LiLe on 16/2/21.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

class LLPushBook: NSObject {

    static func pushBookInBack(dict:NSDictionary, object:AVObject){
        
        object.setObject(dict["BookName"], forKey: "BookName")
        object.setObject(dict["BookEditor"], forKey: "BookEditor")
        object.setObject(dict["title"], forKey: "title")
        object.setObject(dict["score"], forKey: "score")
        object.setObject(dict["type"], forKey: "type")
        object.setObject(dict["detaileType"], forKey: "detaileType")
        object.setObject(dict["description"], forKey: "description")
        object.setObject(AVUser.currentUser(), forKey: "user")
        let image = dict["BookCover"] as? UIImage
        let coverFile = AVFile(data: UIImagePNGRepresentation(image!))
        coverFile.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                object.setObject(coverFile, forKey: "cover")
                object.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success{
                        // 调用通知
                        NSNotificationCenter.defaultCenter().postNotificationName("pushBookNotification", object: nil, userInfo: ["success":"true"])
                    }else{
                        NSNotificationCenter.defaultCenter().postNotificationName("pushBookNotification", object: nil, userInfo: ["success":"false"])
                    }
                })
                
            }else{
                NSNotificationCenter.defaultCenter().postNotificationName("pushBookNotification", object: nil, userInfo: ["success":"false"])
            }
        }
        
        
    }

}
