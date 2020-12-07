//
//  RatingTableViewCell.swift
//  FORSA
//
//  Created by apple on 28/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Cosmos

class RatingTableViewCell: UITableViewCell {
       @IBOutlet weak var lblName: UILabel!
       @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDes: UILabel!
       @IBOutlet weak var rateVw: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
