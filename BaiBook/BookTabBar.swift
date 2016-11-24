//
//  BookTabBar.swift
//  BaiBook
//
//  Created by irishsky on 16/3/30.
//  Copyright © 2016年 irishsky. All rights reserved.
//

import UIKit

protocol BookTabBarDelegate:class{
 func edit()
 func comment()
func like(sender:UIButton)
 func share()

}
class BookTabBar: UIView {
    
  weak var delegate:BookTabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        let imageName = ["Pen 4","chat 3","heart","box outgoing"]
        for var i=0;i<4; i += 1 {
        let btn = UIButton(frame: CGRect(x: CGFloat(i) * frame.width/4, y: 0, width: frame.width/4, height: 40))
            btn.setImage(UIImage(named: imageName[i]), forState: .Normal)
            btn.tag = i
            btn.addTarget(self, action: "btnClick:", forControlEvents: .TouchUpInside)
            self.addSubview(btn)
            
        }
    }

   

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.5)
        CGContextSetRGBStrokeColor(context, 231/255, 231/255, 231/255, 1)
        for var i=1;i<4;i += 1 {
        CGContextMoveToPoint(context, CGFloat(i) * rect.size.width/4, rect.size.height * 0.1)
        CGContextAddLineToPoint(context, CGFloat(i) * rect.size.width/4, rect.size.height * 0.9)
        }
        CGContextMoveToPoint(context, 8, 0)
        CGContextAddLineToPoint(context, rect.size.width - 8, 0)
        CGContextStrokePath(context)
    }
    
    func btnClick(sender:UIButton){
        switch sender.tag{
        case 0: delegate?.edit()
        case 1: delegate?.comment()
        case 2: delegate?.like(sender)
        default: delegate?.share()
        }
    
    }
    
}
