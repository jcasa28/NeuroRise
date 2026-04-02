import Foundation

// model
struct DeepSeekResponse: Decodable {
    let message: Message
    
    struct Message: Decodable {
        let role: String
        let content: String
    }
}

class AIService {
    func getAdvice(metrics: DailyMetrics) async throws -> String {
        
        // URL
        guard let url = URL(string: Secrets.deepSeekURL) else {
            throw URLError(.badURL)
        }

        // Prompt
        let prompt = """
        Do NOT include reasoning, thoughts, or explanations.
        Provide 1–2 sentences of actionable health advice based on the following metrics:
        Heart Rate: \(metrics.heartRate), HRV: \(metrics.hrv), Steps: \(metrics.steps), Calories: \(metrics.calories), Sleep Hours: \(metrics.sleepHours), Respiratory Rate: \(metrics.respiratoryRate).
        """

        // Body para /api/chat
        let body: [String: Any] = [
            "model": "deepseek-r1",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "stream": false
        ]

        let jsonData = try JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Request
        let (data, response) = try await URLSession.shared.data(for: request)

        // Debug útil (por si algo falla)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let errorString = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("❌ Server error:", errorString)
            throw URLError(.badServerResponse)
        }

        // Decode correcto
        let decoded = try JSONDecoder().decode(DeepSeekResponse.self, from: data)

        return decoded.message.content
    }
}
