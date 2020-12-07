//
//  ProfileViewController.swift
//  FORSA
//
//  Created by apple on 01/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVerified: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var stackVerified: UIStackView!
    @IBOutlet weak var lblFollower: UILabel!
    @IBOutlet weak var tblOption: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    
 
    
    let options = [("Edit Profile","XMLID_446_"),
        ("My Ads","tag"),
        ("Subscription","refreshing"),
        ("Wishlist","heart-1"),
        ("Personalisation","visualization"),
        ("Change Password","key-1"),
        ("My Transactions","credit-card"),
        ("Settings","settings (1)"),
        ("Help & Support","call-center-agent")]
    var isCheckFromTab = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblOption.delegate = self
        tblOption.dataSource = self
        self.btnBack.isHidden = isCheckFromTab
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let totalFollowing = AppHelper.getStringForKey(ServiceKeys.total_following)
        let totalFollower = AppHelper.getStringForKey(ServiceKeys.total_followers)
        let name = AppHelper.getStringForKey(ServiceKeys.full_name)
        let imgUrl = AppHelper.getStringForKey(ServiceKeys.profile_image)
        self.lblFollowing.text = totalFollowing
        self.lblFollower.text = totalFollower
        self.lblName.text = name
        
        if let url = URL(string: imgUrl){
            self.imgUser.setImage(url: url)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgBack.roundCorners([.topLeft, .topRight], radius: 30)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLogOUtAction(_ sender: Any) {
        
        self.logoutApiCall()
        
        
    }

    @IBAction func btnFollowActions(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "followingViewController") as! FollowingViewController
            vc.isFollowing = sender.tag == 0
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func logoutApiCall(){
        
        self.hudShow()
     
    
         ServiceClass.sharedInstance.hitServiceForLogout([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                      print_debug("response: \(parseData)")
                      self.hudHide()
             
             if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
              
                
                let mess = parseData["message"].stringValue
                self.alert(message: mess) {
                    AppHelper.setStringForKey("", key: ServiceKeys.token)
                    AppHelper.setBoolForKey(false, key: "logIn")
                    AppHelper.setStringForKey("", key: ServiceKeys.user_id)
                    appDelegate.loginView()
                }
                
             } else {
                 
                 self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
             }

          
         })

    }
    
}

extension ProfileViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.imgIcon.image = UIImage(named: self.options[indexPath.row].1)
        cell.lblText.text =  self.options[indexPath.row].0
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
              let vc = self.storyboard?.instantiateViewController(withIdentifier: "editProfileViewController") as! EditProfileViewController
                             self.navigationController?.pushViewController(vc, animated: true)
            
            
            case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyAddViewController") as! MyAddViewController
                           self.navigationController?.pushViewController(vc, animated: true)
            
//            case 2:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
//                           self.navigationController?.pushViewController(vc, animated: true)
            
 //           case 3:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
//                           self.navigationController?.pushViewController(vc, animated: true)
            
            
//            case 4:
           // let vc = self.storyboard?.instantiateViewController(withIdentifier: "changePasswordViewController") as! ChangePasswordViewController
             //                          self.navigationController?.pushViewController(vc, animated: true)
            case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "changePasswordViewController") as! ChangePasswordViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            case 6:
                       let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyTransactionVC") as! MyTransactionVC
                                      self.navigationController?.pushViewController(vc, animated: true)
            
            case 7:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
                           self.navigationController?.pushViewController(vc, animated: true)
            
            case 8:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpSupportViewController") as! HelpSupportViewController
                           self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    
    }
    
}
