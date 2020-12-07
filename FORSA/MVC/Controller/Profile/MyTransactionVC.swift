//
//  MyTransactionVC.swift
//  FORSA
//
//  Created by sanjay mac on 18/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyTransactionVC: BaseViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var imgBack: UIImageView!
    var transactionArr = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        self.transactionApiCall()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgBack.roundCorners([.topLeft, .topRight], radius: 30)
    }

    @IBAction func backBtnClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func transactionApiCall(){
    
    
        self.hudShow()
       
        ServiceClass.sharedInstance.hitServiceFor_TransactionRecord([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                self.transactionArr.removeAll()
                for obj in parseData["data"].arrayValue {
                    self.transactionArr.append(obj)
                }
                
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })

         

     }
    
}

extension MyTransactionVC:UITableViewDelegate,UITableViewDataSource,detailBtnDelegate{
    
    
    func detailBtntapped(index: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailVC") as! TransactionDetailVC
        let id = self.transactionArr[index]
        vc.trans_id = id["id"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTransactionTableCell", for: indexPath) as! MyTransactionTableCell
        
        let data = self.transactionArr[indexPath.row]
        if let url = URL(string: data["productimg"].stringValue){
                       cell.imgView.setImage(url: url, placeholder: nil, completion: nil)
                   }
        cell.productNameLbl.text = data["title"].stringValue
        cell.dateLbl.text = data["transactiondate"].stringValue
        cell.delegate = self
        cell.viewDetailBtn.tag = indexPath.row
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
}
