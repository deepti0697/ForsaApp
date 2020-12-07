//
//  AddProduvtDetailVC.swift
//  FORSA
//
//  Created by apple on 26/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddProduvtDetailVC: BaseViewController {
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtVwPeoDetail: UITextView!
    var imagesArr = [mediamodel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "productSubCategoryVC") as! ProductSubCategoryVC
              self.navigationController?.pushViewController(vc, animated: true)
    }
    


}

extension AddProduvtDetailVC{
    func addPrdDetailApiCall(){
        if self.imagesArr.count > 0{
            
            let params:[String:Any] = ["":"","":"","":""]
            ServiceClass.sharedInstance.hitServiceForHomeProduct([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                         print_debug("response: \(parseData)")
                         self.hudHide()
                
                if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
              
                    
                } else {
                   
                }

             
            })
        }
    }
}


