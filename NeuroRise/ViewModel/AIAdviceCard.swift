import SwiftUI
import CoreData


// MARK: - AI Advice Card
struct AIAdviceCard: View {
    var message: String
    let theme: NRTheme

    @State private var dotScale: CGFloat = 1.0
    private let blue = Color(red: 0.31, green: 0.56, blue: 0.97)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle()
                    .fill(blue)
                    .frame(width: 8, height: 8)
                    .shadow(color: blue.opacity(0.9), radius: 4)
                    .scaleEffect(dotScale)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                            dotScale = 0.6
                        }
                    }
                Text("AI COACH · DEEPSEEK")
                    .font(.system(.headline, weight: .semibold))
                    .tracking(0.6)
                    .foregroundColor(blue)
            }

            Text(message)
                .font(.system(.headline))
                .foregroundColor(theme.aiText)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.aiBG)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(theme.aiBorder, lineWidth: 0.5)
        )
    }
}

#Preview {
    MetricsView()
}
