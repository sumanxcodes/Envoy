import Foundation
import SwiftUI
import Combine
import GoogleGenerativeAI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let chatService = ChatService.shared
    
    // Temporary ID generator for local messages
    private func generateId() -> UUID { UUID() }
    
    func sendMessage() async {
        print("🚀 sendMessage called with text: \(inputText)")
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { 
            print("⚠️ Input text is empty, returning")
            return 
        }
        
        let userText = inputText
        inputText = ""
        
        // Add user message to UI immediately
        let userMessage = ChatMessage(
            id: generateId(),
            userId: UUID(), // Placeholder, normally from Auth session
            role: "user",
            content: userText,
            markersJson: nil,
            createdAt: Date()
        )
        messages.append(userMessage)
        
        isLoading = true
        
        // Create placeholder AI message for streaming
        let aiMessageId = generateId()
        let aiMessage = ChatMessage(
            id: aiMessageId,
            userId: UUID(),
            role: "model",
            content: "",
            markersJson: nil,
            createdAt: Date()
        )
        messages.append(aiMessage)
        
        do {
            // Convert history for Gemini (exclude the empty AI message we just added)
            let history = messages.dropLast().map { msg in
                ModelContent(role: msg.role, parts: msg.content)
            }
            
            // Stream the response
            let stream = chatService.sendMessageStream(userText, history: history)
            var fullResponse = ""
            
            for try await chunk in stream {
                fullResponse += chunk
                
                // Update the AI message with accumulated text
                if let index = messages.firstIndex(where: { $0.id == aiMessageId }) {
                    messages[index] = ChatMessage(
                        id: aiMessageId,
                        userId: UUID(),
                        role: "model",
                        content: fullResponse,
                        markersJson: nil,
                        createdAt: messages[index].createdAt
                    )
                }
            }
            
        } catch {
            print("❌ ERROR in sendMessage: \(error)")
            print("❌ Error details: \(error.localizedDescription)")
            errorMessage = "Error: \(error.localizedDescription)"
            
            // Remove the empty AI message on error
            messages.removeAll { $0.id == aiMessageId }
            
            // Add error message to chat
            let errorMsg = ChatMessage(
                id: generateId(),
                userId: UUID(),
                role: "model",
                content: "Sorry, I encountered an error: \(error.localizedDescription)",
                markersJson: nil,
                createdAt: Date()
            )
            messages.append(errorMsg)
        }
        
        isLoading = false
        print("✅ sendMessage completed. isLoading = false")
    }
}
