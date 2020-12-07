//
//  ReportTableViewCell.swift
//  FORSA
//
//  Created by apple on 28/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    @IBOutlet weak var vwReport: UIView!
    @IBOutlet weak var btnSimiler: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnWishList: UIButton!
    @IBOutlet weak var vwSlide: UIView!
    @IBOutlet weak var collectionProduct: UICollectionView!
    @IBOutlet weak var btnViwAllProduct: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
