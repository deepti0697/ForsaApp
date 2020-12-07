//
//  ChooseCountryViewController.swift
//  FORSA
//
//  Created by apple on 17/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChooseCountryViewController: BaseViewController {
   
      @IBOutlet weak var txtCountry: UITextField!
    
    var countryArr = [LanguageDTo]()
    var selectedCountryObj : LanguageDTo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         txtCountry.placeholder = "Country"
               Utilities.setRightViewIcon(icon: #imageLiteral(resourceName: "arrow-point-to-right (1)"), field: txtCountry)
        txtCountry.delegate = self
        getCountry()
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        if Validate.shared.validateCountry(vc: self) {
            submitCountry()
        }
        
    }
    
    func showActionsheet(textField : UITextField) {
        let rowsArray = self.countryArr.map({$0.name})
                 let placeHolder = "Language"
                 
                 let customStringPicker = ActionSheetStringPicker.init(title:placeHolder, rows: rowsArray as [Any], initialSelection: 0, doneBlock:
                 { picker, values, indexes in
                     textField.text = (String(describing: indexes!))
                     self.selectedCountryObj = self.countryArr[values]
                     return
                 }, cancel: nil, origin: textField)
                 customStringPicker!.tapDismissAction = TapAction.cancel
                 self.view.endEditing(true)
                 customStringPicker!.show()
    }
    
 func getCountry() {
        
        self.hudShow()
        ServiceClass.sharedInstance.hitServiceForGetAllCountry([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                for obj in parseData["data"].arrayValue {
                    self.countryArr.append(LanguageDTo(fromJson: obj))
                }
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
    }
    
    func submitCountry() {
         
         self.hudShow()
        ServiceClass.sharedInstance.hitServiceForSubmitCountry(["country_id": self.selectedCountryObj?.id ?? "" ] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                      print_debug("response: \(parseData)")
                      self.hudHide()

                      if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                          
                      let vc = self.storyboard?.instantiateViewController(withIdentifier: "categoryViewController") as! CategoryViewController
                          self.navigationController?.pushViewController(vc, animated: true)

                      } else {

                          self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                      }
                  })
     }

}


extension ChooseCountryViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            showActionsheet(textField : textField)
            return false
      
       }
}
