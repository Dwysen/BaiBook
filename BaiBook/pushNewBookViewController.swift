//
//  pushNewBookViewController.swift
//  BaiBook
//
//  Created by irishsky on 16/2/17.
//  Copyright © 2016年 irishsky. All rights reserved.
//

import UIKit

class pushNewBookViewController: UIViewController,BookTitleDelegate,PhotoPickerDelegate,VPImageCropperDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var BookTitle:BookTitleView?
    
    var tableView:UITableView?
    
    var titleArray:Array<String> = []
    
    var Book_Title = ""
    
    var Score:LDXScore?
    
    var IsScoring = false
    
    var type = "文学"
    var detailType = "文学"
    
    var Book_Description = ""
    
    var BookObject:AVObject?
    //判断是编辑还是发布新书
    var fixType:String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.BookTitle = BookTitleView(frame: CGRect(x: 0, y: 40, width: SCREEN_WIDTH, height: 160))
        self.BookTitle?.delegate = self
        self.view.addSubview(self.BookTitle!)
        self.tableView = UITableView(frame: CGRect(x: 0, y: 200, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 200), style: .Grouped)
        self.tableView?.tableFooterView = UIView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.backgroundColor = UIColor(colorLiteralRed: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        self.view.addSubview(self.tableView!)
        self.titleArray = ["标题","评分","分类","书评"]
        self.Score = LDXScore(frame: CGRect(x: 100, y: 10, width: 100, height: 22))
        Score?.isSelect = true
        Score?.normalImg = UIImage(named: "btn_star_evaluation_normal")
        Score?.highlightImg = UIImage(named: "btn_star_evaluation_press")
        Score?.max_star = 5
        Score?.show_score = 5
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pushBookNotifiction:", name: "pushBookNotifiction", object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func choiceCover() {
        let vc = PhotoPickerController()
        vc.delegate = self
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
        
    }
    func pushBookNotifiction(notifiction:NSNotification){

    let dict = notifiction.userInfo
        if String(dict!["success"]!) == "true"{
            
    ProgressHUD.showSuccess("上传成功")
    self.dismissViewControllerAnimated(true) { () -> Void in
       
            }} else {
        ProgressHUD.showError("上传失败")
        }
    }
    
    func fixBook(){
        if self.fixType == "fix" {
        self.BookTitle?.BookName?.text = self.BookObject!["bookName"] as? String
        self.BookTitle?.BookEditor?.text = self.BookObject!["bookEditor"] as? String
        let coverFile = self.BookObject!["cover"] as? AVFile
            coverFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                self.BookTitle?.BookCover?.setImage(UIImage(data: data), forState: .Normal)
                
            })
            self.Book_Title = (self.BookObject!["bookTitle"] as? String)!
            self.type = (self.BookObject!["type"] as? String)!
            self.detailType = (self.BookObject!["detailType"] as? String)!
            self.Book_Description = (self.BookObject!["description"] as? String)!
            self.Score?.show_star = (Int)((self.BookObject!["bookScore"] as? String)!)!
            
            if self.Book_Description != ""{
            self.titleArray.append("")
            }
        }
    
    }
    
    deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
    print("pushNewBookViewController release ", terminator: "")
    }
    func getImagemFromPicker(image: UIImage) {
        let vc = VPImageCropperViewController(image: image, cropFrame: CGRect(x: 0, y: 100, width: SCREEN_WIDTH, height: SCREEN_WIDTH * 1.273), limitScaleRatio: 3)
        vc.delegate = self
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
        
        
    }
    
    func imageCropper(cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        self.BookTitle?.BookCover?.setImage(editedImage, forState: .Normal)
        cropperViewController.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    func imageCropperDidCancel(cropperViewController: VPImageCropperViewController!) {
        
    }
    
    func close(){
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    func sure(){
        ProgressHUD.show("上传中")
        let dict = [
            "bookName":(self.BookTitle?.BookName?.text)!,
            "bookEditor":(self.BookTitle?.BookEditor?.text)!,
            "bookCover":(self.BookTitle?.BookCover?.currentImage)!,
            "bookTitle":self.Book_Title,"bookScore":String((self.Score?.show_star)!),
            "type":self.type,
            "detailType":self.detailType,
            "description":self.Book_Description
        ]
        //如果是编辑状态，则更新书的信息
        if self.fixType == "fix" {
            pushBook.pushBook(dict, object: self.BookObject!)
        } else {
            //如果不是编辑状态，即新建一本书。
       let object = AVObject(className: "BaiBook")
            pushBook.pushBook(dict,object: object)
        
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        //单元格重用之前清理掉其中的内容
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        if(indexPath.row != 1){
            cell.accessoryType = .DisclosureIndicator
        }
        cell.textLabel?.text = self.titleArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: MY_FONT, size: 15)
        cell.detailTextLabel?.font = UIFont(name: MY_FONT, size: 13)
        var row = indexPath.row
        if IsScoring && row > 1{
        row--
        }
        switch row{
        case 0:
            cell.detailTextLabel?.text = self.Book_Title
        case 2:
            cell.detailTextLabel?.text = self.type + "->" + self.detailType
        case 4:
            cell.accessoryType = .None
            let commentView = UITextView(frame: CGRect(x: 4, y: 4, width: SCREEN_WIDTH - 8, height: 80))
            commentView.text = self.Book_Description
            commentView.font = UIFont(name: MY_FONT, size: 14)
            cell.contentView.addSubview(commentView)
        default:break
        }
        //如果评分栏存在且是第三行，则将Score添加到Cell中。
        if IsScoring && indexPath.row == 2 {
        cell.contentView.addSubview(Score!)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if IsScoring && indexPath.row >= 5 {
        return 88
        } else if !IsScoring && indexPath.row >= 4 {
        return 88
        } else {
        return 44
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var row = indexPath.row
        if IsScoring && row > 1 {
        row -= 1
        }
        switch row{
        case 0:
            tableViewSelectTitle()
        case 1:
            tableViewSelectScore()
        case 2:
            tableViewSelectType()
        default:
            tableViewSelectDiscription()
        }
    }
    
    func tableViewSelectTitle(){
        let vc = Push_titleViewController()
        GeneralFactory.addTitleWithTitle(vc)
        vc.callBack = {(title:String) -> Void in
        self.Book_Title = title
        self.tableView?.reloadData()
            }
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
    }
    func tableViewSelectScore(){
//        let vc = Push_ScoreViewController()
//        GeneralFactory.addTitleWithTitle(vc)
//        self.presentViewController(vc, animated: true) { () -> Void in     }
        
        let indexpath = [NSIndexPath(forRow: 2, inSection: 0)]
        self.tableView?.beginUpdates()
        if IsScoring{
        titleArray.removeAtIndex(2)
        self.tableView?.deleteRowsAtIndexPaths(indexpath, withRowAnimation: .Right)
        self.IsScoring = false
        } else {
        titleArray.insert("", atIndex: 2)
        self.tableView?.insertRowsAtIndexPaths(indexpath, withRowAnimation: .Left)
        self.IsScoring = true
        }
        self.tableView?.endUpdates()
    }
    
    func tableViewSelectType(){
        let vc = Push_TypeViewController()
        GeneralFactory.addTitleWithTitle(vc)
        let btn1 = vc.view.viewWithTag(123) as! UIButton
        let btn2 = vc.view.viewWithTag(456) as! UIButton
        btn1.setTitleColor(RGB(38, green: 82, blue: 67), forState: .Normal)
        btn2.setTitleColor(RGB(38, green: 82, blue: 67), forState: .Normal)
        vc.type = self.type
        vc.detailType = self.detailType
        vc.callBack = ({(type:String,detailType:String) -> Void in
        self.type = type
        self.detailType = detailType
        self.tableView?.reloadData()

        })
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
        
        
    }
    
    func tableViewSelectDiscription(){
        let vc = Push_DiscriptionViewController()
        GeneralFactory.addTitleWithTitle(vc)
        vc.txtView!.text = self.Book_Description
        vc.callBack = ({(description:String) -> Void in
        self.Book_Description = description
            if self.titleArray.last == "" {
                self.titleArray.removeLast()
            }
            if description != "" {
                self.titleArray.append("")
            }
            self.tableView?.reloadData()
            
        })

        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
        
        
    }

    
}
