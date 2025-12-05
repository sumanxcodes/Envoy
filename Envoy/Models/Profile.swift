import Foundation

struct Profile: Codable, Identifiable {
    let id: UUID
    let email: String?
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case avatarUrl = "avatar_url"
    }
}
