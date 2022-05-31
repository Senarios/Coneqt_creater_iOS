//
//  AppDelegate.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 25/11/2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import Alamofire
import GoogleSignIn
import FBSDKCoreKit
import FirebaseMessaging


@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?


    
    
    func application(
          _ application: UIApplication,
          didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        NetworkMonitor.shared.startMonitoring()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self


        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
       
        print("come in user activity")
        guard let url = userActivity.webpageURL else {
            
            return false
        }
        print("url is",url.absoluteString)
         let vc = ViewControllers.get(BroadCasterVC(), from : "Stream")
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
    
//    func application(
//        _ app: UIApplication,
//        open url: URL,
//        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//    ) -> Bool {
//        ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
//        return GIDSignIn.sharedInstance.handle(url)
//    }

    func application(
          _ app: UIApplication,
          open url: URL,
          options: [UIApplication.OpenURLOptionsKey : Any] = [:]
      ) -> Bool {
        var flag: Bool = false
          if ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
          ){
            //URL Scheme Facebook
            flag = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
              annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
          }else{
            //URL Scheme Google
              flag = GIDSignIn.sharedInstance.handle(url)
          }
        return flag
      }
    
    // MARK: UISceneSession Lifecycle
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }

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
    
    static func goForUnAuthUser(){
        
        let vc = ViewControllers.get(SignInViewController(), from: "Main")
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.window?.makeKeyAndVisible()
        
    }


}


extension AppDelegate : UNUserNotificationCenterDelegate,MessagingDelegate{




    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        NotificationCenter.default.post(name: NotificationName.NOTIFICATION_DETECTED, object: nil)
         // Change this to your preferred presentation option
        completionHandler([[.alert, .sound,.badge]])
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       
        let userInfo = response.notification.request.content.userInfo


          // Print full message.
          print(userInfo)

          completionHandler()
    }




    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        print("Firebase registration token: \(String(describing: fcmToken))")
        Defaults.fcmToken = fcmToken

        
    
         // TODO: If necessary send token to application server.
         // Note: This callback is fired at each app startup and whenever a new token is generated
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(" fail come in error to register for remote notification",error.localizedDescription)
    }
}
