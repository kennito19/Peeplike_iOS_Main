//
//  AppDelegate.swift
//  Peepalike
//
//  Created by MacBook on 18/01/21.
//  Copyright © 2021 Rohit. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FirebaseMessaging
import GooglePlaces
import GoogleMaps
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    
    
    static var isChatcomingFrom:String?
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool
    {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

    }
    
    

var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    let Session = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self
        
        //Firebase PushNotification
        Messaging.messaging().delegate = self
               if #available(iOS 10.0, *) {
                   UNUserNotificationCenter.current().delegate = self
                   
                   let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                   UNUserNotificationCenter.current().requestAuthorization(
                       options: authOptions,
                       completionHandler: {_, _ in })
               } else {
                   let settings: UIUserNotificationSettings =
                       UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                   application.registerUserNotificationSettings(settings)
               }
               
               application.registerForRemoteNotifications()
        
        let isLogin = UserDefaults.standard.bool(forKey: SESSION.isLogin)
        print("IsLogin->",isLogin)
        
        if isLogin == true
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "MainTab") as! MainTabController
            self.window?.rootViewController = homePage
        }
        else
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "LoginNav") //LoginNav,MainNav
            self.window?.rootViewController = homePage
        }
        
        
        GMSServices.provideAPIKey(CONSTANT.googleAPIKey)
        GMSPlacesClient.provideAPIKey(CONSTANT.googleAPIKey)

//        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "UserBirthdateVC") as! UserBirthdateVC
//        self.window?.rootViewController = homePage
//
        
        
        
        
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        
       

        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

// ====================== EXTENSIONS FOR FIREBASE MESSAGE IMPLEMENTATION  ========================= //
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate
{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo
        
                if let messageID = userInfo[gcmMessageIDKey]
                {
                    print("Message ID: \(messageID)")
                }
        
                print(userInfo)
        
                completionHandler([])
    }
    
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//
//        if let messageID = userInfo[gcmMessageIDKey]
//        {
//            print("Message ID: \(messageID)")
//        }
//
//        print(userInfo)
//
//        completionHandler([])
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey]
        {
            print("Message ID: \(messageID)")
        }
        
      
        
        completionHandler()
    }
}

// ====================== EXTENSIONS FOR FIREBASE MESSAGE IMPLEMENTATION  ========================= //
extension AppDelegate : MessagingDelegate
{

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")

        self.Session.set(fcmToken, forKey: SESSION.FCMToken)
        self.Session.synchronize()
    }



    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?)
    {
        print("Firebase registration token: \(fcmToken)")
        self.Session.set(fcmToken, forKey: SESSION.FCMToken)


    }
}

