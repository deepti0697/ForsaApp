//
//  ChooseCategoryVC.swift
//  FORSA
//
//  Created by sanjay mac on 27/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChooseCategoryVC: BaseViewController {


    @IBOutlet weak var personaliseTitleLbl: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var categoryColleView: UICollectionView!
    @IBOutlet weak var skipBtn: UIButton!
    
    var catArr = [CategoryDTo]()

    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    let numberOfItemsPerRow: CGFloat = 3
    let spacingBetweenCells: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryColleView.delegate = self
        categoryColleView.dataSource = self
        //self.backBtn.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        getCategory()
    }
    
    
    //MARK:- IBACTION
    
    @IBAction func applyBtnClicked(_ sender: UIButton) {
        //submitCategory()
         kApplicationDelegate.setHomeView()
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func skipBtnClicked(_ sender: UIButton) {
        kApplicationDelegate.setHomeView()
    }
    

    
    func getCategory() {
           
           self.hudShow()
           ServiceClass.sharedInstance.hitServiceForGetAllCategory([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                        print_debug("response: \(parseData)")
                        self.hudHide()
               
               if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                   
                   for obj in parseData["data"].arrayValue {
                       self.catArr.append(CategoryDTo(fromJson: obj))
                   }
                   
               } else {
                   
                   self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
               }
            DispatchQueue.main.async {
                self.categoryColleView.reloadData()
            }
            
           })
       }
       
       func submitCategory() {
            
            self.hudShow()
        let catArr = self.catArr.filter({$0.isSelected}).map({$0.id ?? ""})
        let ids = catArr.joined(separator: ",")
        
        ServiceClass.sharedInstance.hitServiceForSubmitCategory(["categories" : ids] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                         print_debug("response: \(parseData)")
                         self.hudHide()

                         if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                             
                                kApplicationDelegate.setHomeView()

                         } else {

                             self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                         }
                     })
        }
    
}

extension ChooseCategoryVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseCategoryCCell", for: indexPath) as! ChooseCategoryCCell
        let catObj = catArr[indexPath.row]
        cell.categoryLbl.text = catObj.cat_name
        print("Check Selection for ",catObj.cat_name, catObj.isSelected)
        if let imgStr = catObj.img{
            if let imgURL  = URL(string: imgStr){
                cell.imgView.setImage(url: imgURL, placeholder: UIImage(named: ""), completion: nil)
            }
            
        }
        
        cell.selectionBackView.backgroundColor = catObj.isSelected ? UIColor.blue.withAlphaComponent(0.3)  : UIColor.blue.withAlphaComponent(0.0)
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let totalSpacing = (numberOfItemsPerRow * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row

            let width = (UIScreen.main.bounds.width - totalSpacing)/numberOfItemsPerRow
             return CGSize(width: width, height: width + 16)
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return sectionInsets
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return spacingBetweenCells
     }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        catArr[indexPath.row].isSelected = !catArr[indexPath.row].isSelected
        
        
        
        DispatchQueue.main.async {
           // collectionView.reloadData()
            collectionView.reloadItems(at: [indexPath])
        }
        
    }
    
    
}
