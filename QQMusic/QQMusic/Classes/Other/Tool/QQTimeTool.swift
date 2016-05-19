//
//  QQTimeTool.swift
//  QQMusic
//
//  Created by haoran on 16/5/17.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//

import UIKit

class QQTimeTool: NSObject {

    // 获得格式化后的时间文本
    class func getFormatTime (time : NSTimeInterval) -> String{
        // time 123
        // 03:12
        let min = Int(time / 60)
        
        let sec = Int(time % 60)
        
        let resultStr = String(format: "%02d:%02d", min, sec)
        
        return resultStr
    }
    
    // 把格式化后时间字符串转化为多少秒
    class func getTimeInterval(formatTime : String) -> NSTimeInterval{
    
        //  00:00.89  -> 多少秒
        let minAndSec = formatTime.componentsSeparatedByString(":")
        if minAndSec.count == 2 {
            let min = NSTimeInterval(minAndSec[0]) ?? 0
            let sec = NSTimeInterval(minAndSec[1]) ?? 0
            
            return min * 60 + sec
        }
        
        return 0
    }
    
    
    
    
}
