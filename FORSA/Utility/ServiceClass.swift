//
//  ServiceClass.swift
//  TradeInYourLease
//
//  Created by Ajay Vyas on 10/2/17.
//  Copyright © 2017 Ajay Vyas. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class ServiceClass: NSObject {

    static let sharedInstance = ServiceClass()
 
    enum ResponseType : Int {
        case   kResponseTypeFail = 0
        case  kresponseTypeSuccess
    }
    
    typealias completionBlockType = (ResponseType, JSON, AnyObject?) ->Void
    
    
    func hudShow()  {
           SVProgressHUD.setDefaultMaskType(.clear)
           SVProgressHUD.show()
       }
       func hudHide()  {
           SVProgressHUD.dismiss()
       }
    
    
  //MARK:- Common Get Webservice calling Method using SwiftyJSON and Alamofire
        func hitServiceWithUrlString( urlString:String, parameters:[String:AnyObject],headers:HTTPHeaders,completion:@escaping completionBlockType)
        {
            if Reachability.forInternetConnection()!.isReachable()
            {
                print(headers)
                print(urlString)
                print(parameters)
                hudShow()
                AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers : headers)
                    .responseJSON { response in
                        self.hudHide()
                        guard case .success(let rawJSON) = response.result else {
                            print("SomeThing wrong")
                            
                            var errorDict:[String:Any] = [String:Any]()
                            errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                            errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong"
                            completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                            return
                        }
                        if rawJSON is [String: Any] {
                            let json = JSON(rawJSON)
                            print(json)
                            if  json["status"] == true {
                                completion(ResponseType.kresponseTypeSuccess,json,nil)
                            }
                            else {
                                var errorDict:[String:Any] = [String:Any]()
                                errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                                errorDict[ServiceKeys.keyErrorMessage] = json["message"].stringValue
                                errorDict[ServiceKeys.keyErrorDic] = json["errors"].dictionary
                                
                                print(json["error_code"].stringValue)
                                
                                if json["error_code"].stringValue == "delete_user"{
                                    SVProgressHUD.dismiss()
                                }
                                else {
                                    completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                                }
                            }
                        }
                }
            }
            else {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let errorDict = NSMutableDictionary()
                    errorDict.setObject(ErrorCodes.errorCodeInternetProblem, forKey: ServiceKeys.keyErrorCode as NSCopying)
                    errorDict.setObject("Check your internet connectivity", forKey: ServiceKeys.keyErrorMessage as NSCopying)
                    completion(ResponseType.kResponseTypeFail,JSON(),errorDict as NSDictionary)
                }
                
            }
            
        }
        
        
        func hitServiceWithUrlStringWithErrorList( urlString:String, parameters:[String:AnyObject],headers:HTTPHeaders,completion:@escaping completionBlockType)
          {
              if Reachability.forInternetConnection()!.isReachable()
              {
                  print(headers)
                  print(urlString)
                  print(parameters)
                   hudShow()
                  AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers : headers)
                      .responseJSON { response in
                        self.hudHide()
                          guard case .success(let rawJSON) = response.result else {
                              print("SomeThing wrong")
                              
                              var errorDict:[String:Any] = [String:Any]()
                              errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                              errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong"
                              completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                              return
                          }
                          if rawJSON is [String: Any] {
                              let json = JSON(rawJSON)
                              print(json)
                              if  json["status"] == true {
                                  completion(ResponseType.kresponseTypeSuccess,json,nil)
                              }
                              else {
                                  var errorDict:[String:Any] = [String:Any]()
                                  errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                                  errorDict[ServiceKeys.keyErrorMessage] = json["message"].string
                                    errorDict[ServiceKeys.keyErrorDic] = json["errors"].dictionary
                                
                                  print(json["error_code"].dictionary)
                                   completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                                  
                                  
                                  
                              }
                          }
                  }
              }
              else {
                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                      let errorDict = NSMutableDictionary()
                      errorDict.setObject(ErrorCodes.errorCodeInternetProblem, forKey: ServiceKeys.keyErrorCode as NSCopying)
                      errorDict.setObject("Check your internet connectivity", forKey: ServiceKeys.keyErrorMessage as NSCopying)
                      completion(ResponseType.kResponseTypeFail,JSON(),errorDict as NSDictionary)
                  }
                  
              }
              
          }
        
        func hitGetServiceWithUrlString( urlString:String, parameters:[String:Any],headers:HTTPHeaders,completion:@escaping completionBlockType)
        {
            if Reachability.forInternetConnection()!.isReachable()
            {
                hudShow()
                let updatedUrl = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                let url = URL(string: updatedUrl!)!
                print("URL \(url)")
                print("PARAMETERS: \(parameters)")
                
            
                
                AF.request(url, method: .get , encoding: JSONEncoding.prettyPrinted, headers: headers).responseJSON { response in
                    
                    self.hudHide()
                    guard case .success(let rawJSON) = response.result else {
                        print("SomeThing wrong")
                        
                        print(response.result)
                        
                        var errorDict:[String:Any] = [String:Any]()
                        errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                        errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong"
                        
                        completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                        return
                    }
                    if rawJSON is [String: Any] {
                        
                        let json = JSON(rawJSON)
                        print(json)
                        if  json["status"] == "success" || json["status"] == true {
                            completion(ResponseType.kresponseTypeSuccess,json,nil)
                        }
                        else {
                            var errorDict:[String:Any] = [String:Any]()
                            errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                            errorDict[ServiceKeys.keyErrorMessage] = json["message"].stringValue
                            print(json["error_code"].stringValue)
                            
                            
                            if json["error_code"].stringValue == "delete_user"{
                                SVProgressHUD.dismiss()
                                
                            }
                            else {
                                completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                            }
                            
                            
                        }
                    }
             
                }
            }
                
            else  {
     
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let errorDict = NSMutableDictionary()
                    errorDict.setObject(ErrorCodes.errorCodeInternetProblem, forKey: ServiceKeys.keyErrorCode as NSCopying)
                    errorDict.setObject("Check your internet connectivity", forKey: ServiceKeys.keyErrorMessage as NSCopying)
                    completion(ResponseType.kResponseTypeFail,JSON(),errorDict as NSDictionary)
                }
            }
        }
        
        func hitGetServiceWithUrlParams( urlString:String, parameters:[String:Any],headers:HTTPHeaders,completion:@escaping completionBlockType)
           {
            
               if Reachability.forInternetConnection()!.isReachable()
               {
                   hudShow()
                   let updatedUrl = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                   let url = URL(string: updatedUrl!)!
                   print("URL \(url)")
                   print("PARAMETERS: \(parameters)")
                   
               
                   
                   AF.request(url, method: .get,parameters: parameters  , encoding: URLEncoding.default, headers: headers).responseJSON { response in
                       
                    self.hudHide()
                       guard case .success(let rawJSON) = response.result else {
                           print("SomeThing wrong")
                           
                           print(response.result)
                           
                           var errorDict:[String:Any] = [String:Any]()
                           errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                           errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong"
                           
                           completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                           return
                       }
                       if rawJSON is [String: Any] {
                           
                           let json = JSON(rawJSON)
                           print(json)
                           if  json["status"] == true {
                               completion(ResponseType.kresponseTypeSuccess,json,nil)
                           }
                           else {
                               var errorDict:[String:Any] = [String:Any]()
                               errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                               errorDict[ServiceKeys.keyErrorMessage] = json["message"].stringValue
                               print(json["error_code"].stringValue)
                               
                               
                               if json["error_code"].stringValue == "delete_user"{
                                   SVProgressHUD.dismiss()
                                   
                               }
                               else {
                                   completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                               }
                               
                               
                           }
                       }
                
                   }
               }
                   
               else  {
        
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                       let errorDict = NSMutableDictionary()
                       errorDict.setObject(ErrorCodes.errorCodeInternetProblem, forKey: ServiceKeys.keyErrorCode as NSCopying)
                       errorDict.setObject("Check your internet connectivity", forKey: ServiceKeys.keyErrorMessage as NSCopying)
                       completion(ResponseType.kResponseTypeFail,JSON(),errorDict as NSDictionary)
                   }
               }
           }
        
        func imageUpload(_ urlString:String, params:[String : Any],data : Data?,imageKey:String,fileName: String?,
        pathExtension: String?, headers:HTTPHeaders, completion:@escaping completionBlockType){
            
            print(urlString)
    //        print(params)
    //        AF.upload(multipartFormData:{ multipartFormData in
    ////            if let data1 = data {
    //            multipartFormData.append(data ?? Data() , withName: imageKey, fileName: "file.jpg", mimeType: "image/jpg")
    ////            }
                hudShow()
                                
                    AF.upload(multipartFormData: { multipartFormData in
    //                           if let data1 = data {
    //                            multipartFormData.append(data1 , withName:  imageKey, fileName: "attachment", mimeType: "image/jpg")
    //                                          }
                        if let data = data {
                            multipartFormData.append(data, withName: "fileUpload", fileName: "\(fileName!).\(pathExtension!)", mimeType: "\(fileName!)/\(pathExtension!)")
                        }
                                   
    //                    multipartFormData.append(data ?? Data() , withName:  "identified", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                                    
                                    for (key, value) in params {
                                   
                                            let str = "\(value)"
                                            multipartFormData.append(((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
                                    }
                       }, to: urlString, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
                           print("Upload Progress: \(progress.fractionCompleted)")
                       }).responseJSON(completionHandler: { data in
                           print("upload finished: \(data)")
                       }).response { (response) in
                        self.hudHide()
                        switch response.result {
                        case .success(let _):
                            
                                guard case .success(let rawJSON) = response.result else {
                                    var errorDict:[String:Any] = [String:Any]()
                                    errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                                    errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong" + urlString
                                    
                                    completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                                    
                                    return
                                }
                                print(rawJSON ?? "")
                
                                if let rawJSN = rawJSON {
                                    let json = try? JSON(data: rawJSN)
                                    
                                    if  json?["status"] == "false"{
                                        var errorDict:[String:Any] = [String:Any]()
                                        
                                        errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                                        errorDict[ServiceKeys.keyErrorMessage] = json?["message"].stringValue
                                        
                                        completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                                    }
                                    else {
                                        completion(ResponseType.kresponseTypeSuccess,json ?? JSON(),nil)
                                    }
                                
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                    }

        }
        
        
        //multiple images upload
        func multipleImageUpload(_ urlString:String, params:[String : Any],data: [Data],identifiedImageData : Data,headers:HTTPHeaders, completion:@escaping completionBlockType){
             
             print(urlString)
             print(params)
             print(data)
            
            hudShow()
            AF.upload(multipartFormData: { multipartFormData in
                      for imgData in data {
                                          multipartFormData.append(imgData , withName:  "file_data[]", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                                      }
                           
                            multipartFormData.append(identifiedImageData , withName:  "identified", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                            
                            for (key, value) in params {
                           
                                    let str = "\(value)"
                                    multipartFormData.append(((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
                            }
               }, to: urlString, method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
                   print("Upload Progress: \(progress.fractionCompleted)")
               }).responseJSON(completionHandler: { data in
                   print("upload finished: \(data)")
               }).response { (response) in
                self.hudHide()
                switch response.result {
                case .success(let _):
                    
                        guard case .success(let rawJSON) = response.result else {
                            var errorDict:[String:Any] = [String:Any]()
                            errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                            errorDict[ServiceKeys.keyErrorMessage] = "SomeThing wrong" + urlString
                            
                            completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                            
                            return
                        }
                        print(rawJSON ?? "")
        
                        if let rawJSN = rawJSON {
                            let json = try? JSON(data: rawJSN)
                            
                            if  json?["status"] == "error"{
                                var errorDict:[String:Any] = [String:Any]()
                                
                                errorDict[ServiceKeys.keyErrorCode] = ErrorCodes.errorCodeFailed
                                errorDict[ServiceKeys.keyErrorMessage] = json?["message"].stringValue
                                
                                completion(ResponseType.kResponseTypeFail,JSON(),errorDict as AnyObject);
                            }
                            else {
                                completion(ResponseType.kresponseTypeSuccess,json ?? JSON(),nil)
                            }
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }

             
         }
     
       //MARK:- EmailLogin
      func hitServiceForEmailLogin(_ params:[String : Any], completion:@escaping completionBlockType)
      {
          let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.login)"
         
          let headers: HTTPHeaders = [:]
          self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
      }
  
    
    //MARK:- OTPLogin
     func hitServiceForOTPLogin(_ params:[String : Any], completion:@escaping completionBlockType)
     {
         let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.otp_login)"
        
         let headers: HTTPHeaders = [:]
         self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
     }
    
    //MARK:- OTP Send
    func hitServiceForOTPSend(_ params:[String : Any], token: String, completion:@escaping completionBlockType)
        {
            let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.register_otp)"
           
             let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
            self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
        }
    
    
    
    // For SignUp
    func hitServiceForRegistration(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.enterregistrationcode)"
        print(baseUrl)
           let headers: HTTPHeaders = [ "Content-Type" : "application/json"]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    
    func hitServiceForForgotPassword(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.forgot_password)"
        print(baseUrl)
        let headers: HTTPHeaders = [:]
        print_debug(params)
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
    
   func hitServiceForUpdatePassword(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.change_password)"
        print(baseUrl)
        let headers: HTTPHeaders = ["Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
        self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
    }
    
//    func hitServiceForLogOut(_ params:[String : Any], completion:@escaping completionBlockType)
//               {
//                   let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.logout)"
//                   print(baseUrl)
//                   let headers: HTTPHeaders = ["Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
//                   print_debug(params)
//                   self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
//               }
    
    func hitServiceForResetPassword(_ params:[String : Any], completion:@escaping completionBlockType)
         {
             let baseUrl = "\(ServiceUrls.baseUrl)\(ServiceUrls.setPasswordForgot)"
             print(baseUrl)
             let headers: HTTPHeaders = [ "Content-Type" : "application/json"]
             print_debug(params)
             self.hitServiceWithUrlString(urlString: baseUrl, parameters: params as [String : AnyObject] , headers: headers, completion: completion)
         }
    
   
    
   


    //MARK:- Register
    func hitServiceForRegister(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.register)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json"]
       
        self.hitServiceWithUrlStringWithErrorList(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
    }

   
    
    //MARK:- Register_new
    func hitServiceForRegister_New(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.register_new)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json"]
       
        self.hitServiceWithUrlStringWithErrorList(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
    }
    
    //MARK:- Get languages
   
      func hitServiceForGetAllLanguages(_ params:[String : Any], completion:@escaping completionBlockType)
      {
          let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.language)"
         
          let headers: HTTPHeaders = [ "Content-Type" : "application/json"]
          self.hitGetServiceWithUrlParams(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
      }
    
    //    //MARK : Submit Lang
    func hitServiceForSubmitLanguage(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.update_language)"
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
        self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
    }
    
    
    
     //MARK:- Get Country
    
       func hitServiceForGetAllCountry(_ params:[String : Any], completion:@escaping completionBlockType)
       {
           let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.countries)"
          
           let headers: HTTPHeaders = [ "Content-Type" : "application/json"]
           self.hitGetServiceWithUrlParams(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
       }
    
    //MARK:- Get category
       
          func hitServiceForGetAllCategory(_ params:[String : Any], completion:@escaping completionBlockType)
          {
              let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.category)"
             
              let headers: HTTPHeaders = [ "Content-Type" : "application/json","Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
              self.hitGetServiceWithUrlParams(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
          }
    
     
     //    //MARK : Submit Country
     func hitServiceForSubmitCountry(_ params:[String : Any], completion:@escaping completionBlockType)
     {
         let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.update_country)"
         let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
         self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
     }
    //    //MARK : update_category
        func hitServiceForSubmitCategory(_ params:[String : Any], completion:@escaping completionBlockType)
        {
            let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.update_category)"
            let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
            self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
        }
    
    
    func hitServiceForGet_PrdCategory(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.prdCategory)"
       
        let headers: HTTPHeaders = [ "Content-Type" : "application/json","Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
        self.hitGetServiceWithUrlParams(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
    }
    
    func hitServiceFor_SubPrdCategory(_ params:[String : Any], completion:@escaping completionBlockType)
       {
           let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.prdSubCategory)"
          
           let headers: HTTPHeaders = [ "Content-Type" : "application/json","Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
           self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
       }
    
    
    func hitServiceForHomeProductForGuest(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.home_product_ForGuest)"
       
        self.hitGetServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: [:], completion: completion)
    }
    
    func hitServiceForHomeProduct(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.home_product)"
       let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
        self.hitGetServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
    }
    
    //MARK:- Product Like
    func hitServiceFor_prdLike(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.prd_like)"
       
        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
        self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
    }
    
    //MARK:- Product wishlist
       func hitServiceFor_prdWishlist(_ params:[String : Any], completion:@escaping completionBlockType)
       {
           let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.prd_wishlist)"
          
           let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
           self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
       }
    
 //MARK:- hit service for home filter
    func hitServiceForHomeFilter(_ params:[String : Any], completion:@escaping completionBlockType)
    {
        let isLogin = AppHelper.getBoolForKey("logIn")
        if isLogin == true{
          let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.home_filter_user)"
          let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
           self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
        }else{
            let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.home_filter_guestUser)"
                   self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: [:], completion: completion)
        }
        
        
    }
    
    
    //MARK:- supportform API Call
    
          func hitServiceFor_supportform(_ params:[String : Any], completion:@escaping completionBlockType)
          {
              let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.supportform)"
             
              let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
              self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
          }
    
  //MARK:- Settings API Call
     
           func hitServiceFor_settings(_ params:[String : Any], completion:@escaping completionBlockType)
           {
               let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.settings)"
              
               let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
               
                self.hitGetServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
           }
    
    
    //MARK:- language fetch API Call
       
             func hitServiceFor_languageFetch(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.languageFetch)"
                
                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
                 
                  self.hitGetServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
             }
    
    //MARK:- country Fetch API Call
       
             func hitServiceFor_CountryFetch(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.countryFetch)"
                
                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
                 
                  self.hitGetServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
             }
    
    
    func hitServiceForLogout(_ params:[String : Any], completion:@escaping completionBlockType)
       {
           let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.logout)"
          let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
           self.hitGetServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
       }
    
    
    
//    //MARK:- Add Product Detail With Media
//    
//    func hitServiceForPrdDetail(_ params:[String : Any], completion:@escaping completionBlockType)
//       {
//           let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.home_product)"
//          let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
//           self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
//        
//       }
    
    
    //MARK:- TransactionRecord Fetch API Call
    
          func hitServiceFor_TransactionRecord(_ params:[String : Any], completion:@escaping completionBlockType)
          {
              let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.transaction_record)"
             
              let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
              
               self.hitGetServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
          }
    
    func hitServiceFor_TransactionDetail(_ params:[String : Any], completion:@escaping completionBlockType)
          {
              let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.transaction_detail_with_trans_id)"
             
              let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
              
            self.hitGetServiceWithUrlString(urlString: urlString + (params["trans_id"] as! String), parameters:[:], headers: headers, completion: completion)
          }
    
    
    
    func hitServiceFor_submitRating(_ params:[String : Any], completion:@escaping completionBlockType)
          {
              let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.submit_rating)"
             
              let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
              
               self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
          }
   
    
    
    //MARK:- PRODUCT DETAIL PAGE API's
    
    func hitServiceFor_Prd_detail(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.prd_detail)"

                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]

               self.hitGetServiceWithUrlString(urlString: urlString + (params["prd_id"] as! String), parameters:[:], headers: headers, completion: completion)
             }
    
    
    func hitServiceFor_Prd_similar(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.prd_similar)"

                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]

               self.hitGetServiceWithUrlString(urlString: urlString + (params["prd_id"] as! String), parameters:[:], headers: headers, completion: completion)
             }
    
    
    func hitServiceFor_Prd_wishlist_detailPage(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.prd_wishlist_detailPage)"

                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]

               self.hitGetServiceWithUrlString(urlString: urlString + (params["prd_id"] as! String), parameters:[:], headers: headers, completion: completion)
             }
    
    
    func hitServiceFor_Prd_review_rating(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.prd_reviews_rating)"

                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]

               self.hitGetServiceWithUrlString(urlString: urlString + (params["prd_id"] as! String), parameters:[:], headers: headers, completion: completion)
             }
    
    
    
    //MARK:- PROFILE UPDATE AND VIEW
    
    func hitServiceFor_getProfile(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_profile)"

                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]

               self.hitGetServiceWithUrlString(urlString: urlString, parameters:[:], headers: headers, completion: completion)
             }
    
    
    func hitServiceFor_ProfileUpdate(_ params:[String : Any],data: Data,imageKey:String="image", completion:@escaping completionBlockType)
          {
              let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.update_profile)"
             
              let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
              
               self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
            
            self.imageUpload(urlString, params: params as [String : AnyObject], data: data, imageKey: imageKey, fileName: imageKey, pathExtension: ".jpg", headers: headers, completion: completion)
          }
    
    func hitServiceFor_changePassword(_ params:[String : Any], completion:@escaping completionBlockType)
          {
              let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.change_password)"
             
              let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]
              
               self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
          }
    
    
    
    //MARK:- FOllowing and Follower APi call
    
    
    func hitServiceFor_following(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.following)"

                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]

               self.hitGetServiceWithUrlString(urlString: urlString, parameters:[:], headers: headers, completion: completion)
             }
    
    func hitServiceFor_followers(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.follower)"

                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]

               self.hitGetServiceWithUrlString(urlString: urlString, parameters:[:], headers: headers, completion: completion)
             }
    
    
    func hitServiceFor_start_follow(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.start_follow)"

                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]

               self.hitServiceWithUrlString(urlString: urlString, parameters:params as [String : AnyObject], headers: headers, completion: completion)
             }
    
    
    func hitServiceFor_start_unfollow(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.start_unfollow)"

                 let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]

               self.hitServiceWithUrlString(urlString: urlString, parameters:params as [String : AnyObject], headers: headers, completion: completion)
             }
   
    func hitServiceFor_myAds(_ params:[String : Any], completion:@escaping completionBlockType)
             {
                 let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.my_ads)"

                let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization": "Bearer " + AppHelper.getStringForKey(ServiceKeys.token)]

               self.hitGetServiceWithUrlString(urlString: urlString, parameters:params as [String : AnyObject], headers: headers, completion: completion)
             }
//    
//     
//     //MARK:- Get all board list
//    
//       func hitServiceForGetAllBoard(_ params:[String : Any], completion:@escaping completionBlockType)
//       {
//           let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.board_list)"
//          
//           let headers: HTTPHeaders = [ "Content-Type" : "application/json"]
//           self.hitGetServiceWithUrlParams(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
//       }
//   
//    //MARK:- Get all sub list
//      
//         func hitServiceForGetAllSubjects(_ params:[String : Any], completion:@escaping completionBlockType)
//         {
//             let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.subject_list)"
//            
//             let headers: HTTPHeaders = [ "Content-Type" : "application/json"]
//             self.hitGetServiceWithUrlParams(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
//         }
//    

//    
//    //MARK : Get Tutor Details
//       func hitServiceForGetTutorDetail(_ params:[String : Any], completion:@escaping completionBlockType)
//       {
//           let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.tutor_profile)"
//           let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
//        self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
//       }
//    
//    //MARK : Submit Message
//       func hitServiceForSubmitMessage(_ params:[String : Any], completion:@escaping completionBlockType)
//       {
//           let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.tutor_send_message)"
//        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization" : "bearer " + AppHelper.getStringForKey(ServiceKeys.token) ]
//        self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
//       }
//    
//    
//    //MARK : Follow API
//          func hitServiceForCreateFollower(_ params:[String : Any], completion:@escaping completionBlockType)
//          {
//              let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.create_follower)"
//           let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization" : "bearer " + AppHelper.getStringForKey(ServiceKeys.token) ]
//           self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
//          }
//    
//    //MARK : Submit Rate
//         func hitServiceForSubmitRating(_ params:[String : Any], completion:@escaping completionBlockType)
//         {
//             let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.tutor_rating_by_student)"
//          let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization" : "bearer " + AppHelper.getStringForKey(ServiceKeys.token) ]
//          self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
//         }
// 
//    //MARK : Join API
//           func hitServiceForJoin(_ params:[String : Any], completion:@escaping completionBlockType)
//           {
//               let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.create_follower)"
//            let headers: HTTPHeaders = [ "Content-Type" : "application/json", "Authorization" : "bearer " + AppHelper.getStringForKey(ServiceKeys.token) ]
//            self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
//           }
//    
//    //MARK : Get search
//       func hitServiceForSearchQueries(_ params:[String : Any], completion:@escaping completionBlockType)
//       {
//           let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.search_string)"
//           let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
//           self.hitGetServiceWithUrlParams(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
//       }
//    
// 
//  
//    //MARK : Get All Notification
//      func hitServiceForGetAllTutorVideos(_ params:[String : Any], completion:@escaping completionBlockType)
//      {
//          let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.tutor_profile_videos)"
//          let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
//       self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
//      }
//
//    
//    //MARK : Get Community Detail
//     func hitServiceForGetAllCommunityDetail(_ params:[String : Any], completion:@escaping completionBlockType)
//     {
//         let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_query_detail)"
//         let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
//        self.hitGetServiceWithUrlParams(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
//     }
//    
// 
//    //MARK : Create Request
//    func hitServiceForReviewRateList(_ params:[String : Any], completion:@escaping completionBlockType)
//    {
//        let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.tutor_review_list)"
//        let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
//        self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
//    }
//
//    
    
    //MARK :  Post upload ans
       func hitServiceForUploadPost(_ params:[String : Any], completion:@escaping completionBlockType)
       {
           let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.add_query_reply)"
           let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
           self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
       }

    
    //MARK : Get vendor info
    func hitServiceForUploadImages(_ params:[String : Any],data: [Data],identifiedImageData : Data, completion:@escaping completionBlockType)
           {
               let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.upload_user_files)"
               let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
            self.multipleImageUpload(urlString, params: params, data: data, identifiedImageData: identifiedImageData, headers: headers, completion: completion)
           }
    
  
    
    
    
    //MARK :  Post upload ans
       func hitServiceForContactUs(_ params:[String : Any], completion:@escaping completionBlockType)
       {
           let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.submit_contact_form)"
           let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
           self.hitServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
       }
    
    
      //MARK : Get AllCommunity
      func hitServiceForGetDoctorDetail(_ params:[String : Any], completion:@escaping completionBlockType)
      {
          let urlString = "\(ServiceUrls.baseUrl)\(ServiceUrls.get_resume)"
          let headers: HTTPHeaders = [ "Content-Type" : "application/json", "access_token": AppHelper.getStringForKey(ServiceKeys.token)]
          self.hitGetServiceWithUrlString(urlString: urlString, parameters: params as [String : AnyObject], headers: headers, completion: completion)
      }
}
