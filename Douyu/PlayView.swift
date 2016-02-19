//
//  PlayView.swift
//  Douyu
//
//  Created by 吴锡波 on 16/2/19.
//  Copyright © 2016年 吴锡波. All rights reserved.
//



import UIKit
import ysocket



class  PlayView: UIViewController {
    
    
    var Room_id_from_Anotherview = NSString()
    //var Gonline = NSString()

    
    
    var Danmu_Auth_Socket:TCPClient?
    var Danmu_Socket:TCPClient?
    
    var Rtmp_Room_Info_data = []
    let uuid = UIDevice.currentDevice().identifierForVendor!.UUIDString.stringByReplacingOccurrencesOfString("-", withString: "").lowercaseString
    let time = Int(NSDate().timeIntervalSince1970)
    
    
    let DanmuView:UITextView = UITextView()
    let playerView:UIView = UIView()
    var movieView:UIView!
    var mediaPlayer = VLCMediaPlayer()
    
    

    
    
    
   // var movieView: UIView!  //
    //var controlView: UIView!
   // var mediaPlayer = VLCMediaPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Room_id_from_Anotherview)
        
        let Danmu_Rect:CGRect = CGRectMake(0,286,width, 230)
        DanmuView.frame = Danmu_Rect
        //DanmuView.text = ""
        DanmuView.layer.borderWidth = 1
        DanmuView.layer.borderColor = UIColor.grayColor().CGColor
        DanmuView.editable = false
        DanmuView.scrollEnabled = true
        
        DanmuView.layoutManager.allowsNonContiguousLayout = false;
        
        self.view.addSubview(DanmuView)
        let playerView_Rect:CGRect = CGRectMake(0, 80, width, 200)
        playerView.frame = playerView_Rect
        
        self.view.addSubview(playerView)
        
        self.movieView = UIView()
        self.movieView.backgroundColor = UIColor.blackColor()
        self.movieView.frame = UIScreen.screens()[0].bounds
        self.movieView.frame.origin.y = 0
        self.movieView.frame.size.height = 200
        self.playerView.addSubview(self.movieView)
        
        
        
        
        

        RmtpLoadData(Room_id_from_Anotherview as String)
//
//        self.movieView = UIView()
//        self.movieView.backgroundColor = UIColor.blackColor()
//        self.movieView.frame = UIScreen.screens()[0].bounds
//        self.movieView.frame.origin.y = 0
//        self.movieView.frame.size.height = 200
//        self.playView.addSubview(self.movieView)
        
        
        
        //ChushihuaSocket("119.90.49.91",Auth_port: 8054,Danmu_port: 12601) //定义两个socket连接
        
        
        //print(Rtmp_data.Rtmp_multi_bitrate["middle"])
        
        //  do_login_auth_danmu("475252")
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    private func DouyuMsg(content:String)->NSData{
        let LengthBytes:[UInt8] = [UInt8(content.characters.count + 9),0x00,0x00,0x00]
        let magicBytes:[UInt8] = [0xb1,0x02,0x00,0x00]
        let endBytes:[UInt8] = [0x00]
        
        let length:NSData = NSData(bytes:LengthBytes, length:LengthBytes.count)
        let code = length
        let magic:NSData = NSData(bytes:magicBytes, length:magicBytes.count)
        let contentN:NSData = content.dataUsingEncoding(NSUTF8StringEncoding)!
        let end:NSData = NSData(bytes:endBytes, length:endBytes.count)
        
        let msg = NSMutableData()
        msg.appendData(length)
        msg.appendData(code)
        msg.appendData(magic)
        msg.appendData(contentN)
        msg.appendData(end)
        return msg
    }
    
    private func check(str: NSString,pattern:String)-> String {
        var ZZstr:String = ""
        // 使用正则表达式一定要加try语句
        do {
            // - 1、创建规则
            
            // - 2、创建正则表达式对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
            // - 3、开始匹配
            let res = regex.firstMatchInString(str as String, options: [], range: NSMakeRange(0, (str as String).characters.count))
            
            if res != nil {
                let r1 = res!.rangeAtIndex(1)
                ZZstr = (str as NSString).substringWithRange(r1)
            }else{
                print("正则匹配失败")
            }
            //print(ZZstr)
        }
        catch {
            return str as String
        }
        return ZZstr
    }
    
    func processClientSocket(danmu_login:String,danmu_join_group:String){
        //let Danmu:TCPClient = TCPClient(addr: "danmu.douyutv.com", port: 12601)
        
        
        let Pdanmu_content = "content@=(.*)/snick"
        let Pdanmu_sayer = "/snick@=(.*)/cd@"
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            
            
            func readmsg()->NSString?{
                let nomessage:NSString = "非消息数据"
                
                //read 4 byte int as type
                
                let byte=self.Danmu_Socket!.read(4000)
                if byte != nil{
                    let data = NSData(bytes: byte!, length: byte!.count)
                    let str = NSString(data: data.subdataWithRange(NSMakeRange(12, data.length-12)), encoding: NSUTF8StringEncoding)
                    if str != nil{
                        if str!.componentsSeparatedByString("type@=chatmessage").count > 1 {
                            //                let danmu_content:String = self.check(str!,pattern: Pdanmu_content)
                            //                let danmu_sayer:String = self.check(str!,pattern: Pdanmu_sayer)
                            //                print(danmu_sayer + ":" + danmu_content)
                            
                            return str
                            
                        }
                    }else
                    {
                        //print("数据为空")
                        return nomessage
                    }
                    
                }
                else{
                    print("没有获取到数据－－－－－－－－－－－－－－－－－－－")
                }
                return nomessage
            }
            
            
            
            
            var (Danmu_success,Danmu_errmsg)=self.Danmu_Socket!.connect(timeout: 1)
            
            if Danmu_success{
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.DanmuView.text = self.DanmuView.text + "连接成功\n"
                })
                
                (Danmu_success,Danmu_errmsg)=self.Danmu_Socket!.send(data:self.DouyuMsg(danmu_login))
                
                if Danmu_success{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.DanmuView.text = self.DanmuView.text + "登录弹幕房间成功\n"
                        (Danmu_success,Danmu_errmsg)=self.Danmu_Socket!.send(data:self.DouyuMsg(danmu_join_group))
                        readmsg()
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                            while true{
                                
                                //let msg:NSString = "非消息数据"
                                if let msg=readmsg(){
                                    if msg != "非消息数据"{
                                        
                                        let danmu_content:String = self.check(msg,pattern: Pdanmu_content)
                                        let danmu_sayer:String = self.check(msg,pattern: Pdanmu_sayer)
                                        //self.DanmuView.text = danmu_sayer + ":" + danmu_content
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.DanmuView.text = self.DanmuView.text + danmu_sayer + ":" + danmu_content + "\n"
                                            if self.DanmuView.contentSize.height > self.DanmuView.frame.size.height {
                                                //print(self.DanmuView.contentSize.height)
                                                self.DanmuView.scrollRangeToVisible(NSMakeRange(self.DanmuView.text.characters.count, 1))
                                                print(self.DanmuView.text.characters.count)
                                                // print("高度超过了，要移动了")
                                            }
                                            
                                            //                            self.DanmuView.scrollRangeToVisible(NSMakeRange(self.DanmuView.text.characters.count, 1))
                                        })
                                        //print(danmu_sayer + ":" + danmu_content)
                                        
                                    }else{
                                        //print("非数据消息我是")
                                    }
                                }
                                
                            }
                        })
                        
                        
                        
                    })
                }else{
                    
                    print("登录弹幕房间失败")
                    print(Danmu_errmsg)
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.DanmuView.text = self.DanmuView.text + "连接失败\n"
                })
                print("连接失败")
                
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                
                //这里写需要大量时间的代码
                let keep_danmu_live = "type@=keeplive/tick@=\(self.time)/"
                
                while true {
                    
                    
                    (Danmu_success,Danmu_errmsg)=self.Danmu_Socket!.send(data:self.DouyuMsg(keep_danmu_live))
                    
                    print("发送心跳包")
                    sleep(30)
                }
                
            })
            
            
            
            
            
            
        })
        
    }
    
    
    
    func do_login_auth_danmu(room_id:String){
        
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
        //            print( "test" )
        //        });
        
        //let room_id = "56040"
        
        let vk = (String(time)+"7oE9nPEG9xXV69phU31FYCLUagKeYtsF"+uuid).md5
        let qrl = "type@=qrl/rid@=\(room_id)/"
        let logreq = "type@=loginreq/username@=/ct@=0/password@=/roomid@=\(room_id)/devid@=\(uuid)/rt@=\(time)/vk@=\(vk)/ver@=20150929/"
        let Puser = "username@=([a-z0-9_\\.-]+)/nickname"
        let Pgid = "gid@=([a-z0-9_\\.-]+)/"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            
            var (Danmu_Auth_success,errmsg)=self.Danmu_Auth_Socket!.connect(timeout: 1)
            if Danmu_Auth_success{
                dispatch_async(dispatch_get_main_queue(), {
                    self.DanmuView.text = self.DanmuView.text + "连接到认证服务器成功\n"
                })
                print("连接到认证服务器成功")
                //发送数据
                (Danmu_Auth_success,errmsg)=self.Danmu_Auth_Socket!.send(data:self.DouyuMsg(logreq))
                if Danmu_Auth_success{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.DanmuView.text = self.DanmuView.text + "登录到验证服务器\n"
                    })
                    print("发送成功")
                    var byte=self.Danmu_Auth_Socket!.read(4000)
                    var data = NSData(bytes: byte!, length: byte!.count)
                    var str = NSString(data: data.subdataWithRange(NSMakeRange(12, data.length-12)), encoding: NSASCIIStringEncoding)
                    
                    
                    
                    if str!.componentsSeparatedByString("type@=error").count > 1 {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.DanmuView.text = self.DanmuView.text + "请检查房间id\n"
                            self.DanmuView.text = self.DanmuView.text + (str! as String) + "\n"
                        })
                        print("roomid_error")
                        
                        
                        
                        
                    }else{
                        
                        if str!.componentsSeparatedByString("live_stat@=0").count > 1 {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.DanmuView.text = self.DanmuView.text + "用户离线中\n"
                            })
                            print("离线")
                            
                            
                        }else{
                            dispatch_async(dispatch_get_main_queue(), {
                                self.DanmuView.text = self.DanmuView.text + "准备登录到弹幕服务器\n"
                            })
                            print("直播中")
                            
                            let username:String = self.check(str!,pattern: Puser)  //匹配出 username
                            let danmu_login = "type@=loginreq/username@=\(username)/password@=1234567890123456/roomid@=\(room_id))"
                            print("用户名是：" + username)
                            
                            byte=self.Danmu_Auth_Socket!.read(4000)
                            data = NSData(bytes: byte!, length: byte!.count)
                            str = NSString(data: data.subdataWithRange(NSMakeRange(12, data.length-12)), encoding: NSASCIIStringEncoding)
                            
                            
                            
                            
                            let gid:String = self.check(str!,pattern: Pgid)
                            //print(str)
                            print("gid is :" + gid)
                            let danmu_join_group = "type@=joingroup/rid@=\(room_id)/gid@=\(gid)/"
                            self.Chushi_danmu_Socket(12601)
                            (Danmu_Auth_success,errmsg)=self.Danmu_Auth_Socket!.send(data:self.DouyuMsg(qrl))
                            
                            self.processClientSocket(danmu_login,danmu_join_group: danmu_join_group )
                            //byte=self.Danmu_Auth_Socket!.read(4000)
                            //byte=self.Danmu_Auth_Socket!.read(4000)
                            
                            
                            
                            //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                            
                            //这里写需要大量时间的代码
                            let keep_auth_live = "type@=keeplive/tick@=\(self.time)/vbw@=0/k@=19beba41da8ac2b4c7895a66cab81e23/"
                            while true {
                                
                                
                                (Danmu_Auth_success,errmsg)=self.Danmu_Auth_Socket!.send(data:self.DouyuMsg(keep_auth_live))
                                
                                print("发送心跳包")
                                sleep(30)
                            }
                            
                            // })
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.DanmuView.text = self.DanmuView.text + "验证服务器登陆失败\n"
                    })
                    print(errmsg)
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.DanmuView.text = self.DanmuView.text + "连接到认证服务器失败\n"
                })
                print(errmsg)
            }
            
            
        })
        
        
        
    }
    
    func Chushi_auth_Socket(Auth_ip:String,Auth_port:Int){
        Danmu_Auth_Socket = TCPClient(addr: Auth_ip, port: Auth_port)
        
        
        
        
    }
    
    func Chushi_danmu_Socket(Danmu_port:Int){
        
        
        Danmu_Socket = TCPClient(addr: "danmu.douyutv.com", port: Danmu_port)
        
        
    }
    func RmtpLoadData(room_id:String){
        //创建NSURL对象
        let url_prefix:String = "http://douyutv.com/api/v1/"
        let md5url:String = "room/\(room_id)?aid=android&client_sys=android&time=\(self.time)"
        let auth_str:String = md5url + "1231"
        let url_t:String = url_prefix + md5url + "&auth=" + auth_str.md5
        //print(urlString)
        let url:NSURL! = NSURL(string:url_t)
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
            let Rtmp_json : AnyObject! = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
            //print(Rtmp_json)
            //print(channljson)
            
            if let Rtmp_list = Rtmp_json.objectForKey("data") as? NSDictionary{
                let currentRtmpDataSource = NSMutableArray()
                let Rtmp_Items = Rtmp_room_Info()
                // print("xx")
                if Rtmp_list["show_status"] as! NSString == "1"{
                    
                    
                    
                    
                    Rtmp_Items.Rtmp_url = Rtmp_list["rtmp_url"] as! NSString
                    Rtmp_Items.Rtmp_live = Rtmp_list["rtmp_live"] as! NSString
                    Rtmp_Items.Rtmp_multi_bitrate = Rtmp_list["rtmp_multi_bitrate"] as! NSDictionary
                    Rtmp_Items.Danmu_Auth_Servers = Rtmp_list["servers"] as! NSArray
                    currentRtmpDataSource.addObject(Rtmp_Items)
                    self.Rtmp_Room_Info_data = currentRtmpDataSource
                    let Rtmp_data = Rtmp_Room_Info_data[0] as! Rtmp_room_Info
                    print(Rtmp_data.Danmu_Auth_Servers[0]["ip"])
                    
                    //Danmu_Auth_Socket = TCPClient(addr: "119.90.49.94", port: 8051)

                    
                    Chushi_auth_Socket(Rtmp_data.Danmu_Auth_Servers[1]["ip"] as! String,Auth_port: Int(Rtmp_data.Danmu_Auth_Servers[1]["port"] as! String)!)
                    do_login_auth_danmu(Room_id_from_Anotherview as String)
                    
                    
                    
                    
                    print("初始化完成")
                    let url = NSURL(string: (Rtmp_data.Rtmp_url as String) + "/" + (Rtmp_data.Rtmp_live as String))
                    let media = VLCMedia(URL: url)
                    mediaPlayer.media = media
                    mediaPlayer.drawable = self.movieView
                    mediaPlayer.play()
                    
                    
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.DanmuView.text = self.DanmuView.text + "用户离线中\n"
                    })
                    print("主播离线中")
                }
                
                
                
            }
            
        }
        catch {
            
            print(error)
        }
        
        //self.do_table_refresh();
        return
    }
    
    
    
    
}
