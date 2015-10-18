//
//  ThemeContentTableViewCell.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/17/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class ThemeContentTableViewCell: UITableViewCell {

    @IBOutlet weak var themeContentLabel: myUILabel!
    @IBOutlet weak var themeContentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //文字居上分布
        themeContentLabel.verticalAlignment = VerticalAlignmentTop
        
        //添加分割线
        let btmLine = UIView(frame: CGRectMake(15, 91, UIScreen.mainScreen().bounds.width - 30, 1))
        btmLine.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        self.contentView.addSubview(btmLine)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
