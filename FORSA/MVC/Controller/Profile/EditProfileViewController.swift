//
//  EditProfileViewController.swift
//  FORSA
//
//  Created by apple on 01/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class EditProfileViewController: BaseViewController {
    
    @IBOutlet weak var txtName: UITextField!
    
     @IBOutlet weak var txtEmail: UITextField!
     @IBOutlet weak var txtPhone: UITextField!
     @IBOutlet weak var txtGender: UITextField!
     @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var profImgView: UIImageView!
    let picker = UIImagePickerController()
    var getUserProf = [String:JSON]()
    var profImgData = Data()
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        txtDOB.delegate = self
        txtGender.delegate = self
//        txtGender.placeholder = "Gender"
              Utilities.setRightViewIcon(icon: #imageLiteral(resourceName: "arrow-point-to-right (1)"), field: txtGender)
        Utilities.setRightViewIcon(icon: #imageLiteral(resourceName: "target"), field: txtLocation)
        self.getProfileApiCall()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   @IBAction func btnSubmitAction(_ sender: Any) {
//          self.navigationController?.popViewController(animated: true)
    
    self.updateProfileApiCall(imageData: profImgData)
      }
    
    
    
    @IBAction func profBtnClicked(_ sender: UIButton) {
        
        self.openAlert()
    }
    
    
    
     func latLong(lat: Double,long: Double)  {

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            print("Response GeoLocation : \(placemarks)")
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            let pm = placemarks! as [CLPlacemark]

              if pm.count > 0 {
                  let pm = placemarks![0]
                  print(pm.country)
                  print(pm.locality)
                  print(pm.subLocality)
                  print(pm.thoroughfare)
                  print(pm.postalCode)
                  print(pm.subThoroughfare)
                  var addressString : String = ""
                  if pm.subLocality != nil {
                      addressString = addressString + pm.subLocality! + ", "
                  }
                  if pm.thoroughfare != nil {
                      addressString = addressString + pm.thoroughfare! + ", "
                  }
                  if pm.locality != nil {
                      addressString = addressString + pm.locality! + ", "
                  }
                  if pm.country != nil {
                      addressString = addressString + pm.country! + ", "
                  }
                  if pm.postalCode != nil {
                      addressString = addressString + pm.postalCode! + " "
                  }

                print(addressString)

                self.txtLocation.text = addressString
            }

        })
    }
    
 
    func showActionsheet(textField : UITextField) {
        if textField == txtGender {
            let rowsArray = ["Male", "Female"]
            let placeHolder = "Gender"
            
            let customStringPicker = ActionSheetStringPicker.init(title:placeHolder, rows: rowsArray as [Any], initialSelection: 0, doneBlock:
            { picker, values, indexes in
                textField.text = (String(describing: indexes!))
                //                     self.selectLangObj = self.langArr[values]
                return
            }, cancel: nil, origin: textField)
            customStringPicker!.tapDismissAction = TapAction.cancel
            self.view.endEditing(true)
            customStringPicker!.show()
        } else {
               let date = Date()
                               
                               let datePicker = ActionSheetDatePicker(title: "Select Date", datePickerMode: UIDatePicker.Mode.date, selectedDate: date, doneBlock: {
                                   picker, value, index in
                                   picker?.tapDismissAction = TapAction.cancel
                                   textField.resignFirstResponder()
                                   let date = (String(describing: value!))
                                   textField.text = Utilities.convertToString(dateString: date, formatIn: DateFormat_yyyy_mm_dd_hh_mm_ss_0000, formatOut: DateFormat_dd_mm_yyyy)
                                   textField.resignFirstResponder()
                                   
                                   return
                               }, cancel: { ActionStringCancelBlock in
                                   textField.resignFirstResponder()
                                   return }, origin: textField)
                               self.view.endEditing(true)
            //                   datePicker?.minimumDate = Date()
                               datePicker?.show()
        }
    }
    
    
    func getProfileApiCall(){
        
        self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceFor_getProfile([:] , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                let data = parseData["data"].dictionaryValue
                self.getUserProf = data
                self.setupGetProfileData()
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
        
    }
    
    
    
    
    func setupGetProfileData(){
        var lattiude = Double()
        var longitude = Double()
        txtName.text = self.getUserProf["full_name"]?.stringValue
        txtEmail.text = self.getUserProf["email"]?.stringValue
        txtPhone.text = self.getUserProf["mobile"]?.stringValue
        txtGender.text = self.getUserProf["gender"]?.stringValue
        txtDOB.text = self.getUserProf["dob"]?.stringValue
        txtLocation.text = self.getUserProf["address"]?.stringValue
        
        if let urlStr = self.getUserProf["id_photo_url"]?.stringValue{
            if let url = URL(string: urlStr){
              profImgView.setImage(url: url)
            }
        }
        
        guard let lat =   self.getUserProf["latitude"]?.stringValue else{
            return
        }
        guard let long = self.getUserProf["longitude"]?.stringValue else{
            return
        }
        
        lattiude = (lat as NSString).doubleValue
        longitude = (long as NSString).doubleValue
        self.latLong(lat: lattiude, long: longitude)
        
    }

}



extension EditProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            showActionsheet(textField : textField)
            return false
       }
}


extension EditProfileViewController:UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    
    func updateProfileApiCall(imageData: Data)
    {
        
        self.hudShow()
        
        ServiceClass.sharedInstance.hitServiceFor_ProfileUpdate(["full_name":txtName.text!,"email":txtEmail.text!,"mobile":txtPhone.text!,"gender":txtGender.text!,"dob":txtDOB.text!,"location":txtLocation.text!,"user_name":txtName.text!], data: imageData , completion: { (type:ServiceClass.ResponseType, parseData:JSON, errorDict:AnyObject?) in
                     print_debug("response: \(parseData)")
                     self.hudHide()
            if (ServiceClass.ResponseType.kresponseTypeSuccess==type){
                
                let message = parseData["message"].stringValue
                self.alert(message: message) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else {
                
                self.makeToast((errorDict?[ServiceKeys.keyErrorMessage] as? String)!)
            }
        })
        
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        if(selectedImage != nil)
        {
            self.profImgView.image = selectedImage
            
        }
        // Dismiss the picker.
        dismiss(animated: true, completion: {
            
            DispatchQueue.main.async {
                if let data =  selectedImage.jpegData(compressionQuality: 0.8){
                    self.profImgData = data
                }
                
            }
            
        })
        
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func openAlert()
    {
        
        let alertController = UIAlertController(title: "Change Photo", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let cAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: {alert -> Void in
            self.btnCamera()
        })
        let gAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: {alert -> Void in
            self.btnGallary()
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("MSG53", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(cAction)
        alertController.addAction(gAction)
        
        alertController.addAction(cancelAction)
        if UIDevice.current.userInterfaceIdiom == .pad {
            guard let viewBase = self.view else {
                return
                
            }
            alertController.popoverPresentationController?.permittedArrowDirections = .up
            alertController.popoverPresentationController?.sourceView = self.view
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func btnCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: (NSLocalizedString("MSG43", comment: "")),
            message: (NSLocalizedString("MSG44", comment: "")),
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: (NSLocalizedString("MSG18", comment: "")),
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    func btnGallary() {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
//        picker.popoverPresentationController?.sourceView = self.imageViewProfile
    }

}
