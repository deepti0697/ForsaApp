//
//  Validations.swift
//  AppTemplate
//
//  Created by admin on 15/01/19.
//  Copyright © 2019 dotsquare. All rights reserved.
//

import Foundation


import UIKit
import AVFoundation

class Validation: NSObject{
    
    
    // MARK: validate TextField
    class func validateTextFiled(textfiled: UITextField) -> Bool {
        
        textfiled.text = textfiled.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if textfiled.text==nil || textfiled.text == ""
        {
            return false
        }
        
        return true
        
    }
    
    // MARK: validate TextView
    class func validateTextView(textView: UITextView) -> Bool {
        
        textView.text = textView.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if textView.text==nil || textView.text == ""
        {
            return false
        }
        return true
    }
    
    
    
    
    
    func emailValidation(txtFieledEmail: String)-> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: txtFieledEmail)
    }
    
    func phoneNoValidation(txtFieldPhone:String)-> Bool{
        
        let charcter  = NSCharacterSet(charactersIn: "+0123456789").inverted
        var filtered:NSString!
        let inputString:NSArray = (txtFieldPhone as NSString).components(separatedBy: charcter) as NSArray
        filtered = inputString.componentsJoined(by: "") as NSString
        
        return  ((txtFieldPhone as NSString) == filtered && txtFieldPhone.count <= 15)
    }
    
    
    func phoneNumberLengthValidation(pNumber : String) -> Bool{
        return pNumber.count >= 4 && pNumber.count <= 16
    }
    
    func stringDoesNotExceed(pNumber : String,length : String )-> Bool{
        return pNumber.count > (length as NSString).integerValue
    }
    
    func specialCharacterNotEnter(txtField:String)->Bool {
        
        let characterSet:NSCharacterSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789").inverted as NSCharacterSet
        var filtered:String!
        let inputString:[String] = txtField.components(separatedBy: characterSet as CharacterSet)
        filtered = inputString.joined(separator: "") as String
        return txtField == filtered;
        
    }
    
    func PasswordAndConfirmPasswordMatch(txtfieldone:String ,secondValue txtfieldTwo:String)->Bool{
        return txtfieldone == txtfieldTwo;
    }
    
    func emptyTextFeild(txtfieldone:String )->Bool //,secondValue txtfieldTwo:String)
    {
        return txtfieldone.isEmpty
    }
    
    func postCodeValidation(txtfieldone:String )->Bool //,secondValue txtfieldTwo:String)
    {
        return txtfieldone.count >= 4 && txtfieldone.count <= 8
    }
    
    public func passwordValidation(_ password: String)->Bool{
        //(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%&*()_+=|<>?{}\\[\\]~-]).{8}
        let passwordRegex = "^(?=.*[a-z])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{6,15}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    
    func checkSpaceInPassword(txtField: String) -> Bool{
        
        let whitespace = NSCharacterSet.whitespaces
        let range = txtField.rangeOfCharacter(from: whitespace)
        // range will be nil if no whitespace is found
        if range != nil {
            return true
        }
        return false
    }
    
    
    func validationContaingSpecialCharacterDigitCharacher(txtField: String) ->Bool{
        let ValidlRegEx = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-16].*[0-16])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
        let Test = NSPredicate(format:"SELF MATCHES %@", ValidlRegEx)
        return Test.evaluate(with: txtField)
    }
    
    
    func validateStringDigit(txtField: String, length : Int) ->Bool
    {
        return txtField.count == length ? true : false
    }    
}
