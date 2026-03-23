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
    @Published var distance: Double? = nil
    @Published var calories: Double? = nil
    @Published var sleepHours: Double? = nil
    @Published var respiratoryRate: Double? = nil
    @Published var walkingBalance: Double? = nil
    @Published var bodyTemp: Double? = nil

    private let healthManager = HealthKitManager()

    func requestHealthAccess() {
        healthManager.requestAuthorization { success in
            print("Health access: \(success)")
            if success { self.fetchAllMetrics() }
        }
    }

    func fetchAllMetrics() {

        // Heart & Stress
        healthManager.fetchQuantity(.heartRate, unit: HKUnit(from: "count/min")) {
            self.heartRate = $0
        }
        healthManager.fetchQuantity(.heartRateVariabilitySDNN, unit: HKUnit.secondUnit(with: .milli)) {
            self.stressScore = $0
        }
        //Activity
        healthManager.fetchQuantity(.stepCount, unit: HKUnit.count()) {
            self.steps = $0
        }
        healthManager.fetchQuantity(.distanceWalkingRunning, unit: HKUnit.meter()) {
            self.distance = $0
        }
        healthManager.fetchQuantity(.activeEnergyBurned, unit: HKUnit.kilocalorie()) {
            self.calories = $0
        }
        //Sleep
        healthManager.fetchCategory(.sleepAnalysis) {
            self.sleepHours = $0
        }
        // Respiratory
        healthManager.fetchQuantity(.respiratoryRate, unit: HKUnit(from: "count/min")) {
            self.respiratoryRate = $0
        }
        // Balance
        healthManager.fetchQuantity(.appleWalkingSteadiness, unit: HKUnit.percent()) {
            self.walkingBalance = $0
        }
        // Temperature
        healthManager.fetchQuantity(.bodyTemperature, unit: HKUnit.degreeCelsius()) {
            self.bodyTemp = $0
        }
    }
}
