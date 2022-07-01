//
//  AppDelegate.swift
//  My
//
//  Created by Prof K on 6/27/22.
//

import UIKit
import AFNetworking
import UserNotifications
import SwiftyStoreKit
import VoxeetSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var previousNetworkReachabilityStatus: AFNetworkReachabilityStatus = .unknown
    let networkReachabilityChanged = NSNotification.Name(JamitStoryboardConstant.BROADCAST_NETWORK_CHANGE)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        JamitLog.setDebug(IJamitConstants.DEBUG)
        UINavigationBar.appearance().isTranslucent = false
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        // [END register_for_notifications]
        
        TotalDataManager.shared.readConfigure()
        
        self.initVoxeet()
        
        //init in app purchase
        self.initIAP()
    
        //facebook sdk
//        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //turn off badge if it has push
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        self.setUpMonitoringNetwork()
        return true
    }
    
    private func initIAP() {
        //IAP: completeTransactions when openning app
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
            }
        }
        
        //IAP delegate
        StoreKitManager.shared.delegate = self
    }
    
    private func initVoxeet() {
        
        //prevent screen go to idle mode
        UIApplication.shared.isIdleTimerDisabled = true
        
        // VoxeetSDK initialization.
        VoxeetSDK.shared.initialize(consumerKey: IJamitConstants.DOLBY_CONSUMER_KEY,
                                    consumerSecret: IJamitConstants.DOLBY_SECRET_KEY)
        
        // Example of public variables to change the conference behavior.
//        VoxeetSDK.shared.notification.push.type = .none
//        VoxeetSDK.shared.conference.defaultBuiltInSpeaker = true
//        VoxeetSDK.shared.conference.defaultVideo = false
        VoxeetSDK.shared.notification.push.type = .none
        VoxeetSDK.shared.conference.defaultBuiltInSpeaker = false
        VoxeetSDK.shared.conference.defaultVideo = false
    }
    
    private func setUpMonitoringNetwork () {
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
            var isNetworkConnected = false
            switch (status) {
                case .reachableViaWWAN, .reachableViaWiFi:
                    isNetworkConnected = true
                default:
                    isNetworkConnected = false
            }
            JamitLog.logD("=======> setUpMonitoringNetwork =\(isNetworkConnected)")
            if (self.previousNetworkReachabilityStatus != .unknown && status != self.previousNetworkReachabilityStatus) {
                NotificationCenter.default.post(name: self.networkReachabilityChanged, object: nil, userInfo: [
                    JamitStoryboardConstant.KEY_IS_CONNECT : isNetworkConnected
                    ])
            }
            self.previousNetworkReachabilityStatus = status
        }
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate : PurchaseDelegate{
    
    func purchaseSuccess(_ receipt: ReceiptItem) {
        // Notify to view controller
        let userInfo = MemberShipManager.shared.getDictReceiptItem(receipt: receipt)
        JamitLog.logE("============>purchaseSuccess =\(userInfo)")
        NotificationCenter.default.post(name: Notification.Name(MemberShipManager.BROADCAST_PURCHASE_SUCCESS), object: nil, userInfo: userInfo)
    }
    
    func purchaseFailed(_ error: String?) {
        var msgShow = error
        if msgShow == nil || msgShow!.isEmpty {
            msgShow = getString(StringRes.title_purchase_error)
        }
        // Notify to view controller
        NotificationCenter.default.post(name: Notification.Name(MemberShipManager.BROADCAST_PURCHASE_FAIL), object: nil, userInfo: [MemberShipManager.KEY_MESSAGE: msgShow as Any])
    }
    
    
}

