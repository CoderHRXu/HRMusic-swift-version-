//
//  QQLrcLabel.swift
//  QQMusic
//
//  Created by haoran on 16/5/18.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//

import UIKit

class QQLrcLabel: UILabel {

    /// 进度
    var progress :Double = 0.0 {
    
        didSet{
            setNeedsDisplay()
        }
    
    }
    
    
    // 重写绘制方法
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // 1.设置填充色
        UIColor.greenColor().set()
        
        let progressFloat = CGFloat(progress)
        
        let fillRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * progressFloat, rect.size.height)
        
        // SourceIn /* R = S*Da */
        // SourceOut /* R = S*(1 - Da) */
        UIRectFillUsingBlendMode(fillRect, .SourceIn)
        
    }


}
