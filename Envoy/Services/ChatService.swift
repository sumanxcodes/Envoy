import Foundation
import GoogleGenerativeAI

class ChatService {
    static let shared = ChatService()
    
    private let model: GenerativeModel
    
    private init() {
        // TODO: Replace with your actual API Key or fetch from a secure source
        // You can get an API key at https://aistudio.google.com/app/apikey
        let apiKey = "YOUR_GEMINI_API_KEY"
        
        self.model = GenerativeModel(name: "gemini-pro", apiKey: apiKey)
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
