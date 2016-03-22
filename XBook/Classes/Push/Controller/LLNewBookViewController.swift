//
//  LLNewBookViewController.swift
//  XBook
//
//  Created by LiLe on 16/1/3.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

class LLNewBookViewController: UIViewController, BookTitleViewDelegate, PhotoPickerDelegate, VPImageCropperDelegate, UITableViewDelegate, UITableViewDataSource {

    var bookTitleView:LLBookTitleView?
    var tableView:UITableView?
    var titleArray:Array<String> = []
    var bookTitle = ""
    var score:LDXScore?
    /**
     是否显示星星
     */
    var showScore = false
    
    var type = "文学"
    var detailType = "文学"
    var bookDescription = ""
    
    // 编辑
    var book:AVObject?
    var fixType:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        self.bookTitleView = LLBookTitleView(frame: CGRectMake(0, 40, SCREEN_WIDTH, 160))
        self.bookTitleView?.delegate = self
        self.view.addSubview(self.bookTitleView!)
        
        self.tableView = UITableView(frame: CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT - 200), style: .Grouped)
        /**
        使没有内容的线条消失
        */
        self.tableView?.tableFooterView = UIView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        // 注册一个cell
        self.tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.backgroundColor = UIColor(colorLiteralRed: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        self.view.addSubview(self.tableView!)
        
        self.titleArray = ["标题", "评分", "分类", "书评"]
        
        self.score = LDXScore(frame: CGRectMake(100, 10, 100, 22))
        self.score?.isSelect = true // true：可以编辑（可以选择星星）
        self.score?.normalImg = UIImage(named: "btn_star_evaluation_normal")
        self.score?.highlightImg = UIImage(named: "btn_star_evaluation_press")
        self.score?.max_star = 5
        self.score?.show_star = 5
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pushBookNotification:"), name: "pushBookNotification", object: nil)
    }
    
    func fixBook() {
        if self.fixType == "fix" {
            self.bookTitleView?.BookName?.text = self.book!["BookName"] as? String
            self.bookTitleView?.BookEditor?.text = self.book!["BookEditor"] as? String
            let coverFile = self.book!["cover"] as? AVFile
            coverFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                self.bookTitleView?.BookCover?.setImage(UIImage(data: data), forState: .Normal)
            })
            
            self.bookTitle = (self.book!["title"] as? String)!
            self.type = (self.book!["type"] as? String)!
            self.detailType = (self.book!["detaileType"] as? String)!
            self.bookDescription = (self.book!["description"] as? String)!
            self.score?.show_star = (Int)((self.book!["score"] as? String)!)!
            if self.bookDescription != "" {
                self.titleArray.append("")
            }
        }
    }

    /**
     选择封面
     */
    func choiceCover() {
        let photoPickerVc = LLPhotoPickerViewController()
        photoPickerVc.delegate = self
        self.presentViewController(photoPickerVc, animated: true) { () -> Void in
            
        }
    }
    

    // MARK: - 调用相册或相机
    /**
     实现相机中的代理方法
     
     - parameter image: 回调的照片
     */
    func getImageFromPicker(image: UIImage) {
        
        let croVC = VPImageCropperViewController(image: image, cropFrame: CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT*1.273), limitScaleRatio: 3)
        croVC.delegate = self
        self.presentViewController(croVC, animated: true) { () -> Void in
            
        }
    }
    
    func imageCropper(cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        self.bookTitleView?.BookCover?.setImage(editedImage, forState: .Normal)
        cropperViewController.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func imageCropperDidCancel(cropperViewController: VPImageCropperViewController!) {
        cropperViewController.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func close() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func sure() {
        let dict = [
            "BookName":(self.bookTitleView?.BookName?.text)!,
            "BookEditor":(self.bookTitleView?.BookEditor?.text)!,
            "BookCover":(self.bookTitleView?.BookCover?.currentImage)!,
            "title":self.bookTitle,
            "score":String((self.score?.show_score)!),
            "type":self.type,
            "detailType":self.detailType,
            "description":self.bookDescription
        ]
        ProgressHUD.show("")
        if self.fixType == "fix" {
            LLPushBook.pushBookInBack(dict, object: self.book!)

        } else {
             let object = AVObject(className: "Book")
            LLPushBook.pushBookInBack(dict, object: object)
        }
    }
    
    
    
    /**
     pushBookNotification
     */
    func pushBookNotification(notification:NSNotification){
        let dict = notification.userInfo
        if String(dict!["success"]!) == "true"{
            if self.fixType == "fix" {
                ProgressHUD.showSuccess("修改成功")
            } else {
                ProgressHUD.showSuccess("上传成功")
            }
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        }else{
            ProgressHUD.showError("上传失败")
        }
        
    }
    
    // MARK: - UITableViewDelegate && UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        
        // 在重用之前移除cell上的控件
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        // 在除下标为1的其他cell右边加一个小箭头
        if(indexPath.row != 1) {
            cell.accessoryType = .DisclosureIndicator
        }
        cell.textLabel?.text = self.titleArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: MY_FONT, size: 15)
        cell.detailTextLabel?.font = UIFont(name: MY_FONT, size: 13)
        
        var row = indexPath.row

        if self.showScore && row > 1 {
            row--
        }
        
        switch row {
        case 0:
            cell.detailTextLabel?.text = self.bookTitle
            break
        case 2:
            cell.detailTextLabel?.text = self.type + "->" + self.detailType
            break
        case 4:
            cell.accessoryType = .None
            let commentView = UITextView(frame: CGRectMake(4,4,SCREEN_WIDTH-8,80))
            commentView.text = self.bookDescription
            commentView.font = UIFont(name: MY_FONT, size: 14)
            commentView.editable = false
            cell.contentView.addSubview(commentView)
            break
        default:
            break
        }
        // 判断是否需要在第二行添加小星星
        if self.showScore && indexPath.row == 2 {
            cell.contentView.addSubview(self.score!)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if showScore && indexPath.row >= 5 {
            return 88
        }else if !self.showScore && indexPath.row >= 4 {
            return 88
        }else{
            return 44
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 取消点击效果
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        var row = indexPath.row
        if self.showScore && row>1 {
            row -= 1
        }
        switch row {
        case 0:
            self.tableViewSelectTitle()
            break
        case 1:
            self.tableViewSelectScore()
            break
        case 2:
            self.tableViewSelectType()
            break
        case 3:
            self.tableViewSelectDescription()
            break
        default:
            break
        }

    }
    
    /**
    *  选择标题
    */
    func tableViewSelectTitle() {
        let titleVC = LLTitleViewController()
        LLGeneralFactory.addTitleWithTitle(titleVC)
        titleVC.callBack = ({(title:String)->Void in
            self.bookTitle = title
            self.tableView?.reloadData()
        
        })
        self.presentViewController(titleVC, animated: true) { () -> Void in
            
        }
    }
    
    /**
    *  选择评分
    */
    func tableViewSelectScore() {
        self.tableView?.beginUpdates()
        
        let tempIndexPath = [NSIndexPath(forRow: 2, inSection: 0)]
        
        if self.showScore {
            self.titleArray.removeAtIndex(2)
            self.tableView?.deleteRowsAtIndexPaths(tempIndexPath, withRowAnimation: .Right)
            self.showScore = false
        } else {
            self.titleArray.insert("", atIndex: 2)
            self.tableView?.insertRowsAtIndexPaths(tempIndexPath, withRowAnimation: .Left)
            self.showScore = true
        }
        
        self.tableView?.endUpdates()
    }
    
    /**
     选择分类
     */
    func tableViewSelectType() {
        let typeVC = LLTypeViewController()
        LLGeneralFactory.addTitleWithTitle(typeVC)
        let btn1 = typeVC.view.viewWithTag(1234) as? UIButton
        let btn2 = typeVC.view.viewWithTag(1235) as? UIButton
        btn1?.setTitleColor(RGB(38, g: 82, b: 67), forState: .Normal)
        btn2?.setTitleColor(RGB(38, g: 82, b: 67), forState: .Normal)
        typeVC.type = self.type
        typeVC.detailType = self.detailType
        typeVC.callBack = ({(type:String,detailType:String)->Void in
            self.type = type
            self.detailType = detailType
            self.tableView?.reloadData()
        })
        self.presentViewController(typeVC, animated: true) { () -> Void in
            
        }
    }
    
    /**
     选择书评
     */
    func tableViewSelectDescription() {
        let descriptionVC = LLDescriptionViewController()
        LLGeneralFactory.addTitleWithTitle(descriptionVC)
        descriptionVC.textView?.text = self.bookDescription
        descriptionVC.callBack = ({(description:String)->Void in
            self.bookDescription = description
            if self.titleArray.last == "" {
                self.titleArray.removeLast()
            }
            if description != "" {
                self.titleArray.append("")
            }
            self.tableView?.reloadData()
        })
        self.presentViewController(descriptionVC, animated: true) { () -> Void in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
      析构函数中监测是否发生了内存泄漏，移除通知
     */
    deinit {
        print("LLNewBookViewController release")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
