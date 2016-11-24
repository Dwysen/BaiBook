//
//  LoginViewController.swift
//  BaiBook
//
//  Created by irishsky on 16/3/18.
//  Copyright © 2016年 irishsky. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var topLayout: NSLayoutConstraint!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBAction func login(sender: UIButton) {
        
        AVUser.logInWithUsernameInBackground(self.userName.text, password: self.passWord.text) { (user, error) -> Void in
            if error == nil {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            } else {
                if error.code == 210{
                    ProgressHUD.showError("用户名或密码错误")
                }else if error.code == 211 {
                    ProgressHUD.showError("不存在该用户")
                }else if error.code == 216 {
                    ProgressHUD.showError("未验证邮箱")
                }else if error.code == 1{
                    ProgressHUD.showError("操作频繁")
                }else{
                    ProgressHUD.showError("登录失败")
                }

            
            
            }
         }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        XKeyBoard.registerKeyBoardHide(self)
        XKeyBoard.registerKeyBoardShow(self)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShowNotification(notification:NSNotification){
            UIView.animateWithDuration(0.3) { () -> Void in
                self.topLayout.constant = -200
                
                //挪上去的时候有动画效果，若去掉该行代码则为瞬间效果。
                self.view.layoutIfNeeded()
        }
    }
    func keyboardWillHideNotification(notification:NSNotification){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.topLayout.constant = 8
            self.view.layoutIfNeeded()
        }
     
    }


}
