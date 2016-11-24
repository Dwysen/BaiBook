//
//  BookDetailView.swift
//  BaiBook
//
//  Created by Dwysen on 16/3/29.
//  Copyright © 2016年 Dwysen. All rights reserved.
//

import UIKit

class BookDetailView: UIView {

    var VIEW_WIDTH:CGFloat!
    var VIEW_HEIGHT:CGFloat!
    
    var BookName:UILabel?
    var Editor:UILabel?
    var userName:UILabel?
    var date:UILabel?
    var more:UILabel?
    var score:LDXScore?
    var cover:UIImageView?

    
    
    
    override init(frame:CGRect){
    super.init(frame: frame)
        self.VIEW_WIDTH = frame.size.width
        self.VIEW_HEIGHT = frame.size.height
        self.backgroundColor = UIColor.whiteColor()
        
        self.cover = UIImageView(frame: CGRectMake(8,8,(VIEW_HEIGHT - 16)/1.273,VIEW_HEIGHT-16))
        self.addSubview(self.cover!)
        
        self.BookName = UILabel(frame: CGRectMake((VIEW_HEIGHT - 16)/1.273+16,8,VIEW_WIDTH - (VIEW_HEIGHT - 16)/1.273 - 16,VIEW_HEIGHT/4))
        self.BookName?.font = UIFont(name: MY_FONT, size: 18)
        self.addSubview(self.BookName!)
        
        self.Editor = UILabel(frame: CGRectMake((VIEW_HEIGHT - 16)/1.273+16,8+VIEW_HEIGHT/4,VIEW_WIDTH - (VIEW_HEIGHT - 16)/1.273 - 16,VIEW_HEIGHT/4))
        self.Editor?.font = UIFont(name: MY_FONT, size: 18)
        self.addSubview(self.Editor!)
        
        
        self.userName = UILabel(frame: CGRectMake((VIEW_HEIGHT - 16)/1.273+16,24+VIEW_HEIGHT/4+VIEW_HEIGHT/6,VIEW_WIDTH - (VIEW_HEIGHT - 16)/1.273 - 16,VIEW_HEIGHT/6))
        self.userName?.font = UIFont(name: MY_FONT, size: 13)
        self.userName?.textColor = RGB(35, green: 87, blue: 139)
        self.addSubview(self.userName!)
        
        self.date = UILabel(frame: CGRectMake((VIEW_HEIGHT - 16)/1.273+16,16+VIEW_HEIGHT/4+VIEW_HEIGHT/6*2,80,VIEW_HEIGHT/6))
        self.date?.font = UIFont(name: MY_FONT, size: 13)
        self.date?.textColor = UIColor.grayColor()
        self.addSubview(self.date!)
        
        self.score = LDXScore(frame: CGRectMake((VIEW_HEIGHT - 16)/1.273+16+80,16+VIEW_HEIGHT/4+VIEW_HEIGHT/6*2,80,VIEW_HEIGHT/6))
        self.score?.isSelect = false
        self.score?.normalImg = UIImage(named: "btn_star_evaluation_normal")
        self.score?.highlightImg = UIImage(named: "btn_star_evaluation_press")
        self.score?.max_star = 5
        self.score?.show_star = 5
        self.addSubview(self.score!)
        
        self.more = UILabel(frame: CGRectMake((VIEW_HEIGHT - 16)/1.273+16,8+VIEW_HEIGHT/4+VIEW_HEIGHT/6*3,VIEW_WIDTH - (VIEW_HEIGHT - 16)/1.273 - 16,VIEW_HEIGHT/6))
        self.more?.textColor = UIColor.grayColor()
        self.more?.font = UIFont(name: MY_FONT, size: 13)
        self.addSubview(self.more!)
        

        
    
    }

 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //在View底部添加一条线
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.5)
        CGContextSetRGBStrokeColor(context, 231/255, 231/255, 231/255, 1)
        
        CGContextMoveToPoint(context, 8, VIEW_HEIGHT - 2)
        CGContextAddLineToPoint(context, VIEW_WIDTH - 8, VIEW_HEIGHT - 2)
        CGContextStrokePath(context)
    }

}
