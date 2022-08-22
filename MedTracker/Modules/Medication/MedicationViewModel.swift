//
//  MedicationViewModel.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import UIKit

protocol MedicationViewModelDelegate: AnyObject {
    func didUpdateMedications(_ medications: [Medication])
}

class MedicationViewModel {
    
    weak var delegate: MedicationViewModelDelegate?
    
    private let coreDataService: CoreDataService
    private(set) var medications: [Medication] {
        didSet {
            if medications == oldValue { return }
            delegate?.didUpdateMedications(medications)
        }
    }
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        self.medications = []
    }
    
    func fetchMedications() {
        medications = coreDataService.getMedications()
    }
    
    func didTapDeleteButton(_ sender: UIViewController, _ medication: Medication) {
        do {
            try coreDataService.deleteMedication(with: medication.id)
            fetchMedications()
        } catch {
            print("could not delete")
        }
    }
}
