//
//  metricCard.swift
//  NeuroRise
//
//  Created by Jesus Casasanta on 3/22/26.
//

import SwiftUI

struct metricCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)

            Text(value)
                .font(.title2)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemCyan).opacity(0.2))
        .cornerRadius(12)
    }
}
