//
//  Metric.swift
//  NeuroRise
//
//  Created by Jesus Casasanta on 4/2/26.
//


import Foundation

struct Metric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let icon: String
    let detailType: String
}