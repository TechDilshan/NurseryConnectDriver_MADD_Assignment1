import Foundation
import CoreLocation

struct DriverLocation: Codable, Equatable {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var passengers: [Passenger]

    init(
        latitude: Double,
        longitude: Double,
        timestamp: Date = Date(),
        passengers: [Passenger] = []
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.passengers = passengers
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static func == (lhs: DriverLocation, rhs: DriverLocation) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude &&
        lhs.timestamp == rhs.timestamp &&
        lhs.passengers == rhs.passengers
    }
}
