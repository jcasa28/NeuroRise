//
//  MetricsView.swift
//  NeuroRise
//
//  Created by Jesus Casasanta on 3/10/26.
//

import SwiftUI

// MARK: - Theme
struct NRTheme {
    let background:    Color
    let cardBG:        Color
    let cardBorder:    Color
    let labelMuted:    Color
    let valuePrimary:  Color
    let subtitleMuted: Color
    let aiBG:          Color
    let aiBorder:      Color
    let aiText:        Color
    let headerSub:     Color

    static let dark = NRTheme(
        background:    Color(red: 0.04, green: 0.05, blue: 0.08),
        cardBG:        Color(red: 0.07, green: 0.08, blue: 0.12),
        cardBorder:    Color.white.opacity(0.07),
        labelMuted:    Color.white.opacity(0.38),
        valuePrimary:  Color.white,
        subtitleMuted: Color.white.opacity(0.28),
        aiBG:          Color(red: 0.06, green: 0.08, blue: 0.15),
        aiBorder:      Color(red: 0.31, green: 0.56, blue: 0.97).opacity(0.25),
        aiText:        Color.white.opacity(0.65),
        headerSub:     Color.white.opacity(0.4)
    )

    static let light = NRTheme(
        background:    Color(red: 0.95, green: 0.96, blue: 0.98),
        cardBG:        Color.white,
        cardBorder:    Color.black.opacity(0.07),
        labelMuted:    Color.black.opacity(0.38),
        valuePrimary:  Color(red: 0.08, green: 0.09, blue: 0.14),
        subtitleMuted: Color.black.opacity(0.32),
        aiBG:          Color(red: 0.93, green: 0.96, blue: 1.0),
        aiBorder:      Color(red: 0.31, green: 0.56, blue: 0.97).opacity(0.35),
        aiText:        Color(red: 0.15, green: 0.2, blue: 0.35),
        headerSub:     Color.black.opacity(0.38)
    )
}

// MARK: - Sparkline
struct SparklineView: View {
    var color: Color
    var points: [CGFloat] = [20, 16, 18, 10, 14, 8, 12, 9]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let minP = points.min() ?? 0
            let maxP = points.max() ?? 1
            let range = maxP - minP == 0 ? 1 : maxP - minP
            let step = w / CGFloat(points.count - 1)

            Path { path in
                for (i, val) in points.enumerated() {
                    let x = CGFloat(i) * step
                    let y = h - ((val - minP) / range) * h
                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else       { path.addLine(to: CGPoint(x: x, y: y)) }
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
            .opacity(0.75)
        }
    }
}

// MARK: - Metric Card
struct MetricCard: View {
    let metric: Metric
    let accentColor: Color
    let sparkPoints: [CGFloat]
    let subtitle: String
    let theme: NRTheme

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(accentColor.opacity(0.15))
                        .frame(width: 32, height: 32)
                    Text(metric.icon)
                        .font(.system(size: 16))
                }
                Spacer()
                Circle()
                    .fill(accentColor)
                    .frame(width: 7, height: 7)
                    .shadow(color: accentColor.opacity(0.7), radius: 3)
            }
            .padding(.bottom, 10)

            Text(metric.title.trimmingCharacters(in: .whitespaces).uppercased())
                .font(.system(.headline, weight: .medium))
                .tracking(0.5)
                .foregroundColor(theme.labelMuted)
                .padding(.bottom, 3)

            Text(metric.value)
                .font(.system(size: 19, weight: .bold, design: .monospaced))
                .foregroundColor(theme.valuePrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.bottom, 2)

            Text(subtitle)
                .font(.system(.subheadline))
                .foregroundColor(theme.subtitleMuted)
                .padding(.bottom, 8)

            SparklineView(color: accentColor, points: sparkPoints)
                .frame(height: 26)
        }
        .padding(14)
        .background(theme.cardBG)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(theme.cardBorder, lineWidth: 0.5)
        )
        .overlay(
            VStack {
                Rectangle()
                    .fill(accentColor.opacity(0.8))
                    .frame(height: 2)
                    .cornerRadius(16)
                Spacer()
            }
        )
    }
}

// MARK: - MetricsView
struct MetricsView: View {

    @StateObject var viewModel = MetricsViewModel()
    @State private var aiMessage: String = "Analyzing your metrics..."
    @Environment(\.colorScheme) var colorScheme
    let aiService = AIService()

    var theme: NRTheme { colorScheme == .dark ? .dark : .light }

    private let accentColors: [String: Color] = [
        "heartRate":       Color(red: 0.89, green: 0.38, blue: 0.35),
        "stressScore":     Color(red: 0.49, green: 0.36, blue: 0.75),
        "steps":           Color(red: 0.31, green: 0.56, blue: 0.97),
        "distance":        Color(red: 0.24, green: 0.66, blue: 0.54),
        "calories":        Color(red: 0.91, green: 0.53, blue: 0.29),
        "sleepHours":      Color(red: 0.36, green: 0.49, blue: 0.91),
        "respiratoryRate": Color(red: 0.29, green: 0.72, blue: 0.78),
        "walkingBalance":  Color(red: 0.55, green: 0.76, blue: 0.29),
        "bodyTemp":        Color(red: 0.89, green: 0.63, blue: 0.23),
    ]

    private let sparkData: [String: [CGFloat]] = [
        "heartRate":       [20, 16, 18, 10, 14, 8,  12, 9],
        "stressScore":     [22, 18, 14, 16, 10, 13, 9,  11],
        "steps":           [26, 22, 20, 18, 15, 12, 10, 8],
        "distance":        [24, 20, 22, 15, 17, 11, 13, 9],
        "calories":        [20, 22, 16, 19, 12, 14, 10, 11],
        "sleepHours":      [14, 10, 8,  12, 9,  7,  10, 8],
        "respiratoryRate": [18, 14, 16, 12, 14, 10, 12, 10],
        "walkingBalance":  [16, 12, 14, 10, 12, 8,  10, 7],
        "bodyTemp":        [14, 12, 13, 11, 13, 12, 11, 12],
    ]

    private let subtitles: [String: String] = [
        "heartRate":       "Normal range",
        "stressScore":     "Low stress",
        "steps":           "63% of daily goal",
        "distance":        "+0.6 km vs yesterday",
        "calories":        "Active burn",
        "sleepHours":      "Good quality",
        "respiratoryRate": "Healthy",
        "walkingBalance":  "Excellent",
        "bodyTemp":        "No fever detected",
    ]

    var metrics: [Metric] {
        [
            Metric(title: "Heart Rate",   value: "\(Int(viewModel.heartRate ?? 0)) BPM",                      icon: "❤️",  detailType: "heartRate"),
            Metric(title: "HRV · Stress", value: "\(Int(viewModel.stressScore ?? 0)) ms",                     icon: "🧠",  detailType: "stressScore"),
            Metric(title: "Steps",        value: "\(Int(viewModel.steps ?? 0))",                              icon: "🚶",  detailType: "steps"),
            Metric(title: "Distance",     value: String(format: "%.2f km", (viewModel.distance ?? 0) / 1000), icon: "🏃",  detailType: "distance"),
            Metric(title: "Calories",     value: "\(Int(viewModel.calories ?? 0)) kcal",                      icon: "🔥",  detailType: "calories"),
            Metric(title: "Sleep",        value: String(format: "%.1f hrs", viewModel.sleepHours ?? 0),       icon: "🛌",  detailType: "sleepHours"),
            Metric(title: "Resp. Rate",   value: "\(Int(viewModel.respiratoryRate ?? 0)) bpm",                icon: "🫁",  detailType: "respiratoryRate"),
            Metric(title: "Balance",      value: "\(Int(viewModel.walkingBalance ?? 0)) %",                   icon: "🧍",  detailType: "walkingBalance"),
            Metric(title: "Body Temp",    value: String(format: "%.1f °C", viewModel.bodyTemp ?? 0),          icon: "🌡️", detailType: "bodyTemp"),
        ]
    }

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // MARK: Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("NeuroRise Dashboard")
                            .font(.system(.largeTitle, weight: .semibold))
                            .foregroundColor(theme.valuePrimary)
                        Text(formattedDate())
                            .font(.system(.headline))
                            .foregroundColor(theme.headerSub)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 40)

                    // MARK: Grid
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(metrics) { metric in
                            NavigationLink(destination: MetricDetailView(metric: metric)) {
                                MetricCard(
                                    metric: metric,
                                    accentColor: accentColors[metric.detailType] ?? .blue,
                                    sparkPoints: sparkData[metric.detailType] ?? [10, 8, 12, 9, 11, 7, 10, 8],
                                    subtitle: subtitles[metric.detailType] ?? "",
                                    theme: theme
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)

                    // MARK: AI Card
                    AIAdviceCard(message: aiMessage, theme: theme)
                        .padding(.horizontal, 20)
                        .padding(.top, 14)
                        .padding(.bottom, 28)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.requestHealthAccess()
            Task {
                let m = DailyMetrics(
                    heartRate:       viewModel.heartRate ?? 0,
                    hrv:             viewModel.stressScore ?? 0,
                    steps:           Int(viewModel.steps ?? 0),
                    calories:        viewModel.calories ?? 0,
                    sleepHours:      viewModel.sleepHours ?? 0,
                    respiratoryRate: viewModel.respiratoryRate ?? 0
                )
                do {
                    aiMessage = try await aiService.getAdvice(metrics: m)
                } catch {
                    aiMessage = "Unable to generate advice at this time."
                }
            }
        }
    }

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d · All systems nominal"
        return f.string(from: Date())
    }
}

// MARK: - Previews
#Preview("Dark Mode") {
    NavigationView { MetricsView() }
        .preferredColorScheme(.dark)
}

#Preview("Light Mode") {
    NavigationView { MetricsView() }
        .preferredColorScheme(.light)
}
