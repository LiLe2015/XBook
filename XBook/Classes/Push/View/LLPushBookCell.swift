//
//  LLPushBookCell.swift
//  XBook
//
//  Created by LiLe on 16/2/23.
//  Copyright © 2016年 LiLe. All rights reserved.
//

import UIKit

class LLPushBookCell: SWTableViewCell {

    var bookName: UILabel?
    var editor: UILabel?
    var more: UILabel?
    var cover: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        self.bookName = UILabel(frame: CGRectMake(78,8,242,25))
        self.bookName?.font = UIFont(name: MY_FONT, size: 15)
        self.contentView.addSubview(self.bookName!)
        
        self.editor = UILabel(frame: CGRectMake(78,33,242,25))
        self.editor?.font = UIFont(name: MY_FONT, size: 15)
        self.contentView.addSubview(self.editor!)

        self.more = UILabel(frame: CGRectMake(78,66,242,25))
        self.more?.font = UIFont(name: MY_FONT, size: 13)
        self.more?.textColor = UIColor.grayColor()
        self.contentView.addSubview(self.more!)
        
        self.cover = UIImageView(frame: CGRectMake(8, 9, 56, 70))
        self.contentView.addSubview(self.cover!)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
