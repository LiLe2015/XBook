//
//  LLRankViewController.swift
//  XBook
//
//  Created by LiLe on 16/1/3.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

class LLRankViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 判断用户是否已经登陆
        if AVUser.currentUser() == nil {
            let story = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = story.instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(loginVC, animated: true, completion: { () -> Void in
                
            })
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
