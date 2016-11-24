//
//  BookDetailViewController.swift
//  BaiBook
//
//  Created by irishsky on 16/3/29.
//  Copyright © 2016年 irishsky. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController,BookTabBarDelegate,InputViewDelegate,HZPhotoBrowserDelegate{
   
    var BookObject:AVObject?
    var BookTitleView:BookDetailView?
    var BookViewTabBar:BookTabBar?
    var BookDescrptionView:UITextView?
    var input:InputView?
    var keyBoardHeight:CGFloat = 0.0
    //用于隐藏键盘的LayView
    var layView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        //把Back移到自身位置上方60的地方。
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -60), forBarMetrics: .Default)
        initBookDetailView()
        
        //查询是否已经点赞
        isLike()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initBookDetailView(){
        self.BookTitleView = BookDetailView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT/4))
        self.view.addSubview(self.BookTitleView!)
        let coverFile = self.BookObject!["cover"] as? AVFile
        self.BookTitleView?.cover?.sd_setImageWithURL(NSURL(string: (coverFile?.url)!), placeholderImage: UIImage(named: "CD"))
        self.BookTitleView?.BookName?.text = "<" + (self.BookObject!["bookName"] as! String) + ">"
        self.BookTitleView?.Editor?.text = "作者：" + (self.BookObject!["bookEditor"] as! String)
        
        let user = self.BookObject!["user"] as? AVUser
        user?.fetchInBackgroundWithBlock({ (returnUser, error) -> Void in
            self.BookTitleView?.userName?.text = "编者" + (returnUser as! AVUser).username
        })
        
        let date = self.BookObject!["createdAt"] as? NSDate
        let formate = NSDateFormatter()
        formate.dateFormat = "yy-MM-dd"
        self.BookTitleView?.date?.text = formate.stringFromDate(date!)
        
        let scoreString = self.BookObject!["bookScore"] as? String
        self.BookTitleView?.score?.show_star = Int(scoreString!)!
        
        let scanNumber = self.BookObject!["scanNumber"] as? NSNumber
        let likeNumber = self.BookObject!["likeNumber"] as? NSNumber
        let commentNumber = self.BookObject!["commentNumber"] as? NSNumber
        
        self.BookTitleView?.more?.text = "\(likeNumber!)个喜欢，\(scanNumber!)次浏览，\(commentNumber!)次评论"
        
        BookViewTabBar = BookTabBar(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 40, width: SCREEN_WIDTH, height: 40))
        BookViewTabBar?.delegate = self
        self.view.addSubview(BookViewTabBar!)
        
        BookDescrptionView = UITextView(frame: CGRect(x: 0, y: 64 + SCREEN_HEIGHT/4, width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 3/4 - 64 - 40))
        BookDescrptionView?.text = BookObject!["description"] as? String
        BookDescrptionView?.editable = false
        self.view.addSubview(BookDescrptionView!)
        
        let tap = UITapGestureRecognizer(target: self, action: "photoBrowser")
        self.BookTitleView?.cover?.addGestureRecognizer(tap)
        self.BookTitleView?.cover?.userInteractionEnabled = true
        
        //浏览量+1

        GeneralFactory.addIncrementKey(self.BookObject!, type: .scan)
        //更新LeanCloud后台
        self.BookObject?.saveInBackground()
        
        
    }
    
    func photoBrowser(){
        
        let photoBrowser =  HZPhotoBrowser()
        //显示图片的个数
        photoBrowser.imageCount = 1
        //当前预览第几张
        photoBrowser.currentImageIndex = 0
        photoBrowser.delegate = self
        photoBrowser.show()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.input != nil {
        NSNotificationCenter.defaultCenter().removeObserver(self.input!, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.input!, selector: "keyboardWillShowNotification", name: UIKeyboardWillShowNotification, object: nil)
        
            }
    }
    override func viewWillDisappear(animated: Bool) {
            if self.input != nil {
        NSNotificationCenter.defaultCenter().removeObserver(self.input!, name: UIKeyboardWillShowNotification, object: nil)
        }
    }
    
    deinit {
    print("BookDetailViewController release", terminator: "")
    NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    func photoBrowser(browser: HZPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
        return self.BookTitleView?.cover?.image
    }
    func photoBrowser(browser: HZPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
        let coverFile = self.BookObject!["cover"] as? AVFile
        return NSURL(string: (coverFile?.url)!)
    }
    
    func isLike(){
    let query = AVQuery(className: "Like")
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: self.BookObject)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results != nil && results.count != 0 {
            let btn = self.BookViewTabBar?.viewWithTag(2) as? UIButton
                btn?.setImage(UIImage(named: "solidheart"), forState: .Normal)
            }
        }
    }
    
    func edit(){
        if self.input == nil {
            self.input = NSBundle.mainBundle().loadNibNamed("InputView", owner: self, options: nil).last as? InputView
            self.input?.frame = CGRect(x: 0, y: SCREEN_HEIGHT-44, width: SCREEN_WIDTH, height: 44)
            self.input?.delegate = self
            self.view.addSubview(input!)
        }
        
        
        if layView == nil{
            self.layView = UIView(frame: self.view.frame)
            layView?.backgroundColor = UIColor.grayColor()
            layView?.alpha = 0
            let tap = UITapGestureRecognizer(target: self, action: "tapLayView")
            layView?.addGestureRecognizer(tap)
            
        }
        self.view.insertSubview(layView!, belowSubview: input!)
        self.layView?.hidden = false
        self.input?.inputTextView?.becomeFirstResponder()
        

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
            
            GeneralFactory.addIncrementKey(self.BookObject!, type: .comment)
      
            } else {
            
            }
            
        }
    }
    
    func textViewHeightDidChange(height: CGFloat) {
        
        self.input?.height = height + 10
     
        self.input?.bottom = SCREEN_HEIGHT - keyBoardHeight
    }
    

    func keyboardWillHide(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
            //将input的底部移到（屏幕的高度 + input高度）的地方。移出屏幕
            self.input?.bottom = SCREEN_HEIGHT + (self.input?.height)!
            
            self.layView?.alpha = 0
            self.layView?.hidden = true
            }) { (finish) -> Void in
                
        }
    }
    
    func keyboardWillShow(inputView: InputView!, keyboardHeight: CGFloat, animationDuration duration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        self.keyBoardHeight = keyboardHeight
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
             //将input的底部移到（屏幕的高度 - 键盘高度）的地方。
            self.input?.bottom = SCREEN_HEIGHT - keyboardHeight
            self.layView?.alpha = 0.2
            }) { (finish) -> Void in
                
        }
    }
    
    func comment(){
       let vc = CommentViewController()
           vc.BookObject = self.BookObject
           GeneralFactory.addTitleWithTitle(vc, title1: "", title2: "确定")
// 一进入就开始刷新
           vc.tableView?.header.beginRefreshing()
           self.presentViewController(vc, animated: true) { () -> Void in
                
        }
          }
    func tapLayView(){
    self.input?.inputTextView?.resignFirstResponder()
    }
    
    func like(sender:UIButton){
        sender.enabled = false
        sender.setImage(UIImage(named: "redheart"), forState: .Normal)
        
        let query = AVQuery(className: "Like")
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.whereKey("BookObject", equalTo: self.BookObject)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results != nil && results.count != 0 {
                for var object in results {
                 object = object as! AVObject
                 //如果已经点赞，则取消点赞删除掉记录
                 object.deleteEventually()
                    
                }
                 sender.setImage(UIImage(named: "heart"), forState: .Normal)
                //取消点赞
                GeneralFactory.addIncrementKey(self.BookObject!, type: .dislike)
    
                
            } else {
                //点赞
             let object = AVObject(className: "Like")
                object.setObject(AVUser.currentUser(), forKey: "user")
                object.setObject(self.BookObject, forKey: "BookObject")
                object.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success {
                    sender.setImage(UIImage(named: "solidheart"), forState: .Normal)
                        
                            GeneralFactory.addIncrementKey(self.BookObject!, type: .like)
                 
                        
                    } else {
                    ProgressHUD.showError("操作失败")
                    }
                    
                })
            
            }
                  sender.enabled = true
        }

        
    }
    func share(){
        let shareParams = NSMutableDictionary()
        shareParams.SSDKSetupLineParamsByText("分享内容", image: self.BookTitleView?.cover?.image, type: SSDKContentType.Image)
        ShareSDK.share(.TypeWechat, parameters: shareParams) { (state, userData, contentEntity, error) -> Void in
            switch state {
            case SSDKResponseState.Success:
                ProgressHUD.showSuccess("分享成功")
                break
            case SSDKResponseState.Fail:
                ProgressHUD.showError("分享失败")
                break
            case SSDKResponseState.Cancel:
                ProgressHUD.showError("已取消分享")
                break
            default:
                break   
            }
        }
        
    }

}
