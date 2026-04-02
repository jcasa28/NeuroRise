//
//  MetricsView.swift
//  NeuroRise
//
//  Created by Jesus Casasanta on 3/10/26.
//

import SwiftUI

struct MetricsView: View {

    @StateObject var viewModel = MetricsViewModel()

    @State private var aiMessage: String = "Loading advice..."
    let aiService = AIService()
    
    var metrics: [Metric] {
        [
            Metric(title: "Heart Rate ",
                   value: "\(Int(viewModel.heartRate ?? 0)) BPM",
                   icon: "❤️",
                   detailType: "heartRate"),
            Metric(title: "HRV (Stress) ",
                   value: "\(Int(viewModel.stressScore ?? 0)) ms",
                   icon: "🧠",
                   detailType: "stressScore"),
            Metric(title: "Steps ",
                   value: "\(Int(viewModel.steps ?? 0))",
                   icon: "🚶",
                   detailType: "steps"),
            Metric(title: "Distance ",
                   value: String(format: "%.2f m", viewModel.distance ?? 0),
                   icon: "🏃",
                   detailType: "distance"),
            Metric(title: "Calories ",
                   value: "\(Int(viewModel.calories ?? 0)) kcal",
                   icon: "🔥",
                   detailType: "calories"),
            Metric(title: "Sleep ",
                   value: String(format: "%.1f h", viewModel.sleepHours ?? 0),
                   icon: "🛌",
                   detailType: "sleepHours"),
            Metric(title: "Respiratory Rate ",
                   value: "\(Int(viewModel.respiratoryRate ?? 0)) bpm",
                   icon: "🫁",
                   detailType: "respiratoryRate"),
            Metric(title: "Balance ",
                   value: "\(Int(viewModel.walkingBalance ?? 0)) %",
                   icon: "🧍",
                   detailType: "walkingBalance"),
            Metric(title: "Body Temp ",
                   value: String(format: "%.1f °C", viewModel.bodyTemp ?? 0),
                   icon: "🌡️",
                   detailType: "bodyTemp"),
        ]
    }

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(metrics) { metric in
                        NavigationLink(destination: MetricDetailView(metric: metric)) {
                            VStack(spacing: 8) {
                                Text(metric.icon)
                                    .font(.largeTitle)
                                Text(metric.title)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                Text(metric.value)
                                    .font(.title2)
                                    .bold()
                            }
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemCyan).opacity(0.2))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
                AIAdviceCard(message: aiMessage)
            }
            .navigationTitle("NeuroRise Dashboard 📊")
            .onAppear {
                viewModel.requestHealthAccess()
                
                Task {
                    let metrics = DailyMetrics(
                        heartRate: viewModel.heartRate ?? 0,
                        hrv: viewModel.stressScore ?? 0,
                        steps: Int(viewModel.steps ?? 0),
                        calories: viewModel.calories ?? 0,
                        sleepHours: viewModel.sleepHours ?? 0,
                        respiratoryRate: viewModel.respiratoryRate ?? 0
                    )

                    do {
                        aiMessage = try await aiService.getAdvice(metrics: metrics)
                    } catch {
                        aiMessage = "Unable to generate advice."
                    }
                }
                
            }
        }
    }
}

#Preview {
    MetricsView()
}
