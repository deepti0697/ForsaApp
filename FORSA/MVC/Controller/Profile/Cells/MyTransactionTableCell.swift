//
//  MyTransactionTableVC.swift
//  FORSA
//
//  Created by sanjay mac on 18/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

protocol detailBtnDelegate:class{
    func detailBtntapped(index:Int)
}

class MyTransactionTableCell: UITableViewCell {

    
    @IBOutlet weak var viewDetailBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var productNameLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    weak var delegate:detailBtnDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func viewDetailBtnClicked(_ sender: UIButton) {
        
        delegate?.detailBtntapped(index: sender.tag)
        
    }
}
