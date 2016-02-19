//
//  RoomItem.swift
//  Douyu
//
//  Created by 吴锡波 on 16/1/30.
//  Copyright © 2016年 吴锡波. All rights reserved.
//

import Foundation
class ChannlItem {
    var Gname = NSString()
    var Gonline = NSString()
    var Gcid = NSString()
}

extension String {
    var md5 : String{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
        
        CC_MD5(str!, strLen, result);
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.destroy();
        
        return String(format: hash as String)
    }
}

class RoomItem {
    var room_id = NSString()
    var room_src_img = NSString()
    var room_name = NSString()
    var room_showtime = NSString()
    var room_online = NSString()
    var room_nickname = NSString()
    var room_fans = NSString()
    var room_show_status = NSString()
    var room_vod_quality = NSString()
}

class Rtmp_room_Info {
    var Rtmp_url = NSString()
    var Rtmp_live = NSString()
    var Rtmp_multi_bitrate = NSDictionary()
    var Danmu_Auth_Servers = NSArray()
    var Room_name = NSString()
    var Room_show_details = NSString()
    var room_fans = NSString()
    var room_cdns = NSArray()
    var room_owner_weight = NSString()
    var room_show_status = NSString()
}


import UIKit

class Room_Cell: UICollectionViewCell {
    var imageView: UIImageView!
    
    var textLabel: UILabel!
    let width = UIScreen.mainScreen().bounds.size.width
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView = UIImageView(frame: CGRectMake(0, 0, (width-30)/2, ((width-30)/2)/(320/180)))
        self.textLabel = UILabel(frame:  CGRectMake(0, CGRectGetMaxY(imageView!.frame), (width-30)/2, 20))
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.textLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //self.imageView.
        //fatalError("init(coder:) has not been implemented")
    }
}

class HeaderReusableView: UICollectionReusableView {
    var headerLb:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerLb=UILabel()
        headerLb.frame=CGRectMake(5, 0, width-10, 40)
        headerLb.backgroundColor=UIColor.whiteColor()
        self .addSubview(headerLb!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class JKContactModel: NSObject,NSCoding{
    
    var DouyuId:NSString!
    var DouyuToken:NSString!
    var DouyuTokenTime:NSString!
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(self.DouyuId, forKey: "DouyuId")
        aCoder.encodeObject(self.DouyuToken, forKey: "DouyuToken")
        aCoder.encodeObject(self.DouyuTokenTime, forKey: "DouyuTokenTime")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.DouyuId = aDecoder.decodeObjectForKey("DouyuId") as! NSString!
        self.DouyuToken = aDecoder.decodeObjectForKey("DouyuToken") as! NSString!
        self.DouyuTokenTime = aDecoder.decodeObjectForKey("DouyuTokenTime") as! NSString!
    }
    
    override init() {
        
    }
    
}


