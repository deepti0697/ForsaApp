//
//  Defines.swift
//  Panther
//
//  Created by Manish Jangid on 7/27/17.
//  Copyright © 2017 Manish Jangid. All rights reserved.
//

import Foundation
import UIKit




// MARK : GLOBAL Functions
func print_debug <T> (_ object:T)
{
    print(object)
}

let DateFormat_yyyy_mm_dd_hh_mm_ss_sss = "yyyy-MM-dd HH:mm:ss"

let DateFormat_yyyy_mm_dd_hh_mm_ss_0000 = "yyyy-MM-dd HH:mm:ss +0000"
let output_format_HH_mm_ss = "HH:mm:ss  MMM dd yyy"
let DateFormat_dd_mm_yyyy = "dd-MM-yyyy"
let DateFormat_dd_MM_yyyy = "yyyy-MM-dd"
let time_Format = "HH:mm"
let time_Format_S = "hh:mm:ss"
let appDelegate = UIApplication.shared.delegate as! AppDelegate



//MARK:- Service Keys

struct ServiceKeys{
    
    static let user_id = "user_id"
    static let vendor_id = "vendor_id"
    static let isFirstTime = "isFirstTime"
    static let full_name = "full_name"
    static let total_followers = "total_followers"
    static let total_following = "total_following"
    
    static let device_token = "device_token"
    static let token = "token"
    static let user_name = "user_name"
    static let email = "email"
    
    static let profile_image = "profile_image"
    static let phone_no = "phone_no"
    
    static let accout_type = "accout_type"
    static let dateFormat = "dateFormat"
    static let  timeFormat = "timeFormat"
    static let receiptNo  = "receiptNo"
    static let dob  = "dob"
    static let keyLatLong = "LatLon"
     static let keyAddressClient = "AddressClient"
   
      static let languageType = "languageType"
    
    static let keyContactNumber = "contact_number"
    static let keyProfileImage = "image_url"
   
    static let keyErrorCode = "errorCode"
    static let keyErrorMessage = "errMessage"
    static let keyUserType = "user_type"
    static let keyErrorDic = "errorDic"
    static let langId = "langId"
    
    
   
   
    
  
    static let keyStatus =  "status"
    static let KeyAccountName = "account_name"
    static let KeyPushNotificationDeviceToken = "KeyPushNotificationDeviceToken"
   

}

struct ServiceUrls
{
//    static let baseUrl = "http://34.238.160.251:3002/register_user"

    
    static let baseUrl = "http://dev.rglabs.net/forsa/api/"
    static let login = "v1/login"
    static let otp_login = "v1/mobile-login"
    static let register_otp = "v1/register-otp"
    
    static let language = "v1/languages"
    static let update_language = "v1/update-language"
    static let countries = "v1/countries"
    static let category = "v1/category"
    static let prdCategory = "v1/product-cat"
    static let prdSubCategory = "v1/product-subcat"
    static let update_country = "v1/update-country"
    static let update_category = "v1/update-category"
    static let home_product_ForGuest = "v1/home-prd-public" + "?categories_id=&recentlyadded=recentlyadded&mosttrending=mosttrending"
    static let home_product = "v1/home-prd" + "?categories_id=&recentlyadded=recentlyadded&mosttrending=mosttrending"
    static let register = "v1/register"
    static let register_new = "v1/register-new"
    
    
    static let enterregistrationcode = "patient/enter_registration_code"
    static let createpassword = "patient/create_password"
    static let forgot_password = "forgot_password"
    static let otpEnter = "verify_otp"
    static let generateOTP = "generate_otp"
  
    static let setPasswordForgot = "reset_pass_otp"
    
   
    static let get_state    = "get_state"
    static let list_queries  = "list_queries"
    static let create_request  = "create_request"
    static let update_user_fileds  = "update_user_fields"
    static let get_vendor_details = "get_vendor_details"
    static let upload_user_files = "upload_user_files"
    static let update_profile_image = "update_profile_data"
    static let addQuery             = "add_query"
     static let get_query_detail             = "get_query_detail"
    static let add_query_reply             = "add_query_reply"
    static let submit_contact_form =  "submit_contact_form"
    static let get_resume = "get_resume"
    static let list_notification_logs = "list_notification_logs"
    static let search_string = "search_queries"
    static let prd_like = "v1/prd-like"
    static let prd_wishlist = "v1/prd-wishlist"
    static let home_filter_user = "v1/home-filter-user"
    static let home_filter_guestUser = "v1/home-filter"
    static let settings = "v1/settings"
    static let supportform = "v1/supportform"
    static let languageFetch = "v1/languages"
    static let countryFetch = "v1/countries"
    static let logout = "v1/logout"
    static let transaction_record = "v1/transaction-record"
    static let transaction_detail_with_trans_id = "v1/transaction-detail?trans_id="
    static let submit_rating = "v1/submit-rating"
    
    static let prd_detail = "v1/prd-detail?prd_id="
    static let prd_similar = "v1/prd-similar?prd_id="
    static let prd_wishlist_detailPage = "v1/my-wishlist-prd?prd_id="
    static let prd_reviews_rating = "v1/prd-review-rating?prd_id="
    static let get_profile = "v1/get-profile"
    static let update_profile = "v1/update-profile"
    
    static let change_password = "v1/change-password"  //v1/following
    
    static let following = "v1/following"
    static let follower = "v1/follower"
    static let start_unfollow = "v1/start-unfollow"
    static let start_follow = "v1/start-follow"
    
    static let my_ads = "v1/my-ads"

    
//    http://dev.rglabs.net/forsa/api/v1/prd-detail?prd_id=25
//
//    http://dev.rglabs.net/forsa/api/v1/prd-similar?prd_id=25
//
//    http://dev.rglabs.net/forsa/api/v1/my-wishlist-prd?prd_id=25
//
//    http://dev.rglabs.net/forsa/api/v1/prd-review-rating?prd_id=25
}
struct ErrorCodes
{
    static let    errorCodeInternetProblem = -1 //Unable to update use
    
    static let    errorCodeSuccess = 1 // 'Process successfully.'
    static let    errorCodeFailed = 2 // 'Process failed.
}


struct CustomColor{
    
   
    static let darkBlueColor = UIColor(red: 10.0/255.0, green: 211.0/255.0, blue: 225.0/255.0, alpha: 1.0)
      static let lightBlueColor = UIColor(red: 4/255.0, green: 167/255.0, blue: 191/255.0, alpha: 1.0)
    static let selectedtabColor = UIColor(red: 236/255.0, green: 36.0/255.0, blue: 143.0/255.0, alpha: 0.8)
     static let backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)
     //236,66,143
}


struct CustomFont {
    static let boldfont13 = UIFont(name: "GlacialIndifference-Bold", size: 13)!
    static let boldfont18 =  UIFont(name: "GlacialIndifference-Bold", size: 18)!
    static let boldfont14 =  UIFont(name: "GlacialIndifference-Bold", size: 14)!
    static let regularfont17 =  UIFont(name: "GlacialIndifference-Regular", size: 17)!
    static let regularfont16 =  UIFont(name: "GlacialIndifference-Regular", size: 16)!
    static let regularfont14 =  UIFont(name: "GlacialIndifference-Regular", size: 14)!
    static let regularfont18 =  UIFont(name: "GlacialIndifference-Regular", size: 18)!
    static let regularfont15 =  UIFont(name: "GlacialIndifference-Regular", size: 15)!
    static let boldfont15 =  UIFont(name: "GlacialIndifference-Bold", size: 15)!
}






