//
//  BaseViewController.swift
//  pikopako
//
//  Created by Ajay Vyas on 5/14/18.
//  Copyright © 2018 XtreemSolution. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Toast
import SwiftyJSON
import Kingfisher



class BaseViewController: UIViewController {
    
    
    var backButton = UIButton()
    var imageButtom = UIImageView()
    var rightView = UIView()
    var slideButton = UIButton()
    var slideImage = UIImageView()
    var navTitle: UILabel!
    var backgroundImage : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        transparentNavigationController()
        backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 32))
        backButton.backgroundColor = .clear
        let widthConstraint = backButton.widthAnchor.constraint(equalToConstant: 60)
        let heightConstraint = backButton.heightAnchor.constraint(equalToConstant: 32)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        navTitle = UILabel()
     
        navTitle.frame = CGRect(x: 0, y: 0, width:self.view.frame.width/2 + 30, height: 44)
        navTitle.numberOfLines = 2
           navTitle.font = UIFont(name: "PlayfairDisplay-Bold", size: 20)
        navTitle.textAlignment = NSTextAlignment.center
        
        navTitle.text = ""
        navTitle.textColor = UIColor.gray
        
        navTitle.backgroundColor = .clear
        //navTitle.textAlignment = .center
        self.navigationItem.titleView = navTitle
        
        //        navTitle.center = (self.navigationItem.titleView?.center)!
        
        imageButtom = UIImageView(frame:CGRect(x: 0 , y: 6 , width: 30, height: 30))
        imageButtom.image = UIImage(named:"back")
        let widthConstraint1 = imageButtom.widthAnchor.constraint(equalToConstant: 11)
        let heightConstraint1 = imageButtom.heightAnchor.constraint(equalToConstant:18)
        heightConstraint1.isActive = true
        widthConstraint1.isActive = true
        
        backButton.addSubview(imageButtom)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        backButton.addTarget(self, action: #selector(backButton(_:)), for: .touchUpInside)
        
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.isHidden     = true
        backgroundImage.layer.zPosition = -1
        backgroundImage.translatesAutoresizingMaskIntoConstraints = true
        
        self.view.addSubview(backgroundImage)
        
//        appDelegate.selectedVC?.navigationController = self.navigationController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func notificationButtonClicked(_ sender: UIButton) {
        //        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        //   let vc = storyboard.instantiateViewController(withIdentifier: "notificationViewController") as! NotificationViewController
        //   self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.view.endEditing(true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    // register scroll view
    
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    func makeToast(_ txt: String){
        self.view.hideToasts()
        self.view.makeToast(txt, duration: 1.5, position: "CSToastPositionCenter")
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // Remove observer for keybord Show/Hide
        
        
        self.view.endEditing(true)
    }
    
    
    
    
    
    
    
    
    
    
    //hud show and hide
    
    func hudShow()  {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }
    func hudHide()  {
        SVProgressHUD.dismiss()
    }
    
    func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }

    
    func transparentNavigationController() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func hideNavigationController() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
 
    

    
//    func setTitle(title:String) {
//        self.title = title
//        let attributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 14)!]
//        UINavigationBar.appearance().titleTextAttributes = attributes
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: CustomColor.pageTitleColor]
//    }
    
    func addShadowToBar() {
        let shadowView = UIView(frame: self.navigationController!.navigationBar.frame)
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.4 // your opacity
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2) // your offset
        shadowView.layer.shadowRadius =  4 //your radius
        self.view.addSubview(shadowView)
    }
    

    
    
    
    func removeAllData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    
    
    
    
    
}

