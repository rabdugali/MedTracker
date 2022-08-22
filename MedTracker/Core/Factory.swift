//
//  Factory.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import UIKit
import CoreData.NSPersistentContainer

protocol ViewControllerFactory {
    func makeTabBarConrtoller() -> UITabBarController
    func makeMedicationViewController() -> MedicationViewController
    func makeMedicationAddViewController() -> MedicationAddViewController
    func makeTodayViewController() -> TodayViewController
    func makeHistoryViewController() -> HistoryViewController
}

protocol ViewModelFactory {
    func makeMedicationViewModel() -> MedicationViewModel
    func makeMedicationAddViewModel() -> MedicationAddViewModel
    func makeTodayViewModel() -> TodayViewModel
    func makeHistoryViewModel() -> HistoryViewModel
}

protocol CoreDataFactory {
    var persistentContainer: NSPersistentContainer { get }
    func makeCoreDataService() -> CoreDataService
}

protocol NotificationFactory {
    var notificationCenter: UNUserNotificationCenter { get }
    var calendar: Calendar { get }
    func makeNotificationService() -> NotificationService
}
