//
//  SideMenuViewController.swift
//  FORSA
//
//  Created by apple on 17/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SideMenuViewController: BaseViewController {

    @IBOutlet weak var lblVerified: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var tblMenu: UITableView!
    
    let menuArr = [("Privacy Policy","key"),("Terms and Condition ","google-docs"),("About Forsa","call-center-agent")]
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
        tblMenu.delegate = self
        tblMenu.dataSource = self
    }
    
    @IBAction func btnProfileAction(_ sender: Any) {
    }
    
   
    

}
extension SideMenuViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        cell.lblName.text = menuArr[indexPath.row].0
        cell.imgKey.image = UIImage(named: menuArr[indexPath.row].1)
        
        return cell
    }
    
    
}
