//
//  DependencyContainer.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import UIKit
import CoreData.NSPersistentContainer

class DependencyContainer {
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constans.appName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                print("persistentContainer:", error.localizedDescription)
            }
        })
        return container
    }()
    let notificationCenter: UNUserNotificationCenter = {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if let error = error {
                print("notificationCenter:", error.localizedDescription)
            }
        }
        return notificationCenter
    }()
    let calendar: Calendar = Calendar.current
}

//MARK: - ViewControllerFactory

extension DependencyContainer: ViewControllerFactory {
    func makeMedicationViewController() -> MedicationViewController {
        return MedicationViewController(
            viewModel: makeMedicationViewModel(),
            factory: self
        )
    }
    
    func makeMedicationAddViewController() -> MedicationAddViewController {
        return MedicationAddViewController(viewModel: makeMedicationAddViewModel())
    }
    
    func makeTodayViewController() -> TodayViewController {
        return TodayViewController(viewModel: makeTodayViewModel())
    }
    
    func makeHistoryViewController() -> HistoryViewController {
        return HistoryViewController(viewModel: makeHistoryViewModel())
    }
    
    func makeTabBarConrtoller() -> UITabBarController {
        let tabBarController = UITabBarController()
        let controllers = getViewControllers()
        tabBarController.setViewControllers(controllers, animated: false)
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.backgroundColor = .white
        controllers.enumerated().forEach { index, navigationController in
            guard
                let navigationController = navigationController as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? TabBarModel
            else {
                return
            }
            tabBarController.tabBar.items?[index].title = viewController.tabBarTitle
            tabBarController.tabBar.items?[index].image = viewController.tabBarImage
        }
        return tabBarController
    }
    
    private func getViewControllers() -> [UIViewController] {
        return [
            makeTodayViewController(),
            makeMedicationViewController(),
            makeHistoryViewController()
        ].map{ UINavigationController(rootViewController: $0) }
    }
}

//MARK: - ViewModelFactory

extension DependencyContainer: ViewModelFactory {
    func makeMedicationViewModel() -> MedicationViewModel {
        return MedicationViewModel(coreDataService: makeCoreDataService())
    }
    
    func makeMedicationAddViewModel() -> MedicationAddViewModel {
        return MedicationAddViewModel(
            coreDataService: makeCoreDataService(),
            notificationService: makeNotificationService()
        )
    }
    
    func makeTodayViewModel() -> TodayViewModel {
        return TodayViewModel(coreDataService: makeCoreDataService())
    }
    
    func makeHistoryViewModel() -> HistoryViewModel {
        return HistoryViewModel(coreDataService: makeCoreDataService())
    }
}

//MARK: - CoreDataFactory

extension DependencyContainer: CoreDataFactory {
    func makeCoreDataService() -> CoreDataService {
        return CoreDataService(persistentContainer: persistentContainer)
    }
}


extension DependencyContainer: NotificationFactory {
    func makeNotificationService() -> NotificationService {
        return NotificationService(notificationCenter: notificationCenter, calendar: calendar)
    }
}
