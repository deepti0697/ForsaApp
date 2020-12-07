//
//  Model.swift
//  ASOEBI
//
//  Created by apple on 03/08/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import SwiftyJSON
import Photos

class User{
    
    var user_name   : String!
    var email       : String!
    var mobile    : String!
    var accountType : String!
    var token       : String!
    var id   : String!
    var otp_verified : Int?
    var img_url      : String?
    var verification_token : String?
    var receiptNo     : String?
    var dob     : String?
    var lat_long : String?
    var address : String?
    var full_name : String?
    var total_followers : String?
    var total_following : String?
    var is_verified : String?
    var last_login : String?

    init() { }
    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        
        let json            = parseData["data"]
        user_name           = json["user_name"].stringValue
        email               = json["email"].stringValue
        mobile              = json["mobile"].stringValue
        token               = json["token"].stringValue
        otp_verified         = json["otp_verified"].intValue
        img_url               = json["image"].stringValue
        verification_token    = json["verification_token"].stringValue
        receiptNo             = json["receiptNo"].stringValue
        dob                     = json["dob"].stringValue
        lat_long                = json["param_data"]["lat_long"].stringValue
        address                = json["param_data"]["address"].stringValue
        full_name              = json["full_name"].stringValue
        id                     = json["id"].stringValue
        last_login             = json["last_login"].stringValue
        total_followers             = json["total_followers"].stringValue
        total_following             = json["total_following"].stringValue
        is_verified             = json["is_verified"].stringValue
    }
}


class LanguageDTo {
    
    var lang_code                 : String!
    var id                    : String!
    var title             : String!
    var name             : String!
    
    init() {
        
    }
    
    init(fromJson parseData: JSON!){
        
        if parseData?.isEmpty ?? false{
            return
        }
        lang_code               = parseData["lang_code"].stringValue
        id                  = parseData["id"].stringValue
        title           = parseData["title"].stringValue
        name           = parseData["name"].stringValue
        
    }
}

class CategoryDTo {
    
    var id               : String!
    var cat_name            : String!
    var isSelected : Bool = false
    var img : String!
    var subcat_id:String!
    var subcat_name:String!
    
    init(fromJson parseData: JSON!){
      
        if parseData.isEmpty{
            return
        }
        cat_name             = parseData["cat_name"].stringValue
        id          = parseData["id"].stringValue
        img = parseData["cat_image"].stringValue
        subcat_id = parseData["subcat_id"].stringValue
        subcat_name = parseData["subcat_name"].stringValue
    }
}

class TransactionDetailModel {
    
    var id               : String!
    var order_id            : String!
    var trans_id : String!
    var title:String!
    var buyer_user_id:String!
    var seller_user_id:String!
    var buyerusername:String!
    var sellerusername:String!
    var transactiondate:String!
    var productimg:String!
    var buyeruserimg:String!
    var selleruserimg:String!
    
    init(fromJson parseData: JSON!){
      
        if parseData.isEmpty{
            return
        }
        id             = parseData["id"].stringValue
        order_id          = parseData["order_id"].stringValue
        trans_id = parseData["trans_id"].stringValue
        title = parseData["title"].stringValue
        buyer_user_id = parseData["buyer_user_id"].stringValue
        seller_user_id = parseData["seller_user_id"].stringValue
        buyerusername = parseData["buyerusername"].stringValue
        sellerusername = parseData["sellerusername"].stringValue
        transactiondate = parseData["transactiondate"].stringValue
        productimg = parseData["productimg"].stringValue
        buyeruserimg = parseData["buyeruserimg"].stringValue
        selleruserimg = parseData["selleruserimg"].stringValue
    }
}


class HomeProductForGuest {
    
    var id               : String!
    var total_like            : String!
    var user_id : String!
    var title : String!
    var third_category_id : String!
    var file_name : String!
    var total_view : String!
    var status : String!
    var visibility : String!
    var description : String!
    var subcategory_id : String!
    var created_at : String!
    var category_id : String!
    var likeornot:String!
    var wishstatus:String!
    
    init(fromJson parseData: JSON!){
      
        if parseData.isEmpty{
            return
        }
        total_like             = parseData["total_like"].stringValue
        id          = parseData["id"].stringValue
        user_id          = parseData["user_id"].stringValue
        title          = parseData["title"].stringValue
        third_category_id          = parseData["third_category_id"].stringValue
        file_name          = parseData["file_name"].stringValue
        total_view          = parseData["total_view"].stringValue
        status          = parseData["status"].stringValue
        visibility          = parseData["visibility"].stringValue
        description          = parseData["description"].stringValue
        subcategory_id          = parseData["subcategory_id"].stringValue
        created_at          = parseData["created_at"].stringValue
        category_id          = parseData["category_id"].stringValue
        likeornot = parseData["likeornot"].stringValue
        wishstatus = parseData["wishstatus"].stringValue
    }
}



class HomeFilterModel {
    
    var sortByArr = [sortbyFilterData]()
    var categoriesArr = [categoriesFilterData]()
    
    init(fromJson parseData: JSON!){
      
        if parseData.isEmpty{
            return
        }
        let sortData = parseData["sortbyrec"].arrayValue
        let categoriesData = parseData["categrec"].arrayValue
        self.sortByArr.removeAll()
        self.categoriesArr.removeAll()
        
        
        for value in sortData{
            let sortByData = sortbyFilterData(fromJson: value)
            self.sortByArr.append(sortByData)
        }
        
        for value in categoriesData{
            let categoriesData = categoriesFilterData(fromJson: value)
            self.categoriesArr.append(categoriesData)
        }
        
    }
    
    
    struct sortbyFilterData{
        var id:String!
        var value:String!
        var title:String!
        
        
        init(fromJson parseData: JSON!){
          
            if parseData.isEmpty{
                return
            }
            
            self.id = parseData["id"].stringValue
            self.value = parseData["value"].stringValue
            self.title = parseData["title"].stringValue
            
        }
    }
    
    struct categoriesFilterData {
        var id:String!
        var cat_name:String?
        var is_select:String?
        var slug:String?
        init(fromJson parseData: JSON!){
          
            if parseData.isEmpty{
                return
            }
          self.id = parseData["id"].stringValue
            self.cat_name = parseData["cat_name"].stringValue
            self.is_select = parseData["is_select"].stringValue
            self.slug = parseData["slug"].stringValue
            
        }
    }
    
    
}



class QueriesDTo {
    
    
    var query_id                  : String!
    var user_id                   : String!
    var query                     : String!
    var label                     : String!
    var is_active                 : String!
    var is_public                 : String!
    var views                     : String!
    var replies                   : String!
    var upvote                    : String!
    var downvote                  : String!
    var created_at                : String!
    var query_by                  : String!
    var user_profile              : String!
    
    init() { }
    init(fromJson parseData: JSON!){
       
        if parseData.isEmpty{
            return
        }
        
        query_id                    = parseData["query_id"].stringValue
        user_id                     = parseData["user_id"].stringValue
        query                       = parseData["query"].stringValue
        label                       = parseData["label"].stringValue
        is_active                   = parseData["is_active"].stringValue
        is_public                   = parseData["is_public"].stringValue
        views                       = parseData["views"].stringValue
        replies                     = parseData["replies"].stringValue
        upvote                      = parseData["upvote"].stringValue
        downvote                    = parseData["downvote"].stringValue
        created_at                  = parseData["created_at"].stringValue
        query_by                    = parseData["query_by"].stringValue
        user_profile                = parseData["user_profile"].stringValue.replacingOccurrences(of: "//", with: "/")
    }
    
    
    
}

class PostedDTo {

       var query_id                  : String!
       var reply_text                : String!
       var query_by                  : String!
       var downvote                  : String!
       var is_active                 : String!
       var is_public                 : String!
       var views                     : String!
       var replies                   : String!
       var upvote                    : String!
       var created_at                : String!
       var user_profile              : String!
       
       
       init(fromJson parseData: JSON!){
          
           if parseData.isEmpty{
               return
        }
        
        query_id                    = parseData["query_id"].stringValue
        reply_text                  = parseData["reply_text"].stringValue
        is_active                   = parseData["is_active"].stringValue
        is_public                   = parseData["is_public"].stringValue
        views                       = parseData["views"].stringValue
        replies                     = parseData["replies"].stringValue
        upvote                      = parseData["upvote"].stringValue
        downvote                    = parseData["downvote"].stringValue
        created_at                  = parseData["created_at"].stringValue
        query_by                    = parseData["query_by"].stringValue
        user_profile                = parseData["user_profile"].stringValue.replacingOccurrences(of: "//", with: "/")
       }

}


class DoctorDTo {

    var other_details                   : [String]!
    var phones                          : String!
    var society_details                 : [String]!
    var address                         : String!
    var img_url                         : String!
    var emails                          : String!
    var university                      : [String]!
    var languages                       : String!
    var name                            : String!
    
    
    
    
    init(fromJson parseData: JSON!){
        
        if parseData.isEmpty{
            return
        }
        
        other_details                    = parseData["other_details"].array?.compactMap({ $0.string })
        university                       = parseData["university"].array?.compactMap({ $0.string })
        society_details                  = parseData["society_details"].array?.compactMap({ $0.string })
        phones                           = parseData["phones"].stringValue
        address                          = parseData["address"].stringValue
        img_url                          = parseData["img_url"].stringValue.replacingOccurrences(of: "//", with: "/")
        emails                           = parseData["emails"].stringValue
        languages                        = parseData["languages"].stringValue
        name                             = parseData["name"].stringValue
        
    }

}


class NotificationDTo {

    

    var notification_message                          : String!
    var notification_title                       : String!
    var created_at                            : String!
    
    
    
    init(fromJson parseData: JSON!){
        
        if parseData.isEmpty{
            return
        }
        
        notification_message                    = parseData["notification_message"].stringValue
        notification_title                       = parseData["notification_title"].stringValue
        created_at                             = parseData["created_at"].stringValue
        
    }

}



class LanguageListModel{
    var title: String!
    var lang_code: String!
    var id: String!
    
    
    
    init(fromJson parseData: JSON!){
        
        if parseData.isEmpty{
            return
        }
        
        title = parseData["title"].stringValue
        lang_code = parseData["lang_code"].stringValue
        id = parseData["id"].stringValue
        
    }
}


class CountriesListModel{
    var shortname: String!
    var name: String!
    var id: String!
    
    
    
    init(fromJson parseData: JSON!){
        
        if parseData.isEmpty{
            return
        }
        
        shortname = parseData["shortname"].stringValue
        name = parseData["name"].stringValue
        id = parseData["id"].stringValue
        
    }
}


struct mediamodel {
    var mediaassest: PHAsset!
    var thumbnail: UIImage?
    var mediaurl:URL?
    var mediaisvideo: Bool!
    var mediaisimage:Bool!
    
    init(mediaassest: PHAsset? = nil,thumbnail: UIImage? = nil,mediaurl:URL? = nil,mediaisvideo:Bool = false,mediaisimage:Bool = false)
        
    {
        self.mediaassest = mediaassest
        self.thumbnail = thumbnail
        self.mediaurl = mediaurl
        self.mediaisvideo = mediaisvideo
        self.mediaisimage = mediaisimage
       
    }
}


struct similarPrdModel{
    
    var prd_img: String!
    var total_like: String!
    var third_category_id: String!
    var status:String!
    var id:String!
    var description:String!
    var visibility:String!
    var user_id:String!
    var subcategory_id:String!
    var title:String!
    var likeornot:String!
    var created_at:String!
    var total_view:String!
    var wishstatus:String!
    var category_id:String!
    
    init(fromJson parseData: JSON!){
        
        if parseData.isEmpty{
            return
        }
        
        prd_img = parseData["prd_img"].stringValue
        total_like = parseData["total_like"].stringValue
        third_category_id = parseData["third_category_id"].stringValue
        status = parseData["status"].stringValue
        id = parseData["id"].stringValue
        description = parseData["description"].stringValue
        visibility = parseData["visibility"].stringValue
        user_id = parseData["user_id"].stringValue
        subcategory_id = parseData["subcategory_id"].stringValue
        title = parseData["title"].stringValue
        likeornot = parseData["likeornot"].stringValue
        created_at = parseData["created_at"].stringValue
        total_view = parseData["total_view"].stringValue
        wishstatus = parseData["wishstatus"].stringValue
        category_id = parseData["category_id"].stringValue
    }
}

struct prdDetailModel{
    

    var mediaRecord = [mediaRecordModel]()
    var prdRecord = [prdRecordModel]()
    
    init(fromJson parseData: JSON!){
        
        if parseData.isEmpty{
            return
        }
        let mediarec = parseData["mediarec"].arrayValue
        let prdrec = parseData["prdrec"].arrayValue
        mediaRecord.removeAll()
        prdRecord.removeAll()
        
        for media in mediarec{
            let model = mediaRecordModel(fromJson: media)
            mediaRecord.append(model)
        }
        
        for prd in prdrec{
            let model = prdRecordModel(fromJson: prd)
            prdRecord.append(model)
        }
        

    }
}


struct mediaRecordModel {
    
    var media_type: String!
    var product_image: String!

    init(fromJson parseData: JSON!){
        
        if parseData.isEmpty{
            return
        }

        media_type = parseData["media_type"].stringValue
        product_image = parseData["product_image"].stringValue

    }
}


struct prdRecordModel {
    
    var sellersince: String!
    var sellercountrycode: String!
    var sellername: String!
    var prd_id: String!
    var sellerimage: String!
    var batering: String!
    var title: String!
    var sellermobile: String!
    var trade: String!
    var total_view: String!
    var price: String!
    var description: String!
    var selleremail: String!
    
    init(fromJson parseData: JSON!){
        
        if parseData.isEmpty{
            return
        }
       
        sellersince = parseData["sellersince"].stringValue
        sellercountrycode = parseData["sellercountrycode"].stringValue
        sellername = parseData["sellername"].stringValue
        prd_id = parseData["prd_id"].stringValue
        sellerimage = parseData["sellerimage"].stringValue
        batering = parseData["batering"].stringValue
        title = parseData["title"].stringValue
        trade = parseData["trade"].stringValue
        total_view = parseData["total_view"].stringValue
        price = parseData["price"].stringValue
        description = parseData["description"].stringValue
        selleremail = parseData["selleremail"].stringValue

    }
}



struct myWishListPrdModel{
    
    var price: String!
    var visibility: String!
    var total_view: String!
    var created_at:String!
    var user_id:String!
    var image:String!
    var batering:String!
    var trade:String!
    var is_draft:String!
    var shipping_cost_type:String!
    var is_deleted:String!
    var expiry_date:String!
    var third_category_id:String!
    var address:String!
    var rating:String!
    var state_id:String!
    var total_like:String!
    var shipping_cost:String!
    var city_id:String!
    var title:String!
    var product_condition:String!
    var category_id:String!
    var shipping_time:String!
    var hit:String!
    var zip_code:String!
    var under_package:String!
    var quantity:String!
    var country_id:String!
    var currency:String!
    var offer_price:String!
    var subcategory_id:String!
    var id:String!
    var status:String!
    var description:String!
    var is_sold:String!
    var updated_at:String!
    var slug:String!
    
    init(fromJson parseData: JSON!){
        
        if parseData.isEmpty{
            return
        }
        
        price = parseData["price"].stringValue
        visibility = parseData["visibility"].stringValue
        total_view = parseData["total_view"].stringValue
        created_at = parseData["created_at"].stringValue
        user_id = parseData["user_id"].stringValue
        image = parseData["image"].stringValue
        batering = parseData["batering"].stringValue
        trade = parseData["trade"].stringValue
        is_draft = parseData["is_draft"].stringValue
        shipping_cost_type = parseData["shipping_cost_type"].stringValue
        is_deleted = parseData["is_deleted"].stringValue
        created_at = parseData["created_at"].stringValue
        total_view = parseData["total_view"].stringValue
        expiry_date = parseData["expiry_date"].stringValue
        third_category_id = parseData["third_category_id"].stringValue
        address = parseData["address"].stringValue
        rating = parseData["rating"].stringValue
        state_id = parseData["state_id"].stringValue
        total_like = parseData["total_like"].stringValue
        shipping_cost = parseData["shipping_cost"].stringValue
        city_id = parseData["city_id"].stringValue
        title = parseData["title"].stringValue
        product_condition = parseData["product_condition"].stringValue
        shipping_time = parseData["shipping_time"].stringValue
        hit = parseData["hit"].stringValue
        category_id = parseData["category_id"].stringValue
        under_package = parseData["under_package"].stringValue
        zip_code = parseData["zip_code"].stringValue
        quantity = parseData["quantity"].stringValue
        country_id = parseData["country_id"].stringValue
        currency = parseData["currency"].stringValue
        offer_price = parseData["offer_price"].stringValue
        subcategory_id = parseData["subcategory_id"].stringValue
        id = parseData["id"].stringValue
        status = parseData["status"].stringValue
        description = parseData["description"].stringValue
        is_sold = parseData["is_sold"].stringValue
        updated_at = parseData["updated_at"].stringValue
        slug = parseData["slug"].stringValue
        
    }
}

struct prdReviewRatingModel{
    var rating: String!
    var ratingdate: String!
    var user_name: String!
    var comment:String!
    
    
    init(fromJson parseData: JSON!){
        
        if parseData.isEmpty{
            return
        }
        
        rating = parseData["rating"].stringValue
        ratingdate = parseData["ratingdate"].stringValue
        user_name = parseData["user_name"].stringValue
        comment = parseData["comment"].stringValue
    }
}


struct followsModel {
    var userid: String!
    var following_id: String!
    var follower_id: String!
    var user_name:String!
    var email:String!
    var image:String!
    var option:String!
    
    
    init(fromJson parseData: JSON!){
        
        if parseData.isEmpty{
            return
        }
        
        userid = parseData["userid"].stringValue
        following_id = parseData["following_id"].stringValue
        follower_id = parseData["follower_id"].stringValue
        user_name = parseData["user_name"].stringValue
        email = parseData["email"].stringValue
        image = parseData["image"].stringValue
        option = parseData["option"].stringValue
    }
}


struct myAdsModel{
    var id: String!
    var title: String!
    var status: String!
    var visibility:String!
    var total_like:String!
    var total_view:String!
    var created_at:String!
     var expiry_date:String!
     var file_name:String!
     var productstatus:String!
     var tradestatus:String!
    
    
    init(fromJson parseData: JSON!){
        
        if parseData.isEmpty{
            return
        }
        
        id = parseData["id"].stringValue
        title = parseData["title"].stringValue
        status = parseData["status"].stringValue
        visibility = parseData["visibility"].stringValue
        total_like = parseData["total_like"].stringValue
        total_view = parseData["total_view"].stringValue
        created_at = parseData["created_at"].stringValue
        expiry_date = parseData["expiry_date"].stringValue
        file_name = parseData["file_name"].stringValue
        productstatus = parseData["productstatus"].stringValue
        tradestatus = parseData["tradestatus"].stringValue
    }
}



