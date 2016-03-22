//
//  LLBookDetailViewController.swift
//  XBook
//
//  Created by LiLe on 16/2/23.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

class LLBookDetailViewController: UIViewController, LLBookTabBarDelegate, InputViewDelegate, HZPhotoBrowserDelegate {

    var book: AVObject?
    
    var bookTitleView:LLBookDetailView?
    
    var bookViewTabbar:LLBookTabBar?
    
    var bookTextView:UITextView?
    
    var input:InputView?
    
    // 显示键盘时的背景遮罩
    var layView:UIView?
    
    var keyBoardHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        
        self.initBookDetailView()
        
        self.bookViewTabbar = LLBookTabBar(frame: CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40))
        self.view.addSubview(self.bookViewTabbar!)
        self.bookViewTabbar?.delegate = self
        
        self.bookTextView = UITextView(frame: CGRectMake(0, 64+SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - SCREEN_HEIGHT/4-40))
        self.bookTextView?.editable = false
        self.bookTextView?.text = self.book!["description"] as? String
        self.view.addSubview(self.bookTextView!)
        
        self.isLove()
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.input != nil {
            
            NSNotificationCenter.defaultCenter().removeObserver(self.input!, name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self.input!, selector: Selector("keyboardWillHideNotification:"), name: UIKeyboardWillShowNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.input != nil {

            NSNotificationCenter.defaultCenter().removeObserver(self.input!, name: UIKeyboardWillShowNotification, object: nil)
        }
    }
    
    deinit {
        print("bookDetailViewController dealloc!")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - UI
    /**
     初始化BookDetailView
    */
    func initBookDetailView() {
        self.bookTitleView = LLBookDetailView(frame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT/4))
        self.view.addSubview(self.bookTitleView!)
        
        let coverFile = self.book!["cover"] as? AVFile
        self.bookTitleView?.cover?.sd_setImageWithURL(NSURL(string: (coverFile?.url)!), placeholderImage: UIImage(named: "Cover"))
        
        self.bookTitleView?.bookName?.text = "《"+(self.book!["BookName"] as! String) + "》"
        self.bookTitleView?.editor?.text = "作者："+(self.book!["BookEditor"] as! String)
        
        let user = self.book!["user"] as? AVUser
        user?.fetchInBackgroundWithBlock({ (returnUser, error) -> Void in
            self.bookTitleView?.userName?.text = "编者："+(returnUser as! AVUser).username
        })
        
        let date = self.book!["createdAt"] as? NSDate
        let format = NSDateFormatter()
        format.dateFormat = "yy-MM-dd"
        self.bookTitleView?.date?.text = format.stringFromDate(date!)
        
//        let scoreString = self.book!["score"] as? String
//        self.bookTitleView?.score?.show_star = Int(scoreString!)!
        
        let scanNumber = self.book!["scanNumber"] as? NSNumber
        let loveNumber = self.book!["loveNumber"] as? NSNumber
        let discussNumber = self.book!["discussNumber"] as? NSNumber
        
        self.bookTitleView?.more?.text = (loveNumber?.stringValue)!+"个喜欢."+(discussNumber?.stringValue)!+"次评论."+(scanNumber?.stringValue)!+"次浏览"
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("photoBrowser"))
        self.bookTitleView?.cover?.addGestureRecognizer(tap)
        self.bookTitleView?.cover?.userInteractionEnabled = true
        
        LLGeneralFactory.addIncrementkey(self.book!, type: .scan)

    }
    
    /**
     是否点赞
     */
    func isLove() {
        let query = AVQuery(className: "Love")
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: self.book)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results != nil && results.count != 0 {
                let btn = self.bookViewTabbar?.viewWithTag(2) as? UIButton
                btn?.setImage(UIImage(named: "solidheart"), forState: .Normal)
            }
        }
    }

    func comment()
    {
        if self.input == nil {
            self.input = NSBundle.mainBundle().loadNibNamed("InputView", owner: self, options: nil).last as? InputView
            self.input?.frame = CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)
            self.input?.delegate = self
            self.view.addSubview(self.input!)
        }
        if self.layView == nil {
            self.layView = UIView(frame: self.view.frame)
            self.layView?.backgroundColor = UIColor.grayColor()
            self.layView?.alpha = 0
            let tap = UITapGestureRecognizer(target: self, action: Selector("tapInputView"))
            self.layView?.addGestureRecognizer(tap)
        }
        // 将layView插入到input的下边
        self.view.insertSubview(self.layView!, belowSubview: self.input!)
        self.layView?.hidden = false
        self.input?.inputTextView?.becomeFirstResponder()
    }
    
    func tapInputView() {
        self.input?.inputTextView?.resignFirstResponder()
    }
    
    func commentController()
    {
        let commentVC = LLCommentViewController()
        LLGeneralFactory.addTitleWithTitle(commentVC, title1: "", title2: "关闭")
        commentVC.book = self.book
        commentVC.tableView?.mj_header.beginRefreshing()
        self.presentViewController(commentVC, animated: true) { () -> Void in
            
        }
    }
    
    func likeBook(btn:UIButton)
    {
        btn.enabled = false
        btn.setImage(UIImage(named: "redheart"), forState: .Normal)
        
        let query = AVQuery(className: "Love")
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: self.book)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results != nil && results.count != 0 {
                for var object in results {
                    object = (object as? AVObject)!
                    object.deleteEventually()
                }
                btn.enabled = true
                btn.setImage(UIImage(named: "heart"), forState: .Normal)

                LLGeneralFactory.addIncrementkey(self.book!, type: .cancelLove)

            } else {
                let object = AVObject(className: "Love")
                object.setObject(AVUser.currentUser(), forKey: "user")
                object.setObject(self.book, forKey: "BookObject")
                object.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success {
                        btn.setImage(UIImage(named: "solidheart"), forState: .Normal)
                        
                        LLGeneralFactory.addIncrementkey(self.book!, type: .love)

                    } else {
                        ProgressHUD.showError("操作失败")
                    }
                })
            }
            btn.enabled = true
        }

    }
    
    func shareAction()
    {
        let shareParams = NSMutableDictionary()
        shareParams.SSDKSetupShareParamsByText("分享内容", images: self.bookTitleView?.cover?.image, url: NSURL(string: "http://www.baidu.com"), title: "标题", type: SSDKContentType.Image)
        //        ShareSDK.share(.TypeWechat, parameters: shareParams) { (state, userData, contentEntity, error) -> Void in
        //            switch state{
        //            case SSDKResponseState.Success:
        //                ProgressHUD.showSuccess("分享成功")
        //                break
        //            case SSDKResponseState.Fail:
        //                ProgressHUD.showError("分享失败")
        //                break
        //            case SSDKResponseState.Cancel:
        //                ProgressHUD.showError("已取消分享")
        //                break
        //            default:
        //                break
        //            }
        //        }
        
        ShareSDK.showShareActionSheet(self.view, items: [22], shareParams: shareParams) { (state, platForm, userdata, contentEntity, error, success) -> Void in
            
            switch state{
            case SSDKResponseState.Success:
                ProgressHUD.showSuccess("分享成功")
                break
            case SSDKResponseState.Fail:
                ProgressHUD.showError("分享失败")
                break
            case SSDKResponseState.Cancel:
                ProgressHUD.showError("已取消分享")
                break
            default:
                break
            }
            
        }
    }
    
    // MARK: - 键盘的代理方法
    func keyboardWillHide(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.layView?.alpha = 0
            self.input?.bottom = SCREEN_HEIGHT+(self.input?.height)!
            }) { (finish) -> Void in
                self.layView?.hidden = true
        }
    }
    
    func keyboardWillShow(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        self.keyBoardHeight = keyboardHeight
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.input?.bottom = SCREEN_HEIGHT - keyboardHeight
            self.layView?.alpha = 0.2
            }) { (finish) -> Void in
                
        }
    }
    
    func textViewHeightDidChange(height: CGFloat) {
        self.input?.height = height + 10
        self.input?.bottom = SCREEN_HEIGHT - self.keyBoardHeight
    }
    
    /**
     InputViewDelegate
     */
    func publishButtonDidClick(button: UIButton!) {
        ProgressHUD.show("")

        let object = AVObject(className: "discuss")
        object.setObject(self.input?.inputTextView?.text, forKey: "text")
        object.setObject(AVUser.currentUser(), forKey: "user")
        object.setObject(self.book, forKey: "BookObject")
        object.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.input?.inputTextView?.resignFirstResponder()
                ProgressHUD.showSuccess("评论成功")
                
                self.book?.incrementKey("discussNumber")
                self.book?.saveInBackground()
            } else {
                
            }
        }
    }
    
    // MARK: - HZPhotoBrowser
    func photoBrowser() {
        let photoBrower = HZPhotoBrowser()
        photoBrower.imageCount = 1
        photoBrower.currentImageIndex = 0
        photoBrower.delegate = self
        photoBrower.show()
    }
    
    func photoBrowser(browser: HZPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
        let coverFile = self.book!["cover"] as? AVFile
        return NSURL(string: (coverFile?.url)!)
    }
    
    func photoBrowser(browser: HZPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
        return self.bookTitleView?.cover?.image
    }
    
}
