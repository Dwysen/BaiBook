//
//  Push_titleController.swift
//  BaiBook
//
//  Created by Dwysen on 16/3/14.
//  Copyright © 2016年 Dwysen. All rights reserved.
//

import UIKit

// 更改标题的闭包
typealias Push_TitleCallBack = (title:String) -> Void


class Push_titleViewController: UIViewController {
    var callBack : Push_TitleCallBack?
      var textfd : UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        textfd = UITextField(frame: CGRect(x: 15, y: 60, width: SCREEN_WIDTH - 30, height: 30))
        textfd?.placeholder = "书评标题"
        textfd?.borderStyle = .RoundedRect
        textfd?.font = UIFont(name: MY_FONT, size: 15)
        self.view.addSubview(textfd!)
        textfd?.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close(){self.dismissViewControllerAnimated(true) { () -> Void in
        
        }}
    
    func sure(){
    self.callBack?(title: (self.textfd?.text)!)
    self.dismissViewControllerAnimated(true) { () -> Void in
        
        }
    }



}
