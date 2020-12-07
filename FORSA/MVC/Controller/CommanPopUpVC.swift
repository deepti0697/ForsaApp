//
//  CommanPopUpVC.swift
//  FORSA
//
//  Created by sanjay mac on 19/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class CommanPopUpVC: BaseViewController {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    var imgType:String = "check"
    var titleStr:String = ""
    var descriptionStr:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgView.image = UIImage(named: imgType)
        self.titleLbl.text = titleStr
        self.descriptionLbl.text = descriptionStr
    }
    
    @IBAction func okBtnClicked(_ sender: UIButton) {
        
        
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    

}
