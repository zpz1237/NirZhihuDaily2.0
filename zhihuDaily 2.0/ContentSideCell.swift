//
//  ContentSideCell.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/12/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import UIKit

class ContentSideCell: UITableViewCell {

    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentPlusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置未选中状态下的Cell UI
        self.contentView.backgroundColor = UIColor(red: 19/255.0, green: 26/255.0, blue: 32/255.0, alpha: 1)
        self.contentTitleLabel.textColor = UIColor(red: 136/255.0, green: 141/255.0, blue: 145/255.0, alpha: 1)
        self.contentPlusImageView.image = UIImage(named: "plus")!.imageWithRenderingMode(.AlwaysTemplate)
        self.contentPlusImageView.tintColor = UIColor(red: 66/255.0, green: 72/255.0, blue: 77/255.0, alpha: 1)
        
        //设置选中状态下的Cell UI
        let selectedView = UIView(frame: self.contentView.frame)
        selectedView.backgroundColor = UIColor(red: 12/255.0, green: 19/255.0, blue: 25/255.0, alpha: 1)
        self.selectedBackgroundView = selectedView
        self.contentTitleLabel.highlightedTextColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
