//
//  HomeSideCell.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/12/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class HomeSideCell: UITableViewCell {

    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var homeTitleLabel: UILabel!
    @IBOutlet weak var homeSwitchImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //设置Cell UI的初始状态
        self.contentView.backgroundColor = UIColor(red: 12/255.0, green: 19/255.0, blue: 25/255.0, alpha: 1)
        self.homeTitleLabel.textColor = UIColor.whiteColor()
        self.homeImageView.image = UIImage(named: "home")!.imageWithRenderingMode(.AlwaysTemplate)
        self.homeImageView.tintColor = UIColor.whiteColor()
        self.homeSwitchImageView.image = UIImage(named: "switch")!.imageWithRenderingMode(.AlwaysTemplate)
        self.homeSwitchImageView.tintColor = UIColor(red: 66/255.0, green: 72/255.0, blue: 77/255.0, alpha: 1)
        
        //设置Cell被选中的背景view及字体颜色
        let selectedView = UIView(frame: self.contentView.frame)
        selectedView.backgroundColor = UIColor(red: 12/255.0, green: 19/255.0, blue: 25/255.0, alpha: 1)
        self.selectedBackgroundView = selectedView
        self.homeTitleLabel.highlightedTextColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
