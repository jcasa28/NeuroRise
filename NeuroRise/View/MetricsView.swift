//
//  MetricsView.swift
//  NeuroRise
//
//  Created by Jesus Casasanta on 3/10/26.
//

import SwiftUI

struct MetricsView: View {

    @StateObject var viewModel = MetricsViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                Text("NeuroRise Dashboard 📊")
                    .font(.largeTitle)
                    .bold()

                // ❤️ Heart
                metricCard(title: "Heart Rate ❤️",
                           value: "\(Int(viewModel.heartRate ?? 0)) BPM")

                metricCard(title: "HRV (Stress) 🧠",
                           value: "\(Int(viewModel.stressScore ?? 0)) ms")

                // 🏃 Activity
                metricCard(title: "Steps 🚶",
                           value: "\(Int(viewModel.steps ?? 0))")

                metricCard(title: "Distance 🏃",
                           value: String(format: "%.2f m", viewModel.distance ?? 0
                                    ))

                metricCard(title: "Calories 🔥",
                           value: "\(Int(viewModel.calories ?? 0)) kcal")

                // 😴 Sleep
                metricCard(title: "Sleep 🛌",
                           value: String(format: "%.1f h", viewModel.sleepHours ?? 0
                                    ))

                // 🫁 Respiratory
                metricCard(title: "Respiratory Rate 🫁",
                           value: "\(Int(viewModel.respiratoryRate ?? 0)) bpm")

                // 🧍 Balance
                metricCard(title: "Balance 🧍",
                           value: "\(Int(viewModel.walkingBalance ?? 0)) %")

                // 🌡️ Temperature
                metricCard(title: "Body Temp 🌡️",
                           value: String(format: "%.1f °C", viewModel.bodyTemp ?? 0
                                    ))

            }
            .padding()
        }
        .onAppear {
            viewModel.requestHealthAccess()
        }
    }
}

#Preview{
    MetricsView()
}
