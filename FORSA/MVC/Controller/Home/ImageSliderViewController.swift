//
//  ImageSliderViewController.swift
//  FORSA
//
//  Created by sanjay mac on 27/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Photos
import AVKit

class ImageSliderViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    var player:AVPlayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imgSlideBtnClicked(_ sender: UIButton) {
        
    }
    
    
    
            func requestavasset(asset: PHAsset) {
            // We only want videos here
            guard asset.mediaType == .video else { return  }
            //warrnnig
            //        let reources = PHAssetResource.assetResources(for: asset)
            //        let originalfilename = reources[0].originalFilename
            //       // print("originalfilename = \(originalfilename)" )
            
            
            let imagemanager = PHImageManager()
            let videorequestoptions = PHVideoRequestOptions()
            videorequestoptions.deliveryMode = .automatic
            videorequestoptions.version = .original
            videorequestoptions.isNetworkAccessAllowed = true
            
            imagemanager.requestAVAsset(forVideo: asset, options: videorequestoptions) { (vassest, audiomix, infodic) in
               
                if let video = vassest as? AVURLAsset
                {
                    let url = video.url
                    
                    self.autoPlayVideo(videoUrl: url)
                }
            }
        }
        
        
        func removeChildController(){
            if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }

        }
        
        
        func autoPlayVideo(videoUrl:URL){
            

                DispatchQueue.main.async {
               
                self.player = AVPlayer(url: videoUrl)
                let controller = AVPlayerViewController()
                controller.player = self.player
                controller.videoGravity = .resizeAspectFill
            
                controller.view.frame = self.containerView.frame
                self.containerView.addSubview(controller.view)
                self.addChild(controller)
                self.player?.play()
            
        }
            
            
        }

}
