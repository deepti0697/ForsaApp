//
//  ChangePasswordViewController.swift
//  FORSA
//
//  Created by apple on 02/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        txtOldPassword.delegate = self
        txtNewPassword.delegate = self
        txtConfirmPassword.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgBack.roundCorners([.topLeft, .topRight], radius: 30)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        self.changePassApiCall()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func changePassApiCall(){
        
        self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceFor_changePassword(["old_password":self.txtOldPassword.text!,"new_password":self.txtNewPassword.text!,"confirm_password":self.txtConfirmPassword.text!] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                let message = parseData["message"].stringValue
                self.alert(message:message) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
        
    }

}

extension ChangePasswordViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
   
}
