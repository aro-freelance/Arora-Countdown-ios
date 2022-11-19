//
//  CustomNotificationDelegate.swift
//  AroraCountdown
//
//  Created by Mandy on 11/17/22.
//

import Foundation
import UserNotifications
 
class CustomNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    //
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           completionHandler([.alert, .sound, .badge])
       }
       
       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           defer { completionHandler() }
           guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
           // perform action here
           
       }
}
