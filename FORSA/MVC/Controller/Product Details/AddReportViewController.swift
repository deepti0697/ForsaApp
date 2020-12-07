//
//  AddReportViewController.swift
//  FORSA
//
//  Created by apple on 28/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddReportViewController: BaseViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnSubmitAction(_ sender: Any) {
    }
    
    @IBAction func btnCrossAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
