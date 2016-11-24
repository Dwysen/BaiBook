//
//  GeneralFactory.swift
//  BaiBook
//
//  Created by irishsky on 16/2/17.
//  Copyright © 2016年 irishsky. All rights reserved.
//

import UIKit

enum XIncrement{
case like,dislike,comment,scan
}
class GeneralFactory: NSObject {
    
    static func addTitleWithTitle(target:UIViewController,title1:String="关闭",title2:String="确认"){
    let btn1 = UIButton(frame: CGRect(x: 10, y: 20, width: 40, height: 20))
        btn1.setTitle(title1, forState: .Normal)
        btn1.tag = 123
        btn1.contentHorizontalAlignment = .Left
        btn1.setTitleColor(MAIN_RED, forState: .Normal)
        btn1.titleLabel?.font = UIFont(name: MY_FONT, size: 14)
        target.view.addSubview(btn1)
    
        let btn2 = UIButton(frame: CGRect(x: SCREEN_WIDTH - 50, y: 20, width: 40, height: 20))
        btn2.setTitle(title2, forState: .Normal)
        btn2.tag = 456
        btn2.contentHorizontalAlignment = .Right
        btn2.setTitleColor(MAIN_RED, forState: .Normal)
        btn2.titleLabel?.font = UIFont(name: MY_FONT, size: 14)
        target.view.addSubview(btn2)
        
        btn1.addTarget(target, action: "close", forControlEvents: .TouchUpInside)
        btn2.addTarget(target, action: "sure", forControlEvents: .TouchUpInside)
    }
 
    static func addIncrementKey(BookObject:AVObject,type:XIncrement){
        switch type{
        case .like:
                BookObject.incrementKey("likeNumber", byAmount: 1)
            break
        case .dislike:
               BookObject.incrementKey("likeNumber", byAmount: -1)
             break
        case .comment:
            BookObject.incrementKey("commentNumber", byAmount: 1)
            break
        default:
               BookObject.incrementKey("scanNumber", byAmount: 1)
            break
        }
            BookObject.saveInBackground()
    }
    
}
