//
//  Push_DiscriptionViewController.swift
//  BaiBook
//
//  Created by irishsky on 16/3/14.
//  Copyright © 2016年 irishsky. All rights reserved.
//

import UIKit
typealias Push_DiscriptionCallBack = (description:String) -> Void
class Push_DiscriptionViewController: UIViewController {
    
    var callBack:Push_DiscriptionCallBack?
    var txtView:JVFloatLabeledTextView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        txtView = JVFloatLabeledTextView(frame: CGRect(x: 8, y: 60, width: SCREEN_WIDTH - 16, height: SCREEN_HEIGHT - 68))
        txtView?.placeholder = "请输入书籍描述"
        txtView?.textColor = UIColor.grayColor()
        self.view.addSubview(txtView!)
        
      XKeyBoard.registerKeyBoardShow(self)
      XKeyBoard.registerKeyBoardHide(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close(){self.dismissViewControllerAnimated(true) { () -> Void in
        
        }}
    
    func sure(){
        self.callBack!(description:(self.txtView?.text)!)
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
   
    func keyboardWillShowNotification(notification:NSNotification){
     let rect = XKeyBoard.returnKeyBoardWindow(notification)
     self.txtView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: rect.size.height, right: 0)
    }
    func keyboardWillHideNotification(notification:NSNotification){

        self.txtView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    
}
