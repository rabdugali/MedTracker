//
//  MedicationEntity+CoreDataProperties.swift
//  MedTracker
//
//  Created by ra on 8/21/22.
//
//

import Foundation
import CoreData


extension MedicationEntity {
    @NSManaged public var id: UUID
    @NSManaged public var name: String?
    @NSManaged public var doze: Int16
    @NSManaged public var intakeTime: Date
    @NSManaged public var lastTake: Date?
    @NSManaged public var history: Set<HistoryEntity>?

}

// MARK: Generated accessors for history
extension MedicationEntity {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: HistoryEntity)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: HistoryEntity)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}

extension MedicationEntity : Identifiable {

}
