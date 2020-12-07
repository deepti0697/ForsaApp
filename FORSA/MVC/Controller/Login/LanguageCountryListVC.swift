//
//  LanguageCountryListVC.swift
//  FORSA
//
//  Created by sanjay mac on 05/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol LanguageCountrySelectionDelegate:class {
    func selectedLangCountry(str:String, isLngBtn:Bool);
}

class LanguageCountryListVC: BaseViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var selectItemTitleLbl: UILabel!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var stackHeightConstraint: NSLayoutConstraint!
    var isLanguageBtn = false
    var langArr = [LanguageListModel]()
    var countryArr = [CountriesListModel]()
    weak var delegate:LanguageCountrySelectionDelegate?
    var langTempArr = [LanguageListModel]()
    var countryTempArr = [CountriesListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backButton.isHidden = true
        tblView.delegate = self
        tblView.dataSource = self
        searchTxt.delegate = self
        self.cancelBtn.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tblView.reloadData()
        }
    }
    
    
 override func viewWillLayoutSubviews() {
       super.updateViewConstraints()
    if self.tblView.contentSize.height > UIScreen.main.bounds.size.height - 148{
       self.stackHeightConstraint.constant = UIScreen.main.bounds.size.height - 148
    }else{
      self.stackHeightConstraint.constant = self.tblView.contentSize.height + 136
    }
    
   }
    
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        
        self.searchTxt.text = ""
    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        
        self.dismiss(animated: false)
    }
    

}



extension LanguageCountryListVC:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if searchTxt.text!.count == 0{
            self.cancelBtn.isHidden = true
            self.countryTempArr.removeAll()
            self.langTempArr.removeAll()
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
            return
        }else{
            self.cancelBtn.isHidden = false
        }
        
        
        if isLanguageBtn == true{
            if textField.text!.count > 0{
               
                self.langTempArr = textField.text!.isEmpty ? self.langArr : self.langArr.filter{ $0.title.contains(textField.text!)}

            }
        }else{
          if textField.text!.count > 0{
               
            self.countryTempArr = textField.text!.isEmpty ? self.countryArr : self.countryArr.filter{ $0.name.contains(textField.text!)}

            }
        }
        
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    
}


extension LanguageCountryListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isLanguageBtn == true{
            return self.langTempArr.count == 0 ? self.langArr.count : self.langTempArr.count
        }else{
            return self.countryTempArr.count == 0 ? self.countryArr.count : self.countryTempArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCountryTableCell", for: indexPath) as! LanguageCountryTableCell
        if self.isLanguageBtn == true{
            cell.lbl.text = self.langTempArr.count == 0 ? self.langArr[indexPath.row].title : self.langTempArr[indexPath.row].title
        }else{
            cell.lbl.text = self.countryTempArr.count == 0 ? self.countryArr[indexPath.row].name : self.countryTempArr[indexPath.row].name
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isLanguageBtn == true{
            
            let title = self.langTempArr.count == 0 ? self.langArr[indexPath.row].title : self.langTempArr[indexPath.row].title
            
            if let selectedStr = title{
                delegate?.selectedLangCountry(str: selectedStr, isLngBtn: true)
                
            }
        }else{
            
            let title = self.countryTempArr.count == 0 ? self.countryArr[indexPath.row].name : self.countryTempArr[indexPath.row].name
            
            if let selectedStr = title{
                delegate?.selectedLangCountry(str: selectedStr, isLngBtn: false)

            }
        }
        
        self.dismiss(animated: false)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
  
    
    
    
    
}
