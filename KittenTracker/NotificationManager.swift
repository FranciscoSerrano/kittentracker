//
//  NotificationManager.swift
//  KittenTracker
//
//  Created by Francisco Serrano on 3/24/25.
//


import SwiftUI
import UserNotifications

@Observable
class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleFeedingNotification(for foster: Foster) {
        // Remove any existing notifications for this foster
        cancelFeedingNotifications(for: foster)
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Feeding Time!"
        content.body = "\(foster.name) needs to be fed"
        content.sound = .default
        
        // Create trigger based on next feeding time
        guard let nextFeeding = foster.nextFeedingTime else { return }
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: nextFeeding)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // Create request
        let identifier = "FEEDING-\(foster.id)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Schedule notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelFeedingNotifications(for foster: Foster) {
        let identifier = "FEEDING-\(foster.id)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
