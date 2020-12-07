//
//  OTPViewController.swift
//  FORSA
//
//  Created by apple on 25/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SVPinView
import SwiftyJSON
import SwiftyAttributes


class OTPViewController: BaseViewController {
    
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var vwSVP: SVPinView!
    
    var user: User?
    var phonenumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.navigationController?.setNavigationBarHidden(false, animated: true)
        vwSVP.style = .none
        vwSVP.pinLength = 4


      let magenta = "OTP have sent OTP on your mobile number ".withAttributes([
        .textColor(UIColor(red: 47/255, green: 48/255, blue: 48/255, alpha: 1.0)),
          .font(.systemFont(ofSize: 14.0))
          ])
      let cyan = "\(phonenumber).".withAttributes([
         .textColor(UIColor(red: 47/255, green: 48/255, blue: 48/255, alpha: 1.0)),
          .font(.boldSystemFont(ofSize: 14.0))
          ])
      let green = " Please verify.".withAttributes([
         .textColor(UIColor(red: 47/255, green: 48/255, blue: 48/255, alpha: 1.0)),
          .font(.systemFont(ofSize: 14.0))
          ])
  
      let finalString = magenta + cyan + green
        lblPhone.attributedText = finalString
       
    }
    
    @IBAction func btnResendAction(_ sender: Any) {
        
    
                                 var userInfo = [String: Any]()
                                     userInfo["mobile"] = self.phonenumber
                                 self.hudShow()
                                 ServiceClass.sharedInstance.hitServiceForOTPLogin(userInfo as [String : Any], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                                     print_debug("response: \(parseData)")
                                     self.hudHide()
                                     
                                     if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                                         
                                        Common.showAlert(alertMessage: parseData["message"].stringValue, alertButtons: ["Ok"]) { (btn) in
                                        }
                                     } else {
                                     
                                       guard let dicErr = errorDict?[ServiceKeys.keyErrorDic] as? [String : JSON] else {
                                           return
                                       }
                                       Common.showAlert(alertMessage: (dicErr["login"]?.stringValue)!, alertButtons: ["Ok"]) { (bt) in
                                       }
                                       
                                       
                                     }
                                 })
                                 
                             }
                   
        
    
    
 
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        var pinStr = ""
        var userInfo = [String: Any]()
    
        if vwSVP.getPin().count < 4 {
            Common.showAlert(alertMessage: "Please enter valid OTP", alertButtons: ["Ok"]) { (btn) in }
            return
        } else {
            userInfo["otp"] = vwSVP.getPin()
        }
        
        self.hudShow()
        ServiceClass.sharedInstance.hitServiceForOTPSend(userInfo as [String : Any],token: self.user?.token ?? "", completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
            print_debug("response: \(parseData)")
            self.hudHide()
            
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                AppHelper.setStringForKey(self.user?.full_name!, key: ServiceKeys.full_name)
                AppHelper.setStringForKey(self.user?.email, key: ServiceKeys.email)
                AppHelper.setStringForKey(self.user?.mobile, key: ServiceKeys.phone_no)
                AppHelper.setStringForKey(self.user?.token, key: ServiceKeys.token)
                AppHelper.setStringForKey(self.user?.id, key: ServiceKeys.user_id)
                kApplicationDelegate.setHomeView()
                
                
            } else {
                
                guard let dicErr = errorDict?[ServiceKeys.keyErrorDic] as? [String : JSON] else {
                    return
                }
                Common.showAlert(alertMessage: (dicErr["login"]?.stringValue)!, alertButtons: ["Ok"]) { (bt) in
                }
                
                
            }
        })
        
    }
    
    
    
    
}


