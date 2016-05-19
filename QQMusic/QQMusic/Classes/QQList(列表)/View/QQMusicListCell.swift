//
//  QQMusicListCell.swift
//  QQMusic
//
//  Created by haoran on 16/5/16.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//

import UIKit

enum AnimationType {
    case Rotation
    case Translation
}


class QQMusicListCell: UITableViewCell {

    /// 歌手头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 歌曲名字
    @IBOutlet weak var songNameLabel: UILabel!
    /// 歌手名字
    @IBOutlet weak var singerNameLabel: UILabel!
    
    
    // 模型属性
    var musicM : QQMusicModel? {
        // 重写set方法
        didSet{
            if musicM?.icon != nil {
                iconImageView.image = UIImage(named: musicM!.icon!)
            }
        
            songNameLabel.text = musicM?.name
            singerNameLabel.text = musicM?.singer
            
        }
    }
    
    /// 返回QQMusicListCell
    class func cellWithTableView(tableView : UITableView) -> QQMusicListCell{
        
        let ID : String = "listCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID) as? QQMusicListCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("QQMusicListCell", owner: nil, options: nil).first  as? QQMusicListCell
        }
        return cell!
    }
    
    
    /// 动画效果
    func beginAnimation(type : AnimationType ) -> () {
        switch type {
        case .Rotation:
            // 把已有layer的动画移除
            self.layer.removeAnimationForKey("rotation")
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.values = [M_PI * 0.25, 0]
            animation.duration = 0.5
            self.layer.addAnimation(animation, forKey: "rotation")
            
        case .Translation:
            
            self.layer.removeAnimationForKey("translation")
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.values = [60, 0]
            animation.duration = 0.5
            self.layer.addAnimation(animation, forKey: "translation")
        }
        
        
    }
    
    
    // 初始化
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // 设置圆角
        iconImageView.layer.cornerRadius = iconImageView.width * 0.5
        iconImageView.layer.masksToBounds = true
        
    }

    // 重写cell高亮状态
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
