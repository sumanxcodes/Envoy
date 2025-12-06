import Foundation
import MapKit

struct MapPin: Identifiable, Codable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
    let title: String
    let timestamp: Date
    
    init(coordinate: CLLocationCoordinate2D, title: String = "Pin") {
        self.id = UUID()
        self.coordinate = coordinate
        self.title = title
        self.timestamp = Date()
    }
    
    // Codable conformance for CLLocationCoordinate2D
    enum CodingKeys: String, CodingKey {
        case id, title, timestamp, latitude, longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}
