//
//  UIFeedView.swift
//  FirstApp
//
//  FeedView
//
//  Created by ccfyyn on 15/12/16.
//  Copyright © 2015年 ccfyyn. All rights reserved.
//
import Foundation
import UIKit

public class UIFeedView: UIScrollView, UIScrollViewDelegate {
    // 垂直边距
    public var verticalSpacing:CGFloat = 4.0
    // 水平边距
    public var horizontalSpacing:CGFloat = 4.0
    // 数据源代理
    weak public var dataSource:UIFeedViewDataSource?
    // 列的高度
    var columnsHeight:[CGFloat]?
    // 所有Items的frame
    var itemFrames: Array<CGRect> = Array<CGRect>()
    // reuse的UIFeedViewCell
    var reuseDequeue: Array<UIFeedViewCell> = Array<UIFeedViewCell>()
    // 当前在显示的UIFeedViewCell
    var currentCells: Dictionary<Int, UIFeedViewCell> = Dictionary<Int, UIFeedViewCell>()
    
    public func reloadData(){
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("onTap:"))
        addGestureRecognizer(tapGesture)
        // 监听滚动事件
        self.delegate = self
        // 清除全部数据
        itemFrames.removeAll()
        //
        reuseDequeue.removeAll()
        //
        currentCells.removeAll()
        // 删除所有的View
        for view in subviews.enumerate(){
            view.element.removeFromSuperview()
        }
        //
        if let del = dataSource {
            // var height = 0
            let columns = del.numberOfColumns()
            columnsHeight = [CGFloat](count: columns, repeatedValue: 0)
            // itemWidth
            let itemWidth = (bounds.size.width - CGFloat(columns - 1) * horizontalSpacing - contentInset.left - contentInset.right) / CGFloat(columns)
            // 总数据条数
            let items = del.numberOfDatas()
            // 遍历所有item的size
            for item in 0..<items {
                let size = del.sizeOfItem(item, itemWidth: itemWidth)
                let scale = itemWidth / size.width
                let itemHeight = size.height * scale
                let nextColTopY = getNextColumnToInsert(columns)
                let indexColumn = nextColTopY.index
                let indexTopY = nextColTopY.minValue
                let rect = CGRectMake(CGFloat(indexColumn) * (itemWidth + horizontalSpacing), indexTopY + verticalSpacing, itemWidth, itemHeight)
                itemFrames.append(rect)
                // 更新columnsHeight
                columnsHeight![indexColumn] = indexTopY + verticalSpacing + itemHeight
            }
            // 设置自向contentSize
            self.contentSize = CGSizeMake(bounds.size.width - contentInset.left - contentInset.right, getMaxY(columns))
            //
            scrollViewDidScroll(self)
        }
    }
    
    // 获取下一个Item需要插入的列和topY
    func getNextColumnToInsert(columns:Int) ->(index:Int, minValue:CGFloat) {
        var index = 0
        var min = CGFloat.max
        var i = 0
        for i = 0; i < columns; i++ {
            if columnsHeight![i] < min {
                min = columnsHeight![i]
                index = i
            }
        }
        return (index, min)
    }
    
    // 获取contentSize对应的最大高度
    func getMaxY(columns:Int) ->CGFloat{
        var max = CGFloat.min
        for h in columnsHeight! {
            if h > max {
                max = h
            }
        }
        return max
    }
    
    // UIScrollView 滚动事件
    public func scrollViewDidScroll(scrollView: UIScrollView){
        var findFirst = false
        var i = 0
        for rect in itemFrames {
            // 位置i对应的 cell 不为空
            if let cell = currentCells[i] {
                if rectIsInScreen(cell.frame) { // cell 在当前屏幕中 -> 不做处理
                    if !findFirst {
                        findFirst = true
                    }
                    i++
                    continue
                } else { // cell 不在当前屏幕中 -> 加入 reuse 列表
                    reuseDequeue.append(cell)
                    // 置空 key 为 i 的cell
                    currentCells[i] = nil
                    // 从SuperView移除
                    cell.removeFromSuperview()
                }
            }
            // 该item当前在屏幕内
            if rectIsInScreen(rect){
                if !findFirst {
                    findFirst = true
                }
                let cell = dataSource!.cellForItem(self, item:i)
                // 设置frame
                cell.frame = itemFrames[i]
                // 保存到当前显示列表中
                currentCells[i] = cell
                // 添加到self
                self.addSubview(cell)
            } else {
                if findFirst { // 之前已经找到位于当前屏幕上的view -> 结束循环
                    break
                }
            }
            i++
        }
    }
    
    // 获取重用的cell
    public func dequeueReusableCellWithIdentifier(identifier:String) ->UIFeedViewCell? {
        for clgroup in reuseDequeue.enumerate() {
            if(clgroup.element.identifier == identifier){
                let cell = reuseDequeue.removeAtIndex(clgroup.index) // 从reuse列表中移除
                return cell
            }
        }
        return nil
    }
    
    // rect 是否在当前屏幕内
    func rectIsInScreen(rect:CGRect) ->Bool {
        var fm = bounds
        let size = contentOffset
        fm.origin = size
        return !(CGRectGetMaxY(rect) < fm.origin.y || CGRectGetMinY(rect) > CGRectGetMaxY(fm))
    }
    
    // onTap点击事件
    func onTap(gesture:UIGestureRecognizer) {
        let point = gesture.locationInView(self)
        var i = 0
        for rect in itemFrames {
            if rect.contains(point){
                if dataSource!.respondsToSelector("feedView:didSelectItemAtIndex:"){
                    dataSource!.feedView!(self, didSelectItemAtIndex: i)
                }
                break
            }
            i++
        }
    }
}

@objc public protocol UIFeedViewDataSource : NSObjectProtocol {
    // 列数
    func numberOfColumns() ->Int
    // 总数据条数
    func numberOfDatas() ->Int
    // 指定item位置的尺寸size
    func sizeOfItem(item:Int, itemWidth:CGFloat) ->CGSize
    // 指定item位置的UIFeedViewCell
    func cellForItem(feedView:UIFeedView, item:Int) ->UIFeedViewCell
    // 选中了某一项
    optional func feedView(feedView:UIFeedView, didSelectItemAtIndex item: Int)
}

public class UIFeedViewCell: UIView {
    var identifier:String
    
    init(identifier:String) {
        self.identifier = identifier
        super.init(frame:CGRectZero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
