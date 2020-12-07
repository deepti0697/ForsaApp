//
//  HomeViewController.swift
//  FORSA
//
//  Created by apple on 17/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON





class HomeViewController: BaseViewController {
    
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var welcomeUserNameLbl: UILabel!
    @IBOutlet weak var productsTypeLbl: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    var catArr = [HomeProductForGuest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
//
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:(UIScreen.main.bounds.width - 60)/2, height: 220)
        layout.minimumInteritemSpacing = 8
        homeCollectionView.collectionViewLayout = layout
//
//      addrightimageField(textField: txtSearch, img: "search-menu")
//        self.homeCollectionView.reloadData()
        self.getHomeProductApiCall()
    }
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgBack.roundCorners([.topLeft, .topRight], radius: 30)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
 //MARK:- getHomeProductApiCall
    func getHomeProductApiCall() {
           
           self.hudShow()
        
        let isLogin = AppHelper.getBoolForKey("logIn")
        if isLogin == true{
            ServiceClass.sharedInstance.hitServiceForHomeProduct([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                         print_debug("response: \(parseData)")
                         self.hudHide()
                
                if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                 self.catArr.removeAll()
                    for obj in parseData["data"].arrayValue {
                        self.catArr.append(HomeProductForGuest(fromJson: obj))
                    }
                             DispatchQueue.main.async {
                                 self.homeCollectionView.reloadData()
                             }
                    
                } else {
                    if let errorCode = errorDict?["errorCode"] as? Int, errorCode == 2{
                        self.alert(message: "Session Expired") {
                            
                            AppHelper.setStringForKey("", key: ServiceKeys.token)
                            AppHelper.setBoolForKey(false, key: "logIn")
                            AppHelper.setStringForKey("", key: ServiceKeys.user_id)
                            appDelegate.loginView()
                        }
                    }else{
                        self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                    }
                    
                }

             
            })

        }else{
            ServiceClass.sharedInstance.hitServiceForHomeProductForGuest([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                         print_debug("response: \(parseData)")
                         self.hudHide()
                
                if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                 self.catArr.removeAll()
                    for obj in parseData["data"].arrayValue {
                        self.catArr.append(HomeProductForGuest(fromJson: obj))
                    }
                             DispatchQueue.main.async {
                                 self.homeCollectionView.reloadData()
                             }
                    
                } else {
                    
                    self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                }

             
            })

        }
       }
    
    
    
    @IBAction func btnProfileAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    @IBAction func btnFilterAction(_ sender: Any) {
        
        
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "filterViewController") as! FilterViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.filterDelegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnSideMenuAction(_ sender: Any) {
        panel?.openLeft(animated: true)
    }
    


}


extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
  
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return catArr.count
        
    }
    
 
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendedCollectionViewCell", for: indexPath) as! RecommendedCollectionViewCell
        cell.delegate = self
        cell.favBtn.tag = indexPath.row
        cell.likeBtn.tag = indexPath.row
        let catObj = self.catArr[indexPath.row]
        cell.lblName.text = catObj.title
        cell.lblWatch.text = catObj.total_view
        cell.lblDistance.text = "50 KM"
        cell.totalLikeLbl.text = catObj.total_like
        cell.soldLbl.text = "SOLD"
            if let url = URL(string: catObj.file_name){
                cell.imgType.setImage(url: url, placeholder: nil, completion: nil)
            }
        if catObj.likeornot == "Not Liked"{
            cell.likeBtn.setImage(UIImage(named: "like"), for: .normal)
        }else{
            cell.likeBtn.setImage(UIImage(named: "likeSelected"), for: .normal)
        }
        
        if catObj.wishstatus == "Not Wished"{
            cell.favBtn.setImage(UIImage(named: "heart-1")?.withRenderingMode(.alwaysTemplate), for: .normal)
            
        }else{
            cell.favBtn.setImage(UIImage(named: "redHeart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
            return cell
        
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//            return CGSize(width:UIScreen.main.bounds.width/2 - 70, height: 190)
//
//    }
    
    
    
 
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 15
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 15
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "productDetailsViewController") as! ProductDetailsViewController
        vc.prd_id = self.catArr[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
    }

    
}

//MARK:- CellButtonActionDelegate  Like, Favorite
extension HomeViewController:CellButtonActionDelegate,HomeFilterDelegate{
    func filterApply() {
        print("filterApply")
    }
    
    func favBtnAction(index: Int) {
        let isLogin = AppHelper.getBoolForKey("logIn")
        if isLogin == true{
            self.favoritePrdApiCall(productIndex: index)
        }else{
            self.alertWithCancel(message: "You need to login first") {
                appDelegate.loginView()
            }
        }
        //print("favIndex:\(index)")
    }
    
    func likeBtnAction(index: Int) {
      let isLogin = AppHelper.getBoolForKey("logIn")
      if isLogin == true{
        self.productLikeApiCall(productIndex: index)
      }else{
          self.alertWithCancel(message: "You need to login first") {
              appDelegate.loginView()
          }
      }
    }
    
    
    
    // MARK:- Like product Api Call
    
    func productLikeApiCall(productIndex:Int){
        
        self.hudShow()
    
        let catObj = self.catArr[productIndex]
        guard let id = catObj.id else{
            self.hudHide()
            return
        }
        if catObj.likeornot == "Not Liked"{
                          ServiceClass.sharedInstance.hitServiceFor_prdLike(["prd_id" : id] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                                           print_debug("response: \(parseData)")
                                           self.hudHide()

                                           if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                                               
                                                  kApplicationDelegate.setHomeView()
                                              
                                              
                                           } else {

                                               self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                                           }
                                       })
                      }else{
            
//            ServiceClass.sharedInstance.hitServiceFor_prdLike(["prd_id" : id] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
//                             print_debug("response: \(parseData)")
//                             self.hudHide()
//
//                             if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
//
//                                    kApplicationDelegate.setHomeView()
//
//
//                             } else {
//
//                                 self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
//                             }
//                         })
                          
                      }
        
        
        

    }
    
    
    
    // MARK:- Favorite product Api Call
    
    func favoritePrdApiCall(productIndex:Int){
        
        self.hudShow()
    
        let catObj = self.catArr[productIndex]
        
       
               
             
        
        guard let id =  catObj.id else{
            self.hudHide()
            return
        }
        
        if catObj.wishstatus == "Not Wished"{
                         ServiceClass.sharedInstance.hitServiceFor_prdWishlist(["prd_id" : id] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                                            print_debug("response: \(parseData)")
                                            self.hudHide()

                                            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                                                
                                                   kApplicationDelegate.setHomeView()
                                               
                                               
                                            } else {

                                                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                                            }
                                        })
                         
                     }else{
                         
                     }
     
      
    }
    
   
}
