//
//  LLLoginViewController.swift
//  XBook
//
//  Created by LiLe on 16/2/21.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

class LLLoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var topLayout: NSLayoutConstraint!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        XKeyBoard.registerKeyBoardHide(self)
        XKeyBoard.registerKeyBoardShow(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        AVUser.logInWithUsernameInBackground(self.username.text, password: self.password.text) { (user, error) -> Void in
            if error == nil {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }else{
                if error.code == 210{
                    ProgressHUD.showError("用户名或密码错误")
                }else if error.code == 211 {
                    ProgressHUD.showError("不存在该用户")
                }else if error.code == 216 {
                    ProgressHUD.showError("未验证邮箱")
                }else if error.code == 1{
                    ProgressHUD.showError("操作频繁")
                }else{
                    ProgressHUD.showError("登录失败")
                }
            }
        }
    }

    /**
     *  注册键盘出现和消失
     */
    func keyboardWillHideNotification(notification:NSNotification){
        // 改变约束
        UIView.animateWithDuration(0.3) { () -> Void in
            self.topLayout.constant = 8
            // 使用约束添加动画一定要添加下面这句话，添加了下面这句话就以一桢一桢的形式展示动画。不加这句话，直接移动到了最后的位置
            self.view.layoutIfNeeded()
        }
        
    }
    func keyboardWillShowNotification(notification:NSNotification){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.topLayout.constant = -200
            self.view.layoutIfNeeded()
        }
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
