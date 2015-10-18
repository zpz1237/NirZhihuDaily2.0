//
//  ThemeEditorTableViewCell.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/17/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class ThemeEditorTableViewCell: UITableViewCell {

    @IBOutlet weak var accessorySign: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //更改accessorySign颜色
        accessorySign.tintColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
        accessorySign.image = UIImage(named: "switch")?.imageWithRenderingMode(.AlwaysTemplate)
        
        //添加分割线
        let btmLine = UIView(frame: CGRectMake(0, 44.5, UIScreen.mainScreen().bounds.width, 0.5))
        btmLine.backgroundColor = UIColor(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1)
        self.contentView.addSubview(btmLine)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
