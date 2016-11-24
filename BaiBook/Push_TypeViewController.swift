//
//  Push_ScoreViewController.swift
//  BaiBook
//
//  Created by Dwysen on 16/3/14.
//  Copyright © 2016年 Dwysen. All rights reserved.
//

import UIKit

typealias Push_TypeCallBack = (type:String,detailType:String) -> Void

class Push_TypeViewController: UIViewController,IGLDropDownMenuDelegate{
    var segmentLabel:UILabel?
    var segmental1:AKSegmentedControl?
    var segmental2:AKSegmentedControl?
    var callBack:Push_TypeCallBack?
    
    var type = "文学"
    var detailType = "文学"
    
    var dropDownMenu1:IGLDropDownMenu?
    var dropDownMenu2:IGLDropDownMenu?

    
    
    var literatureArray1:Array<NSDictionary> = []
    var literatureArray2:Array<NSDictionary> = []
    
    
    var humanitiesArray1:Array<NSDictionary> = []
    var humanitiesArray2:Array<NSDictionary> = []
    
    
    var livelihoodArray1:Array<NSDictionary> = []
    var livelihoodArray2:Array<NSDictionary> = []
    
    
    var economiesArray1:Array<NSDictionary> = []
    var economiesArray2:Array<NSDictionary> = []
    
    
    var technologyArray1:Array<NSDictionary> = []
    var technologyArray2:Array<NSDictionary> = []
    
    var NetworkArray1:Array<NSDictionary> = []
    var NetworkArray2:Array<NSDictionary> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGB(231, green: 231, blue: 231)
        segmentLabel = UILabel(frame: CGRect(x: (SCREEN_WIDTH - 300) / 2, y: 20, width: 300, height: 20))
        segmentLabel?.font = UIFont(name: MY_FONT, size: 17)
        segmentLabel?.text = "请选择分类"
        
        segmentLabel?.textColor = RGB(82, green: 113, blue: 131)
        segmentLabel?.textAlignment = .Center
        self.view.addSubview(segmentLabel!)
        
        initSegmental()
        
        initDropArray()
        
        createDropMenu(literatureArray1, array2: literatureArray2)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func close(){self.dismissViewControllerAnimated(true) { () -> Void in
        
        }}
    
    func sure(){
        self.callBack!(type:self.type,detailType: self.detailType)
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func initSegmental(){
        segmental1 = AKSegmentedControl(frame: CGRect(x: 10, y: 60, width: SCREEN_WIDTH - 20, height: 38))
        segmental2 = AKSegmentedControl(frame: CGRect(x: 10, y: 120, width: SCREEN_WIDTH - 20, height: 38))

        let buttonArray1 = [["image":"ledger","title":"文学","font":MY_FONT],["image":"drama masks","title":"人文社科","font":MY_FONT],["image":"aperture","title":"生活","font":MY_FONT]]
        
        let buttonArray2 = [
            ["image":"atom","title":"经管","font":MY_FONT],
            ["image":"alien","title":"科技","font":MY_FONT],
            ["image":"fire element","title":"网络流行","font":MY_FONT],
        ]

        segmental1?.initButtonWithTitleandImage(buttonArray1)
        
        segmental2?.initButtonWithTitleandImage(buttonArray2)
        
        segmental1?.addTarget(self, action: "segmentalChange:", forControlEvents: .ValueChanged)
        segmental2?.addTarget(self, action: "segmentalChange:", forControlEvents: .ValueChanged)
        
        
        

        self.view.addSubview(segmental1!)
        self.view.addSubview(segmental2!)
}
    
    func initDropArray(){
        
        self.literatureArray1 = [
            ["title":"小说"],
            ["title":"漫画"],
            ["title":"青春文学"],
            ["title":"随笔"],
            ["title":"现当代诗"],
            ["title":"戏剧"],
        ];
        self.literatureArray2 = [
            ["title":"传记"],
            ["title":"古诗词"],
            ["title":"外国诗歌"],
            ["title":"艺术"],
            ["title":"摄影"],
        ];
        self.humanitiesArray1 = [
            ["title":"历史"],
            ["title":"文化"],
            ["title":"古籍"],
            ["title":"心理学"],
            ["title":"哲学/宗教"],
            ["title":"政治/军事"],
        ];
        self.humanitiesArray2 = [
            ["title":"社会科学"],
            ["title":"法律"],
        ];
        self.livelihoodArray1 = [
            ["title":"休闲/爱好"],
            ["title":"孕产/胎教"],
            ["title":"烹饪/美食"],
            ["title":"时尚/美妆"],
            ["title":"旅游/地图"],
            ["title":"家庭/家居"],
        ];
        self.livelihoodArray2 = [
            ["title":"亲子/家教"],
            ["title":"两性关系"],
            ["title":"育儿/早教"],
            ["title":"保健/养生"],
            ["title":"体育/运动"],
            ["title":"手工/DIY"],
        ];
        self.economiesArray1  = [
            ["title":"管理"],
            ["title":"投资"],
            ["title":"理财"],
            ["title":"经济"],
        ];
        self.economiesArray2  = [
            ["title":"没有更多了"],
        ];
        self.technologyArray1 =  [
            ["title":"科普读物"],
            ["title":"建筑"],
            ["title":"医学"],
            ["title":"计算机/网络"],
        ];
        self.technologyArray2 = [
            ["title":"农业/林业"],
            ["title":"自然科学"],
            ["title":"工业技术"],
        ];
        self.NetworkArray1 =    [
            ["title":"玄幻/奇幻"],
            ["title":"武侠/仙侠"],
            ["title":"都市/职业"],
            ["title":"历史/军事"],
        ];
        self.NetworkArray2 =    [
            ["title":"游戏/竞技"],
            ["title":"科幻/灵异"],
            ["title":"言情"],
        ];

    }
    
    
    func segmentalChange(segment:AKSegmentedControl){
    var index = segment.selectedIndexes.firstIndex
        
        self.type = ((segment.buttonsArray[index] as! UIButton).titleLabel?.text)!
  
        //如果点击的是第一个segmental，则取消第二个Segmental的点击效果
        if segment == self.segmental1{
        self.segmental2?.setSelectedIndex(3)
        } else {
        self.segmental1?.setSelectedIndex(3)
        index += 3
        }
        
        if dropDownMenu1 != nil {
        dropDownMenu1?.resetParams()
        }
        if dropDownMenu2 != nil {
            dropDownMenu2?.resetParams()
        }
        
        switch index {
        case 0:
            self.createDropMenu(self.literatureArray1, array2: self.literatureArray2)
            break
        case 1:
            self.createDropMenu(self.humanitiesArray1, array2: self.humanitiesArray2)
            break
        case 2:
            self.createDropMenu(self.livelihoodArray1, array2: self.livelihoodArray2)
            break
        case 3:
            self.createDropMenu(self.economiesArray1, array2: self.economiesArray2)
            break
        case 4:
            self.createDropMenu(self.technologyArray1, array2: self.technologyArray2)
            break
        case 5:
            self.createDropMenu(self.NetworkArray1, array2: self.NetworkArray2)
            break
        default:
            break
        }
    }
    
    func createDropMenu(array1:Array<NSDictionary>,array2:Array<NSDictionary>){
    let dropDownItme1 = NSMutableArray()
        for var i = 0; i<array1.count; i++ {
        let dict = array1[i]["title"]
            let item = IGLDropDownItem()
            item.text = dict as? String
            dropDownItme1.addObject(item)
        }
        let dropDownItme2 = NSMutableArray()
        for var i = 0; i<array2.count; i++ {
            let dict = array2[i]["title"]
            let item = IGLDropDownItem()
            item.text = dict as? String
            dropDownItme2.addObject(item)
        }
        
        //因为需要不断重用，所以
        dropDownMenu1?.removeFromSuperview()
        dropDownMenu1 = IGLDropDownMenu()
        dropDownMenu1?.menuText = "点我"
        dropDownMenu1?.menuButton.textLabel.adjustsFontSizeToFitWidth = true
        dropDownMenu1?.menuButton.textLabel.textColor = RGB(38, green: 82, blue: 67)
        dropDownMenu1?.paddingLeft = 15
        dropDownMenu1?.delegate = self
        dropDownMenu1?.type = .Stack
        dropDownMenu1?.itemAnimationDelay = 0.1
        dropDownMenu1?.gutterY = 5
        dropDownMenu1?.dropDownItems = dropDownItme1 as [AnyObject]
        dropDownMenu1?.frame = CGRect(x: 20, y: 160, width: SCREEN_WIDTH / 2 - 30, height: (SCREEN_HEIGHT-200) / 7)
        self.view.addSubview(dropDownMenu1!)
        dropDownMenu1?.reloadView()
        
        self.dropDownMenu2?.removeFromSuperview()
        self.dropDownMenu2 = IGLDropDownMenu()
        self.dropDownMenu2?.menuText = "点我，展开详细列表"
        self.dropDownMenu2?.menuButton.textLabel.adjustsFontSizeToFitWidth = true
        self.dropDownMenu2?.menuButton.textLabel.textColor = RGB(38, green: 82, blue: 67)
        self.dropDownMenu2?.paddingLeft = 15
        self.dropDownMenu2?.delegate = self
        self.dropDownMenu2?.type = .Stack
        self.dropDownMenu2?.itemAnimationDelay = 0.1
        self.dropDownMenu2?.gutterY = 5
        self.dropDownMenu2?.dropDownItems = dropDownItme2  as [AnyObject]
        self.dropDownMenu2?.frame = CGRectMake(SCREEN_WIDTH/2+10, 160, SCREEN_WIDTH/2-30, (SCREEN_HEIGHT-200)/7)
        self.view.addSubview(self.dropDownMenu2!)
       self.dropDownMenu2?.reloadView()

        
        
        
    }
    func dropDownMenu(dropDownMenu: IGLDropDownMenu!, selectedItemAtIndex index: Int) {
        if dropDownMenu == self.dropDownMenu1 {
            let item = self.dropDownMenu1?.dropDownItems[index] as? IGLDropDownItem
            self.detailType = (item?.text)!
            self.dropDownMenu2?.menuButton.text = self.detailType
        }else{
            let item = self.dropDownMenu2?.dropDownItems[index] as? IGLDropDownItem
            self.detailType = (item?.text)!
            self.dropDownMenu1?.menuButton.text = self.detailType
        }
    }
    
    
}


