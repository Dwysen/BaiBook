//
//  BookTitleView.swift
//  BaiBook
//
//  Created by Dwysen on 16/2/29.
//  Copyright © 2016年 Dwysen. All rights reserved.
//

import UIKit
@objc protocol BookTitleDelegate{
       optional func choiceCover()
}

class BookTitleView: UIView {
    var BookCover:UIButton?
    var BookName:JVFloatLabeledTextField?
    var BookEditor:JVFloatLabeledTextField?
    //protocal需弱引用，否则会发生内存泄露。
    weak var delegate:BookTitleDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.BookCover = UIButton(frame: CGRect(x: 10, y: 8, width: 110, height: 141))
        self.BookCover?.setImage(UIImage(named: "CD"), forState: .Normal)
        self.BookCover?.addTarget(self, action: "choiceCover", forControlEvents: .TouchUpInside)
        self.addSubview(self.BookCover!)
        
        self.BookName = JVFloatLabeledTextField(frame: CGRect(x: 128, y: 8+40, width: SCREEN_WIDTH-128-15, height: 30))
        self.BookEditor = JVFloatLabeledTextField(frame: CGRect(x: 128, y: 8+70, width: SCREEN_WIDTH-128-15, height: 30))
        
        self.BookName?.placeholder = "书名"
        self.BookEditor?.placeholder = "作者"
        self.BookName?.floatingLabelFont = UIFont(name: MY_FONT, size: 14)
        self.BookEditor?.floatingLabelFont = UIFont(name: MY_FONT, size: 14)
        
        self.BookName?.font = UIFont(name: MY_FONT, size: 14)
        self.BookEditor?.font = UIFont(name: MY_FONT, size: 14)
        
        self.addSubview(BookName!)
        self.addSubview(BookEditor!)
    }
    



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  
    func choiceCover(){
        self.delegate?.choiceCover!()
    
    }
}
