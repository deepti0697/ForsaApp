//
//  ForgotViewController.swift
//  Maxillofacia
//
//  Created by apple on 02/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class ForgotViewController: BaseViewController {
    
    @IBOutlet weak var txtEmail     : UITextField!
    @IBOutlet weak var vwEmail      : UIView!
    @IBOutlet weak var btnSubmit     : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwEmail.setshadowWithRadius()
        txtEmail.setPlaceHolderColor(name: "phone_email")
        
    }
    override func viewDidLayoutSubviews() {
        self.view.layoutIfNeeded()
           btnSubmit.applyGradient(colours: [CustomColor.lightBlueColor,CustomColor.darkBlueColor])
       }

    @IBAction func btnSubmitAction(_ sender : UIButton) {
        
        if Validate.shared.validateForgotPassword(vc: self) {
              var userInfo = [String: Any]()
              if txtEmail.text?.isNumeric() ?? false {
                  userInfo["phone_no"] = (self.txtEmail.text?.contains("+32"))! ? self.txtEmail.text : ("+32" + (self.txtEmail.text ?? ""))
              } else {
                  userInfo["email"] = self.txtEmail.text
              }
              self.hudShow()
              ServiceClass.sharedInstance.hitServiceForForgotPassword(userInfo as [String : Any], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                  print_debug("response: \(parseData)")
                  self.hudHide()
                  let user = User(fromJson:parseData)
                  if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                    
                      
                  } else {
                      
                      self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                  }
              })
              
          }
    }

}
