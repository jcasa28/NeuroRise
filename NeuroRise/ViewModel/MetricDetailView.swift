//  MetricDetailView.swift
//  NeuroRise
//
//  Created by Assistant on 4/2/26.
//

import SwiftUI

struct MetricDetailView: View {
    let metric: Metric
    
    var body: some View {
        VStack(spacing: 24) {
            Text(metric.icon)
                .font(.system(size: 80))

            Text(metric.title)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text(metric.value)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)

            Spacer()

            // Placeholder for more detailed info
            Text("More details about \(metric.title) coming soon!")
                .foregroundStyle(.gray)
        }
        .padding()
        .navigationTitle(metric.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MetricDetailView(
        metric: Metric(title: "Heart Rate", value: "72 BPM", icon: "❤️", detailType: "heartRate")
    )
}
