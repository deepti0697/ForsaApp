//
//  FilterViewController.swift
//  FORSA
//
//  Created by apple on 21/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol HomeFilterDelegate:class {
    func filterApply()
}

class FilterViewController: BaseViewController {
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
     @IBOutlet weak var vwMain: UIView!
    var totalSection = ["Sort by","Categories"]
    var filterDelegate:HomeFilterDelegate?
    var homeFilterModel:HomeFilterModel?
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    let numberOfItemsPerRow: CGFloat = 2
    let spacingBetweenCells: CGFloat = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
               layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: filterCollectionView.bounds.width/2, height: 50)
               layout.minimumInteritemSpacing = 0
               layout.minimumLineSpacing = 0
               filterCollectionView!.collectionViewLayout = layout
        self.homeFilterApiCall()
    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         vwMain.roundCorners([.topLeft, .topRight], radius: 30)
     }
    
    @IBAction func btnCrossAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    @IBAction func btnApplyAction(_ sender: Any) {
        filterDelegate?.filterApply()
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FilterViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return totalSection.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return self.homeFilterModel?.sortByArr.count ?? 0

        }
        else{
            return self.homeFilterModel?.categoriesArr.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        if indexPath.section == 0{
            guard let sortBy = self.homeFilterModel?.sortByArr[indexPath.row] else{
              return cell
            }
            
            cell.lblSubject.text = sortBy.title
            
        }else{
            guard let categories = self.homeFilterModel?.categoriesArr[indexPath.row] else{
              return cell
            }
            let isLogin = AppHelper.getBoolForKey("logIn")
            if isLogin == true{
                cell.lblSubject.text = categories.cat_name
            }else{
                cell.lblSubject.text = categories.slug
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterCollectionHeaderCell", for: indexPath) as! FilterCollectionHeaderCell
        if indexPath.section == 0{
           cell.sectionTitleLbl.text = self.totalSection[0]
        }else{
          cell.sectionTitleLbl.text = self.totalSection[1]
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//         let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
//
//            let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
//             return CGSize(width: width, height: 50)
//     }
//
//     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//         return sectionInsets
//     }
//
//     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//         return spacingBetweenCells
//     }
    
    
}


extension FilterViewController{
    
    
    func homeFilterApiCall(){
        
        self.hudShow()
    
    
        ServiceClass.sharedInstance.hitServiceForHomeFilter([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
                        
                     if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                         
                           // kApplicationDelegate.setHomeView()
                        let data = parseData["data"]
                        
                        self.homeFilterModel = HomeFilterModel(fromJson: data)
                        DispatchQueue.main.async {
                            self.filterCollectionView.reloadData()
                        }
                     } else {

                         self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                     }
                 })
    }
    
    
    
}
