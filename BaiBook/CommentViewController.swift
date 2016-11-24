//
//  CommentViewController.swift
//  BaiBook
//
//  Created by irishsky on 16/4/1.
//  Copyright © 2016年 irishsky. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,InputViewDelegate{

    var tableView:UITableView?
    
    var dataArray = NSMutableArray()
    
    var BookObject:AVObject?
    
    var input:InputView?
    
    var layView:UIView?
    var keyBoardHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        let btn = self.view.viewWithTag(123)
        btn?.hidden = true
        
        let titleLabel = UILabel(frame: CGRectMake(0,20,SCREEN_WIDTH,44))
        titleLabel.text = "讨论区"
        titleLabel.font = UIFont(name: MY_FONT, size: 17)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = MAIN_RED
        self.view.addSubview(titleLabel)
        
        self.tableView = UITableView(frame: CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEIGHT - 64 - 44))
        self.tableView?.registerClass(discussCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.view.addSubview(self.tableView!)
        
        self.tableView?.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
        self.tableView?.footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: "footerRefresh")
        
        self.input = NSBundle.mainBundle().loadNibNamed("InputView", owner: self, options: nil).last as? InputView
        self.input?.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 44, width: SCREEN_WIDTH, height: 44)
        self.input?.delegate = self
        self.view.addSubview(self.input!)
        
        self.layView = UIView(frame: self.view.frame)
        self.layView?.backgroundColor = UIColor.grayColor()
        self.layView?.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: "tapLayView")
        self.layView?.addGestureRecognizer(tap)
        self.view.insertSubview(self.layView!, belowSubview: self.input!)
    }
    
    func tapLayView(){
        self.input?.inputTextView?.resignFirstResponder()
    }
    func textViewHeightDidChange(height: CGFloat) {
        self.input?.height = height + 10
        self.input?.bottom = SCREEN_HEIGHT - self.keyBoardHeight
    }

    
    func publishButtonDidClick(button: UIButton!) {
        let object = AVObject(className: "comment")
        object.setObject(self.input?.inputTextView?.text, forKey: "text")
        object.setObject(AVUser.currentUser(), forKey: "user")
        object.setObject(BookObject, forKey: "BookObject")
        object.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.input?.inputTextView?.resignFirstResponder()
                ProgressHUD.showSuccess("评论成功")
                //评论数+1
                self.BookObject?.incrementKey("commentNumber")
                self.BookObject?.saveInBackground()
                
            } else {
                
            }
            
        }

    }
    
    func keyboardWillHide(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.layView?.alpha = 0
            self.input?.bottom = SCREEN_HEIGHT
            }) { (finish) -> Void in
                self.layView?.hidden = true
                //评论完成后恢复inputView到最初的高度
                self.input?.resetInputView()
                self.input?.inputTextView?.text = ""
                self.input?.bottom = SCREEN_HEIGHT
        }
    }
    func keyboardWillShow(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        self.keyBoardHeight = keyboardHeight
        self.layView?.hidden = false
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            self.layView?.alpha = 0.2
            self.input?.bottom = SCREEN_HEIGHT - self.keyBoardHeight
            }) { (finish) -> Void in
                
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func sure(){
    self.dismissViewControllerAnimated(true) { () -> Void in
        
        }
    }
    
    func headerRefresh(){
        let query = AVQuery(className: "comment")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.skip = 0
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: self.BookObject)
        query.includeKey("user")
        query.includeKey("BookObject")
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.header.endRefreshing()
            self.dataArray.removeAllObjects()
            self.dataArray.addObjectsFromArray(results)
            self.tableView?.reloadData()
        }
        
    
    }
    func footerRefresh(){
        let query = AVQuery(className: "comment")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.skip = self.dataArray.count
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: self.BookObject)
        query.includeKey("user")
        query.includeKey("BookObject")
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.footer.endRefreshing()

            self.dataArray.addObjectsFromArray(results)
            self.tableView?.reloadData()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? discussCell
        //在计算cell的高度后cell.initFrame
        cell?.initFrame()
        
        let object = self.dataArray[indexPath.row] as? AVObject
        
        let user = object!["user"] as? AVUser
        
        cell?.nameLabel?.text = user?.username
        
        cell?.avatarImage?.image = UIImage(named: "Avatar")
        
        let date = object!["createdAt"] as? NSDate
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm"
        cell?.dateLabel?.text = format.stringFromDate(date!)
        cell?.detailLabel?.text = object!["text"] as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let object = self.dataArray[indexPath.row] as? AVObject
        let text = object!["text"] as? NSString
        let textSize = text?.boundingRectWithSize(CGSize(width: SCREEN_WIDTH - 56 - 8, height: 0), options: .UsesLineFragmentOrigin , attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil).size
        
        return (textSize?.height)! + 30 + 25
    }
    
    

}
