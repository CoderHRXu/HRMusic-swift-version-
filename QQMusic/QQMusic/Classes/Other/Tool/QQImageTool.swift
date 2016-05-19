//
//  QQImageTool.swift
//  QQMusic
//
//  Created by haoran on 16/5/18.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//

import UIKit

class QQImageTool: NSObject {

    /// 根据图片和歌词生成一张新的锁屏图片
    class func getNewImageFrom(sourceImage : UIImage , str : String) -> UIImage {
        
        let size = sourceImage.size
        
        // 1.开启图形上下文
        UIGraphicsBeginImageContext(size)
        
        // 2.绘制大的图片
        sourceImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        // 3.绘制文字
        // 居中对齐
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.alignment = .Center
        
        let dic: [String : AnyObject] = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSParagraphStyleAttributeName: style,
            NSFontAttributeName: UIFont.systemFontOfSize(18)
        ]

        
        (str as NSString).drawInRect(CGRectMake(0, size.height - 24, size.width, 24), withAttributes: dic)
        
        // 4.获取最终图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5.关闭上下文
        UIGraphicsEndImageContext()
        
        // 6.返回结果
        return resultImage
    }
    
    
}
