//
//  Medication.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import Foundation

struct Medication: Equatable {
    let id: UUID
    var name: String?
    var doze: Int?
    var intakeTime: Date?
    var lastTake: Date?
    
    init(
        id: UUID,
        name: String?,
        doze: Int?,
        intakeTime: Date?,
        lastTake: Date?
    ) {
        self.id = id
        self.name = name
        self.doze = doze
        self.intakeTime = intakeTime
        self.lastTake = lastTake
    }
    
    init(medicationEntity: MedicationEntity) {
        self.id = medicationEntity.id
        self.name = medicationEntity.name
        self.doze = Int(medicationEntity.doze)
        self.intakeTime = medicationEntity.intakeTime
        self.lastTake = medicationEntity.lastTake
    }
}
