import Foundation

struct Trip: Codable, Identifiable {
    let id: UUID
    let name: String
    let ownerId: UUID
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ownerId = "owner_id"
        case createdAt = "created_at"
    }
}
