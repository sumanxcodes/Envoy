import Foundation
import GoogleGenerativeAI

class ChatService {
    static let shared = ChatService()
    
    private let model: GenerativeModel
    
    private init() {
        // Get API key from environment variable
        let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] ?? ""
        
        if apiKey.isEmpty {
            print("❌ WARNING: GEMINI_API_KEY not set!")
            print("📝 Add it in: Xcode > Product > Scheme > Edit Scheme > Run > Arguments > Environment Variables")
        } else {
            print("✅ API key loaded (length: \(apiKey.count) chars)")
        }
        
        // Use gemini-1.5-flash (better free tier limits than 2.0-flash-exp)
        self.model = GenerativeModel(name: "gemini-1.5-flash", apiKey: apiKey)
    }
    
    func sendMessage(_ text: String, history: [ModelContent] = []) async throws -> String {
        let chat = model.startChat(history: history)
        let response = try await chat.sendMessage(text)
        
        if let text = response.text {
            return text
        } else {
            throw NSError(domain: "ChatService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty response from Gemini"])
        }
    }
    
    // Streaming support
    func sendMessageStream(_ text: String, history: [ModelContent] = []) -> AsyncThrowingStream<String, Error> {
        let chat = model.startChat(history: history)
        
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    let stream = chat.sendMessageStream(text)
                    for try await response in stream {
                        if let text = response.text {
                            continuation.yield(text)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
