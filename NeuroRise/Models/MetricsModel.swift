//
//  MetricsModel.swift
//  NeuroRise
//
//  Created by Jesus Casasanta on 3/10/26.
//

struct healthMetrics: Codable {
    let heartRate: Double?
    let oxygenSaturation: Double?
    let respiratoryRate: Double?
    let sleepScore: Double?
    let stressScore: Double?
    let screenTime: Double?
}
