//
//  QQListTVC.swift
//  QQMusic
//
//  Created by haoran on 16/5/16.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//

import UIKit

class QQListTVC: UITableViewController {

    
    /// 音乐模型数组
    var musicMs :[QQMusicModel] = [QQMusicModel](){
    
        didSet{
            tableView.reloadData()
        }
    }
    
    /// 系统初始化
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置界面
        setupUI()
        
        // 获取数据
        QQMusicDataTool.getMusicList { (musicMs) in
//            print(musicMs)
            self.musicMs = musicMs
            
            // 2. 给播放器工具类, 进行复制播放列表
            QQMusicOperationTool.shareInstance.musicMList = musicMs
        }
        
        
    }


    
    
    
   
   
}



// MARK:- 数据展示
extension QQListTVC{
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.musicMs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = QQMusicListCell.cellWithTableView(tableView)
        
        // 取出模型
        let musicM = self.musicMs[indexPath.row]
        cell.musicM = musicM
        return cell
        
    }
    
    // cell即将出现
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // 让cell做动画
        let cell = cell as! QQMusicListCell
        
        cell.beginAnimation(.Translation)
    }
    
    // 点击cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 1.拿到数据模型
        let musicM = self.musicMs[indexPath.row]
        
        // 2.根据数据模型,播放音乐
        QQMusicOperationTool.shareInstance.playMusic(musicM)
        
        // 3.跳转到详情页(执行segue)
        performSegueWithIdentifier("ToDetail", sender: nil)
    }
    
    
}


// MARK:- 界面搭建
extension QQListTVC{
    
   
    /// 提供一个统一界面设置的方法, 供外界调用
    func setupUI(){
        setupTableView()
        hideNavigationBar()
        
    }
    
    
    /// 设置tableView背景图
    private func setupTableView() -> () {
        // 设置背景图
        let backView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        tableView.backgroundView = backView
        // 设置cell高度
        tableView.rowHeight = 60;
        // 设置分割线样式
        tableView.separatorStyle = .None
    }
    
    /// 隐藏导航栏
    private func hideNavigationBar() -> () {
        navigationController?.navigationBarHidden = true
    }
    
    /// 设置状态栏颜色为白色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}



