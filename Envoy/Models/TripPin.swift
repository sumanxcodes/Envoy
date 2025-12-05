import Foundation

struct TripPin: Codable, Identifiable {
    let id: UUID
    let tripId: UUID
    let addedBy: UUID
    let lat: Double
    let lng: Double
    let placeName: String
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case tripId = "trip_id"
        case addedBy = "added_by"
        case lat
        case lng
        case placeName = "place_name"
        case notes
    }
}
