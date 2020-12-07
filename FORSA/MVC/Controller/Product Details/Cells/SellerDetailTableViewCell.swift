//
//  SellerDetailTableViewCell.swift
//  FORSA
//
//  Created by apple on 28/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SellerDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnWhatsApp: UIButton!
    
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnMail: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
