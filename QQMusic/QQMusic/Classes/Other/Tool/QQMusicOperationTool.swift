//
//  QQMusicOperationTool.swift
//  QQMusic
//
//  Created by haoran on 16/5/16.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//  负责的音乐播放的业务逻辑, 比如, 顺序播放, 随机播放等等

import UIKit
import MediaPlayer


class QQMusicOperationTool: NSObject {

    
    var drawRow : Int = -1
    
    
    
    private var artwork : MPMediaItemArtwork?
    
    private var musicMessageModel : QQMusicMessageModel = QQMusicMessageModel()
    
    /// 获得最新的信息
    func getNewMessageModel() -> QQMusicMessageModel {
        
        // 给属性赋值, 保证数据是最新的状态
        musicMessageModel.musicM = musicMList![index]
        
        // 已经播放的时间
        musicMessageModel.costTime = tool.player?.currentTime ?? 0
        
        // 总时长
        musicMessageModel.totalTime = tool.player?.duration ?? 0
        
        // 播放状态
        musicMessageModel.isPlaying = tool.player?.playing ?? false
        
        return musicMessageModel
    }
    
    
    
    
    // 创建单例
    static let shareInstance = QQMusicOperationTool()
    
    // 记录当前的索引
    var index = 0{
    
        didSet{
            
            if index < 0 {
                // 排除空集合
                if musicMList != nil {
                    index = musicMList!.count - 1
                }
            }
            if index > (musicMList?.count ?? 0) - 1 {
                index = 0
            }
        }
    }
    
    // 音乐播放列表
    var musicMList : [QQMusicModel]?
    
    
    
    let tool = QQMusicTool()
    
    /// 传入模型来播放歌曲
    func playMusic(musicM : QQMusicModel) -> () {
        let fileName = musicM.filename ?? ""
        
        tool.playMusic(fileName)
        
        if musicMList == nil {
            print("没有播放列表, 只能, 播放一首歌曲")
            return
        }
        // 获取当前索引
        index = (musicMList?.indexOf(musicM))!
        
    }
    
 
    
    /// 播放
    func playCurrentMusic() -> () {
        tool.resumeCurrentMusic()
    }
    
    /// 暂停
    func pauseCurrentMusic() -> () {
        tool.pauseCurrentMusic()
    }
    
    /// 下一首
    func nextSong() -> () {
        
        index += 1
        
        if let tempList = musicMList {
            // 取出模型
            let musicM = tempList[index]
            // 根据模型播放音乐
            playMusic(musicM)
            
        }
        
    }
  
    /// 上一首
    func previousSong() -> () {
        
        index -= 1
        
        if let tempList = musicMList {
            // 取出模型
            let musicM = tempList[index]
            // 根据模型播放音乐
            playMusic(musicM)
            
        }
        
    }
    
    /// 跳转到指定的时间点播放
    func seekTo(timerInterval : NSTimeInterval) ->() {
        
        tool.seekTo(timerInterval)
    }
    
    
}


extension QQMusicOperationTool{

    func setupLockMessage() {
        
        let musicMM = getNewMessageModel()
        
        
        
        // 展示锁屏信息
    
        // 1.获取锁屏播放中心
        let playCenter = MPNowPlayingInfoCenter.defaultCenter()
        
        // 当前正在播放的歌词信息
        // 1. 根据当前的歌词文件名称, 获取所有的歌词数据模型列表
        let lrcMs = QQLrcDataTool.getLrcData((musicMM.musicM?.lrcname)!)
        
        // 2. 根据列表, 以及当前的播放时间, 获取当前的歌词数据模型
        let rowLrcM = QQLrcDataTool.getRowLrcM(musicMM.costTime, lrcMs: lrcMs)
        
        let lrcM = rowLrcM.lrcM
        
        // 1.1 创建字典
        let songName = musicMM.musicM?.name ?? ""
        let singer = musicMM.musicM?.singer ?? ""
        let costTime = musicMM.costTime
        let totalTime = musicMM.totalTime
        
        if musicMM.musicM?.icon != nil {
            
            let image = UIImage(named: (musicMM.musicM?.icon)!)
            if image != nil {
                
            // 绘制新图片
                if drawRow != rowLrcM.row {
                    // 重新赋值
                    drawRow = rowLrcM.row
                    
                    let tempImage = QQImageTool.getNewImageFrom(image!, str: lrcM.lrcStr)
                    print("绘制了新图片")
                    artwork = MPMediaItemArtwork(image: tempImage)

                }
            }
        }
        
        var infoDic : [String : AnyObject] = [
        
            // 歌曲名称
            MPMediaItemPropertyTitle : songName,
            
            // 演唱者
            MPMediaItemPropertyArtist : singer,
        
            // 当前播放时间
            MPNowPlayingInfoPropertyElapsedPlaybackTime : costTime,
            
            // 总时长
            MPMediaItemPropertyPlaybackDuration : totalTime
        ]
        
        if artwork != nil {
            infoDic[MPMediaItemPropertyArtwork] = artwork!
        }
        
        
        // 2.给锁屏中心赋值
        playCenter.nowPlayingInfo = infoDic
        
        // 3.接受远程事件
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
    }
}

