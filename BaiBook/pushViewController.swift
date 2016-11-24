import UIKit

class pushViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate{

    var dataArray = NSMutableArray()
    var navigationView:UIView?
    var tableView:UITableView?
    
    //当前展开的Cell的IndexPath
    var swipIndexPath:NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setNavigationBar()
        tableView = UITableView(frame: self.view.frame)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.registerClass(pushBookCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView?.tableFooterView = UIView()
        
        tableView?.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headRfresh))
        tableView?.footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(footRfresh))
        
        self.view.addSubview(tableView!)
        self.tableView?.header.beginRefreshing()

    }
    func setNavigationBar(){
    navigationView = UIView(frame: CGRect(x: 0, y: -20, width: SCREEN_WIDTH, height: 65))
    navigationView!.backgroundColor = UIColor.whiteColor()
    self.navigationController?.navigationBar.addSubview(navigationView!)
        
    let addBooKBtn = UIButton(frame: CGRect(x: 20, y: 20, width: SCREEN_WIDTH, height: 45))

        addBooKBtn.setImage(UIImage(named: "CD"), forState: .Normal)
        addBooKBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        addBooKBtn.setTitle("新建书评", forState: .Normal)
        addBooKBtn.titleLabel?.font = UIFont(name: MY_FONT, size: 15)
        addBooKBtn.contentHorizontalAlignment = .Left
        addBooKBtn.addTarget(self, action: #selector(pushNewBook), forControlEvents: .TouchUpInside)
        
        navigationView!.addSubview(addBooKBtn)
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationView?.hidden = false
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationView?.hidden = true
    }
    func pushNewBook(){
        let vc = pushNewBookViewController()
        GeneralFactory.addTitleWithTitle(vc, title1: "关闭", title2: "不关")
        self.presentViewController(vc, animated: true) { () -> Void in
        }
    }

    
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    
    //制作SwipCell的两个按钮
    func returnRightBtn() -> [AnyObject] {
        let btn1 = UIButton(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
        btn1.backgroundColor = UIColor.orangeColor()
        btn1.setTitle("编辑", forState: .Normal)
        
        let btn2 = UIButton(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
        btn2.backgroundColor = UIColor.redColor()
        btn2.setTitle("删除", forState: .Normal)
        return [btn1,btn2]
    
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, scrollingToState state: SWCellState) {
        let indexPath = self.tableView?.indexPathForCell(cell)
        if state == .CellStateRight{
            //如果当前已经有展开的Cell，并且与当前即将展开的不是同一个
            if self.swipIndexPath != nil && self.swipIndexPath?.row != indexPath{
            //隐藏已经展开的Cell
            let swipedCell = self.tableView?.cellForRowAtIndexPath(swipIndexPath!) as? pushBookCell
                swipedCell?.hideUtilityButtonsAnimated(true)
            }
            //记录下当前展开的Cell
            self.swipIndexPath = indexPath
        }
        //收起Cell
        else if state == .CellStateCenter {
          self.swipIndexPath = nil
        }
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        cell.hideUtilityButtonsAnimated(true)
        let indexPath = self.tableView?.indexPathForCell(cell)
        
        let object = self.dataArray[(indexPath?.row)!] as! AVObject
        
        if index == 0 {
        //编辑
            let vc = pushNewBookViewController()
            GeneralFactory.addTitleWithTitle(vc, title1: "关闭", title2: "发布")
            vc.fixType = "fix"
            vc.BookObject = object
            vc.fixBook()
            self.presentViewController(vc, animated: true, completion: { () -> Void in
                
            })
        } else {
        //删除
            ProgressHUD.show("")
            //删除这本书所有的留言
            let commentQuery = AVQuery(className: "comment")
            commentQuery.whereKey("BookObject", equalTo: object)
            commentQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                for Book in results{
                let BookObject = Book as? AVObject
                    BookObject?.deleteInBackground()
                
                }
            })
            //删除这本书所有的点赞
            let likeQuery = AVQuery(className: "Like")
            likeQuery.whereKey("BookObject", equalTo: object)
            likeQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                for Book in results{
                    let BookObject = Book as? AVObject
                    BookObject?.deleteInBackground()
                    
                }
            })
            
            object.deleteInBackgroundWithBlock({ (success, error) -> Void in
                if success{
                ProgressHUD.showSuccess("删除成功")
                self.dataArray.removeObjectAtIndex((indexPath?.row)!)
                self.tableView?.reloadData()
                } else {
                
                }
            })
        
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? pushBookCell
        
        //设置SwipCell的按钮和代理
        cell?.rightUtilityButtons = returnRightBtn()
        cell?.delegate = self
        
        let dict = dataArray[indexPath.row] as? AVObject
        
        cell?.BookName?.text = "<" +  (dict!["bookName"] as! String) + ">:" + (dict!["bookTitle"] as! String)
        cell?.Editor?.text = "<" +  (dict!["bookEditor"] as! String) + ">"
        let date = dict!["createdAt"] as? NSDate
        let formate = NSDateFormatter()
        formate.dateFormat = "yyyy-MM-dd hh:mm"
        cell?.more?.text = formate.stringFromDate(date!)
        let coverFile = dict!["cover"] as? AVFile
        cell?.cover?.sd_setImageWithURL(NSURL(string:(coverFile?.url)!), placeholderImage: UIImage(named: "CD"))
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = BookDetailViewController()
        vc.BookObject = self.dataArray[indexPath.row] as? AVObject
        //push过去时隐藏最下方的TabBar
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func headRfresh(){
    let query = AVQuery(className: "BaiBook")
        query.limit = 20
        query.skip = 0
        query.orderByDescending("createAt")
        //只显示当前用户上传的书评
        query.whereKey("user", equalTo: AVUser.currentUser())
        
        query.findObjectsInBackgroundWithBlock { (result, error) -> Void in
            self.tableView?.header.endRefreshing()
            self.dataArray.removeAllObjects()
            self.dataArray.addObjectsFromArray(result)
            self.tableView?.reloadData()
            
        }
    }
    func footRfresh(){
        let query = AVQuery(className: "BaiBook")
        query.limit = 20
        query.skip = self.dataArray.count
        query.orderByDescending("createAt")
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (result, error) -> Void in
            self.tableView?.footer.endRefreshing()

            self.dataArray.addObjectsFromArray(result)
            self.tableView?.reloadData()
            
        }
    
    }

}
