//
//  RecommendedCollectionViewCell.swift
//  FORSA
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

protocol CellButtonActionDelegate:class {
    func favBtnAction(index:Int)
    func likeBtnAction(index:Int)
}


class RecommendedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
      @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var totalLikeLbl: UILabel!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
     @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblWatch: UILabel!
    
    @IBOutlet weak var soldLbl: UILabel!
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    
    
    weak var delegate:CellButtonActionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func favBtnClicked(_ sender: UIButton) {
        
        delegate?.favBtnAction(index: sender.tag)
    }
    
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        delegate?.likeBtnAction(index: sender.tag)
    }
    
}


