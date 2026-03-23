//
//  MetricsViewModel.swift
//  NeuroRise
//
//  Created by Jesus Casasanta on 3/10/26.
//

import Foundation
import Combine
import HealthKit

class MetricsViewModel: ObservableObject {

    @Published var heartRate: Double? = nil
    @Published var stressScore: Double? = nil
    @Published var steps: Double? = nil
    @Published var sleepHours: Double? = nil
    @Published var screenTimeHours: Double? = nil

    private let healthManager = HealthKitManager()

    func requestHealthAccess() {
        healthManager.requestAuthorization { success in
            print("Health access: \(success)")
            if success { self.fetchAllMetrics() }
        }
    }

    func fetchAllMetrics() {
        healthManager.fetchQuantity(.heartRate, unit: HKUnit(from: "count/min")) { self.heartRate = $0 }
        healthManager.fetchQuantity(.heartRateVariabilitySDNN, unit: HKUnit.secondUnit(with: .milli)) { self.stressScore = $0 }
        healthManager.fetchQuantity(.stepCount, unit: HKUnit.count()) { self.steps = $0 }
        healthManager.fetchCategory(.sleepAnalysis) { self.sleepHours = $0 }
        
    }
}
