import Foundation

protocol LocationServiceProtocol {
    func initialLocation() -> DriverLocation
    func defaultStops() -> [RouteStop]
}

final class LocationService: LocationServiceProtocol {
    func initialLocation() -> DriverLocation {
        DriverLocation(
            latitude: 6.9271,
            longitude: 79.8612,
            timestamp: Date()
        )
    }

    func defaultStops() -> [RouteStop] {
        [
            RouteStop(
                title: "Little Stars Nursery",
                subtitle: "Starting point",
                latitude: 6.9271,
                longitude: 79.8612,
                order: 1
            ),
            RouteStop(
                title: "Little Stars Preschool",
                subtitle: "School Gate A",
                latitude: 6.9286,
                longitude: 79.8645,
                order: 2
            ),
            RouteStop(
                title: "Sunshine Kids School",
                subtitle: "Main Entrance",
                latitude: 6.9300,
                longitude: 79.8680,
                order: 3
            ),
            RouteStop(
                title: "Happy Kids Center",
                subtitle: "Side Gate",
                latitude: 6.9322,
                longitude: 79.8710,
                order: 4
            ),
            RouteStop(
                title: "Little Stars Nursery",
                subtitle: "Final destination",
                latitude: 6.9271,
                longitude: 79.8612,
                order: 5
            )
        ]
    }
}
