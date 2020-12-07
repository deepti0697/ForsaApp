//
//  FollowingViewController.swift
//  FORSA
//
//  Created by apple on 01/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class FollowingViewController: BaseViewController {
    
    @IBOutlet weak var lblNav: UILabel!
       @IBOutlet weak var tblOption: UITableView!
        @IBOutlet weak var imgBack: UIImageView!
    
    var isFollowing : Bool = true
    var followsArr = [followsModel]()
    var userid = ""
    override func viewDidLoad() {
        super.viewDidLoad()

          tblOption.delegate = self
            tblOption.dataSource = self
        lblNav.text =  isFollowing ? "Following" : "Followers"
        
        if isFollowing{
            self.followingApiCall()
        }else{
            self.followerApiCall()
        }
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            imgBack.roundCorners([.topLeft, .topRight], radius: 30)
        }
        
        @IBAction func btnBackAction(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }


    
    func followingApiCall(){
        
        self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceFor_following([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                let dataArr = parseData["data"].arrayValue
                self.followsArr.removeAll()
                for data in dataArr{
                    let model = followsModel(fromJson: data)
                    self.followsArr.append(model)
                }
                
                DispatchQueue.main.async {
                    self.tblOption.reloadData()
                }
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
        
    }
    
    func followerApiCall(){
        
        self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceFor_followers([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
               let dataArr = parseData["data"].arrayValue
               self.followsArr.removeAll()
               for data in dataArr{
                   let model = followsModel(fromJson: data)
                   self.followsArr.append(model)
               }
                
                DispatchQueue.main.async {
                    self.tblOption.reloadData()
                }
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
        
    }

}



extension FollowingViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableViewCell", for: indexPath) as! ProfileTableViewCell
        
        cell.btnUnfollow.tag = indexPath.row
        cell.btnUnfollow.backgroundColor = isFollowing ? UIColor(red: 206/255  , green: 36/255, blue: 36/255, alpha: 1) : UIColor(red: 72/255  , green: 70/255, blue: 70/255, alpha: 1)
        let modelData = self.followsArr[indexPath.row]
        cell.lblText.text = modelData.user_name
        cell.btnUnfollow.addTarget(self, action: #selector(btnFollowUnfollowClicked(_:)), for: .touchUpInside)
        if isFollowing{
            cell.btnUnfollow.setTitle("Unfollow", for: .normal)
        }else{
            cell.btnUnfollow.setTitle("Follow", for: .normal)
        }
        
        if modelData.option == "Not Follower"{
            cell.btnUnfollow.isHidden = true
        }else{
            cell.btnUnfollow.isHidden = false
        }
        
        if let urlStr = modelData.image{
            if let url = URL(string: urlStr){
              cell.imgIcon.setImage(url: url)
            }
        }
        
        
        
        return cell
        
    }
    
    
    @objc func btnFollowUnfollowClicked(_ sender:UIButton){
        let id = self.followsArr[sender.tag]
        self.userid = id.userid
        
        
        if self.isFollowing{
            startUnFollowApiCall()
        }else{
            
            
            startFollowApiCall()
        }
        
    }
    
    func startFollowApiCall(){
        
        self.hudShow()
       
        ServiceClass.sharedInstance.hitServiceFor_start_follow(["userid":userid] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                self.followerApiCall()
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
        
    }
    
    func startUnFollowApiCall(){
        
        self.hudShow()
       
        ServiceClass.sharedInstance.hitServiceFor_start_unfollow(["userid":userid] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                
                self.followingApiCall()
                
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
        
    }
    
    
}
