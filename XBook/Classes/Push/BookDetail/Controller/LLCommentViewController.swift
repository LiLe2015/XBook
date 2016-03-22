//
//  LLCommentViewController.swift
//  XBook
//
//  Created by LiLe on 16/2/28.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

class LLCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, InputViewDelegate {

    var tableView:UITableView?
    
    var dataArray = NSMutableArray()
    
    var book:AVObject?
    
    var input:InputView?
    
    var layView:UIView?
    
    var keyBoardHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let btn = self.view.viewWithTag(1234)
        btn?.hidden = true
        
        let titleLabel = UILabel(frame: CGRectMake(0, 20, SCREEN_WIDTH, 44))
        titleLabel.text = "讨论区"
        titleLabel.font = UIFont(name: MY_FONT, size: 17)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = MAIN_RED
        self.view.addSubview(titleLabel)

        self.tableView = UITableView(frame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44))
        self.tableView?.registerClass(LLDiscussCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.tableFooterView = UIView()
        self.view.addSubview(self.tableView!)
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
        self.tableView?.mj_footer = MJRefreshBackFooter(refreshingTarget: self, refreshingAction: "footerRefresh")
        
        self.input = NSBundle.mainBundle().loadNibNamed("InputView", owner: self, options: nil).last as? InputView
        self.input?.frame = CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)
        self.input?.delegate = self
        self.view.addSubview(self.input!)
        
        self.layView = UIView(frame: self.view.frame)
        self.layView?.backgroundColor = UIColor.grayColor()
        self.layView?.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: Selector("tapLayView"))
        self.layView?.addGestureRecognizer(tap)
        
        self.view.insertSubview(self.layView!, belowSubview: self.input!)
    }

    func sure() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func headerRefresh() {
        let query = AVQuery(className: "discuss")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.skip = 0
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: self.book)
        query.includeKey("user")
        query.includeKey("BookObject")
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_header.endRefreshing()
            
            self.dataArray.removeAllObjects()
            self.dataArray.addObjectsFromArray(results)
            self.tableView?.reloadData()
        }
    }
    
    func footerRefresh() {
        let query = AVQuery(className: "discuss")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.skip = self.dataArray.count
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: self.book)
        query.includeKey("user")
        query.includeKey("BookObject")
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_footer.endRefreshing()
            
            self.dataArray.removeAllObjects()
            self.dataArray.addObjectsFromArray(results)
            self.tableView?.reloadData()
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? LLDiscussCell
        cell?.initFrame()
        
        let object = self.dataArray[indexPath.row] as? AVObject
        let user = object!["user"]
        cell?.nameLabel?.text = user?.username
        cell?.avatarImage?.image = UIImage(named: "Avatar")
        
        let date = object!["createdAt"] as? NSDate
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm"
        cell?.dateLabel?.text = format.stringFromDate(date!)
        cell?.detailLabel?.text = object!["text"] as? String
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let object = self.dataArray[indexPath.row] as? AVObject
        let text = object!["text"] as? NSString
        let textSize = text?.boundingRectWithSize(CGSizeMake(SCREEN_WIDTH-56-8, 0), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil).size
        return (textSize?.height)! + 30 + 25
    }
    
    // MARK: - InputViewDelegate
    func textViewHeightDidChange(height: CGFloat) {
        self.input?.height = height + 10
        self.input?.bottom = SCREEN_HEIGHT - self.keyBoardHeight
    }
    
    func keyboardWillHide(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.layView?.alpha = 0
            self.input?.bottom = SCREEN_HEIGHT
            }) { (finish) -> Void in
                self.layView?.hidden = true
                self.input?.resetInputView()
                self.input?.inputTextView?.text = ""
                self.input?.bottom = SCREEN_HEIGHT
        }
    }
    
    func keyboardWillShow(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        self.keyBoardHeight = keyboardHeight
        self.layView?.alpha = 0
        self.layView?.hidden = false
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.layView?.alpha = 0
            self.input?.bottom = SCREEN_HEIGHT - keyboardHeight
            }) { (finish) -> Void in
            
        }
    }
    
    func publishButtonDidClick(button: UIButton!) {
        let object = AVObject(className: "discuss")
        object.setObject(self.input?.inputTextView?.text, forKey: "text")
        object.setObject(AVUser.currentUser(), forKey: "user")
        object.setObject(self.book, forKey: "book")
        object.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.input?.inputTextView?.resignFirstResponder()
                ProgressHUD.showSuccess("评论成功")
                
                LLGeneralFactory.addIncrementkey(self.book!, type: .discuss)

            } else {
                
            }
        }
    }

}
