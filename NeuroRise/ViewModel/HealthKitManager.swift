//
//  HealthKitManager.swift
//  NeuroRise
//
//  Created by Jesus Casasanta on 3/10/26.
//

import HealthKit

class HealthKitManager {

    let healthStore = HKHealthStore()

    // Pedir permisos para todas las métricas
    func requestAuthorization(completion: @escaping (Bool) -> Void) {

        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }

        let typesToRead: Set<HKObjectType> = [

            // ❤️ Heart & Stress
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,

            // 🏃 Activity
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,

            // 😴 Sleep
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,

            // 🫁 Respiratory (nivel pro)
            HKObjectType.quantityType(forIdentifier: .respiratoryRate)!,

            // 🧍 Balance / gait (MUY diferencial)
            HKObjectType.quantityType(forIdentifier: .appleWalkingSteadiness)!,

            // 🌡️ Temperature (opcional)
            HKObjectType.quantityType(forIdentifier: .bodyTemperature)!
        ]

        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if let error = error {
                print("HealthKit error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    // Función genérica para Quantity Types
    func fetchQuantity(_ identifier: HKQuantityTypeIdentifier, unit: HKUnit = HKUnit.count(), completion: @escaping (Double?) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(nil)
            return
        }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, results, _ in
            guard let sample = results?.first as? HKQuantitySample else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            let value = sample.quantity.doubleValue(for: unit)
            DispatchQueue.main.async { completion(value) }
        }
        healthStore.execute(query)
    }

    // Función para Category Types (sleep, screen time)
    func fetchCategory(_ identifier: HKCategoryTypeIdentifier, completion: @escaping (Double?) -> Void) {
        guard let type = HKCategoryType.categoryType(forIdentifier: identifier) else {
            completion(nil)
            return
        }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, results, _ in
            guard let sample = results?.first as? HKCategorySample else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            // Para Sleep y Screen Time devolvemos duración en horas
            let duration = sample.endDate.timeIntervalSince(sample.startDate) / 3600
            DispatchQueue.main.async { completion(duration) }
        }
        healthStore.execute(query)
    }
}
