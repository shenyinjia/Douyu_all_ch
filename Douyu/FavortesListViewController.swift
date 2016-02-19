//
//  FavortesListViewController.swift
//  Douyu
//
//  Created by 吴锡波 on 16/2/14.
//  Copyright © 2016年 吴锡波. All rights reserved.
//

import UIKit

let FavortesCell = "fcc"
class FavortesListView: UICollectionViewController{
    var RoomdataSource = []
    
    //var Img:UIImage!
    var refreshControl = UIRefreshControl()
    var infiniteScrollingView: UIView!
    //var _aiv:UIActivityIndicatorView!
    
    var Gcid = NSString()
    var Gonline = NSString()
    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //cv.dataSource = self
        //cv.delegate = self
        layout.itemSize = CGSizeMake((width-30)/2,((width-30)/2)/(320/180)+20)
        let paddingY:CGFloat = 20
        let paddingX:CGFloat = 10
        layout.sectionInset = UIEdgeInsetsMake(10,10,0,10)
        layout.minimumLineSpacing = paddingY
        layout.minimumInteritemSpacing = paddingX
        self.collectionView?.collectionViewLayout = layout
        self.collectionView!.registerClass(Room_Cell.self, forCellWithReuseIdentifier:"fcc")
        //self.collectionView!.registerClass(.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        self.collectionView?.alwaysBounceVertical = true
        
        //let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl.addTarget(self, action: "onPullToFresh", forControlEvents: UIControlEvents.ValueChanged)
        //self.refreshControl = refreshControl
        self.collectionView!.addSubview(refreshControl)
        
        saveWithNSUserDefaults("",DouyuToken:"",DouyuTokenTime:0)
        //readWithNSUserDefaults()
        
        //readWithNSUserDefaults()
        
        //print(self.collectionView!.contentSize.height)
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("huilaile")
        readWithNSUserDefaults()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1    //1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //返回记录数
        //print(RoomdataSource.count)
        return RoomdataSource.count;
        
        //return 20;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FavortesCell, forIndexPath: indexPath) as! Room_Cell
        
        let RoomItems = RoomdataSource[indexPath.row] as! RoomItem
        
        //        sessionLoadimg(RoomItems.room_src_img as String)
        //
        //        dispatch_async(dispatch_get_main_queue(), {
        //            cell.imageView.image = self.Img
        //
        //        })
        
        
        let request = NSURLRequest(URL :NSURL(string: RoomItems.room_src_img as String)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue() , completionHandler: { response, data, error in
            if (error != nil) {
                print(error)
                
            } else {
                let image = UIImage.init(data :data!)
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imageView.image = image
                })
            }
        })
        cell.textLabel?.text = RoomItems.room_name as String
        //cell.imageView?.backgroundColor = UIColor.redColor()
        //cell.imgView = UIImageView(image:image);
        cell.backgroundColor = UIColor.whiteColor() //3
        //print(self.collectionView!.frame.origin.y)
        //(cell.contentView.viewWithTag(1001) as! UILabel).text = "xsxsxs"
//        if(self.collectionView!.contentOffset.y + self.collectionView!.frame.size.height >= self.collectionView!.contentSize.height  && self.RoomdataSource.count >= 20 && indexPath.row == self.RoomdataSource.count - 9)
//        {
//            print(indexPath.row)
//            //self.setupInfiniteScrollingView()
//            //self.collectionView!.addSubview(self.infiniteScrollingView)
//            //print(self.collectionView!.frame.origin.y)
//            //self.collectionView!.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
//            //print(self.collectionView!.frame.size.height)
//            print(self.collectionView!.contentSize.height)
//            self.loadMore(self.RoomdataSource.count)
//            
//            //print(self.collectionView!.frame.size.height)
//            //print(self.collectionView!.contentOffset.y + self.collectionView!.frame.size.height)
//            
//            //
//            
//            //            UIView.animateWithDuration(3, delay: 0, options: [UIViewAnimationOptions.OverrideInheritedOptions, UIViewAnimationOptions.OverrideInheritedCurve, UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
//            //                self.collectionView!.contentInset = UIEdgeInsetsMake(0, 0, 80, 0)
//            //                self.setupInfiniteScrollingView()
//            //                self.collectionView!.addSubview(self.infiniteScrollingView)
//            //                //print(self.collectionView!.contentSize.height)
//            //                }, completion: { (finished:Bool) -> Void in
//            //                    print("cishu")
//            //                    self.loadMore(self.RoomdataSource.count)
//            //
//            //
//            //            })
//            
//        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let row=indexPath.row as Int
        let RoomItems = RoomdataSource[row] as! RoomItem
        //入栈
        print(row)
        let PlayViews = PlayView()
        PlayViews.Room_id_from_Anotherview=RoomItems.room_id
        //RoomListView.Gonline = RoomItems.room_name
        print(RoomItems.room_id)
        //取导航控制器,添加subView
        self.navigationController!.pushViewController(PlayViews,animated:true)
        //print("点击了")
    }
    ///  http://www.douyutv.com/api/v1/followRoom?aid=ios&client_sys=ios&limit=20&live=0&offset=0&token=8fdd5d1abdda0b63
    
    func sessionLoadData(Dytoken:NSString){
        //创建NSURL对象
        
        let urlString:String="http://www.douyutv.com/api/v1/followRoom?aid=ios&client_sys=ios&limit=100&live=1&offset=0&token=\(Dytoken)"
        //print(urlString)
        let url:NSURL! = NSURL(string:urlString)
        //创建请求对象
        let request:NSURLRequest = NSURLRequest(URL: url)
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithRequest(request,
            completionHandler: {(data, response, error) -> Void in
                if error != nil{
                    print(error?.code)
                    print(error?.description)
                }else{
                    //let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    //print(data?.length)
                    self.extract_json(data!)
                }
        }) as NSURLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
    }
    
    
    func extract_json(jsonData:NSData)
    {
        
        
        //let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &parseError)
        do  {
            let roomjson : AnyObject! = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
            //print(channljson)
            
            if let room_list = roomjson.objectForKey("data") as? NSArray{
                let currentRoomDataSource = NSMutableArray()
                //print(room_list)
                for currentRooms : AnyObject in room_list{
                    let RoomItems = RoomItem()
                    //if let channl_obj = channl_list[i] as? NSDictionary{
                    
                    
                    RoomItems.room_name = currentRooms["room_name"] as! NSString
                    RoomItems.room_src_img = currentRooms["room_src"] as! NSString
                    RoomItems.room_id = currentRooms["room_id"] as! NSString
                    //ChannlItems.Gonline = currentChannls["online_room"] as! NSString
                    //ChannlItems.Gcid = currentChannls["cate_id"] as! NSString
                    currentRoomDataSource.addObject(RoomItems)
                    
                    
                    
                }
                self.RoomdataSource = currentRoomDataSource
                
            }
            
        }
        catch {
            self.refreshControl.endRefreshing()
            print(error)
        }
        
        self.do_table_refresh();
        return
    }
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            //结束刷新
            
            self.collectionView!.reloadData()
            
            self.refreshControl.endRefreshing()
            
        })
    }
    
    func onPullToFresh() {
        readWithNSUserDefaults()

        //sessionLoadData()
    }
//    private func setupInfiniteScrollingView() {
//        self.infiniteScrollingView = UIView(frame: CGRectMake(0, self.collectionView!.contentSize.height, self.collectionView!.bounds.size.width, 60))
//        self.infiniteScrollingView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        self.infiniteScrollingView!.backgroundColor = UIColor.whiteColor()
//        let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
//        activityViewIndicator.color = UIColor.darkGrayColor()
//        activityViewIndicator.frame = CGRectMake(self.infiniteScrollingView!.frame.size.width/2-activityViewIndicator.frame.width/2, self.infiniteScrollingView!.frame.size.height/2-activityViewIndicator.frame.height/2, activityViewIndicator.frame.width, activityViewIndicator.frame.height)
//        activityViewIndicator.startAnimating()
//        self.infiniteScrollingView!.addSubview(activityViewIndicator)
//        
//        //print("x")
//        //self.collectionView!.addSubview(infiniteScrollingView)
//    }
//    
//    func loadMore(var offset:NSInteger){
//        var NewRoomdataSource = []
//        //创建NSURL对象
//        offset = self.RoomdataSource.count
//        let urlString:String="http://www.douyutv.com/api/v1/live/\(Gcid)?limit=20&offset=\(offset)"
//        //print(urlString)
//        let url:NSURL! = NSURL(string:urlString)
//        //创建请求对象
//        let request:NSURLRequest = NSURLRequest(URL: url)
//        
//        let session = NSURLSession.sharedSession()
//        
//        let dataTask = session.dataTaskWithRequest(request,
//            completionHandler: {(data, response, error) -> Void in
//                if error != nil{
//                    print(error?.code)
//                    print(error?.description)
//                }else{
//                    //let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                    //print(data?.length)
//                    //self.extract_json(data!)
//                    do  {
//                        let roomjson : AnyObject! = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
//                        //print(channljson)
//                        
//                        if let room_list = roomjson.objectForKey("data") as? NSArray{
//                            //print(room_list)
//                            let NewcurrentRoomDataSource = NSMutableArray()
//                            //print(room_list)
//                            for currentRooms : AnyObject in room_list{
//                                let RoomItems = RoomItem()
//                                //if let channl_obj = channl_list[i] as? NSDictionary{
//                                
//                                
//                                RoomItems.room_name = currentRooms["room_name"] as! NSString
//                                RoomItems.room_src_img = currentRooms["room_src"] as! NSString
//                                //ChannlItems.Gonline = currentChannls["online_room"] as! NSString
//                                //ChannlItems.Gcid = currentChannls["cate_id"] as! NSString
//                                NewcurrentRoomDataSource.addObject(RoomItems)
//                                
//                                
//                                
//                            }
//                            //print(currentRoomDataSource.count)
//                            NewRoomdataSource = NewcurrentRoomDataSource
//                            print("获取的数据开始加载")
//                            self.RoomdataSource = self.RoomdataSource.arrayByAddingObjectsFromArray(NewRoomdataSource as! [NSMutableArray])
//                            print(self.RoomdataSource.count)
//                            dispatch_async(dispatch_get_main_queue(), {
//                                //结束刷新
//                                //self.collectionView!.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
//                                //print(self.collectionView!.contentOffset.y)
//                                if (NewRoomdataSource.count != 0){
//                                    
//                                    self.collectionView!.reloadData()
//                                }
//                                
//                                
//                                //self.refreshControl.endRefreshing()
//                                
//                            })
//                            
//                        }
//                        
//                    }
//                    catch {
//                        self.refreshControl.endRefreshing()
//                        print(error)
//                    }
//                }
//        }) as NSURLSessionTask
//        
//        //使用resume方法启动任务
//        dataTask.resume()
//        
//        // print("loadMore")
//        //print(NewRoomdataSource.count)
//        // self.RoomdataSource = self.RoomdataSource.arrayByAddingObjectsFromArray(NewRoomdataSource as! [String])
//        //print(self.RoomdataSource.count)
//        
//    }
    
    func saveWithNSUserDefaults(DouyuId:String,DouyuToken:String,DouyuTokenTime:Int) {
        /// 1、利用NSUserDefaults存储数据
        let defaults = NSUserDefaults.standardUserDefaults();
        //  2、存储数据
        defaults.setObject(DouyuId, forKey: "DouyuId");
        defaults.setObject(DouyuToken, forKey: "DouyuToken");
        defaults.setObject(DouyuTokenTime, forKey: "DouyuTokenTime");
        
        //  3、同步数据
        defaults.synchronize();
    }
    
    func readWithNSUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults();
        let DouyuId = defaults.objectForKey("DouyuId") as! NSString;
        let DouyuToken = defaults.objectForKey("DouyuToken") as! NSString;
        let DouyuTokenTime = defaults.objectForKey("DouyuTokenTime") as! NSInteger;
        if DouyuId != "" && DouyuToken != "" && DouyuTokenTime != 0 {
            if NSDate().timeIntervalSince1970 < Double(DouyuTokenTime){
                sessionLoadData(DouyuToken)
                print("现实收藏列表")
                //self.navigationController!.pushViewController(FavortesRoomListView,animated:true)
                //self.performSegueWithIdentifier("login1", sender:self)
                
            }
            
            
            
        }else{
            //LoginView()
            let loginView = Favortes()
            self.presentViewController(loginView, animated: true, completion: nil)
            print("显示登录列表")
            
        }
        
        //print("\(DouyuToken)");
    }

    
    
}

