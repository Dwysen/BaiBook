//
//  rankViewController.swift
//  BaiBook
//
//  Created by Dwysen on 16/2/16.
//  Copyright © 2016年 Dwysen. All rights reserved.
//

import UIKit

class rankViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
       
//        AVUser.logOut()
        
        if AVUser.currentUser() == nil {
 
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = sb.instantiateViewControllerWithIdentifier("Login")
        self.presentViewController(loginVC, animated: true, completion: { () -> Void in
            
        })
        
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
