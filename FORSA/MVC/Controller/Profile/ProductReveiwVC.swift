//
//  ProductReveiwVC.swift
//  FORSA
//
//  Created by sanjay mac on 18/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductReveiwVC: BaseViewController {

    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var productNameLbl: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var productImgView: UIImageView!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    
    var prd_id = ""
    var trnsDetail:TransactionDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let model = self.trnsDetail{
            self.productNameLbl.text = model.title
            self.dateLbl.text = model.transactiondate
            
            if let urlStr = model.productimg{
                if let url = URL(string: urlStr){
                   self.productImgView.setImage(url: url)
                }
            }
            
            
        }
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgBack.roundCorners([.topLeft, .topRight], radius: 30)
    }
    
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        
        self.productReviewSubmitApiCall()
    }
    

}

extension ProductReveiwVC{
    
    
    func productReviewSubmitApiCall(){
    
    
        
        self.hudShow()
       
        ServiceClass.sharedInstance.hitServiceFor_submitRating(["prd_id":self.prd_id,"rating":"1","comment":"hello test"] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                let message = parseData["message"].stringValue
                self.alert(message: message)
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })

         

     }
}
