 # NeuroRise 🧠

NeuroRise is an iOS health and wellness app that integrates Apple Health metrics with a personalized AI assistant. The app provides a comprehensive health dashboard and generates actionable wellbeing advice based on the user's data.

## Key Features

### Real-time Health Dashboard
- Heart Rate (BPM) ❤️
- Heart Rate Variability (HRV) 🧠
- Steps & Walking Distance 🚶🏃
- Calories Burned 🔥
- Sleep Hours 😴
- Respiratory Rate 🫁
- Walking Balance 🧍
- Body Temperature 🌡️

### AI Coach 🧠
- Generates short, practical health advice based on current metrics.
- Integrated with a custom backend AI (deepseek-r1) for personalized recommendations.

### Modern SwiftUI Interface
- Responsive grid layout for metrics.
- Dynamic cards with intuitive symbols and colors.
- Smooth animations when displaying AI advice.

### Security & Privacy
- Sensitive data is only read from HealthKit with user consent.
- API keys and secrets are stored securely outside the repository using .gitignore.

## Technologies Used

- Swift & SwiftUI – declarative, modern UI.
- HealthKit – access live health metrics.
- Combine – reactive updates for live metrics.
- Async/Await – non-blocking calls to the AI service.
- Xcode 15+ – for building and testing.
- AI Backend – DeepSeek-powered endpoint for health advice.

## Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/NeuroRise.git
cd NeuroRise
```

2. Open in Xcode:

```bash
open NeuroRise.xcodeproj
```

3. Configure HealthKit:
   - Enable HealthKit under Capabilities.
   - The app will request permissions on first launch.

4. Set up your API Key — create a `Secrets.swift` file outside the repository (ignored by Git):

```swift
struct Secrets {
    static let aiApiURL = "https://your-deepseek-endpoint.com/api/chat"
}
```

5. Run on a real iOS device (HealthKit metrics do not work in the simulator).

## How to Use

1. Open the app on your iPhone.
2. Grant HealthKit permissions on first launch.
3. View updated metrics in the dashboard.
4. Tap **Generate Advice** in the AI card to receive recommendations based on your latest metrics.

## Project Structure

```
NeuroRise/
└── NeuroRise/
    ├── Models/
    │   └── MetricsModel.swift
    ├── View/
    │   ├── metricCard.swift
    │   └── MetricsView.swift
    ├── ViewModel/
    │   ├── AIAdviceCard.swift
    │   ├── AIService.swift
    │   ├── DailyMetrics.swift
    │   ├── HealthKitManager.swift
    │   ├── MetricDetailView.swift
    │   └── MetricsViewModel.swift
    ├── Assets/
    ├── ContentView.swift
    ├── Metric.swift
    ├── NeuroRise.xcodeproj
    ├── NeuroRiseApp.swift
    └── Secrets.swift
NeuroRiseTests/
└── NeuroRiseTests.swift
NeuroRiseUITests/
├── NeuroRiseUITests.swift
└── NeuroRiseUITestsLaunchTests.swift
```

## Best Practices

- User data never leaves the device without consent.
- API keys and secrets are securely managed using .gitignore.
- Metrics are fetched asynchronously to avoid blocking the UI.
- The app is designed to scale with new metrics or AI models easily.

## Future Enhancements

- Implement live metrics updates while the user interacts with the app.
- Add a metrics history to visualize trends over time.
- Improve the AI for more advanced personalized advice.
- Expand support to watchOS for Apple Watch metrics.
