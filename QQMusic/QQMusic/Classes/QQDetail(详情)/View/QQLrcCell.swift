//
//  QQLrcCell.swift
//  QQMusic
//
//  Created by haoran on 16/5/18.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//

import UIKit

class QQLrcCell: UITableViewCell {

    
    @IBOutlet weak var lrcContentLabel: QQLrcLabel!
    
    
    var progress :Double = 0.0{
    
        didSet{
            lrcContentLabel.progress = progress
        }
    }
    
    
    var lrcStr = ""{
        didSet{
            lrcContentLabel.text = lrcStr
        }
    }
    
    
    class func cellWithTableView(tableView : UITableView) -> QQLrcCell{
    
        let cellID = "lrcCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? QQLrcCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("QQLrcCell", owner: nil, options: nil).first as? QQLrcCell
        }
    
        return cell!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
