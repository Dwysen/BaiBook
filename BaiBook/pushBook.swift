//
//  pushBook.swift
//  BaiBook
//
//  Created by irishsky on 16/3/22.
//  Copyright © 2016年 irishsky. All rights reserved.
//

import UIKit

class pushBook: NSObject {
    static func pushBook(dict:NSDictionary,object:AVObject){

        

        object.setObject(dict["bookName"], forKey: "bookName")
        object.setObject(dict["bookEditor"], forKey: "bookEditor")
        object.setObject(dict["detailType"], forKey: "detailType")
        object.setObject(dict["bookTitle"], forKey: "bookTitle")
        object.setObject(dict["bookScore"], forKey: "bookScore")
        object.setObject(dict["type"], forKey: "type")
        object.setObject(dict["description"], forKey: "description")
        object.setObject(AVUser.currentUser(), forKey: "user")
        
        let img = dict["bookCover"] as! UIImage
        let coverFile = AVFile(data: UIImagePNGRepresentation(img))
        coverFile.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
            object.setObject(coverFile, forKey: "cover")
            object.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    NSNotificationCenter.defaultCenter().postNotificationName("pushBookNotifiction", object: nil, userInfo: ["success":"true"])
                  
                } else {
                           NSNotificationCenter.defaultCenter().postNotificationName("pushBookNotifiction", object: nil, userInfo: ["success":"false"])
                }
                
            })
            } else {
                       NSNotificationCenter.defaultCenter().postNotificationName("pushBookNotifiction", object: nil, userInfo: ["success":"false"])
            
            }
        }

        
        
        
    
    
    }
}
