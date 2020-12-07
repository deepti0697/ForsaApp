//
//  ProductAddViewController.swift
//  FORSA
//
//  Created by apple on 23/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Lightbox
import AVFoundation
import AVKit
import SVProgressHUD

class ProductAddViewController: BaseViewController {
    
    @IBOutlet weak var lblWelComeName: UILabel!
    @IBOutlet weak var lblUserImage: UIImageView!
    
    @IBOutlet weak var imgMainPhoto: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var txtVwDescription: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
      var gallery: GalleryController!
        var imagesArr = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagesArr.append(UIImage(named: "selectedcamera")!)
        
        self.backButton.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 95, height: 62)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    

    @IBAction func btnDealAction(_ sender: UIButton) {
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
       }

}

extension ProductAddViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectImageCollectionViewCell", for: indexPath) as! SelectImageCollectionViewCell
        cell.imgSelected.image = self.imagesArr[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (imagesArr.count - 1 == indexPath.item) {
        gallery = GalleryController()
         gallery.delegate = self
         present(gallery, animated: true, completion: nil)
        }
    }
    
    
}


extension ProductAddViewController: GalleryControllerDelegate {
    
    // MARK: - GalleryControllerDelegate

    func galleryControllerDidCancel(_ controller: GalleryController) {
      controller.dismiss(animated: true, completion: nil)
      gallery = nil
    }

    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
      controller.dismiss(animated: true, completion: nil)
      gallery = nil


      
    }

    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        self.imagesArr.removeAll()
        Image.resolve(images: images) { (imagesarr) in
            self.imgMainPhoto.image = imagesarr.first!
            self.imagesArr = imagesarr
            self.imagesArr.removeFirst()
            self.imagesArr.append(UIImage(named: "selectedcamera")!)
             self.collectionView.reloadData()
        }
        
        
      controller.dismiss(animated: true, completion: nil)
       
      gallery = nil
    }

    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
      LightboxConfig.DeleteButton.enabled = true

      SVProgressHUD.show()
      Image.resolve(images: images, completion: { [weak self] resolvedImages in
        SVProgressHUD.dismiss()
        self?.showLightbox(images: resolvedImages.compactMap({ $0 }))
      })
    }

    // MARK: - Helper

    func showLightbox(images: [UIImage]) {
      guard images.count > 0 else {
        return
      }

      let lightboxImages = images.map({ LightboxImage(image: $0) })
      let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
   //   lightbox.dismissalDelegate = self
      gallery.present(lightbox, animated: true, completion: nil)
    }
}
