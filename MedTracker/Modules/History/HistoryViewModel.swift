//
//  HistoryViewModel.swift
//  MedTracker
//
//  Created by ra on 8/21/22.
//

protocol HistoryViewModelDelegate: AnyObject {
    func didUpdateHistory(_ history: [History])
}

class HistoryViewModel {
    
    weak var delegate: HistoryViewModelDelegate?
    
    private let coreDataService: CoreDataService
    private(set) var history: [History] {
        didSet {
            if history == oldValue { return }
            delegate?.didUpdateHistory(history)
        }
    }
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        self.history = []
    }
    
    func fetchHistory() {
        history = coreDataService.getHistory()
    }
}
