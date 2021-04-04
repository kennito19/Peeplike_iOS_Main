//
//  Constant.swift
//  
//
//  Created by Admin on 31/03/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
//import Alamofire


//class Connectivity
//{
//    class func isConnectedToInternet() ->Bool
//    {
//        return NetworkReachabilityManager()!.isReachable
//    }
//}

struct CONSTANT {
    static var googleAPIKey = "AIzaSyAL6Dg0qk25EiU3vstUKfnwNOEhE-G3vAM"
}

struct API
{
    static let BASEURL =   "http://peepalike.com/api/"

    
    //Get All Cuisine
    static var Login: String
    {
        return  API.BASEURL + "user_login"
    }
    
    static var AddUser: String
    {
        return  API.BASEURL + "add_profile"
    }
    
    static var SendOTP: String
    {
        return  API.BASEURL + "user_sendotp"
    }
    
    static var VerifyOTP: String
    {
        return  API.BASEURL + "user_verifyotp"
    }
    

    
   
    
}




struct SESSION
{
     static let isLogin = "Login"
    static let isFingrtPrint = "FingerPrintAccess"
    static let Phone = "Phone"
    static let UserRole = "userrole"
    static let PhoneVerificaionID = "PhoneVerificaionID"
    static let authToken = "authToken"
    static let tmobile = "tmobile"
     static let UserName = "UserName"
     static let UserEmail = "UserEmail"
     static let homeLocation = "homeLocation"
    static let FCMToken = "FCMToken"
    
    static let CurLat = "curlat"
    static let curlong = "curlong"
    
    static let Uname = "Uname"
    static let Uemail = "Uemail"
    
    
    static let ISUserAddress = "ISUserAddress"
    static let UserAddress = "UserAddress"
    static let UserID = "UserID"
    static let isEnglish = "isEnglish"
    static let isOrder = "isOrder"
    static let OrderID = "OrderID"
    static let isCon = "isCon"
    static let isOnGoing = "isOnGoing"
    
    static let discount = "discount"
    static let CompanyCharge = "CompanyCharge"
    static let ServiceCharge = "ServiceCharge"
    static let TotalAm = "TotalAm"
    static let CouFrom = "CouFrom"
    
//    static let 
    
    
//    static let UserRole = "UserRole"
}

