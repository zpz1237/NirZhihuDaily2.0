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
        self.contentView.backgroundColor = UIColor(red: 19/255.0, green: 26/255.0, blue: 32/255.0, alpha: 1)
        self.contentTitleLabel.textColor = UIColor(red: 136/255.0, green: 141/255.0, blue: 145/255.0, alpha: 1)
        self.contentPlusImageView.image = UIImage(named: "plus")!.imageWithRenderingMode(.AlwaysTemplate)
        self.contentPlusImageView.tintColor = UIColor(red: 66/255.0, green: 72/255.0, blue: 77/255.0, alpha: 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
