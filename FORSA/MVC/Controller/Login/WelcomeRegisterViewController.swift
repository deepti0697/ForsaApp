//
//  WelcomeRegisterViewController.swift
//  FORSA
//
//  Created by apple on 05/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class WelcomeRegisterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

          self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

  @IBAction func signInAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func loginWithPhoneAndGmailAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUPWithPhoneVC") as! SignUPWithPhoneVC
           // vc.signWithEmail = false
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
            
            let storbrd = UIStoryboard(name: "Main", bundle: nil)
            let vc = storbrd.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController//self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
           // vc.signWithEmail = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        
    }
    
    @IBAction func fbAction(_ sender: Any) {
    }
    
    @IBAction func googleAction(_ sender: Any) {
    }

}
