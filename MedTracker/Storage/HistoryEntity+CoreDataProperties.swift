//
//  HistoryEntity+CoreDataProperties.swift
//  MedTracker
//
//  Created by ra on 8/21/22.
//
//

import Foundation
import CoreData


extension HistoryEntity {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var takenMedications: Set<MedicationEntity>

}

// MARK: Generated accessors for takenMedications
extension HistoryEntity {

    @objc(addTakenMedicationsObject:)
    @NSManaged public func addToTakenMedications(_ value: MedicationEntity)

    @objc(removeTakenMedicationsObject:)
    @NSManaged public func removeFromTakenMedications(_ value: MedicationEntity)

    @objc(addTakenMedications:)
    @NSManaged public func addToTakenMedications(_ values: NSSet)

    @objc(removeTakenMedications:)
    @NSManaged public func removeFromTakenMedications(_ values: NSSet)

}

extension HistoryEntity : Identifiable {

}
