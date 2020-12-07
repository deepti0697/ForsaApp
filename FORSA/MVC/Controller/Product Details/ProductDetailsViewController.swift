//
//  ProductDetailsViewController.swift
//  FORSA
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductDetailsViewController: BaseViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionVwImges: UICollectionView!
    @IBOutlet weak var vwImages: UIView!
    
    @IBOutlet weak var tblData: UITableView!
    let authRequestGroup = DispatchGroup()
    var prd_id = ""
    var productDetialModelObj:prdDetailModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.transparentNavigationController()
        collectionVwImges.delegate = self
        collectionVwImges.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.view.frame.width - 70, height: 290)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionVwImges.collectionViewLayout = layout
        collectionVwImges.isPagingEnabled = true
        pageControl.numberOfPages = 10
        tblData.delegate = self
        tblData.dataSource = self
//        if UIDevice.current.hasNotch  {
//            tblData.contentInset =  UIEdgeInsets(top: -45, left: 0, bottom: 45, right: 0)
//        } else {
//
//        }
        self.imageButtom.image = UIImage(named: "right-arrow")
        imageButtom.contentMode = .center
        
        let rightBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .done, target: self, action: #selector(shareAction))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        self.allPrductDetailPageApiCall()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    @objc func shareAction(_ btn: UITabBarItem) {
        
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startBarteringBtnClicked(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "CommanPopUpVC") as! CommanPopUpVC
        vc.titleStr = "Sorry!"
        vc.descriptionStr = "You don't have subscription plan.\nYou need to buy a plan."
        vc.imgType = "sad-face"
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.present(vc, animated: true)
        
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
    
    func allPrductDetailPageApiCall(){
        
        
        self.productDetailApiCall()
        self.similarProductApiCall()
        self.productReviewApiCall()
        self.wishlistApiCall()
        
        self.authRequestGroup.notify(queue: DispatchQueue.main) {
            // //This only gets executed once all the requests in the authRequestGroup are done
            self.hudHide()
            print("authRequestGroup.notify")
        }
    }
    
    func productDetailApiCall(){
        
        self.hudShow()
        authRequestGroup.enter()
        ServiceClass.sharedInstance.hitServiceFor_Prd_detail(["prd_id":self.prd_id] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            
            self.authRequestGroup.leave()
            
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
        
    }
    
    func wishlistApiCall(){
        
        self.hudShow()
       authRequestGroup.enter()
        ServiceClass.sharedInstance.hitServiceFor_prdWishlist(["prd_id":self.prd_id] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            self.authRequestGroup.leave()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
        
    }
    
    func similarProductApiCall(){
        
        self.hudShow()
        
       authRequestGroup.enter()
        ServiceClass.sharedInstance.hitServiceFor_Prd_similar(["prd_id":self.prd_id] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            self.authRequestGroup.leave()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
        
    }
    
    func productReviewApiCall(){
        
        self.hudShow()
        authRequestGroup.enter()
        ServiceClass.sharedInstance.hitServiceFor_Prd_review_rating(["prd_id":self.prd_id] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            self.authRequestGroup.leave()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
        
    }
    
    
    

}

extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectImageCollectionViewCell", for: indexPath) as! SelectImageCollectionViewCell
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionVwImges.contentOffset, size: collectionVwImges.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = collectionVwImges.indexPathForItem(at: visiblePoint)
        
        self.pageControl.currentPage = indexPath?.item ?? 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionVwImges.contentOffset
        visibleRect.size = collectionVwImges.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionVwImges.indexPathForItem(at: visiblePoint) else { return }
        
        self.pageControl.currentPage = indexPath.item
        print(indexPath)
    }
    
}

extension ProductDetailsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "productDescriptionCell", for: indexPath) as! ProductDescriptionCell
            return cell
            
            case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "sellerDetailTableViewCell", for: indexPath) as! SellerDetailTableViewCell
            return cell
            
            case 2:
                      let cell = tableView.dequeueReusableCell(withIdentifier: "reportTableViewCell", for: indexPath) as! ReportTableViewCell
                      cell.btnReport.addTarget(self, action: #selector(btnAddReportAction), for: .touchUpInside)
                      return cell
        default:
              let cell = tableView.dequeueReusableCell(withIdentifier: "ratingTableViewCell", for: indexPath) as! RatingTableViewCell
                                return cell
        }
    }
    
    
    @objc func btnAddReportAction(_ btn : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addReportViewController") as! AddReportViewController
        vc.modalPresentationStyle = .overFullScreen
        
        self.navigationController?.present(vc, animated: true, completion: {
        })
        
    }
    
    
}
