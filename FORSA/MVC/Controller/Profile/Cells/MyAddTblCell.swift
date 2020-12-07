//
//  MyAddTblCell.swift
//  FORSA
//
//  Created by sanjay mac on 26/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MyAddTblCell: UITableViewCell {

    
    @IBOutlet weak var totalLikeLbl: UILabel!
    @IBOutlet weak var noOfWatchLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var dateDurationLbl: UILabel!
    
    @IBOutlet weak var optionDotBtn: UIButton!
    
    @IBOutlet weak var prdNameLbl: UILabel!
    
    @IBOutlet weak var boostAdBtn: UIButton!
    @IBOutlet weak var activeBtn: UIButton!
    @IBOutlet weak var prdImgView: UIImageView!
    
    @IBOutlet weak var tradeStatusLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
