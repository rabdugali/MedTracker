//
//  TodayViewModel.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import UIKit

protocol TodayViewModelDelegate: AnyObject {
    func didUpdateMedications(_ medications: [Medication])
}

class TodayViewModel {
    
    weak var delegate: TodayViewModelDelegate?
    
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
    
    func fetchTodayMedications() {
        medications = coreDataService.getTodayMedications()
    }
    
    func didTapConfirmButton(_ sender: UIViewController, _ medication: Medication) {
        do {
            try coreDataService.updateLastTake(for: medication)
            try coreDataService.addToHistory(medication: medication)
            fetchTodayMedications()
        } catch {
            print("cant add to history")
        }
    }
}
