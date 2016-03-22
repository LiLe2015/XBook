//
//  LLPhotoPickerViewController.swift
//  XBook
//
//  Created by LiLe on 16/1/4.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

protocol PhotoPickerDelegate {
    func getImageFromPicker(image:UIImage)
}

class LLPhotoPickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var alert:UIAlertController?
    var picker:UIImagePickerController!
    var delegate:PhotoPickerDelegate!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // modal出来时，背景是透明的
        self.modalPresentationStyle = .OverFullScreen
        self.view.backgroundColor = UIColor.clearColor()
        
        self.picker = UIImagePickerController()
        // 如果为true，选择完图片会截一个正方形的图；所以选择false，我们自己截图
        self.picker.allowsEditing = false
        self.picker.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not implemeted")
    }
    
    override func viewDidAppear(animated: Bool) {
        if(self.alert == nil) {
            self.alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            self.alert?.addAction(UIAlertAction(title: "从相册选择", style: .Default, handler: { (action) -> Void in
                self.localPhoto()
            }))
            self.alert?.addAction(UIAlertAction(title: "打开相机", style: .Default, handler: { (action) -> Void in
                self.takePhoto()
            }))
            self.alert?.addAction(UIAlertAction(title: "取消", style: .Default, handler: { (action) -> Void in
                
            }))
            self.presentViewController(self.alert!, animated: true, completion: { () -> Void in
                
            })
        }
    }
    
    /**
     打开相机
     */
    func takePhoto() {
        if(UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            self.picker.sourceType = .Camera
            self.presentViewController(self.picker, animated: true, completion: { () -> Void in
                
            })
        } else {
            let alertView = UIAlertController(title: "此机型无相机", message: nil, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "关闭", style: .Cancel, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }))
            self.presentViewController(alertView, animated: true, completion: { () -> Void in
                
            })
        }
    }
    
    /**
     获取本地相册
     */
    func localPhoto() {
        self.picker.sourceType = .PhotoLibrary
        self.presentViewController(self.picker, animated: true) { () -> Void in
            
        }
    }
    
    /**
     回调方法
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.picker.dismissViewControllerAnimated(true) { () -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.delegate.getImageFromPicker(image)
            })
        }
    }
    
}
