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
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
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
        
        do {
            // Convert history for Gemini
            let history = messages.dropLast().map { msg in
                ModelContent(role: msg.role, parts: msg.content)
            }
            
            let responseText = try await chatService.sendMessage(userText, history: history)
            
            let aiMessage = ChatMessage(
                id: generateId(),
                userId: UUID(), // Placeholder
                role: "model",
                content: responseText,
                markersJson: nil,
                createdAt: Date()
            )
            messages.append(aiMessage)
            
        } catch {
            errorMessage = error.localizedDescription
            // Optionally add an error message to the chat
        }
        
        isLoading = false
    }
}

