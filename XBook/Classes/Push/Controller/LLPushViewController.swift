//
//  LLPushViewController.swift
//  XBook
//
//  Created by LiLe on 16/1/3.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

class LLPushViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate {

    var dataArray = NSMutableArray()
    var navigationView:UIView!
    var tableView:UITableView?
    
    var swipIndexPath:NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        self.setNavigationBar()
        
        self.tableView = UITableView(frame: self.view.frame)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        self.tableView?.registerClass(LLPushBookCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.tableFooterView = UIView()
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("headRefresh"))
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: Selector("footRefresh"))
        
        self.tableView?.mj_header.beginRefreshing()
    }

    /**
     下拉刷新
     */
    func headRefresh() {
        let query = AVQuery(className: "Book")
        query.orderByDescending("createAt")
        query.limit = 20
        query.skip = self.dataArray.count
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_header.endRefreshing()
            
            self.dataArray.removeAllObjects()
            self.dataArray.addObjectsFromArray(results)
            self.tableView?.reloadData()
        }
    }
    
    /**
     上拉加载
     */
    func footRefresh() {
        let query = AVQuery(className: "Book")
        query.orderByDescending("createAt")
        query.limit = 20
        query.skip = self.dataArray.count
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_footer.endRefreshing()
            
            self.dataArray.addObjectsFromArray(results)
            self.tableView?.reloadData()
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationView.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationView.hidden = true
    }
    
    func setNavigationBar() {
        navigationView = UIView(frame: CGRectMake(0, -20, SCREEN_WIDTH, 65))
        navigationView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.addSubview(navigationView)
        
        let addBookBtn = UIButton(frame: CGRectMake(20, 20, SCREEN_WIDTH, 45))
        addBookBtn.setImage(UIImage(named: "plus circle"), forState: .Normal)
        addBookBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        addBookBtn.setTitle("   新建书评", forState: .Normal)
        addBookBtn.titleLabel?.font = UIFont(name: MY_FONT, size: 15)
        addBookBtn.contentHorizontalAlignment = .Left // 按钮文字居左
        addBookBtn.addTarget(self, action: Selector("pushNewBook"), forControlEvents: .TouchUpInside)
        navigationView.addSubview(addBookBtn)
    }
    
    func pushNewBook() {
        let newBookVc = LLNewBookViewController()
        LLGeneralFactory.addTitleWithTitle(newBookVc, title1: "关闭", title2: "发布")
        self.presentViewController(newBookVc, animated: true) { () -> Void in
            
        }
    }
    
    // MARK: - UITableViewDataSource and UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? LLPushBookCell
        
        cell?.rightUtilityButtons = self.returnRightBtn() as! [AnyObject]
        cell?.delegate = self
        
        let dict = self.dataArray[indexPath.row] as? AVObject
        
        cell?.bookName?.text = "{"+(dict!["BookName"] as! String)+"):"+(dict!["title"] as! String)
        cell?.editor?.text = "作者:"+(dict!["BookEditor"] as! String)
        
        let date = dict!["createdAt"] as? NSDate
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm"
        cell?.more?.text = format.stringFromDate(date!)
        
        let coverFile = dict!["cover"] as? AVFile
        cell?.cover?.sd_setImageWithURL(NSURL(string: (coverFile?.url)!), placeholderImage: UIImage(named: "Cover"))
        
        return cell!
    }
    
    func returnRightBtn() -> (AnyObject) {
        let btn1 = UIButton(frame: CGRectMake(0,0,88,88))
        btn1.backgroundColor = UIColor.orangeColor()
        btn1.setTitle("编辑", forState: .Normal)
        
        let btn2 = UIButton(frame: CGRectMake(0,0,88,88))
        btn2.backgroundColor = UIColor.redColor()
        btn2.setTitle("删除", forState: .Normal)
        
        return [btn1, btn2]
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, scrollingToState state: SWCellState) {
        let indexPath = self.tableView?.indexPathForCell(cell)
        if state == .CellStateRight {
            if self.swipIndexPath != nil && self.swipIndexPath?.row != indexPath?.row {
                let swipedCell = self.tableView?.cellForRowAtIndexPath(self.swipIndexPath!) as? LLPushBookCell
                swipedCell?.hideUtilityButtonsAnimated(true)
            }
            self.swipIndexPath = indexPath
        } else if state == .CellStateCenter {
            self.swipIndexPath = nil
        }            
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        
        cell.hideUtilityButtonsAnimated(true)
        let indexPath = self.tableView?.indexPathForCell(cell)
        
        let object = self.dataArray[indexPath!.row] as? AVObject
        
        if index == 0 { // 编辑
            let vc = LLNewBookViewController()
            LLGeneralFactory.addTitleWithTitle(vc, title1: "关闭", title2: "发布")
            
            vc.fixType = "fix"
            vc.book = object
            vc.fixBook()
            self.presentViewController(vc, animated: true, completion: { () -> Void in
                
            })
        } else { // 删除
            ProgressHUD.show("")
            
            let discussQuery = AVQuery(className: "discuss")
            discussQuery.whereKey("BookObject", equalTo: object)
            discussQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                for book in results {
                    let book = book as? AVObject
                    book?.deleteInBackground()
                }
            })
            
            let loveQuery = AVQuery(className: "discuss")
            loveQuery.whereKey("BookObject", equalTo: object)
            loveQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                for book in results {
                    let book = book as? AVObject
                    book?.deleteInBackground()
                }
            })
            
            object?.deleteInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    ProgressHUD.showSuccess("删除成功")
                    self.dataArray.removeObjectAtIndex((indexPath?.row)!)
                    self.tableView?.reloadData()
                } else {
                    
                }
            })

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        
        let bookDetailVc = LLBookDetailViewController()
        bookDetailVc.book = self.dataArray[indexPath.row] as? AVObject
        // push到详情页时隐藏下边的tabbar
        bookDetailVc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(bookDetailVc, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}
