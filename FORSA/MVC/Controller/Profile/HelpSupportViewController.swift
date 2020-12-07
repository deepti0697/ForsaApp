//
//  HelpSupportViewController.swift
//  FORSA
//
//  Created by apple on 03/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class HelpSupportViewController: BaseViewController {

    @IBOutlet weak var navTitleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var getInTouchTitleLbl: UILabel!
    @IBOutlet weak var nameTitleLbl: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTitleLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var messageTxtView: UITextView!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTxt.delegate = self
        emailTxt.delegate = self
        messageTxtView.delegate = self
    }
    
    
    func supportFormApiCall() {
           
           self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceFor_supportform(["name" : nameTxt.text!,"email" : emailTxt.text!,"message" : messageTxtView.text!] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                        print_debug("response: \(parseData)")
                        self.hudHide()
               
               if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                   
//                   for obj in parseData["data"].arrayValue {
//                       self.catArr.append(HomeProductForGuest(fromJson: obj))
//                   }
//                            DispatchQueue.main.async {
//                                self.homeCollectionView.reloadData()
//                            }
                   
               } else {
                   
                   self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
               }

            
           })
       }
    

    @IBAction func backBtnClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        
        if (nameTxt.text?.trimmingCharacters(in: .whitespaces).count)! > 0 {
            if Utilities.isValidEmail(testStr: (nameTxt.text?.trimmingCharacters(in: .whitespaces))!) {
                
                if (messageTxtView.text?.trimmingCharacters(in: .whitespaces).count)! > 0 {
                           self.supportFormApiCall()
                       }else{
                           self.alert(message: "Please Enter Your Message")
                       }
                
            }else{
              self.alert(message: "Please Enter Valid Email")
            }
        }else{
            self.alert(message: "Please Enter Your Name")
        }
        
       
        
    }
    
}


extension HelpSupportViewController:UITextFieldDelegate,UITextViewDelegate{
    
   //MARK:- UITEXTFIELD Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    //MARK:- UITEXTView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
    }
    
}
