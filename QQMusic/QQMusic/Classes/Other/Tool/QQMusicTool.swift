//
//  QQMusicTool.swift
//  QQMusic
//
//  Created by haoran on 16/5/16.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//  提供的是, 单首音乐的操作(播放, 暂停, 停止, 快进, 倍速)

import UIKit
import AVFoundation

let kPlayDidFinishNotification = "playFinish"

class QQMusicTool: NSObject {

    var player : AVAudioPlayer?
    // 具体的播放实现
    
    
    override init() {
        super.init()
        
        // 1. 获取音频会话
        let session = AVAudioSession.sharedInstance()
        
        do{
            // 2.设置音频会话类别
            try session.setCategory(AVAudioSessionCategoryPlayback)
            
            // 3.激活回话
            try session.setActive(true)
        }catch{
            print(error)
            return
        }
        
    }
    
    
    
    /// 根据文件名播放歌曲
    func playMusic(name : String) -> () {
        
        // 1. 创建播放器
        guard let url = NSBundle.mainBundle().URLForResource(name, withExtension: nil) else{
            return
        }

        if url == player?.url {
            // 播放的是同一首歌曲
            player?.play()
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
        
            // 设置代理
            player?.delegate = self
            
        }catch {
            print(error)
        }
        
        // 2. 准备播放
        player?.prepareToPlay()
        
        // 3. 开始播放
        player?.play()
    }
    
    /// 暂停播放
    func pauseCurrentMusic() -> () {
        player?.pause()
    }
    
    /// 继续播放
    func resumeCurrentMusic() -> () {
        player?.play()
    }
 
    /// 跳转到指定的时间点播放
    func seekTo(timeInterval : NSTimeInterval) ->(){
        player?.currentTime = timeInterval
    }
    
}


extension QQMusicTool:AVAudioPlayerDelegate{
    
    // 单首歌曲播放结束
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        print("歌曲播放结束")
        // 发通知
        NSNotificationCenter.defaultCenter().postNotificationName(kPlayDidFinishNotification, object: nil)
    }

}
