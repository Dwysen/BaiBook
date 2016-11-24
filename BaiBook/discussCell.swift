//
//  discussCell.swift
//  BaiBook
//
//  Created by Dwysen on 16/4/1.
//  Copyright © 2016年 Dwysen. All rights reserved.
//

import UIKit

class discussCell: UITableViewCell {

    var avatarImage:UIImageView?
    
    var nameLabel:UILabel?
    
    var detailLabel:UILabel?
    
    var dateLabel:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }


    
    required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
   
    
    func initFrame(){
        for view in self.contentView.subviews{
        view.removeFromSuperview()
        }
        
        self.avatarImage = UIImageView(frame: CGRectMake(8,8,40,40))
        self.avatarImage?.layer.cornerRadius = 20
        self.avatarImage?.layer.masksToBounds = true
        self.contentView.addSubview(self.avatarImage!)
        
        self.nameLabel = UILabel(frame: CGRectMake(56,8,SCREEN_WIDTH-56-8,15))
        self.nameLabel?.font = UIFont(name: MY_FONT, size: 13)
        self.contentView.addSubview(self.nameLabel!)
        
        
        self.dateLabel = UILabel(frame: CGRectMake(56,self.frame.size.height-8-10,SCREEN_WIDTH-56-8,10))
        self.dateLabel?.font = UIFont(name: MY_FONT, size: 13)
        self.dateLabel?.textColor = UIColor.grayColor()
        self.contentView.addSubview(self.dateLabel!)
        
        self.detailLabel = UILabel(frame: CGRectMake(56,30,SCREEN_WIDTH-56-8,self.frame.size.height - 30 - 25))
        self.detailLabel?.font = UIFont(name: MY_FONT, size: 15)
        self.detailLabel?.numberOfLines = 0
        self.contentView.addSubview(self.detailLabel!)
    }

}
