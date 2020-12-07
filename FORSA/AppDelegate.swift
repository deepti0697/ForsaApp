//
//  AppDelegate.swift
//  FORSA
//
//  Created by apple on 17/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FAPanels

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
       var currentNavController:UINavigationController?
     var tabBarController = UITabBarController()
     var navigationController:UINavigationController?
     let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
     var selectedVC : UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       self.window = UIWindow(frame: UIScreen.main.bounds)
        Thread.sleep(forTimeInterval: 3.0)
        IQKeyboardManager.shared.enable = true
  
        if ( AppHelper.getStringForKey(ServiceKeys.token) != "" ) {
            self.setHomeView()
        } else {
            self.loginView()
        }
      
        return true
    }
    
 


}

extension AppDelegate {
    
    func loginView() {
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeSignInViewController") as! WelcomeSignInViewController
             let nav = UINavigationController(rootViewController: vc)
              self.window?.rootViewController = nav
              self.window?.makeKeyAndVisible()
          }
    
    func setHomeView() {
        
        let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        let nv1 = UINavigationController(rootViewController: vc1)
        // nv1.restorationIdentifier = "gigListViewController"
         self.selectedVC = nv1
        var nv2 : UINavigationController!
        
        let vc2 = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        nv2 = UINavigationController(rootViewController: vc2)
        //  nv2.restorationIdentifier = "gigsListViewController"
        
        let vc3 = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        let nv3 = UINavigationController(rootViewController: vc3)
        
        //  nv3.restorationIdentifier = "communityViewController"
        
        
        let vc4 = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        let nv4 = UINavigationController(rootViewController: vc4)
        //   nv4.restorationIdentifier = "chatsListViewController"
        
        
        let vc5 = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
         vc5.isCheckFromTab = true
        let nv5 = UINavigationController(rootViewController: vc5)
        // nv5.restorationIdentifier = "logoutViewController"
        
        nv1.tabBarItem = UITabBarItem.init(title: "first", image: UIImage(named: "home (1)"), selectedImage: UIImage(named: "home (1)"))
        nv2.tabBarItem = UITabBarItem.init(title: "secnds", image: UIImage(named: "clipboard"), selectedImage: UIImage(named: "clipboard"))
        nv3.tabBarItem = UITabBarItem.init(title: "third", image: UIImage(named: ""), selectedImage: UIImage(named: "Friends_select"))
        nv4.tabBarItem = UITabBarItem.init(title: "fourth", image: UIImage(named: "speaker"), selectedImage: UIImage(named: "speaker"))
        nv5.tabBarItem = UITabBarItem.init(title: "fifth", image: UIImage(named: "Group 9949"), selectedImage: UIImage(named: "Group 9949"))
       // nv3.tabBarItem.isEnabled = false
     
        nv1.tabBarItem.title = "Home"
        nv2.tabBarItem.title = "Category"
        nv3.tabBarItem.title = "Upload"
        nv4.tabBarItem.title = "Boost"
        nv5.tabBarItem.title = "Profile"
        
        //              var bottomSpace : CGFloat = -10
        //              var topSpace : CGFloat = 0
        //
        //              if #available(iOS 11.0, *) {
        //                  bottomSpace  = -10
        //                  topSpace = 0
        //              }else {
        //                  bottomSpace  = -5
        //                  topSpace = 5
        //              }
        //
        //              nv1.tabBarItem.imageInsets = UIEdgeInsets(top: topSpace, left: 0, bottom: bottomSpace, right: 0)
        //              nv2.tabBarItem.imageInsets = UIEdgeInsets(top: topSpace, left: 0, bottom: bottomSpace, right: 0)
        //              nv3.tabBarItem.imageInsets = UIEdgeInsets(top: topSpace, left: 0, bottom: bottomSpace, right: 0)
        //              nv4.tabBarItem.imageInsets = UIEdgeInsets(top: topSpace, left: 0, bottom: bottomSpace, right: 0)
        //              nv5.tabBarItem.imageInsets = UIEdgeInsets(top: topSpace, left: 0, bottom: bottomSpace, right: 0)
        
        
        // Fallback on earlier versions
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBarController.tabBar.layer.shadowRadius = 5
        tabBarController.tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBarController.tabBar.layer.shadowOpacity = 0.5
        
        tabBarController.tabBar.shadowImage = nil
       
        tabBarController.viewControllers = [nv1, nv2, nv3, nv4, nv5]
        tabBarController.tabBar.tintColor = UIColor.black
        tabBarController.selectedIndex = 0
        
       
        if self.navigationController == nil {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let leftMenuVC = storyboard.instantiateViewController(withIdentifier: "sideMenuViewController") as! SideMenuViewController
            
            let rootController = FAPanelController()
            rootController.configs.bounceOnRightPanelOpen = false
            rootController.configs.canLeftSwipe = false
            rootController.configs.canRightSwipe = false
            
            rootController.rightPanelPosition = .back
            rootController.configs.maxAnimDuration = 0.30
            rootController.configs.leftPanelWidth = UIScreen.main.bounds.width * 0.81
            _ = rootController.center(self.tabBarController).left(leftMenuVC)
            self.window?.rootViewController = rootController
            self.window?.makeKeyAndVisible()
        }else {
            self.navigationController?.present(tabBarController, animated: true, completion: {
                
            })
        }
          setupMiddleButton()
         
      }
      
    func setupMiddleButton() {
        
        var menuButtonFrame = menuButton.frame
        if UIDevice.current.hasNotch {
             menuButtonFrame.origin.y =  self.tabBarController.tabBar.frame.height - self.tabBarController.tabBar.frame.height - 45
        } else {
             menuButtonFrame.origin.y =  self.tabBarController.tabBar.frame.height - 45
        }
       
        menuButtonFrame.origin.x = (self.tabBarController.tabBar.frame.width)/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        menuButton.clipsToBounds = true
        
        let imageview = UIImageView(frame: CGRect(x:  menuButton.frame.width/2 - 35 , y:  menuButton.frame.height/2 - 35 , width: (70), height: 70))
        imageview.contentMode = .scaleAspectFit
        menuButton.addSubview(imageview)
        imageview.image = UIImage(named: "Group 9799")
        
        self.tabBarController.tabBar.addSubview(menuButton)
        
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        //                  if user_type == UserType.Patient.rawValue {
        //                      menuButton.tag = 0
        //                  } else if user_type == UserType.Doctor.rawValue {
        //                      menuButton.tag = 1
        //                  }else if user_type == UserType.Nurse.rawValue {
        //                      menuButton.tag = 2
        //                  }
        
    }
    
      @objc func menuButtonAction(sender:UIButton) {
                  //print("UnderWorking")
        self.tabBarController.selectedIndex = 2
        
//        let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
//        let vc3 = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
//        let _ = UINavigationController(rootViewController: vc3)
        
        
      }
      
    
}
