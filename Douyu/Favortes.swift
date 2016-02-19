//
//  Favortes.swift
//  Douyu
//
//  Created by 吴锡波 on 16/1/28.
//  Copyright © 2016年 吴锡波. All rights reserved.
//


import UIKit

class Favortes:UIViewController{
    //var LivedataSource = []
    var infiniteScrollingView: UIView!
    let FavortesRoomListView=FavortesListView()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rectRect:CGRect = CGRectMake(0,20,width, 44)
        let line:CGRect = CGRectMake(0,64,width, 0.5)
        let label:UILabel = UILabel(frame:rectRect)
        label.text = "登录"
        
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(17)
        label.backgroundColor = UIColor.whiteColor()
        let linelabel:UILabel = UILabel(frame:line)
        linelabel.backgroundColor = UIColor.lightGrayColor()
        
        self.view.addSubview(label)
        self.view.addSubview(linelabel)
        
        setupInfiniteScrollingView()
        print(NSDate().timeIntervalSince1970)
        LoginView()
        //saveWithNSUserDefaults("",DouyuToken:"",DouyuTokenTime:0)
        //readWithNSUserDefaults()
        // Do any additional setup after loading the view, typically from a nib.
    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
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
    
//    func readWithNSUserDefaults() {
//        let defaults = NSUserDefaults.standardUserDefaults();
//        let DouyuId = defaults.objectForKey("DouyuId") as! NSString;
//        let DouyuToken = defaults.objectForKey("DouyuToken") as! NSString;
//        let DouyuTokenTime = defaults.objectForKey("DouyuTokenTime") as! NSInteger;
//        if DouyuId != "" && DouyuToken != "" && DouyuTokenTime != 0 {
//            if NSDate().timeIntervalSince1970 < Double(DouyuTokenTime){
//                
//               print("现实收藏列表")
//              self.navigationController!.pushViewController(FavortesRoomListView,animated:true)
//            //self.performSegueWithIdentifier("login1", sender:self)
//                
//            }
//            
//           
//        
//        }else{
//            
//            print("显示登录列表")
//        }
//        
//        //print("\(DouyuToken)");
//    }
    
 

    func LoginDouYu(){
        
        let user = self.view.viewWithTag(1001) as! UITextField
        let password = self.view.viewWithTag(1002) as! UITextField
        password.resignFirstResponder()
        user.resignFirstResponder()
        print(user.text! as NSString)
        print((password.text!.md5 as NSString))
        let urlString:String="http://www.douyutv.com/api/v1/login?aid=ios&client_sys=ios&password=\(password.text!.md5 as NSString)&time=1454401260&type=md5&username=\(user.text! as NSString)"
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
                    do  {
                        let loginjson : AnyObject! = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        //print(channljson)
                        //print(roomjson)
                        if loginjson.objectForKey("error") as! NSInteger == 0 {
                             let login_list = loginjson.objectForKey("data") as? NSDictionary
                            self.saveWithNSUserDefaults(user.text! as NSString as String,DouyuToken:login_list!["token"] as! String,DouyuTokenTime:login_list!["token_exp"] as! Int)
                            //self.performSegueWithIdentifier("login1", sender:self)
                            print("登录成功")
                            self.dismissViewControllerAnimated(true, completion:{ () -> Void in
                            //self.FavortesRoomListView.readWithNSUserDefaults()
                                print("我要确定了，你知道吗？");
                            })
                        }else{
                            print("判断error的值")
                        }
//                        if let room_list = roomjson.objectForKey("data") as? NSDictionary{
//                            print(room_list["token"])
//                            //self.RoomdataSource = currentRoomDataSource
//                            
//                        }
                        
                    }
                    catch {
                        
                        print(error)
                    }

                }
        }) as NSURLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
        
        
    }
    private func setupInfiniteScrollingView() {
        self.infiniteScrollingView = UIView(frame: CGRectMake(0, 64.5, width, height - 114))
        self.infiniteScrollingView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.infiniteScrollingView!.backgroundColor = UIColor.whiteColor()
        
        
        //print("x")
        self.view.addSubview(infiniteScrollingView)
    }
    private func LoginView() {
        let IdTextLabel = UILabel(frame:CGRectMake(self.infiniteScrollingView.frame.origin.x+30,self.infiniteScrollingView.frame.origin.y+70,60,30))
        IdTextLabel.text = "用户名:"
        IdTextLabel.textColor = UIColor.blackColor()
        IdTextLabel.textColor = UIColor.blueColor()
        
        let PwdTextLabel = UILabel(frame:CGRectMake(self.infiniteScrollingView.frame.origin.x+30,self.infiniteScrollingView.frame.origin.y+120,40,30))
        PwdTextLabel.text = "密码:"
        PwdTextLabel.textColor = UIColor.blackColor()
        PwdTextLabel.textColor = UIColor.blueColor()
        
        let IdtextField = UITextField(frame:CGRectMake(self.infiniteScrollingView.frame.origin.x+100,self.infiniteScrollingView.frame.origin.y+70,160,30))
        
        IdtextField.placeholder="请输入用户名"
        IdtextField.text="xu56124551"
        IdtextField.adjustsFontSizeToFitWidth=true
        IdtextField.clearButtonMode=UITextFieldViewMode.WhileEditing
        IdtextField.backgroundColor = UIColor.whiteColor()
        IdtextField.borderStyle=UITextBorderStyle.Line
        IdtextField.keyboardType = UIKeyboardType.ASCIICapable;
        IdtextField.tag = 1001
        
        let PwdtextField = UITextField(frame:CGRectMake(self.infiniteScrollingView.frame.origin.x+100,self.infiniteScrollingView.frame.origin.y+120,160,30))
        PwdtextField.placeholder="请输入密码"
        PwdtextField.text="Tg987123"
        PwdtextField.adjustsFontSizeToFitWidth=true
        PwdtextField.clearButtonMode=UITextFieldViewMode.WhileEditing
        PwdtextField.backgroundColor = UIColor.whiteColor()
        PwdtextField.borderStyle=UITextBorderStyle.Line
        PwdtextField.secureTextEntry=true
        PwdtextField.keyboardType = UIKeyboardType.Default;
        PwdtextField.tag = 1002
        
        
        //let LoginBtn = UIButton(frame:CGRectMake(self.infiniteScrollingView.frame.origin.x+100,self.infiniteScrollingView.frame.origin.y+200,120,60))
        let LoginBtn:UIButton = UIButton(type:.System)
        LoginBtn.frame = CGRectMake(self.infiniteScrollingView.frame.origin.x+100,self.infiniteScrollingView.frame.origin.y+150,120,60)
        LoginBtn.setTitle("登录", forState:UIControlState.Normal)
        LoginBtn.titleLabel?.font = UIFont.systemFontOfSize(30)
        LoginBtn.backgroundColor=UIColor.whiteColor()
        LoginBtn.addTarget(self,action:Selector("LoginDouYu"),forControlEvents:.TouchUpInside)
        
        
       
        
        
        //print("x")
        self.infiniteScrollingView.addSubview(IdTextLabel)
        self.infiniteScrollingView.addSubview(PwdTextLabel)
        self.infiniteScrollingView.addSubview(IdtextField)
        self.infiniteScrollingView.addSubview(PwdtextField)
        self.infiniteScrollingView.addSubview(LoginBtn)
    }
}



