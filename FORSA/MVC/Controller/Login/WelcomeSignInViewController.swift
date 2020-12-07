//
//  WelcomeSignInViewController.swift
//  FORSA
//
//  Created by apple on 05/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class WelcomeSignInViewController: BaseViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewController(withIdentifier: "welcomeRegisterViewController") as! WelcomeRegisterViewController, animated: true)
    }
    
    @IBAction func loginWithPhoneAndGmailAction(_ sender: UIButton) {
        if sender.tag == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.signWithEmail = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.signWithEmail = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func fbAction(_ sender: Any) {
    }
    
    @IBAction func googleAction(_ sender: Any) {
    }
    @IBAction func guestAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseCategoryVC") as! ChooseCategoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
