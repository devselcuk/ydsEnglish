//
//  AppDelegate.swift
//  ydsEnglish
//
//  Created by çağrı on 2.03.2019.
//  Copyright © 2019 selcuk. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import UserNotifications
import FacebookCore
import TwitterKit
import SwiftyStoreKit






@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate, MessagingDelegate {
    
    

    var window: UIWindow?
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    
                   
                    
                case .failed, .purchasing, .deferred:
                    print("failed")
                    
                    break // do nothing
                @unknown default:
                    print("default")
                }
            }
        }
       
        ProductDatabase.verifySubscription(id: ProductDatabase.oneMonthId)
        ProductDatabase.verifySubscription(id: ProductDatabase.threeMonthsId)
        ProductDatabase.verifySubscription(id: ProductDatabase.oneYearId)
        
        ProductDatabase.verifySubscription(id: ProductDatabase.nonRenewableOneMonth)
        TWTRTwitter.sharedInstance().start(withConsumerKey:"DQ17cldjZjMdChNgGCVsVQicA", consumerSecret:"58gx582VjG5Jl88yO9X5g1jw0GvTT7ge7ZMZ1DF5EWdNNVZmfS")

        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        
        let tabBar = UITabBar.appearance()
       
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = UIColor.flatBlack()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .clear
        
        UINavigationBar.appearance().tintColor = UIColor.flatMintColorDark()
        
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        InstanceID.instanceID().instanceID { (result, error) in
          
            
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            
            }
        }
        
       
  
    
      
      
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
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
       
        
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let facebookReturn =  SDKApplicationDelegate.shared.application(app, open: url, options: options)
        let twitterReturn = TWTRTwitter.sharedInstance().application(app, open: url, options: options)

        
        return facebookReturn || twitterReturn
        
    }
  
    

    func applicationWillResignActive(_ application: UIApplication) {
        let globalReference = Database.database().reference()
        let myUserName = userDefaults.string(forKey: "username")
        
        if globalGameId != nil {
          globalReference.child("Game").child(globalGameId!).child(myUserName!).setValue(["status":"closed"])
            globalReference.child("Game").removeAllObservers()
        }
     
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let globalReference = Database.database().reference()
        let myUserName = userDefaults.string(forKey: "username")
        
        if globalGameId != nil {
            globalReference.child("Game").child(globalGameId!).child(myUserName!).setValue(["status":"closed"])
            globalReference.child("Game").removeAllObservers()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let globalReference = Database.database().reference()
        let myUserName = userDefaults.string(forKey: "username")
        
        if globalGameId != nil {
            globalReference.child("Game").child(globalGameId!).child(myUserName!).setValue(["status":"closed"])
            globalReference.child("Game").removeAllObservers()
        }
    }
    
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
                granted, error in
                print("Permission granted: \(granted)") // 3
                
                
                
                UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .sound, .badge]) {
                        [weak self] granted, error in
                        
                        print("Permission granted: \(granted)")
                        guard granted else { return }
                        self?.getNotificationSettings()
                }
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
     
        
        Messaging.messaging().apnsToken  = deviceToken
    }
    
    // Device Token: b28c7e636a29c20186ea200560a425edf07df42f35e3e666082f22813b87607d


}

