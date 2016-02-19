//
//  FavortesList.swift
//  Douyu
//
//  Created by 吴锡波 on 16/2/5.
//  Copyright © 2016年 吴锡波. All rights reserved.
//

import UIKit

class FavortesList:UIViewController{
    //var LivedataSource = []
    var infiniteScrollingView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rectRect:CGRect = CGRectMake(0,20,width, 44)
        let line:CGRect = CGRectMake(0,64,width, 0.5)
        let label:UILabel = UILabel(frame:rectRect)
        label.text = "我的收藏"
        
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(17)
        label.backgroundColor = UIColor.whiteColor()
        let linelabel:UILabel = UILabel(frame:line)
        linelabel.backgroundColor = UIColor.lightGrayColor()
        
        self.view.addSubview(label)
        self.view.addSubview(linelabel)
        
        //setupInfiniteScrollingView()
        print(NSDate().timeIntervalSince1970)
        
        //saveWithNSUserDefaults("",DouyuToken:"",DouyuTokenTime:0)
        //readWithNSUserDefaults()
        // Do any additional setup after loading the view, typically from a nib.
}


}

