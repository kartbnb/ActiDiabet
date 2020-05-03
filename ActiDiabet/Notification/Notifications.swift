//
//  Notifications.swift
//  ActiDiabet
//
//  Created by 佟诗博 on 17/4/20.
//  Copyright © 2020 Shibo Tong. All rights reserved.
//

import UIKit
import NotificationCenter

class Notifications: NSObject, UNUserNotificationCenterDelegate {

    /// This class is used for controlling notification
    
    var notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
    
    // authorise notification (need called at AppDelegate)
    func authoriseNotification() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (allow, error) in
            if allow {
                print("allowed notification")
            } else {
                print("not allowed notification")
            }
        }
    }
    // MARK: - Create content
    // create the content of notification
    private func createContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Its Time to do your activity"
        content.body = "Click it to start your activity for today"
        content.sound = UNNotificationSound.default
        content.badge = 1
        return content
    }
    // MARK: - Create Trigger
    // create a time trigger everyday
    private func createTimeTrigger(time: String) -> UNCalendarNotificationTrigger? {
        let timeString = time.split(separator: ":")
        
        guard let minute = Int(timeString[1]), let hour = Int(timeString[0]) else {
            print("time or hour not match")
            return nil
        }
        var dateComponents = DateComponents()
        dateComponents.minute = minute
        dateComponents.hour = hour
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        return trigger
    }
    
    // create a Date trigger which will alert in specific date and time
    private func createDateTrigger(date: Date) -> UNCalendarNotificationTrigger? {
        let dateComponents = Calendar.current.dateComponents([.year, .month,.day,.hour,.minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        return trigger
    }
    
    //MARK: - Main functions of create notification
    // create a notification with speccific date
    func createNotification(with date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        let content = createContent()
        let identifier = formatter.string(from: date)
        guard let trigger = createDateTrigger(date: date) else { return }
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
    }
    
    // create a notification with specific time and repeat everyday
    func createNotification(with time: String) {
        let identifier = "do activity"
        let content = createContent()
        guard let trigger = createTimeTrigger(time: time) else {
            return
        }
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    // remove notification
    func removeNotification() {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: ["do activity"])
    }
    
    
    
}
