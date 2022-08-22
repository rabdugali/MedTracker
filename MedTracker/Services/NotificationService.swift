//
//  NotificationService.swift
//  MedTracker
//
//  Created by ra on 8/21/22.
//

import Foundation
import UserNotifications

class NotificationService {
    private let notificationCenter: UNUserNotificationCenter
    private let calendar: Calendar
    
    init(notificationCenter: UNUserNotificationCenter, calendar: Calendar) {
        self.notificationCenter = notificationCenter
        self.calendar = calendar
    }
    
    func createNotification(for medication: Medication) {
        guard
            let name = medication.name,
            let date = medication.intakeTime
        else {
            return
        }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = Constans.appName
        notificationContent.body = "Time to take your medication: \(name)"
        notificationContent.sound = .default
        
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: medication.id.uuidString, content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
}
