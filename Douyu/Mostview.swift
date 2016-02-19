//
//  RoomListViewController.swift
//  Douyu
//
//  Created by 吴锡波 on 16/1/31.
//  Copyright © 2016年 吴锡波. All rights reserved.
//

import UIKit

let most_reuseIdentifier = "Mcc"
//let width = UIScreen.mainScreen().bounds.size.width


class MostListViewController: UICollectionViewController{
    
    
    

   
    

    var LivedataSource = []
    var refreshControl = UIRefreshControl()
    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.itemSize = CGSizeMake((width-30)/2,((width-30)/2)/(320/180)+20)
        let paddingY:CGFloat = 20
        let paddingX:CGFloat = 10
        layout.sectionInset = UIEdgeInsetsMake(10,10,0,10)
        layout.minimumLineSpacing = paddingY
        layout.minimumInteritemSpacing = paddingX
        self.collectionView?.collectionViewLayout = layout
        self.collectionView!.registerClass(Room_Cell.self, forCellWithReuseIdentifier:"Mcc")
        //self.collectionView!.registerClass(.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        self.collectionView?.alwaysBounceVertical = true
        
        //let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl.addTarget(self, action: "onPullToFresh", forControlEvents: UIControlEvents.ValueChanged)
        //self.refreshControl = refreshControl
        self.collectionView!.addSubview(refreshControl)
        sessionLoadData()
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
        return LivedataSource.count;
        
        //return 20;
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Mcc", forIndexPath: indexPath) as! Room_Cell
        
        let RoomItems = LivedataSource[indexPath.row] as! RoomItem
        
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
       
        if(self.collectionView!.contentOffset.y + self.collectionView!.frame.size.height >= self.collectionView!.contentSize.height - height + 450  && self.LivedataSource.count >= 20 && indexPath.row == self.LivedataSource.count - 8)
        {
            print(indexPath.row)
            //self.setupInfiniteScrollingView()
            //self.collectionView!.addSubview(self.infiniteScrollingView)
            //print(self.collectionView!.frame.origin.y)
            //self.collectionView!.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
            //print(self.collectionView!.frame.size.height)
            print(self.collectionView!.contentSize.height)
            self.loadMore(self.LivedataSource.count)
            
            //print(self.collectionView!.frame.size.height)
            //print(self.collectionView!.contentOffset.y + self.collectionView!.frame.size.height)
            
            //
            
            //            UIView.animateWithDuration(3, delay: 0, options: [UIViewAnimationOptions.OverrideInheritedOptions, UIViewAnimationOptions.OverrideInheritedCurve, UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
            //                self.collectionView!.contentInset = UIEdgeInsetsMake(0, 0, 80, 0)
            //                self.setupInfiniteScrollingView()
            //                self.collectionView!.addSubview(self.infiniteScrollingView)
            //                //print(self.collectionView!.contentSize.height)
            //                }, completion: { (finished:Bool) -> Void in
            //                    print("cishu")
            //                    self.loadMore(self.RoomdataSource.count)
            //
            //                    
            //            })
            
        }
        
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let row=indexPath.row as Int
        let RoomItems = LivedataSource[row] as! RoomItem
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
    

    func sessionLoadData(){
        //创建NSURL对象
        
        let urlString:String="http://capi.douyucdn.cn/api/v1/live?aid=ios&client_sys=ios&limit=20&offset=0"
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
                    //print(data!)
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
                self.LivedataSource = currentRoomDataSource
                
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
        
        sessionLoadData()
    }
    func loadMore(var offset:NSInteger){
        var NewRoomdataSource = []
        //创建NSURL对象
        offset = self.LivedataSource.count
        let urlString:String="http://capi.douyucdn.cn/api/v1/live?limit=20&offset=\(offset)"
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
                    //self.extract_json(data!)
                    do  {
                        let roomjson : AnyObject! = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        //print(channljson)
                        
                        if let room_list = roomjson.objectForKey("data") as? NSArray{
                            //print(room_list)
                            let NewcurrentRoomDataSource = NSMutableArray()
                            //print(room_list)
                            for currentRooms : AnyObject in room_list{
                                let RoomItems = RoomItem()
                                //if let channl_obj = channl_list[i] as? NSDictionary{
                                
                                
                                RoomItems.room_name = currentRooms["room_name"] as! NSString
                                RoomItems.room_src_img = currentRooms["room_src"] as! NSString
                                RoomItems.room_id = currentRooms["room_id"] as! NSString
                                //ChannlItems.Gcid = currentChannls["cate_id"] as! NSString
                                NewcurrentRoomDataSource.addObject(RoomItems)
                                
                                
                                
                            }
                            //print(currentRoomDataSource.count)
                            NewRoomdataSource = NewcurrentRoomDataSource
                            print("获取的数据开始加载")
                            self.LivedataSource = self.LivedataSource.arrayByAddingObjectsFromArray(NewRoomdataSource as! [NSMutableArray])
                            print(self.LivedataSource.count)
                            dispatch_async(dispatch_get_main_queue(), {
                                //结束刷新
                                //self.collectionView!.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                                //print(self.collectionView!.contentOffset.y)
                                if (NewRoomdataSource.count != 0){
                                    
                                    self.collectionView!.reloadData()
                                }
                                
                                
                                //self.refreshControl.endRefreshing()
                                
                            })
                            
                        }
                        
                    }
                    catch {
                        self.refreshControl.endRefreshing()
                        print(error)
                    }
                }
        }) as NSURLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
        
        // print("loadMore")
        //print(NewRoomdataSource.count)
        // self.RoomdataSource = self.RoomdataSource.arrayByAddingObjectsFromArray(NewRoomdataSource as! [String])
        //print(self.RoomdataSource.count)
        
    }

    
   }

