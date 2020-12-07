//
//  CameraViewController.swift
//  FORSA
//
//  Created by apple on 26/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import AVKit
import Lightbox
import SVProgressHUD
import Photos

class CameraViewController: BaseViewController{
    
    @IBOutlet weak var timerLbl: UILabel!
    
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var cameraPositionBtn: UIButton!
    @IBOutlet weak var cameraSwitchBtn: UIButton!
    @IBOutlet weak var timerView: UIView!
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var vwCamera: UIView!
    

    @IBOutlet weak var photoCollection: UICollectionView!
    
    @IBOutlet weak var totalImgLimitLbl: UILabel!
    
    var runtimeErrorHandlingObserver: AnyObject?
    var recordingmanager : photocameramanager?
    var videoManager = videorecordingmanager()
    var imagesArr = [mediamodel]()
    var gallery: GalleryController!
    var capturedImage: UIImage?
    var zoomfactor: CGFloat = 1.0
    var currentcameraposition = 0  //0 if camera not switched else 1
    var currentcameraface = "Back"
    var selectedIndex:Int?
    var isImgRecordBtn = true
    var hashqueue: OperationQueue?
    var latestvideothumbnail:UIImage?
    var isrecording = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        photoCollection.delegate = self
        photoCollection.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 76, height: 76)
        layout.scrollDirection = .horizontal
        photoCollection.collectionViewLayout = layout
        
       
           //imgCapture videoCapture videoRecording  videoSwitch cameraSwitch
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.cameraBtn.setImage(UIImage(named: "videoCapture"), for: .normal)
        self.cameraSwitchBtn.setImage(UIImage(named: "videoSwitch"), for: .normal)
        
        if self.isImgRecordBtn{
            if self.recordingmanager == nil
            {
                
                
                
                DispatchQueue.global().async {
                    self.recordingmanager = photocameramanager()
                    
                    DispatchQueue.main.async {
                        self.startcapturesession()
                        self.setcamerapreviewUI()
                        
                        self.setupwhenviewwillappear()
                    }
                }
            }
            else{
                self.setupwhenviewwillappear()
            }
        }else{
           
                
                    DispatchQueue.main.async {
                        self.setcamerapreviewUI()
                        self.setupwhenviewwillappear()
                    }
            
        }
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DispatchQueue.main.async {
            self.stopcapturesession()
            NotificationCenter.default.removeObserver(self.runtimeErrorHandlingObserver!)
          
        }
        
    }
    
    
    func setupwhenviewwillappear()
    {
        
        
        if self.isImgRecordBtn{
            if let pmanager = self.recordingmanager
            {
                
                self.runtimeErrorHandlingObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureSessionRuntimeError, object: pmanager.capturesession, queue: nil, using: { (note) in
                    self.recordingmanager!.captureQueue.async {
                        let sess = pmanager.capturesession
                        if !sess.isRunning
                        {
                            sess.startRunning()
                        }
                        
                        
                    }
                })
                pmanager.capturesession.startRunning()
        }
        }
        else{
            self.startcapturesession()
        }
        
    }
    func setcamerapreviewUI()
    {
        
        if self.isImgRecordBtn{
            recordingmanager!.delegate = self;
            
            self.recordingmanager!.previewlayer.frame = self.vwCamera.bounds
            
            self.vwCamera.layer.insertSublayer(self.recordingmanager!.previewlayer, at: 0)
        }else{
            videoManager.delegate = self;
            
            self.videoManager.previewlayer.frame = self.vwCamera.bounds
            
            self.vwCamera.layer.insertSublayer(self.videoManager.previewlayer, at: 0)
        }
        
        
    }
    
    
    
    func startcapturesession()
    {
        
        if self.isImgRecordBtn{
            if let pmanager = self.recordingmanager
            {
                if !pmanager.capturesession.isRunning
                {
                    pmanager.capturesession.startRunning()
                    
                }
            }
        }else{
            
            if !self.videoManager.capturesession.isRunning
            {
                    self.videoManager.capturesession.startRunning()
                    
            }
            
        }
        
        
    }
    
    func stopcapturesession()
    {
        
        
        if self.isImgRecordBtn{
            if self.recordingmanager == nil{
                return
            }
            if self.recordingmanager!.capturesession.isRunning
            {
                self.recordingmanager!.capturesession.stopRunning()
            }
        }else{
            if self.videoManager.isrecording
            {
                    //                        recordinginterrupted = true
                    print("self.recordingmanager.isrecording = \(self.videoManager.isrecording)")
                    self.cameraBtn.sendActions(for: .touchUpInside)
            }
            if self.videoManager.capturesession.isRunning
            {
                    self.videoManager.capturesession.stopRunning()
            }
        }
        
        
    }
    
    
    
    func prepareForStartRecording(){
        self.timerView.isHidden = true
        self.galleryBtn.isHidden = true
        self.cameraSwitchBtn.isHidden = true
        self.cameraPositionBtn.isHidden = true
    }
    
    func prepareForStopRecording(){
        self.timerView.isHidden = false
        self.galleryBtn.isHidden = false
        self.cameraSwitchBtn.isHidden = false
        self.cameraPositionBtn.isHidden = false
    }
    
    
    
    override var shouldAutorotate: Bool {
        if (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight ||
            UIDevice.current.orientation == UIDeviceOrientation.unknown) {
            return false
        }
        else {
            return true
        }
    }
    
    @objc func onClickMyButton(sender: UIButton){
        print("button pressed")
    }
    
    
    @IBAction func cameraSwitchBtnClicked(_ sender: UIButton) {
         let btn = sender
                   btn.isSelected = !btn.isSelected
                   if btn.isSelected
                   {
                    
                    let onimage = UIImage(named: "cameraSwitch")
                                          btn.setImage(onimage, for: .normal)
                                       self.cameraBtn.setImage(UIImage(named: "imgCapture"), for: .normal)
                       
                       
                    self.isImgRecordBtn = false
                    
                    if self.recordingmanager!.capturesession.isRunning
                    {
                        self.recordingmanager!.capturesession.stopRunning()
                    }
                    
                    self.vwCamera.layer.sublayers = nil
                    videoManager.delegate = self;
                    
                    self.videoManager.previewlayer.frame = self.vwCamera.bounds
                    
                    self.vwCamera.layer.insertSublayer(self.videoManager.previewlayer, at: 0)
                    
                   }
                   else
                   {
                       
                      let onimage = UIImage(named: "videoSwitch")
                         btn.setImage(onimage, for: .normal)
                      self.cameraBtn.setImage(UIImage(named: "videoCapture"), for: .normal)
                    self.isImgRecordBtn = true
                    
                   
                        
                   }
        
       // self.stopcapturesession()
        
        
           //imgCapture videoCapture videoRecording  videoSwitch cameraSwitch
    }
    
    
    //MARK:- image/video record Button
    
    @IBAction func btnImageClick(_ sender: UIButton) {
        
        
        if isImgRecordBtn{
            if let pmanager = self.recordingmanager
            {
                pmanager.captureimage()

            }
        }else{
            
            if !self.isrecording{
                self.prepareForStartRecording()
//                self.hashqueue!.cancelAllOperations()
                self.videoManager.startrecoring()
                self.isrecording = true
            }else{
                self.stoprecording()
                self.prepareForStopRecording()
                self.videoManager.stoprecoring()
                self.isrecording = false
            }
            
            
        }
        
        
    }
    
    
    @IBAction func btnNextAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addProduvtDetailVC") as! AddProduvtDetailVC
        vc.imagesArr = self.imagesArr
        self.navigationController?.pushViewController(vc, animated: true)
        self.stopcapturesession()
    }
    
    @IBAction func btnGalleryClick(_ sender: Any) {

        
         let alert = UIAlertController(title: "Forsa", message: "Please Select an Option", preferredStyle: .actionSheet)
           
           alert.addAction(UIAlertAction(title: "Photo", style: .default , handler:{ (UIAlertAction)in
            self.gallery = GalleryController()
            self.gallery.delegate = self

            Config.Camera.imageLimit = 5 - (self.imagesArr.count - 1)
            Config.tabsToShow = [.imageTab]
            DispatchQueue.main.async {
            self.present(self.gallery, animated: true, completion: nil)
            }
           }))
           
           alert.addAction(UIAlertAction(title: "Video", style: .default , handler:{ (UIAlertAction)in
                self.gallery = GalleryController()
               Config.Camera.imageLimit = 5 - (self.imagesArr.count - 1)
               self.gallery.delegate = self
               Config.tabsToShow = [.videoTab]
            DispatchQueue.main.async {
            self.present(self.gallery, animated: true, completion: nil)
            }
           }))

          

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            
        }))
           
           //uncomment for iPad Support
           //alert.popoverPresentationController?.sourceView = self.view

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
           
    }
    
    @IBAction func btnCameraPositionClick(_ sender: Any) {
        
        if self.recordingmanager == nil
        {
            return
            
        }
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        if btn.isSelected
        {
            // self.camrotatebutton.setImage(UIImage(named: "Icon-Reverse.png"), for: .normal)
            self.recordingmanager!.switchcamerainputdevicetofront()
          //  self.camflashbutton.setImage(UIImage(named: "flashoff.png"), for: .normal)
                currentcameraposition = 1
                self.zoomfactor = 1.0
//                self.zoomlabel.text = "1.0x"
            self.currentcameraface = "Front"
        }
        else
        {
            //self.camrotatebutton.setImage(UIImage(named: "camerarotate.png"), for: .normal)
            self.recordingmanager!.swithcamerainputdevicetoback()
                currentcameraposition = 0
                self.zoomfactor = 1.0
//                self.zoomlabel.text = "1.0x"
             self.currentcameraface = "Back"
        }
    }
    
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        
        self.tabBarController?.selectedIndex = 0
        self.stopcapturesession()
    }
    
    @IBAction func flashBtnClicked(_ sender: UIButton) {
           if  currentcameraposition == 1
           {
                   return
           }
    
           if self.recordingmanager == nil
           {
               return
           }
           let btn = sender
           btn.isSelected = !btn.isSelected
           if btn.isSelected
           {
               self.recordingmanager!.openflashlight()
               
//               let onimage = UIImage(named: "flashon.png")
//               btn.setImage(onimage, for: .normal)
           }
           else
           {
               self.recordingmanager!.closeflashlight()
               
//               let onimage = UIImage(named: "flashoff.png")
//               btn.setImage(onimage, for: .normal)
           }
       }
    
    

    
    
    
//    @IBAction func removeImgPreviewBtnClicked(_ sender: UIButton) {
//        if let index = selectedIndex{
//            self.imagesArr.remove(at: index)
//            DispatchQueue.main.async {
//                self.photoCollection.reloadData()
//            }
//        }
//        DispatchQueue.main.async {
//            self.playerView.isHidden = true
//            self.removeImgPreviewBtn.isHidden = true
//
//        }
//        self.previewImgView.image = nil
//        //self.playerView.layer.sublayers = nil
//        self.removeChildController()
//        self.setcamerapreviewUI()
//    }
    
    
}




extension CameraViewController:videorecordingmanagerdelegate,photocameramanagerdelegate{
    
    
    //MARK:- photocameramanagerdelegate
    
    
    func updatewhenimagefilesavetocameraroll() {
        
    }
    
    func updatewhenimagefilesavetocamerarollfailed() {
        
    }
    
    func updatecurrentimagetaken(_ capturedimage: UIImage) {
        if let data:Data =  capturedimage.jpegData(compressionQuality: 1.0) {
            let metadatainphototab  = self.recordingmanager!.getImageProperties(data)
            
            print("metadata received is = \(metadatainphototab)")
//            self.capturedImage = capturedimage
//            self.processcurrentimage(data)
        }
        else
        {
          //  print("not valid image")
        }
    }
    
    func updatecurrenttakenimagedata(_ capturedimagedata: Data) {

            //                let metadatainphototab  = self.recordingmanager.getImageProperties(capturedimagedata)
            //
            //                print("metadata received is = \(metadatainphototab)")
            if let cappimage = UIImage(data: capturedimagedata)
            {
                    self.capturedImage = cappimage
                    //self.latestphotothumbnail = cappimage
                //self.imagesArr.append(cappimage)
                let model = mediamodel(thumbnail: cappimage, mediaisvideo: false, mediaisimage: true)
                self.imagesArr.append(model)
                DispatchQueue.main.async {
                    self.photoCollection.reloadData()
                }
 //                           self._performShutterAnimation {
//                                    self.resetthumbnailwithanimation()
//                                    self.processcurrentimage(capturedimagedata)

                                    
 //                           }
                            
            }
           
           
            
        }
    
    
    fileprivate func _performShutterAnimation(_ completion: (() -> Void)?) {
            
          let  validPreviewLayer = self.recordingmanager!.previewlayer
                    
                    DispatchQueue.main.async {
                            
                            let duration = 0.1
                            
                            CATransaction.begin()
                            
                            if let completion = completion {
                                    CATransaction.setCompletionBlock(completion)
                            }
                            
                            let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
                            fadeOutAnimation.fromValue = 1.0
                            fadeOutAnimation.toValue = 0.0
                            validPreviewLayer.add(fadeOutAnimation, forKey: "opacity")
                            
                            let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
                            fadeInAnimation.fromValue = 0.0
                            fadeInAnimation.toValue = 1.0
                            fadeInAnimation.beginTime = CACurrentMediaTime() + duration * 2.0
                            validPreviewLayer.add(fadeInAnimation, forKey: "opacity")
                            
                            CATransaction.commit()
                    }
    }
    
    
    //MARK:- videorecordingmanagerdelegate
    func updaterecordingtime(_ recordduration: CMTime) {
        
    }
    
    func updaterecordingprogress(_ progress: CGFloat) {
        
    }
    
    func updaterecordingvideoframedata(_ framedata: Data!) {
        
    }
    
    func updaterecordingvideoframeimage(_ capturedimage: UIImage!) {
        
    }
    
    func updatesamplebuffer(_ framecount: Int32) {
        
    }
    
    func updatewhenvideofilesavetocameraroll() {
        
    }
    
    func updatewhenvideofilesavetocamerarollfailed() {
        
    }
    
    func recordingmanagerreachedmaxrecordtime(_ maxrecordingtime: CGFloat) {
        
    }
    
    func interuption_stop_recording() {
        
    }
    
    func audio_video_interuption() {
        
    }
    
    
    func stoprecording() {
           
           
            
            
        videoManager.stoprecordinghandler { (firstframeimage) in
                    if firstframeimage != nil
                    {
                            self.cameraBtn.isSelected = false
                            self.latestvideothumbnail = firstframeimage
                            
                    }
                    
                    
                    self.cameraBtn.isSelected = false
                    self.videoUpdatetoQueue()
                    
                    
            }
            // startstoptimer.reset()
            
            
    }
    
    
    func videoUpdatetoQueue(){
            let completionOperation = BlockOperation(block: {() in
                    
                    
                    //                        self.activityIndicator.stopAnimating()
                    //
                    //                        self.clearbuttonclicked(self.clearbtn)
                    //                        self.opensharepopup()
            })
            let operation = BlockOperation(block: {() in

                self.videoManager.copyfiletodocumentdirectorywithhandler({ (filepath) in
                            if let docpath = filepath
                            {
                                    let fileurl = URL(fileURLWithPath: docpath)
                                    
                                    self.addVideoInArr(for: fileurl)
                                    print("filepath-----\(filepath)")
                            }
                            else
                            {
                                 
                            }
                    })
                    
                    
            })
            completionOperation.addDependency(operation)
            //self.hashqueue!.addOperation(operation)
            OperationQueue.main.addOperation(completionOperation)
    }
    
    func addVideoInArr(for videourl: URL){
        
        
        let model = mediamodel(thumbnail: self.latestvideothumbnail, mediaurl: videourl, mediaisvideo: true, mediaisimage: false)
        self.imagesArr.append(model)
        
        DispatchQueue.main.async {
            self.photoCollection.reloadData()
        }
    }
}


extension CameraViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 1{
//            return 1
//        }else{
            return imagesArr.count
//        }
          
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectImageCollectionViewCell", for: indexPath) as! SelectImageCollectionViewCell
        
//        if indexPath.section == 1{
//            cell.imgSelected.image = UIImage(named: "selectedcamera")
//            return cell
//        }else{
            let media = self.imagesArr[indexPath.item]
                   
                       cell.imgSelected.image = media.thumbnail
                   
                     return cell
//        }
       
      }
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
//        if indexPath.section == 1{
//            //self.startcapturesession()
//
//            self.removeChildController()
//            self.setcamerapreviewUI()
//        }else{
            self.selectedIndex = indexPath.row
//            let media = self.imagesArr[indexPath.row]
//            if media.mediaisimage{
//               // self.previewImgView.image = media.thumbnail
//                self.removeChildController()
//            }else{
//
//                if let asset = media.mediaassest{
//                    self.requestavasset(asset: asset)
//
//                }
//
////            }
//
//
//
//        }
        
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageSliderViewController") as! ImageSliderViewController
                     
                     self.navigationController?.pushViewController(vc, animated: true)
      }
    

    
    
    
}

extension CameraViewController: GalleryControllerDelegate {
    
    // MARK: - GalleryControllerDelegate

    func galleryControllerDidCancel(_ controller: GalleryController) {
      controller.dismiss(animated: true, completion: nil)
      gallery = nil
    }

    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
      controller.dismiss(animated: true, completion: nil)
      
        let videoAsst = video.asset
        self.getUrlFromPHAsset(asset: videoAsst) { (url) in
            if let videoUrl = url{
                let img = self.thumbnailForVideoAtURL(url: videoUrl)
                let model = mediamodel(mediaassest: videoAsst, thumbnail: img, mediaisvideo: true, mediaisimage: false)
                self.imagesArr.append(model)
                
                DispatchQueue.main.async {
                    self.photoCollection.reloadData()
                }
            }
            
        }
        
      controller.dismiss(animated: true, completion: nil)
      gallery = nil
    }

    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
//        self.imagesArr.removeAll()
        Image.resolve(images: images) { (imagesarr) in
            
            
            for images in imagesarr{
               let model = mediamodel(thumbnail: images, mediaisvideo: false, mediaisimage: true)
               self.imagesArr.append(model)
            }
            
            
            
            DispatchQueue.main.async {
                self.photoCollection.reloadData()
            }
            
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
    
    
    func getUrlFromPHAsset(asset: PHAsset, callBack: @escaping (_ url: URL?) -> Void)
    {
        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions(), completionHandler: { (contentEditingInput, dictInfo) in

            if let strURL = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString
            {
                //PRINT("VIDEO URL: \(strURL)")
                callBack(URL.init(string: strURL))
            }
        })
    }
    
    
    private func thumbnailForVideoAtURL(url: URL) -> UIImage? {

        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)

        var time = asset.duration
        time.value = min(time.value, 2)

        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    
    
}
