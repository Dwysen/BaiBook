//
//  RegisterViewController.swift
//  BaiBook
//
//  Created by irishsky on 16/3/18.
//  Copyright © 2016年 irishsky. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    @IBOutlet weak var topLayOut: NSLayoutConstraint!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBAction func Register(sender: UIButton) {
        let user = AVUser()
        user.username = self.userName.text
        user.password = self.passWord.text
        user.email = self.Email.text
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            if success {
                ProgressHUD.showSuccess("注册成功，请验证邮箱")
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
            })
            }
            else{
                if error.code == 125 {
                    ProgressHUD.showError("邮箱不合法")
                }else if error.code == 203 {
                    ProgressHUD.showError("该邮箱已注册")
                }else if error.code == 202 {
                    ProgressHUD.showError("用户名已存在")
                }else{
                    ProgressHUD.showError("注册失败")
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
            self.topLayOut.constant = -200
            self.view.layoutIfNeeded()
        }
    }
    func keyboardWillHideNotification(notification:NSNotification){
        UIView.animateWithDuration(0.3) { () -> Void in
            self.topLayOut.constant = 8
            self.view.layoutIfNeeded()
        }
        
    }
}
