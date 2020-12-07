//
//  ProductSubCategoryVC.swift
//  FORSA
//
//  Created by apple on 26/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductSubCategoryVC: BaseViewController {

    @IBOutlet weak var tblCategory: UITableView!
     @IBOutlet weak var vwMain: UIView!
    
        var catArr = [CategoryDTo]()
    
   var isCategory = true
   var cat_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        tblCategory.delegate = self
               tblCategory.dataSource = self

        imageButtom.image = imageButtom.image?.withRenderingMode(.alwaysTemplate)
        imageButtom.tintColor = UIColor.white
        self.navTitle.text = isCategory ? "Product Category" : "Sub Category"
        self.navTitle.textColor = .white
        getCategory()
    }
    
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          vwMain.roundCorners([.topLeft, .topRight], radius: 30)
      }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCategory() {
        
        
        if isCategory{
            self.hudShow()
            
           
            ServiceClass.sharedInstance.hitServiceForGet_PrdCategory([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                         print_debug("response: \(parseData)")
                         self.hudHide()
                
                if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                    self.catArr.removeAll()
                    for obj in parseData["data"].arrayValue {
                        self.catArr.append(CategoryDTo(fromJson: obj))
                    }
                    
                    DispatchQueue.main.async {
                        self.tblCategory.reloadData()
                    }
                    
                } else {
                    
                    self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                }
            })
        }else{
            self.hudShow()
            
            ServiceClass.sharedInstance.hitServiceFor_SubPrdCategory(["cat_id":self.cat_id] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                         print_debug("response: \(parseData)")
                         self.hudHide()
                
                if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                    self.catArr.removeAll()
                    for obj in parseData["data"].arrayValue {
                        self.catArr.append(CategoryDTo(fromJson: obj))
                    }
                    
                    DispatchQueue.main.async {
                        self.tblCategory.reloadData()
                    }
                    
                } else {
                    
                    self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                }
            })
        }
             

         }

}

extension ProductSubCategoryVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.catArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        let catObj = catArr[indexPath.row]
        cell.lblName.text = isCategory ? catObj.cat_name : catObj.subcat_name// catObj.cat_name
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCategory  {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "productSubCategoryVC") as! ProductSubCategoryVC
            vc.isCategory = false
            vc.cat_id = catArr[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "productAddViewController") as! ProductAddViewController
                      self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
