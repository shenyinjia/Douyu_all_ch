//
//  ListViewController.swift
//  Douyu
//
//  Created by 吴锡波 on 16/1/28.
//  Copyright © 2016年 吴锡波. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    //var movieView: UIView!
//    var players: [Player] = playersData
    
    
    //数据源定义一个空
    var dataSource = []
    

    
//    var TableData:Array< String > = Array < String >()
//    var GonlineData:Array< String > = Array < String >()
    //var Gamedata: Dictionary<String, String> = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //下拉刷新的
        
        //self.tableView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl.addTarget(self, action: "onPullToFresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
       
        sessionLoadData()
        
        

//       sessionLoadData()
//        self.movieView = UIView()
//        self.movieView.backgroundColor = UIColor.redColor()
//        self.movieView.frame = UIScreen.screens()[0].bounds
//        self.movieView.frame.origin.y = 20
//        self.movieView.frame.size.height = 180
//        self.view.addSubview(self.movieView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("likaile")
        self.refreshControl!.endRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath)
                as UITableViewCell
            let ChannlItems = dataSource[indexPath.row] as! ChannlItem
            //let player = TableData[indexPath.row]
            cell.textLabel?.text = ChannlItems.Gname as String
            cell.detailTextLabel?.text = ChannlItems.Gonline as String
            //print(indexPath.row)

            return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let row=indexPath.row as Int
        let data=self.dataSource[row] as! ChannlItem
        //入栈
        let RoomListView=RoomListViewController()
        RoomListView.Gcid=data.Gcid
        RoomListView.Gonline = data.Gonline
        //取导航控制器,添加subView
        self.navigationController!.pushViewController(RoomListView,animated:true)
    }
    
    
    func sessionLoadData(){
        //创建NSURL对象
        let urlString:String="http://www.douyutv.com/api/v1/game"
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
            let channljson : AnyObject! = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
            //print(channljson)
            
            if let channl_list = channljson.objectForKey("data") as? NSArray{
                let currentChannlDataSource = NSMutableArray()
                for currentChannls : AnyObject in channl_list{
                    let ChannlItems = ChannlItem()
                    //if let channl_obj = channl_list[i] as? NSDictionary{
               
                                    if currentChannls["online_room"] as! NSString != "0" {
                                        ChannlItems.Gname = currentChannls["game_name"] as! NSString
                                        ChannlItems.Gonline = currentChannls["online_room"] as! NSString
                                        ChannlItems.Gcid = currentChannls["cate_id"] as! NSString
                                        currentChannlDataSource.addObject(ChannlItems)
                                        
                                    }

                }
                self.dataSource = currentChannlDataSource
                
            }
            
        }
        catch {
            self.refreshControl!.endRefreshing()
            print(error)
        }
        
        self.do_table_refresh();
        return
    }
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            //结束刷新
             self.refreshControl!.endRefreshing()
            self.tableView.reloadData()
            
            
        })
    }
    //下拉刷新中执行的动作
    func onPullToFresh() {
        
        sessionLoadData()
    }

    
}


