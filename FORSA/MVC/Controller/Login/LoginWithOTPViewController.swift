//
//  LoginWithOTPViewController.swift
//  FORSA
//
//  Created by apple on 25/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginWithOTPViewController: BaseViewController {
    
    
   // @IBOutlet weak var txtMobile: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      //  txtMobile.placeholder = "Phone number"
        backButton.isHidden = true
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

//      @IBAction func btnSignInAction(_ sender: Any) {
//           loginAction()
//          }
//    
//  
//    @IBAction func btnSignInWithEmailAction(_ sender: Any) {
//        self.navigationController?.pushViewController(self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController, animated: true)
//        
//    }
//    
//
//        func loginAction() {
//           if Validate.shared.validateMobile(vc: self) {
//                         var userInfo = [String: Any]()
//                             userInfo["mobile"] = self.txtMobile.text
//                                   
//                         self.hudShow()
//                         ServiceClass.sharedInstance.hitServiceForOTPLogin(userInfo as [String : Any], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
//                             print_debug("response: \(parseData)")
//                            self.hudHide()
//                            
//                            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
//                                
//                                let user = User(fromJson:parseData)
//                                
//                                Common.showAlert(alertMessage: parseData["message"].stringValue, alertButtons: ["Ok"]) { (btn) in
//                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "oTPViewController") as! OTPViewController
//                                    vc.user = user
//                                    vc.phonenumber = self.txtMobile.text ?? ""
//                                    self.navigationController?.pushViewController(vc, animated: true)
//                                }
//                                
//                            } else {
//                             
//                                Common.showAlert(alertMessage: (errorDict?[ServiceKeys.keyErrorMessage] as? String), alertButtons: ["Ok"]) { (bt) in
//                               }
//                               
//                               
//                             }
//                         })
//                         
//                     }
//           }
}
