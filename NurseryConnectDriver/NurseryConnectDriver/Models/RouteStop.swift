import Foundation
import CoreLocation

struct RouteStop: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var subtitle: String
    var latitude: Double
    var longitude: Double
    var order: Int

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        latitude: Double,
        longitude: Double,
        order: Int
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
        self.order = order
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
