import SwiftUI

struct AIAdviceCard: View {
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack{ Text("AI Coach 🧠")
                    .font(.headline)
                
            }
            Text(message)
                .font(.body)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
        .padding()
    }
}
