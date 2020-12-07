//
//  ChooseLanguageAndCountryVC.swift
//  FORSA
//
//  Created by sanjay mac on 05/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChooseLanguageAndCountryVC: BaseViewController, LanguageCountrySelectionDelegate {
    
    

    
    @IBOutlet weak var chooseYourLngTitleLbl: UILabel!
    @IBOutlet weak var chooseYourCountryTitleLbl: UILabel!
    @IBOutlet weak var lngTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    
    var langArr = [LanguageListModel]()
    var countryArr = [CountriesListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.isHidden = false
        languageAndCountryApiCall()
    }
    
    
    func languageAndCountryApiCall(){
                         
      let dispatchGroup = DispatchGroup()
        
        
        dispatchGroup.enter()
                         self.hudShow()
        ServiceClass.sharedInstance.hitServiceFor_languageFetch([:], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                             print_debug("response: \(parseData)")
                             self.hudHide()
                             
                             if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                                 
                                 //print(parseData)
                                 let dataArr = parseData["data"].arrayValue
                                // print(dataArr)
                                 self.langArr.removeAll()
                                for dataDic in dataArr{

                                    let parseData = LanguageListModel(fromJson: dataDic)
                                    self.langArr.append(parseData)
                                    
                                }
                                
                                
                                DispatchQueue.main.async {
                                    dispatchGroup.leave()
                                }
                                 
                             } else {
                             
                               guard let dicStr = errorDict?[ServiceKeys.keyErrorMessage] as? String else {
                                   return
                               }
                               Common.showAlert(alertMessage: dicStr, alertButtons: ["Ok"]) { (bt) in
                               }
                               
                               
                             }
                         })
        
        
        
        
        dispatchGroup.enter()
        
        self.hudShow()
              ServiceClass.sharedInstance.hitServiceFor_CountryFetch([:], completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                                   print_debug("response: \(parseData)")
                                   self.hudHide()
                                   
                                   if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                                       
                                      // print(parseData)
                                    let dataArr = parseData["data"].arrayValue
                                    self.countryArr.removeAll()
                                    for dataDic in dataArr{

                                        let parseData = CountriesListModel(fromJson: dataDic)
                                        self.countryArr.append(parseData)
                                        
                                    }
                                    
                                      DispatchQueue.main.async {
                                          dispatchGroup.leave()
                                      }
                                       
                                   } else {
                                   
                                     guard let dicStr = errorDict?[ServiceKeys.keyErrorMessage] as? String else {
                                         return
                                     }
                                     Common.showAlert(alertMessage: dicStr, alertButtons: ["Ok"]) { (bt) in
                                     }
                                     
                                     
                                   }
                               })
        
        
        
        dispatchGroup.notify(queue: .main) {
            // whatever you want to do when both are done
            
            
        }
        
                         
           }
    
    //MARK:- selectedLangCountry Delegate Method
    func selectedLangCountry(str: String, isLngBtn: Bool) {
        if isLngBtn == true{
            self.lngTxt.text = str
        }else{
            self.countryTxt.text = str
        }
    }
    
    //MARK:- IBACTION
    
    @IBAction func lngBtnClicked(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageCountryListVC") as! LanguageCountryListVC
        vc.isLanguageBtn = true
        vc.langArr = self.langArr
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        
        
    }
    
    @IBAction func countryBtnClicked(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguageCountryListVC") as! LanguageCountryListVC
        vc.isLanguageBtn = false
        vc.countryArr = self.countryArr
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        if self.lngTxt.text!.count > 0{
            if self.countryTxt.text!.count > 0{
                //kApplicationDelegate.setHomeView()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseCategoryVC") as! ChooseCategoryVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.alert(message: "Please select your country")
            }
        }else{
            self.alert(message: "Please select your language")
        }
        
        
        
        
    }
    
    
}
