//
//  ViewController.swift
//  FirstApp
//
//  Created by ccfyyn on 15/12/6.
//  Copyright © 2015年 ccfyyn. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController, UIFeedViewDataSource {
    
    var pictures:Array<BaiduPicture> = Array<BaiduPicture>()
    
    weak var feedView:UIFeedView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 添加FeedView
        addFeedView()
        // 获取图片流(来源:百度)
        Alamofire.request(.GET, "http://image.baidu.com/data/imgs", parameters:["col":"美女", "tag":"粉红", "sort":"0", "tag3":"", "pn":"1", "rn":"40", "p":"channel", "from":"1"])
            .responseJSON { response in
                if let obj = response.result.value?["imgs"] {
                    self.parseJsonArray(obj)
                }
        }
    }
    
    func parseJsonArray(object:AnyObject?){
        let array = object! as! Array<Dictionary<String,AnyObject>>
        for index in 0..<array.count - 1 {
            let baiduPicture = BaiduPicture(dictionary: array[index])
            if baiduPicture.imageWidth != 0 {
                pictures.append(baiduPicture)
            }
        }
        feedView?.reloadData()
    }
    
    // ------------------------------------- UIFeedView -------------------------------------
    func addFeedView(){
        let feedView = UIFeedView()
        var rect = self.view.bounds
        rect.origin.y = 20
        rect.size.height -= 20
        feedView.horizontalSpacing = 4
        feedView.verticalSpacing = 4
        feedView.dataSource = self
        feedView.frame = rect
        self.view.addSubview(feedView)
        feedView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4)
        self.feedView = feedView
    }
    
    // 列数
    func numberOfColumns() ->Int {
        return 3
    }
    // 总数据条数
    func numberOfDatas() ->Int {
        return pictures.count
    }
    // 指定item位置的尺寸size
    func sizeOfItem(item:Int, itemWidth:CGFloat) ->CGSize {
        let bdPicture = pictures[item]
        let scale = CGFloat(bdPicture.imageWidth) / itemWidth
        let size = CGSizeMake(itemWidth, CGFloat(bdPicture.imageHeight) / scale)
        return size
    }
    // 指定item位置的UIFeedViewCell
    func cellForItem(feedView:UIFeedView, item:Int) ->UIFeedViewCell {
        let bdPicture = pictures[item]
        // print(bdPicture.thumbLargeTnUrl)
        if let cell = feedView.dequeueReusableCellWithIdentifier("cell") {
            let mycell = cell as! MyCell
            mycell.imageView.kf_setImageWithURL(NSURL(string: bdPicture.thumbLargeTnUrl)!)
            return cell
        } else {
            let cell = MyCell(identifier: "cell")
            cell.imageView.kf_setImageWithURL(NSURL(string: bdPicture.thumbLargeTnUrl)!)
            return cell
        }
    }
    // 某一项被点击
    func feedView(feedView: UIFeedView, didSelectItemAtIndex item: Int) {
        print(item)
    }
}

class MyCell:UIFeedViewCell {
    var imageView:UIImageView
    var imageViewDefault:UIImageView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        imageViewDefault.frame = self.bounds
    }
    
    override init(identifier: String) {
        imageViewDefault = UIImageView()
        imageView = UIImageView()
        super.init(identifier: identifier)
        imageViewDefault.contentMode = .Center
        imageViewDefault.image = UIImage(named: "feed_placeholder")
        self.addSubview(imageViewDefault)
        self.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

