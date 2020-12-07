//
//  ChooseCategoryCVCell.swift
//  FORSA
//
//  Created by sanjay mac on 27/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation


class ChooseCategoryCCell:UICollectionViewCell{
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var selectionBackView: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor  =  .white
    }
    
}
