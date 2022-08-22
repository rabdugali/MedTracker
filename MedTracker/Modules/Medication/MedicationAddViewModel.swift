//
//  MedicationAddViewModel.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import UIKit
import CoreData

protocol MedicationAddViewModelDelegate: AnyObject {
    func didAddMedication()
}

class MedicationAddViewModel {
    
    weak var delegate: MedicationAddViewModelDelegate?
    
    private let coreDataService: CoreDataService
    private let notificationService: NotificationService
    private var medication: Medication
    
    init(coreDataService: CoreDataService, notificationService: NotificationService) {
        self.coreDataService = coreDataService
        self.notificationService = notificationService
        self.medication = Medication(
            id: UUID(),
            name: nil,
            doze: 1,
            intakeTime: nil,
            lastTake: nil
        )
    }
    
    func setName(_ name: String) {
        medication.name = name
    }
    
    func setDoze(_ doze: Int) {
        medication.doze = doze
    }
    
    func setIntakeTime(_ time: Date) {
        medication.intakeTime = time
    }
    
    func didTapSaveButton(_ sender: UIViewController) {
        guard
            medication.name != nil,
            medication.intakeTime != nil
        else {
            return
        }
        
        do {
            try coreDataService.addMedication(medication)
            notificationService.createNotification(for: medication)
            delegate?.didAddMedication()
        } catch {
            print("Could not add medication", error.localizedDescription)
        }
    }
}
