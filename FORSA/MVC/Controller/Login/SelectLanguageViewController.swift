//
//  SelectLanguageViewController.swift
//  FORSA
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectLanguageViewController: BaseViewController {

    @IBOutlet weak var txtLanuage: UITextField!
    var langArr = [LanguageDTo]()
    var selectLangObj : LanguageDTo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtLanuage.placeholder = "Language"
        Utilities.setRightViewIcon(icon: #imageLiteral(resourceName: "arrow-point-to-right (1)"), field: txtLanuage)
        txtLanuage.delegate = self
        getLanguages()
    }
    
    @IBAction func btnNxtAction(_ sender: Any) {
      if Validate.shared.validateLanguage(vc: self) {
        submitLanguage()
        }
    }
    
    func showActionsheet(textField : UITextField) {
        let rowsArray = self.langArr.map({$0.title})
                 let placeHolder = "Language"
                 
                 let customStringPicker = ActionSheetStringPicker.init(title:placeHolder, rows: rowsArray as [Any], initialSelection: 0, doneBlock:
                 { picker, values, indexes in
                     textField.text = (String(describing: indexes!))
                     self.selectLangObj = self.langArr[values]
                     return
                 }, cancel: nil, origin: textField)
                 customStringPicker!.tapDismissAction = TapAction.cancel
                 self.view.endEditing(true)
                 customStringPicker!.show()
    }
    
    func getLanguages() {
        
        self.hudShow()
        ServiceClass.sharedInstance.hitServiceForGetAllLanguages([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()

                     if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                        for obj in parseData["data"].arrayValue {
                            self.langArr.append(LanguageDTo(fromJson: obj))
                        }
                     } else {
                         self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                     }
                 })
    }
    
    func submitLanguage() {
         
         self.hudShow()
        ServiceClass.sharedInstance.hitServiceForSubmitLanguage(["language_id": self.selectLangObj?.id ?? ""] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                      print_debug("response: \(parseData)")
                      self.hudHide()

                      if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                          
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "chooseCountryViewController") as! ChooseCountryViewController
                                                 self.navigationController?.pushViewController(vc, animated: true)

                      } else {

                          self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                      }
                  })
     }

}


extension SelectLanguageViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            showActionsheet(textField : textField)
            return false
      
       }
}
