//
//  SignUPWithPhoneVC.swift
//  FORSA
//
//  Created by sanjay mac on 12/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUPWithPhoneVC: BaseViewController {
    
    @IBOutlet weak var txtMobile: UITextField!
    
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var signUPwithEmailLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        backButton.isHidden = false
               txtMobile.placeholder = "Phone number"
               self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextBtnClicked(_ sender: UIButton) {
        
        signUpActionWithMobile()
    }
    
    @IBAction func btnTickAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func signUPWithEmailClicked(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func signUpActionWithMobile() {
       if Validate.shared.validateMobileWithSignUp(vc: self) {
                     var userInfo = [String: Any]()
                         userInfo["mobile"] = self.txtMobile.text
                         userInfo["register_type"] = "1"
                     self.hudShow()
                     ServiceClass.sharedInstance.hitServiceForRegister_New(userInfo as [String : Any], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                         print_debug("response: \(parseData)")
                        self.hudHide()
                        
                        if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                            
                            let user = User(fromJson: parseData)
                            AppHelper.setStringForKey(user.token, key: ServiceKeys.token)
                            
                            Common.showAlert(alertMessage: parseData["message"].stringValue, alertButtons: ["Ok"]) { (btn) in
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "oTPViewController") as! OTPViewController
                                vc.phonenumber = self.txtMobile.text ?? ""
                                vc.user = user
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                        } else {
                         
                            Common.showAlert(alertMessage: (errorDict?[ServiceKeys.keyErrorMessage] as? String), alertButtons: ["Ok"]) { (bt) in
                           }
                           
                           
                         }
                     })
                     
                 }
       }
}
