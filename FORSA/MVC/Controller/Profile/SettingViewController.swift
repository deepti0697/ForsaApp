//
//  SettingViewController.swift
//  FORSA
//
//  Created by apple on 02/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingViewController: BaseViewController {

    
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var notificationsTitleLbl: UILabel!
    
    @IBOutlet weak var selectLngTitleLbl: UILabel!
    
    @IBOutlet weak var selectLngBtn: UIButton!
    var settingsArr = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.settingsApiCall()
    }
    
    
    func settingsApiCall() {
               
               self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceFor_settings([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                            print_debug("response: \(parseData)")
                            self.hudHide()
                   
                   if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                       
                    let data = parseData["data"].arrayValue
                    
                    let title = data[0]["title"].stringValue
                    let notification_status = data[0]["notification_status"].stringValue
                    
                    self.selectLngTitleLbl.text = title
                    print(notification_status)
//                    self.settingsArr.removeAll()
//                    for dataValue in data{
//                        self.settingsArr.append(dataValue)
//                    }
                    
                    
                       
                   } else {
                       
                       self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
                   }

                
               })
           }
    
    
    @IBAction func btnSelectLang(_ sender: Any) {
        
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationSwitchAction(_ sender: UISwitch) {
        
        if sender.isOn {
            //sender.backgroundColor = .red
           } else {
            //   sender.backgroundColor = .green
           }
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
