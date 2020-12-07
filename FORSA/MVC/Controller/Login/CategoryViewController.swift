//
//  CategoryViewController.swift
//  FORSA
//
//  Created by apple on 17/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryViewController: BaseViewController {

    @IBOutlet weak var tblCat: UITableView!
    
    var catArr = [CategoryDTo]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tblCat.delegate = self
        tblCat.dataSource = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let btn1 = UIButton(type: .custom)
        btn1.setTitle("Skip", for: .normal)
        btn1.titleLabel?.font = UIFont(name: "PlayfairDisplay-Bold", size: 12)
              
        btn1.setTitleColor(UIColor.white, for: .normal)
          btn1.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
          btn1.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        btn1.backgroundColor = .lightGray
              btn1.cornerRadius = btn1.frame.height/2
          let item1 = UIBarButtonItem(customView: btn1)
          self.navigationItem.setRightBarButton(item1, animated: true)
        getCategory()
    }
    
    
    @objc func skipAction(_ btn : UIBarItem) {
        kApplicationDelegate.setHomeView()
    }

    @IBAction func btnNextAction(_ sender: Any) {
        submitCategory()
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
            self.tblCat.reloadData()
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

extension CategoryViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.catArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        let catObj = catArr[indexPath.row]
        cell.lblName.text = catObj.cat_name
        cell.imgTick.image = catObj.isSelected ? #imageLiteral(resourceName: "Group 9950")  : #imageLiteral(resourceName: "Rectangle 3733")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        catArr[indexPath.row].isSelected = !catArr[indexPath.row].isSelected
        tableView.reloadData()
    }
    
}
