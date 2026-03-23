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
        VStack(spacing: 20) {
            Text("Metrics 📊").font(.title)
                
            Spacer()

            Text("Heart Rate ❤️: \(Int(viewModel.heartRate ?? 0)) BPM")
                .padding(7)
                .background(Color(.cyan))
                .cornerRadius(8)
                
            Text("Stress (HRV) 🧠: \(Int(viewModel.stressScore ?? 0)) ms")
                .padding(7)
                .background(Color(.cyan))
                .cornerRadius(8)
            
            Text("Steps 🚶: \(Int(viewModel.steps ?? 0))")
                .padding(7)
                .background(Color(.cyan))
                .cornerRadius(8)
            
            Text("Sleep 🛌: \(String(format: "%.1f", viewModel.sleepHours ?? 0)) h")
                .padding(7)
                .background(Color(.cyan))
                .cornerRadius(8)
            
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.requestHealthAccess()
        }
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}
