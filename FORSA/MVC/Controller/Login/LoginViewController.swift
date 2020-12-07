//
//  LoginViewController.swift
//  FORSA
//
//  Created by apple on 17/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: BaseViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var signInWithEmailStackView: UIStackView!
    @IBOutlet weak var txtMobile: UITextField!

    
    @IBOutlet weak var signInWithPhoneStackView: UIStackView!
    
    var signWithEmail = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtMobile.placeholder = "Phone number"
        
        // Do any additional setup after loading the view.
        txtEmail.placeholder = "Email/Username"
        txtPassword.placeholder = "Password"
        backButton.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if signWithEmail == true{
            self.signInWithEmailStackView.isHidden = false
            self.signInWithPhoneStackView.isHidden = true
        }else{
            self.signInWithEmailStackView.isHidden = true
            self.signInWithPhoneStackView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func btnForgotPasswordAction(_ sender: Any) {
        
    }
  
    @IBAction func btnLoginWithPhoneAction(_ sender: Any) {
        self.signInWithPhoneStackView.isHidden = false
        self.signInWithEmailStackView.isHidden = true
      }
    @IBAction func btnSignInWithEmailAction(_ sender: UIButton) {
          // kApplicationDelegate.setHomeView()
//        if sender.tag == 0{
//            loginAction()
//        }else{
            self.signInWithPhoneStackView.isHidden = true
            self.signInWithEmailStackView.isHidden = false
  //      }
        
       
    }
    
    func loginAction() {
       if Validate.shared.validateLogin(vc: self) {
                     var userInfo : [String: Any] = ["password" : self.txtPassword.text ?? ""]
                         userInfo["email"] = self.txtEmail.text
                               
                     self.hudShow()
                     ServiceClass.sharedInstance.hitServiceForEmailLogin(userInfo as [String : Any], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                         print_debug("response: \(parseData)")
                         self.hudHide()
                         
                         if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                             
                             let user = User(fromJson:parseData)
                             print(user)
                            AppHelper.setStringForKey(user.full_name!, key: ServiceKeys.full_name)
                            AppHelper.setStringForKey(user.total_followers!, key: ServiceKeys.total_followers)
                            AppHelper.setStringForKey(user.total_following!, key: ServiceKeys.total_following)
                            AppHelper.setStringForKey(user.email, key: ServiceKeys.email)
                            AppHelper.setStringForKey(user.mobile, key: ServiceKeys.phone_no)
                            AppHelper.setStringForKey(user.token, key: ServiceKeys.token)
                            AppHelper.setBoolForKey(true, key: "logIn")
                            AppHelper.setStringForKey(user.img_url, key: ServiceKeys.profile_image)
//                            AppHelper.setStringForKey(user.usertype, key: ServiceKeys.usertype)
                            AppHelper.setStringForKey(user.id, key: ServiceKeys.user_id)
                          // kApplicationDelegate.setHomeView()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLanguageAndCountryVC") as! ChooseLanguageAndCountryVC
                            self.navigationController?.pushViewController(vc, animated: true)
                             
                         } else {
                         
                           guard let dicStr = errorDict?[ServiceKeys.keyErrorMessage] as? String else {
                               return
                           }
                           Common.showAlert(alertMessage: dicStr, alertButtons: ["Ok"]) { (bt) in
                           }
                           
                           
                         }
                     })
                     
                 }
       }
    
    
        @IBAction func btnSignInAction(_ sender: UIButton) {
            
            if sender.tag == 0{
                loginAction()
            }else{
               loginActionWithMobile()
            }
            
             
            }
      

      

          func loginActionWithMobile() {
             if Validate.shared.validateMobile(vc: self) {
                           var userInfo = [String: Any]()
                               userInfo["mobile"] = self.txtMobile.text
                                     
                           self.hudShow()
                           ServiceClass.sharedInstance.hitServiceForOTPLogin(userInfo as [String : Any], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                               print_debug("response: \(parseData)")
                              self.hudHide()
                              
                              if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                                  
                                  let user = User(fromJson:parseData)
                                  AppHelper.setBoolForKey(true, key: "logIn")
                                  Common.showAlert(alertMessage: parseData["message"].stringValue, alertButtons: ["Ok"]) { (btn) in
                                      let vc = self.storyboard?.instantiateViewController(withIdentifier: "oTPViewController") as! OTPViewController
                                      vc.user = user
                                      vc.phonenumber = self.txtMobile.text ?? ""
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


