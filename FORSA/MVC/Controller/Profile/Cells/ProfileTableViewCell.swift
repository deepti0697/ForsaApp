//
//  ProfileTableViewCell.swift
//  FORSA
//
//  Created by apple on 01/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var btnUnfollow: UIButton!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
