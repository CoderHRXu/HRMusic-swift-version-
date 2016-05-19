//
//  QQLrcTVC.swift
//  QQMusic
//
//  Created by haoran on 16/5/17.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//

import UIKit

class QQLrcTVC: UITableViewController {

    
    /// 歌词进度
    var progress : Double = 0.0{
        didSet{
            // 1. 获取到当前正在播放的cell
            let indexPath = NSIndexPath(forRow: scroll, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? QQLrcCell
            // 2. 给cell, progress , 赋值
            cell?.progress = progress
        }
    }

    
    /// 数据源
    var dataSource : [QQLrcModel] = [QQLrcModel](){
    
        didSet{
            tableView.reloadData()
        }
    }
    
    /// 滚动行数
    var scroll : Int  = 0 {
        didSet{
            // 防止重复滚动
            if  scroll != oldValue {
                print(scroll)
                let indexPath = NSIndexPath(forRow: scroll, inSection: 0)
                
                // 先刷新, 再做动画, 不然, 有问题
                tableView.reloadRowsAtIndexPaths(tableView.indexPathsForVisibleRows!, withRowAnimation: .Fade)
                
                tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
                
                
            }
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 清除分隔线
        tableView.separatorStyle = .None
        // 不让选中
        tableView.allowsSelection = false
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.contentInset = UIEdgeInsetsMake(tableView.height * 0.5, 0, tableView.height * 0.5, 0)
    }
    
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return dataSource.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = QQLrcCell.cellWithTableView(tableView)
        
        if indexPath.row == scroll{
            cell.progress = progress
        }else{
            cell.progress = 0
        }
        
        cell.lrcStr = dataSource[indexPath.row].lrcStr
        return cell
    }
   

   
}
