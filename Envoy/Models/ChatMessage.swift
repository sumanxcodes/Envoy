import Foundation

struct ChatMessage: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let role: String
    let content: String
    let markersJson: [String]? // Simplified for now, can be specific struct later
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case role
        case content
        case markersJson = "markers_json"
        case createdAt = "created_at"
    }
}
