//
//  History.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import Foundation

struct History: Equatable {
    let id: UUID
    let date: Date
    let takenMedications: [Medication]
    
    init(id: UUID, date: Date, takenMedications: [Medication]) {
        self.id = id
        self.date = date
        self.takenMedications = takenMedications
    }
    
    init(historyEntity: HistoryEntity) {
        self.id = historyEntity.id
        self.date = historyEntity.date
        self.takenMedications = historyEntity.takenMedications.map{ Medication(medicationEntity: $0) }
    }
}
