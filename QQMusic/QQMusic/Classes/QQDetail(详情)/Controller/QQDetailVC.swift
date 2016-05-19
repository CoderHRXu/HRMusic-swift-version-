//
//  QQDetailVC.swift
//  QQMusic
//
//  Created by haoran on 16/5/16.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//

import UIKit

// 专门存放属性
class QQDetailVC: UIViewController {

    /// 前景图片 1
    @IBOutlet weak var foreImageView: UIImageView!
    /// 歌曲总时长 1
    @IBOutlet weak var totalTimerLabel: UILabel!
    /// 歌曲名 1
    @IBOutlet weak var songNameLabel: UILabel!
    /// 歌手名 1
    @IBOutlet weak var singerNameLabel: UILabel!
    /// 背景图片 1
    @IBOutlet weak var backImageView: UIImageView!
    
    /// 播放/暂停按钮 待定
    @IBOutlet weak var playOrPauseBtn: UIButton!


    
    /// 歌词的背景视图(做动画使用) 0
    @IBOutlet weak var LrcBackView: UIScrollView!
    
    /// 已经播放的时长 n
    @IBOutlet weak var costTimeLabel: UILabel!
    /// 进度条 n
    @IBOutlet weak var slider: UISlider!
    /// 歌词显示框 n
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    
    
    /// 歌词视图
    lazy var lrcTVC : QQLrcTVC = {
        let tvc = QQLrcTVC()
        return tvc
    }()
    
    /// 定时器
    var timer : NSTimer?
    
    /// 
    var displayLink : CADisplayLink?
 
    // 移除通知
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // 添加手势
    
}



// MARK:- 数据展示
extension QQDetailVC{
    
    // 当歌曲切换的时候,更新一次
    func setupDataOnce() -> () {
        
        let musicMessageModel = QQMusicOperationTool.shareInstance.getNewMessageModel()
        
        
        /// 前景图片 1
        
        let image = UIImage(named: (musicMessageModel.musicM?.icon)!)
        foreImageView.image = image
        /// 背景图片 1
        backImageView.image = image
        /// 歌曲总时长 1
        totalTimerLabel.text = musicMessageModel.totalTimeFormat
        /// 歌曲名 1
        songNameLabel.text = musicMessageModel.musicM?.name
        /// 歌手名 1
        singerNameLabel.text = musicMessageModel.musicM?.singer
        
        
        // 歌词数据源
        // 1. 获取歌词数据源
        let lrcMs = QQLrcDataTool.getLrcData((musicMessageModel.musicM?.lrcname)!)
//        print(lrcMs)
        // 2. 交给歌词展示控制器, 来显示歌词
        lrcTVC.dataSource = lrcMs
        
        
        
        // 给前景图添加动画
        addRotationAnimation()
        
        if musicMessageModel.isPlaying{
            resumeRotationAnimation()
        }else{
            pauseRotationAnimation()
        }
       
    }

    // 更新多次
    func setupDataTimes() -> () {
        
        let musicMessageModel = QQMusicOperationTool.shareInstance.getNewMessageModel()
        /// 已经播放的时长 n
        costTimeLabel.text = musicMessageModel.costTimeFormat
        /// 进度条 n
        slider.value = Float( musicMessageModel.costTime / musicMessageModel.totalTime)
        // 播放或者暂停按钮 待定
        playOrPauseBtn.selected = musicMessageModel.isPlaying
    }

    // 更新歌词(更新频率问题, 要求更新非常频繁)
    func updateLrc() -> (){
        
        let musicMessageModel = QQMusicOperationTool.shareInstance.getNewMessageModel()
        
        // 1.获取滚动的行号
        let rowLrcM = QQLrcDataTool.getRowLrcM(musicMessageModel.costTime, lrcMs: lrcTVC.dataSource)
        
        // 2.交给歌词展示控制器, 来滚动
        lrcTVC.scroll = rowLrcM.row
        
        // 3.给歌词标签赋值
        let lrcM = rowLrcM.lrcM
        lrcLabel.text = lrcM.lrcStr
        
        // 4.给歌词标签进度赋值
        let value = (musicMessageModel.costTime - lrcM.beginTime)/(lrcM.endTime - lrcM.beginTime)
        lrcLabel.progress = value
        
        // 5.给歌词列表标签赋值
        lrcTVC.progress = value
        
        // 6.设置锁屏信息
        // 前台不更新, 后台更新
        let state = UIApplication.sharedApplication().applicationState
        // Active    前台
        // Inactive
        // Background 后台

        if state == .Background {
            
            QQMusicOperationTool.shareInstance.setupLockMessage()
        }
       
        
        
    }
    
    
    // 添加定时器
    func addTimer() -> () {
        timer = NSTimer(timeInterval: 1, target: self, selector: #selector(setupDataTimes), userInfo: nil, repeats: true)
        
        // 加到runloop
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    // 移除定时器
    func removeTimer() -> () {
        timer?.invalidate()
        timer = nil
    }

    //
    func addDisplayLink() -> () {
        displayLink = CADisplayLink(target: self, selector: #selector(updateLrc))
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func removeDisplayLink() -> () {
        displayLink?.invalidate()
        displayLink = nil
    }
    
}

// MARK:- 业务逻辑
extension QQDetailVC{
    
    // 注意: 在视图加载好之后, 有可能, 里面拿到的不是真实的最终frame, 有可能是xib, 里面的大小
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewOnce()
    
        // 添加通知监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(nextSong), name: kPlayDidFinishNotification, object: nil)
    }
    
    /// 返回列表界面
    @IBAction func close(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    /// 下一首按钮点击
    @IBAction func nextSong() {
        QQMusicOperationTool.shareInstance.nextSong()
        setupDataOnce()
    }
    
    /// 上一首按钮点击
    @IBAction func previousSong() {
        QQMusicOperationTool.shareInstance.previousSong()
        setupDataOnce()
    }
    
    /// 播放或者暂停
    @IBAction func playOrPause(sender: UIButton) {
        
        // 状态取反
        sender.selected = !sender.selected
        if sender.selected {
            // 播放音乐
            QQMusicOperationTool.shareInstance.playCurrentMusic()
            // 继续动画
            foreImageView.layer.resumeAnimate()
        }else{
            // 暂停音乐
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
            // 暂停动画
            foreImageView.layer.pauseAnimate()
        }
        
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupFrame()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addTimer()
        setupDataOnce()
        addDisplayLink()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
        removeDisplayLink()
    }
    
    // 进度条逻辑处理
    /// 进度条按下
    @IBAction func sliderTouchDown(sender: UISlider) {
        
        removeTimer()
        
        
        
    }
    
    // 添加定时器啊
    // 并且, 控制当前的播放进度
    @IBAction func sliderTouchUp(sender: UISlider) {
        
        addTimer()
        let totalTime = QQMusicOperationTool.shareInstance.getNewMessageModel().totalTime
        let currentTime = totalTime * Double(sender.value)
        
        // 2. 设置当前播放进度
        QQMusicOperationTool.shareInstance.tool.seekTo(currentTime)
    }
    
    
    /// 进度条值改变
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        
        // 1. 计算当前时间(0-1)
        // 总时长
        let totalTime = QQMusicOperationTool.shareInstance.getNewMessageModel().totalTime
        let currentTime =  totalTime * Double(sender.value)
        
        costTimeLabel.text = QQTimeTool.getFormatTime(currentTime)
    }
    
    
    // 摇一摇切歌
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if event?.type == .Motion {
            print("开始摇一摇")
            QQMusicOperationTool.shareInstance.nextSong()
            // 设置数据
            setupDataOnce()
        }
        
    }

    
}

extension QQDetailVC : UIGestureRecognizerDelegate{
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool{
        
        // 1.计算比例
        let curP = touch.locationInView(slider)
        let value = curP.x / slider.size.width
        
        // 2.算出时间
        let totalTime = QQMusicOperationTool.shareInstance.getNewMessageModel().totalTime
        let currentTime = totalTime * Double(value)
        
        // 3. 设置当前播放进度
        slider.value = Float(value)
        QQMusicOperationTool.shareInstance.tool.seekTo(currentTime)
        
        return true
    }
    
}



// MARK:- 界面处理
extension QQDetailVC{
   
    // 设置视图
    func setupViewOnce() ->(){
        setUpSlider()
        setupLrcView()
    }
    
    // 设置frame
    func setupFrame() -> () {
        setupForeImageView()
        setupLrcViewFrame()
    }
    
    
    
    // 设置前景圆角图片
    func setupForeImageView() -> () {
        foreImageView.layer.cornerRadius = foreImageView.width * 0.5
        foreImageView.layer.masksToBounds = true
    }
    
    
    // 负责添加控件1 次
    func setupLrcView() -> () {
        
        // 1.创建歌词视图
        lrcTVC.tableView.backgroundColor = UIColor.clearColor()

        // 2.添加到滚动视图
        LrcBackView.addSubview(lrcTVC.tableView!)
        // 分页效果
        LrcBackView.pagingEnabled = true
        // 水平滚动指示器
        LrcBackView.showsHorizontalScrollIndicator = false
        
    }
    
    
    // 布局  N次(准确说, 是执行多少次都没有关系的), 放到有可能不是一次的方法中执行
    func  setupLrcViewFrame() -> () {
        // 修改调整到争取的frame 
        lrcTVC.tableView.frame = LrcBackView.bounds
        lrcTVC.tableView.x = LrcBackView.bounds.width
        LrcBackView.contentSize = CGSizeMake(LrcBackView.width * 2, LrcBackView.height)
    }

    // 设置进度条
    func setUpSlider() -> () {
        
        slider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), forState: UIControlState.Normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchSlider))
        tap.delegate = self
        slider.addGestureRecognizer(tap)
    }

    func touchSlider() -> () {
        print("点击进度条")
    }
    
    // 设置状态栏
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}




// MARK:- 动画处理
extension QQDetailVC:UIScrollViewDelegate{

    /// 添加旋转动画
    func addRotationAnimation() -> () {
        
        // 1.移除之前的动画
        foreImageView.layer.removeAnimationForKey("rotation")
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = M_PI * 2
        animation.duration = 40
        animation.repeatCount = MAXFLOAT
        
        // 设置播放完成之后, 不移除
        animation.removedOnCompletion = false
        
        foreImageView.layer.addAnimation(animation, forKey: "rotation")
        
    }
    
    // 暂停动画
    func pauseRotationAnimation() -> () {
        
        foreImageView.layer.pauseAnimate()
    }
    
    // 继续动画
    func resumeRotationAnimation() -> () {
        foreImageView.layer.resumeAnimate()
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let alpha = 1 - scrollView.contentOffset.x / scrollView.width
        
         // 设置透明度(0.0 - 1.0)
        foreImageView.alpha = alpha
        lrcLabel.alpha = alpha
        
    }

}


// MARK:- 远程事件处理
extension QQDetailVC{
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        let type = (event?.subtype)!
        switch type {
        case .RemoteControlPlay:
            print("播放")
            QQMusicOperationTool.shareInstance.playCurrentMusic()
        case .RemoteControlPause:
            print("暂停")
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
        case .RemoteControlNextTrack:
            print("下一首")
            QQMusicOperationTool.shareInstance.nextSong()
        case .RemoteControlPreviousTrack:
            QQMusicOperationTool.shareInstance.previousSong()
            print("上一首")
        default:
            print("不处理")
        }
        // 更新界面数据
        setupDataOnce()
        
    }
}


