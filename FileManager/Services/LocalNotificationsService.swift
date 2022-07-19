//
//  LocalNotificationsService.swift
//  FileManager
//
//  Created by Alex on 20.07.22.
//

import Foundation
import UIKit
import UserNotifications

class LocalNotificationsService {
    static let shared = LocalNotificationsService()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {}
    
    func requestNotificationsPermissions() {
        
        notificationCenter
            .requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                
                guard granted else { return }
                self.notificationCenter.getNotificationSettings { (settings) in
                    print(settings)
                    guard settings.authorizationStatus == .authorized else { return }
                }
            }
        self.sendFarewellNotification()
        self.sendRemindingNotification()
    }
    
    private func sendFarewellNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Goodbye!"
        content.body = "See you again \u{1F601}"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10,
                                                        repeats: false)
        
        let request = UNNotificationRequest(identifier: "Farewell notification",
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: { (error) in
            print(error?.localizedDescription)
        })
    }
    
    private func sendRemindingNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hello!"
        content.body = "you haven't been in for a long time \u{1F622} "
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 10 , minute: 0), repeats: true)
        
        let request = UNNotificationRequest(identifier: "Reminding notification",
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: { (error) in
            print(error?.localizedDescription)
        })
    }
}

