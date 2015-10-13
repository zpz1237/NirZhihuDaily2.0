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
        self.contentView.backgroundColor = UIColor(red: 12/255.0, green: 19/255.0, blue: 25/255.0, alpha: 1)
        self.homeTitleLabel.textColor = UIColor.whiteColor()
        self.homeImageView.image = UIImage(named: "home")!.imageWithRenderingMode(.AlwaysTemplate)
        self.homeImageView.tintColor = UIColor.whiteColor()
        self.homeSwitchImageView.image = UIImage(named: "switch")!.imageWithRenderingMode(.AlwaysTemplate)
        self.homeSwitchImageView.tintColor = UIColor(red: 66/255.0, green: 72/255.0, blue: 77/255.0, alpha: 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
