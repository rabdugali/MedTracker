//
//  CoreDataService.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import Foundation
import CoreData

class CoreDataService {
    
    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
}

//MARK: - Create

extension CoreDataService {
    func addMedication(_ medication: Medication) throws {
        createMedicationEntity(medication)
        try context.save()
    }
    
    func addToHistory(medication: Medication) throws {
        guard let medicationEntity = findMedication(with: medication.id) else { return }
        if let historyEntity = findHistory(for: Date.currentDate()) {
            try updateTakenMedications(for: historyEntity, medicationEntity)
        } else {
            createHistoryEntity(medicationEntity)
        }
        try context.save()
    }
    
    private func createMedicationEntity(_ medication: Medication) -> MedicationEntity {
        let medicationEntity = MedicationEntity(context: context)
        medicationEntity.id = UUID()
        medicationEntity.name = medication.name ?? "no name"
        medicationEntity.doze = Int16(medication.doze ?? 0)
        medicationEntity.intakeTime = medication.intakeTime ?? Date.currentDate()
        return medicationEntity
    }
    
    private func createHistoryEntity(_ medicationEntity: MedicationEntity) -> HistoryEntity {
        let historyEntity = HistoryEntity(context: context)
        historyEntity.id = UUID()
        historyEntity.date = Date.currentDate()
        historyEntity.addToTakenMedications(medicationEntity)
        return historyEntity
    }
    
    private func findMedication(with id: UUID) -> MedicationEntity? {
        let request = NSFetchRequest<MedicationEntity>(
            entityName: Constans.medicationEntityName
        )
        let predicate = NSPredicate(
            format: "id == %@",
            id as NSUUID
        )
        request.predicate = predicate
        guard let medicationEntity = try? context.fetch(request).first else { return nil }
        return medicationEntity
    }
    
    private func findHistory(for date: Date) -> HistoryEntity? {
        let request = NSFetchRequest<HistoryEntity>(
            entityName: Constans.historyEntityName
        )
        let predicate = NSPredicate(
            format: "date == %@",
            date as NSDate
        )
        request.predicate = predicate
        guard let historyEntity = try? context.fetch(request).first else { return nil }
        return historyEntity
    }
}

//MARK: - Read

extension CoreDataService {
    func getMedications() -> [Medication] {
        let request = NSFetchRequest<MedicationEntity>(
            entityName: Constans.medicationEntityName
        )
        let medications = try? context.fetch(request)
        return medications?.map {
            Medication(medicationEntity: $0)
        } ?? []
    }

    
    func getTodayMedications() -> [Medication] {
        let request = NSFetchRequest<MedicationEntity>(
            entityName: Constans.medicationEntityName
        )
        let predicate = NSPredicate(
            format: "lastTake == nil || lastTake < %@",
            Date.currentDate() as NSDate
        )
        request.predicate = predicate
        let medications = try? context.fetch(request)
        return medications?.map {
            Medication(medicationEntity: $0)
        } ?? []
    }
    
    func getHistory() -> [History] {
        let request = NSFetchRequest<HistoryEntity>(
            entityName: Constans.historyEntityName
        )
        let history = try? context.fetch(request)
        return history?.map{
            History(historyEntity: $0)
        } ?? []
    }
}

//MARK: - Update

extension CoreDataService {
    func updateLastTake(for medication: Medication) throws {
        guard let medicationEntity: NSManagedObject = findMedication(with: medication.id) else { return }
        medicationEntity.setValue(Date.currentDate(), forKey: "lastTake")
        try context.save()
    }
    
    func updateTakenMedications(
        for historyEntity: HistoryEntity,
        _ medicationEntity: MedicationEntity
    ) throws {
        historyEntity.addToTakenMedications(medicationEntity)
        try context.save()
    }
}

//MARK: - Delete

extension CoreDataService {
    func deleteMedication(with id: UUID) throws {
        guard let medicationEntity = findMedication(with: id) else { return }
        context.delete(medicationEntity)
        try context.save()
    }
}
