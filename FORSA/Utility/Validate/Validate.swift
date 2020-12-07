//
//  Validate.swift
//  Maxillofacia
//
//  Created by apple on 11/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

class Validate: NSObject {
    static let  shared =  Validate()
    var validation = Validation()
 
    
    func showMessage(message:String){
        Common.showAlert(alertMessage: message, alertButtons: ["Ok"]) { (btn) in
        }
    }
    
    
       //Validate login form
         func   validateLogin(vc:LoginViewController) -> Bool {
             if vc.txtEmail.text?.trimmingCharacters(in: .whitespaces).count == 0  {
                 self.showMessage(message: Messages.EMAIL_EMPTY.rawValue)
               
                 return false
             } else if ( !validation.emailValidation(txtFieledEmail: vc.txtEmail.text!) ) {

                 self.showMessage(message: Messages.EMAIL_INVALID.rawValue)
              
                 return false

             } else if vc.txtPassword.text?.trimmingCharacters(in: .whitespaces).count == 0  {
                 self.showMessage(message: Messages.PASSWORD_EMPTY.rawValue)
                  
                 return false
             }else {
                 return true
             }
         }
    
    
    //    //Validate validateMobile
    func validateMobile(vc:LoginViewController) -> Bool {
       if vc.txtMobile.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            self.showMessage(message: Messages.PHONE_EMPTY.rawValue)
            return false
        }  else  if ((vc.txtMobile.text?.trimmingCharacters(in: .whitespaces).count)! < 8) || (((vc.txtMobile.text?.trimmingCharacters(in: .whitespaces).count)! > 12))  {
            self.showMessage(message: Messages.PHONE_INVALID.rawValue)
            return false
        }  else {
            return true
        }
    }

 func validateMobileWithSignUp(vc:SignUPWithPhoneVC) -> Bool {
       if vc.txtMobile.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            self.showMessage(message: Messages.PHONE_EMPTY.rawValue)
            return false
        }  else  if ((vc.txtMobile.text?.trimmingCharacters(in: .whitespaces).count)! < 8) || (((vc.txtMobile.text?.trimmingCharacters(in: .whitespaces).count)! > 12))  {
            self.showMessage(message: Messages.PHONE_INVALID.rawValue)
            return false
        }
       else  if !(vc.btnTick.isSelected) {
           self.showMessage(message: Messages.TICK_ALLOW.rawValue)
           return false
       } else {
            return true
        }
    }
    
    //Validate login form
//    func validateForgotPasswordSet(vc:OtpViewController) -> Bool {
//
//
//        if (vc.pin != "" && vc.pin.count < 4) {
//            self.showMessage(message: Messages.VERIFICATION_CODE.rawValue)
//            return false
//        } else if vc.txtNewPassword.text?.trimmingCharacters(in: .whitespaces).count == 0  {
//            self.showMessage(message: Messages.NEW_PASSWORD_EMPTY.rawValue)
//            return false
//        }  else  if (vc.txtNewPassword.text?.trimmingCharacters(in: .whitespaces).count)! < 4 {
//            self.showMessage(message: Messages.NEW_PASSWORD_LENGTH.rawValue)
//            return false
//        } else   if vc.txtConfirmPassword.text?.trimmingCharacters(in: .whitespaces).count == 0  {
//            self.showMessage(message: Messages.CONFIRM_PASSWORD_EMPTY.rawValue)
//            return false
//        }
//        else if vc.txtNewPassword.text != vc.txtConfirmPassword.text {
//            self.showMessage(message: Messages.PASSWORD_DIFFERENT.rawValue)
//            return false
//        }   else {
//            return true
//        }
//    }
//
//    //Validate login form
//      func validateChangePassword(vc:ChangePasswordViewController) -> Bool {
//
//
//          if (vc.pin.count < 4) {
//              self.showMessage(message: Messages.VERIFICATION_CODE.rawValue)
//              return false
//          } else if vc.txtNewPassword.text?.trimmingCharacters(in: .whitespaces).count == 0  {
//              self.showMessage(message: Messages.NEW_PASSWORD_EMPTY.rawValue)
//              return false
//          }  else  if (vc.txtNewPassword.text?.trimmingCharacters(in: .whitespaces).count)! < 4 {
//              self.showMessage(message: Messages.NEW_PASSWORD_LENGTH.rawValue)
//              return false
//          } else   if vc.txtConfirmPassword.text?.trimmingCharacters(in: .whitespaces).count == 0  {
//              self.showMessage(message: Messages.CONFIRM_PASSWORD_EMPTY.rawValue)
//              return false
//          }
//          else if vc.txtNewPassword.text != vc.txtConfirmPassword.text {
//              self.showMessage(message: Messages.PASSWORD_DIFFERENT.rawValue)
//              return false
//          }   else {
//              return true
//          }
//      }

    
//    //Validate Register form
    func validateRegistration(vc:RegisterViewController) -> Bool {
//        if vc.txtName.text?.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showMessage(message: Messages.NAME_EMPTY.rawValue)
//            return false
//        } else  if (vc.txtName.text?.trimmingCharacters(in: .whitespaces).count)! < 3 {
//            self.showMessage(message: Messages.FULL_NAME_LENGTH.rawValue)
//            return false
//        } else
            if vc.txtEmail.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            self.showMessage(message: Messages.EMAIL_EMPTY.rawValue)
            return false
        }else if !validation.emailValidation(txtFieledEmail: vc.txtEmail.text!) {
            self.showMessage(message: Messages.EMAIL_INVALID.rawValue)
            return false
        }
//            else if vc.txtMobile.text?.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showMessage(message: Messages.PHONE_EMPTY.rawValue)
//            return false
//        }  else  if ((vc.txtMobile.text?.trimmingCharacters(in: .whitespaces).count)! < 8) || (((vc.txtMobile.text?.trimmingCharacters(in: .whitespaces).count)! > 12))  {
//            self.showMessage(message: Messages.PHONE_INVALID.rawValue)
//            return false
//        }
            else if vc.txtPassword.text?.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .whitespaces).count == 0 {
            self.showMessage(message: Messages.PASSWORD_EMPTY.rawValue)
            return false
        } else  if (vc.txtPassword.text?.trimmingCharacters(in: .whitespaces).count)! < 4 {
            self.showMessage(message: Messages.PASSWORD_LENGTH.rawValue)
            return false
        }else  if !(vc.btnTick.isSelected) {
            self.showMessage(message: Messages.TICK_ALLOW.rawValue)
            return false
        } else {
            return true
        }
    }

    //Validate Forgot form
     func validateForgotPassword(vc:ForgotViewController) -> Bool {
        if vc.txtEmail.text?.trimmingCharacters(in: .whitespaces).count == 0  {
            self.showMessage(message: Messages.EMAIL_NUMBER.rawValue)
            return false
        } else if (!(vc.txtEmail.text!.isNumeric()) && !validation.emailValidation(txtFieledEmail: vc.txtEmail.text!) ) {
            
            self.showMessage(message: Messages.EMAIL_INVALID.rawValue)
            return false
            
        } else  if (vc.txtEmail.text!.isNumeric() && (((vc.txtEmail.text?.trimmingCharacters(in: .whitespaces).count)! < 8) || (((vc.txtEmail.text?.trimmingCharacters(in: .whitespaces).count)! > 14))))   {
            self.showMessage(message: Messages.PHONE_INVALID.rawValue)
            return false
        }
        else  {
            return true
        }
     }
    
   
    
   
//
    //Validate Language
    func validateLanguage(vc:SelectLanguageViewController) -> Bool {
        if let _ = vc.selectLangObj {
          
            return true
        }else {
              self.showMessage(message: Messages.LANG_EMPTY.rawValue)
            return false
        }
    }
    
    //Validate Language
     func validateCountry(vc:ChooseCountryViewController) -> Bool {
         if let _ = vc.selectedCountryObj {
           
             return true
         }else {
               self.showMessage(message: Messages.COUNTRY_EMPTY.rawValue)
             return false
         }
     }
//
//    //Validate Reset password form
//    func validateResetPassword(vc:ResetPassViewController) -> Bool {
//        if vc.txtVerification.text?.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showMessage(message: Messages.VERIFICATION_CODE.rawValue)
//            return false
//        }else if vc.txtNewPassword.text?.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showMessage(message: Messages.NEW_PASSWORD_EMPTY.rawValue)
//            return false
//        }else if vc.txtConfirmPass.text?.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showMessage(message: Messages.CONFIRM_PASSWORD_EMPTY.rawValue)
//            return false
//        }else if !validation.PasswordAndConfirmPasswordMatch(txtfieldone: vc.txtNewPassword.text!, secondValue: vc.txtConfirmPass.text!) {
//            self.showMessage(message: Messages.PASSWORD_DIFFERENT.rawValue)
//            return false
//        }else {
//            return true
//        }
//    }
//
//    //Validate Edit Profile form
//    func validateEditProfile(vc:ProfileViewController) -> Bool {
//        if !vc.txtFullName.hasText {
//            self.showMessage(message: Messages.NAME_EMPTY.rawValue)
//            return false
//        }else if !vc.txtPhoneNumber.hasText {
//            self.showMessage(message: Messages.PHONE_EMPTY.rawValue)
//            return false
//        } else {
//            return true
//        }
//    }
//
//    //Validate Billing Address Payment
//    func validateBillingAddressForPayment(vc:PaymentSummeryViewController) -> Bool {
//
//       if vc.txtCardType.text?.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showMessage(message: Messages.CARD_TYPE.rawValue)
//            return false
//        } else  if vc.txtCard1.text!.trimmingCharacters(in: .whitespaces).count  == 0 {
//            self.showMessage(message: Messages.CARD_EMPTY.rawValue)
//            return false
//        } else  if vc.txtCard1.text!.trimmingCharacters(in: .whitespaces).count < 16 {
//            self.showMessage(message: Messages.CARD_LENGTH.rawValue)
//            return false
//        } else  if vc.txtCVC.text!.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showMessage(message: Messages.CARD_CVV.rawValue)
//            return false
//        } else  if vc.txtExpireDate.text?.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showMessage(message: Messages.EXPIRY_DATE.rawValue)
//            return false
//       } else if vc.imgPhoto.image == UIImage(named: "placeholder") {
//         self.showMessage(message: Messages.LOCAL_ID.rawValue)
//         return false
//       }
//       else if vc.imgID.image == UIImage(named: "placeholder") {
//         self.showMessage(message: Messages.Photo_ID.rawValue)
//         return false
//       }
//       else if vc.txtPCode.text?.trimmingCharacters(in: .whitespaces).count == 0 {
//        self.showMessage(message: Messages.PHONE_Code.rawValue)
//        return false
//       }
//       else if vc.txtPhone.text?.trimmingCharacters(in: .whitespaces).count == 0 {
//        self.showMessage(message: Messages.PHONE_EMPTY.rawValue)
//        return false
//       }    else if vc.txtPhone.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 10 {
//        self.showMessage(message: Messages.PHONE_INVALID.rawValue)
//        return false
//       }
//       else if vc.txtVwAddressL1.text?.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showMessage(message: Messages.ADD_LINE1.rawValue)
//            return false
//        }
//            //        else if vc.txtVwAddressL1.text?.trim() == "" {
//            //            AppAlerts.showMessage(alertMessage: Messages.ADD_LINE2.rawValue)
//            //            return false
//            //        }
//        else if  vc.txtCity.text?.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showMessage(message: Messages.CITY_EMPTY.rawValue)
//            return false
//        }
//        else if  vc.txtCity.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 3 {
//            self.showMessage(message: Messages.CITY_LENGTH.rawValue)
//            return false
//        }
//        else if  vc.txtPost.text?.trimmingCharacters(in: .whitespaces).count ?? 0 == 0 {
//            self.showMessage(message: Messages.POSTAL_EMPTY.rawValue)
//            return false
//        }
//        else if  vc.txtPost.text?.trimmingCharacters(in: .whitespaces).count ?? 0  < 3 {
//            self.showMessage(message: Messages.POSTAL_LENGTH.rawValue)
//            return false
//        }
//
//        else if  vc.txtCountry.text?.trimmingCharacters(in: .whitespaces).count ?? 0 == 0 {
//            self.showMessage(message: Messages.COUNTRY_EMPTY.rawValue)
//            return false
//        }
//
//        else {
//            return true
//        }
//    }
//
//    //Validate card
//
//    func validateBillingAddressForPayment(vc:PaymentViewController) -> Bool {
//        if vc.txtAmount.text?.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showMessage(message: Messages.AMOUNT.rawValue)
//            return false
//        } else if vc.txtAmount.text?.components(separatedBy: ".").count ?? 0 > 2 {
//            self.showMessage(message: Messages.AMOUNT_VALID.rawValue)
//            return false
//        } else if (vc.cardTextField.cardNumber?.trimmingCharacters(in: .whitespaces).count == 0) || (vc.cardTextField.cardNumber?.trimmingCharacters(in: .whitespaces).count == nil) {
//            self.showMessage(message: Messages.CARD_EMPTY.rawValue)
//            return false
//        } else  if vc.cardTextField.cardNumber?.trimmingCharacters(in: .whitespaces).count ?? 0 < 16 {
//            self.showMessage(message: Messages.CARD_LENGTH.rawValue)
//            return false
//        } else  if vc.cardTextField.expirationMonth == 0 ||  vc.cardTextField.expirationYear == 0 {
//            self.showMessage(message: Messages.EXPIRY_DATE.rawValue)
//            return false
//        } else  if vc.cardTextField.cvc!.trimmingCharacters(in: .whitespaces).count == 0 {
//            self.showMessage(message: Messages.CARD_CVV.rawValue)
//            return false
//        } else {
//            return true
//        }
//
//    }
}
