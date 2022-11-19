//
//  AppDelegate.swift
//  AroraCountdown
//
//  Created by Mandy on 11/10/22.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //delegate for extension for notification button presses
        //UNUserNotificationCenter.current().delegate = self
        
        registerForPushNotifications()
        
//        // Check if launched from notification
//        let notificationOption = launchOptions?[.remoteNotification]
//
//        // 1
//        if
//          let notification = notificationOption as? [String: AnyObject],
//          let aps = notification["aps"] as? [String: AnyObject] {
//          // 2
//          NewsItem.makeNewsItem(aps)
//
//          // 3
//          (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
//        }

        
        return true
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
    
    
    
    func registerForPushNotifications() {
        
        //ask the user to allow notifications
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
                
                //add custom buttons to the notification
//                // 1
//                let viewAction = UNNotificationAction(
//                  identifier: Identifiers.viewAction,
//                  title: "View",
//                  options: [.foreground])
//
//                // 2
//                let newsCategory = UNNotificationCategory(
//                  identifier: Identifiers.newsCategory,
//                  actions: [viewAction],
//                  intentIdentifiers: [],
//                  options: [])
//
//                // 3
//                UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
                
            self?.getNotificationSettings()
          }

    }

    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
          
          print("Notification settings: \(settings)")
          
          //check that the user has authorized notifications, if so then que the notifications
          guard settings.authorizationStatus == .authorized else { return }
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
          
      }
    }
    
    
    
    //this converts tokens from Apple to strings for use with identifying devices to deliver notifications
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
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register: \(error)")
    }
    
    
    //if a notification is received while the app is running
//    func application(
//      _ application: UIApplication,
//      didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//      fetchCompletionHandler completionHandler:
//      @escaping (UIBackgroundFetchResult) -> Void
//    ) {
//      guard let aps = userInfo["aps"] as? [String: AnyObject] else {
//        completionHandler(.failed)
//        return
//      }
//      NewsItem.makeNewsItem(aps)
//    }



}

// MARK: - UNUserNotificationCenterDelegate

//This is the callback you get when the app opens because of a custom notification button action.
//extension AppDelegate: UNUserNotificationCenterDelegate {
//  func userNotificationCenter(
//    _ center: UNUserNotificationCenter,
//    didReceive response: UNNotificationResponse,
//    withCompletionHandler completionHandler: @escaping () -> Void
//  ) {
//    // 1
//    let userInfo = response.notification.request.content.userInfo
//
//    // 2
//    if
//      let aps = userInfo["aps"] as? [String: AnyObject],
//      let newsItem = NewsItem.makeNewsItem(aps) {
//      (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
//
//      // 3
//      if response.actionIdentifier == Identifiers.viewAction,
//        let url = URL(string: newsItem.link) {
//        let safari = SFSafariViewController(url: url)
//        window?.rootViewController?
//          .present(safari, animated: true, completion: nil)
//      }
//    }
//
//    // 4
//    completionHandler()
//  }
//}
//
