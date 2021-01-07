//
//  Appdelegate.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/04.
//
import SwiftUI
import CoreData
import KakaoSDKCommon
import KakaoSDKAuth
import Firebase
import UserNotifications
import FirebaseMessaging


class AppDelegate: NSObject, UIApplicationDelegate, CLLocationManagerDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        KakaoSDKCommon.initSDK(appKey: "b020a097ec1b6d3d45c409694dec9591", loggingEnable:false)
        

        //파이어베이스 공유 인스턴스 생성
        FirebaseApp.configure()
            
        
        Messaging.messaging().delegate = self
        
      
        
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { success, error in
            guard success else {
                //권한을 거부했을경우 예외처리
                return
            }
            //            let locationManager = CLLocationManager()
            //            locationManager.delegate = self
            //            locationManager.requestWhenInUseAuthorization()
        }
        //노티피케이션센터에 어플등록
        application.registerForRemoteNotifications()
        
      
        
        
        return true
    }
    
    
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("[Log] deviceToken :", deviceTokenString)
        Messaging.messaging().apnsToken = deviceToken
     
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if userInfo[gcmMessageIDKey] != nil {
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: userInfo)
        }

    }
    
 
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
        if userInfo[gcmMessageIDKey] != nil {
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: userInfo)
            
        }
      
     
        // Print full message.
        print("정보: \(userInfo)")
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method tguration to create the ne != nilw scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
   
    
    
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //왔을때
       
        print("fcm 도착")
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive didReceiveresponse: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
        let userInfo = didReceiveresponse.notification.request.content.userInfo
 

        // Print message ID.
        if userInfo[gcmMessageIDKey] != nil {
            let eventType = userInfo["eventType"] as! String
            
            if(eventType  == "0"){
                print("저장은하니?")
                notiManager().writeData(eventType: eventType , eventNumber:  userInfo["centerID"] as! String)
                NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: userInfo)
            }else if(eventType == "1"){
                
            }
            
//            if()
//
//
//
           
            
        }
      
        completionHandler()
    }
    
    
    
}



extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
         
        let dataDict: [String: String] = ["token": fcmToken]
    
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        

    }
}


