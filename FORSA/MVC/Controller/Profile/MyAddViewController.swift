//
//  MyAddViewController.swift
//  FORSA
//
//  Created by sanjay mac on 26/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyAddViewController: BaseViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var totalAdsLbl: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    var myAdsArr = [myAdsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        // Do any additional setup after loading the view.
        self.myAdsAPiCall()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgBack.roundCorners([.topLeft, .topRight], radius: 30)
    }

    @IBAction func backBtnClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterBtnClicked(_ sender: UIButton) {
    }
    
    
    func myAdsAPiCall(){
        
        self.hudShow()
        ServiceClass.sharedInstance.hitServiceFor_myAds(["active":"","deactive":"","pending":"","sold":"","expired":""] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                let dataArr = parseData["data"].arrayValue
                for jsondata in dataArr{
                    let model = myAdsModel(fromJson: jsondata)
                    self.myAdsArr.append(model)
                }
                
                DispatchQueue.main.async {
                    self.totalAdsLbl.text = "Total \(self.myAdsArr.count) ads"
                    self.tblView.reloadData()
                }
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
        
    }
    
    
    
}


extension MyAddViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.myAdsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        return self.configureCell(indexPath: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        216
    }
    
    
    
    func configureCell(indexPath:IndexPath) -> UITableViewCell{
        let cell = tblView.dequeueReusableCell(withIdentifier: "MyAddTblCell", for: indexPath) as! MyAddTblCell
               
               let model = self.myAdsArr[indexPath.row]
               cell.prdNameLbl.text = model.title
               cell.totalLikeLbl.text = model.total_like
               cell.noOfWatchLbl.text = model.total_view
        cell.dateDurationLbl.attributedText = self.dateDurateAttributedText(model)
        cell.activeBtn.setTitle(model.productstatus, for: .normal)
        if let urlStr = model.file_name{
            if let url = URL(string: urlStr){
                
                cell.prdImgView.setImage(url: url)
                
            }
        }
        
        let adsFor = model.tradestatus ?? ""
        let tradeStatus = "For : " + adsFor
        let attributedString = NSMutableAttributedString(string: tradeStatus, attributes: [
          .font: UIFont(name: "PlayfairDisplay-Bold", size: 12.0)!,
          .foregroundColor: UIColor(red: 72.0 / 255.0, green: 70.0 / 255.0, blue: 70.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttributes([
          .font: UIFont(name: "PlayfairDisplay-Regular", size: 12.0)!,
          .foregroundColor: UIColor(white: 168.0 / 255.0, alpha: 1.0)
        ], range: NSRange(location: 0, length: 6))
        
        cell.tradeStatusLbl.attributedText = attributedString
        
        return cell
    }
    
    func dateDurateAttributedText(_ model:myAdsModel) -> NSMutableAttributedString {
        
        //conert date formate then assing into from Date variable
        //let createdAt = model.created_at
        
        
        let fromDate = "From " + model.created_at + " - "
        let expiryDate = "To - " + model.expiry_date
        
        let finalDate = fromDate + expiryDate
        let attributedString = NSMutableAttributedString(string: finalDate, attributes: [
          .font: UIFont(name: "PlayfairDisplay-Bold", size: 12.0)!,
          .foregroundColor: UIColor(red: 72.0 / 255.0, green: 70.0 / 255.0, blue: 70.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttributes([
          .font: UIFont(name: "PlayfairDisplay-Regular", size: 12.0)!,
          .foregroundColor: UIColor(white: 168.0 / 255.0, alpha: 1.0)
        ], range: NSRange(location: 0, length: 5))
        attributedString.addAttributes([
          .font: UIFont(name: "PlayfairDisplay-Regular", size: 12.0)!,
          .foregroundColor: UIColor(white: 168.0 / 255.0, alpha: 1.0)
        ], range: NSRange(location: 16, length: 8))
        
        return attributedString
    }
    
    

    
    
    
}
