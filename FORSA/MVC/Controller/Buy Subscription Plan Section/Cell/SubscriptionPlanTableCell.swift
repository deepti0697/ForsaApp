//
//  SubscriptionPlanTableCell.swift
//  FORSA
//
//  Created by sanjay mac on 19/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SubscriptionPlanTableCell: UITableViewCell {
  @IBOutlet weak var radioImgView: UIImageView!
    
    @IBOutlet weak var packageTypeLbl: UILabel!
    
    @IBOutlet weak var packagePriceLbl: UILabel!
    
    @IBOutlet weak var arrowImgView: UIImageView!
    
    
    @IBOutlet weak var txtView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
