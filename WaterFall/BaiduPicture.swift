//
//  BaiduPicture.swift
//  FirstApp
//
//  Created by ccfyyn on 15/12/17.
//  Copyright © 2015年 ccfyyn. All rights reserved.
//

import Foundation

/**
 * 百度图片实体类
*/
public class BaiduPicture {
    var date = ""
    var downloadUrl = ""
    
    var imageUrl = ""
    var imageWidth = 0 // 499
    var imageHeight = 0 // 700
    
    var title = ""
    
    var thumbLargeTnUrl = ""
    var thumbLargeTnWidth = 0 // 400
    var thumbLargeTnHeight = 0 // 561
    
    var thumbLargeUrl = ""
    var thumbLargeWidth = 0 // 310
    var thumbLargeHeight = 0 // 434
    
    var thumbnailUrl = ""
    var thumbnailWidth = 0 // 230
    var thumbnailHeight = 0 // 322
    
    convenience init(dictionary xx:Dictionary<String, AnyObject>){
        self.init()
        
        date = xx["date"]!.description
        downloadUrl = xx["downloadUrl"]!.description
        
        imageUrl = xx["imageUrl"]!.description
        imageWidth = Int(xx["imageWidth"]!.description)!
        imageHeight = Int(xx["imageHeight"]!.description)!
        
        title = xx["title"]!.description
        
        thumbLargeTnUrl = xx["thumbLargeTnUrl"]!.description
        thumbLargeTnWidth = Int(xx["thumbLargeTnWidth"]!.description)!
        thumbLargeTnHeight = Int(xx["thumbLargeTnHeight"]!.description)!
        
        thumbLargeUrl = xx["thumbLargeUrl"]!.description
        thumbLargeWidth = Int(xx["thumbLargeWidth"]!.description)!
        thumbLargeHeight = Int(xx["thumbLargeHeight"]!.description)!
        
        thumbnailUrl = xx["thumbnailUrl"]!.description
        thumbnailWidth = Int(xx["thumbnailWidth"]!.description)!
        thumbnailHeight = Int(xx["thumbnailHeight"]!.description)!
    }
}