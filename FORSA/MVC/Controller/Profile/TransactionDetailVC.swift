//
//  TransactionDetailVC.swift
//  FORSA
//
//  Created by sanjay mac on 18/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class TransactionDetailVC: BaseViewController {

    
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var transactionDateLbl: UILabel!
    @IBOutlet weak var transactionIdLbl: UILabel!
    @IBOutlet weak var sellerNameLbl: UILabel!
    @IBOutlet weak var buyerNameLbl: UILabel!
    @IBOutlet weak var sellerImgView: UIImageView!
    @IBOutlet weak var buyerImgView: UIImageView!
    @IBOutlet weak var imgBack: UIImageView!
    var trans_id = ""
    var transDetailModel:TransactionDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transactionDetailApiCall()
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgBack.roundCorners([.topLeft, .topRight], radius: 30)
    }

    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func rateForsaBtnClicked(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductReveiwVC") as! ProductReveiwVC
        vc.prd_id = self.trans_id
        vc.trnsDetail = self.transDetailModel
               self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TransactionDetailVC{
    
    
    func transactionDetailApiCall(){
    
    
        
        self.hudShow()
       
        ServiceClass.sharedInstance.hitServiceFor_TransactionDetail(["trans_id":self.trans_id] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                let dataArr = parseData["data"].arrayValue
                
                for data in dataArr{
                    
                    let allData = TransactionDetailModel(fromJson: data)
                    self.transDetailModel = allData
                }
                
                self.setJsonData()
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })

         

     }
    
    func setJsonData(){
        if let model = self.transDetailModel{
            
            
            self.productNameLbl.text = model.title
            self.orderIdLbl.text = "Order Id: "+model.order_id
            self.buyerNameLbl.text = model.buyerusername
            self.sellerNameLbl.text = model.sellerusername
            self.transactionDateLbl.text = model.transactiondate
            self.transactionIdLbl.text = model.trans_id
            
            
            if let prdUrlStr = model.productimg{
                if let prdUrl = URL(string: prdUrlStr){
                    self.productImgView.setImage(url: prdUrl)
                }
                
            }
            
            
            if let sellerUrlStr = model.selleruserimg{
                if let sellerUrl = URL(string: sellerUrlStr){
                    self.sellerImgView.setImage(url: sellerUrl)
                }
                
            }
            
            
            if let buyerUrlStr = model.buyeruserimg{
                if let buyerUrl = URL(string: buyerUrlStr){
                    self.buyerImgView.setImage(url: buyerUrl)
                }
                
            }
            
        }
    }
    
}
