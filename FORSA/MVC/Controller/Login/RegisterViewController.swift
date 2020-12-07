//
//  RegisterViewController.swift
//  Maxillofacia
//
//  Created by apple on 02/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
//import FlagPhoneNumber
import SwiftyJSON

class RegisterViewController: BaseViewController {
    
   
    @IBOutlet weak var txtPassword  : UITextField!
    @IBOutlet weak var txtEmail     : UITextField!
//    @IBOutlet weak var txtName      : UITextField!
//    @IBOutlet weak var txtMobile    : UITextField!
      @IBOutlet weak var btnTick    : UIButton!

    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesigns()
           self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setDesigns() {
        
        transparentNavigationController()
        txtEmail.placeholder = "Email address"
        txtPassword.placeholder = "Password"
//        txtName.placeholder = "Name"
//        txtMobile.placeholder = "Phone number"
        
    }
    
    
    @IBAction func btnTickAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    override func viewDidLayoutSubviews() {
        self.view.layoutIfNeeded()
     
        
    }

 
    @IBAction func btnSignupWithNumber(_ sender: Any) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUPWithPhoneVC") as! SignUPWithPhoneVC
                  self.navigationController?.pushViewController(vc, animated: true)
       }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        
         if Validate.shared.validateRegistration(vc: self) {
//            var country_code = ""
//            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//                country_code = countryCode
//                print(countryCode)
//            }
//            var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
            

            var userInfo = [String : Any]()
//            userInfo["user_name"]    = self.txtName.text
            userInfo["password" ]    = self.txtPassword.text
            userInfo["email"]        =  self.txtEmail.text
            userInfo["register_type"]        =  "2"
//            userInfo["mobile"]          = self.txtMobile.text ?? ""
         
            print(userInfo)
            self.hudShow()
            ServiceClass.sharedInstance.hitServiceForRegister_New(userInfo , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                print_debug("response: \(parseData)")
                self.hudHide()

                if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                    
                    let user = User(fromJson:parseData)
                    print(user)
                    let mess = parseData["message"].stringValue
                    AppHelper.setStringForKey(user.full_name!, key: ServiceKeys.full_name)
                    AppHelper.setStringForKey(user.email, key: ServiceKeys.email)
                    AppHelper.setStringForKey(user.mobile, key: ServiceKeys.phone_no)
                    AppHelper.setStringForKey(user.token, key: ServiceKeys.token)
                    //                            AppHelper.setStringForKey(user.usertype, key: ServiceKeys.usertype)
                    AppHelper.setStringForKey(user.id, key: ServiceKeys.user_id)
                    
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectLanguageViewController") as! SelectLanguageViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                    self.alert(message: mess) {
                        self.navigationController?.popViewController(animated: true)
                    }
                    

                } else {

                    self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                }
            })


        }
    }
    
}

