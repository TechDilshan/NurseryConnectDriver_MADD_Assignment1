import Foundation
import MapKit
import SwiftUI

@MainActor
final class LocationViewModel: ObservableObject {
    @Published var currentRegion: MKCoordinateRegion
    @Published var currentLocation: DriverLocation
    @Published var routeStops: [RouteStop]
    @Published var currentStopIndex: Int = 0
    @Published var isSimulationRunning: Bool = false
    @Published var tripStatusText: String = "Ready to start"
    @Published var estimatedArrivalText: String = "ETA unavailable"

    private let locationService: LocationServiceProtocol
    private var timer: Timer?

    init(locationService: LocationServiceProtocol = LocationService()) {
        self.locationService = locationService

        let startLocation = locationService.initialLocation()
        self.currentLocation = startLocation
        self.currentRegion = MKCoordinateRegion(
            center: startLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
        self.routeStops = locationService.defaultStops()
    }

    func startSimulation() {
        guard !isSimulationRunning else { return }

        isSimulationRunning = true
        tripStatusText = "Transport run in progress"
        estimatedArrivalText = "Updating route..."

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.advanceToNextStop()
        }
    }

    func stopSimulation() {
        isSimulationRunning = false
        tripStatusText = "Simulation stopped"
        estimatedArrivalText = "ETA unavailable"
        timer?.invalidate()
        timer = nil
    }

    func resetSimulation() {
        stopSimulation()
        currentStopIndex = 0
        currentLocation = locationService.initialLocation()
        currentRegion = MKCoordinateRegion(
            center: currentLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
        tripStatusText = "Ready to start"
        estimatedArrivalText = "ETA unavailable"
    }

    private func advanceToNextStop() {
        guard !routeStops.isEmpty else { return }

        if currentStopIndex >= routeStops.count {
            stopSimulation()
            tripStatusText = "Transport run completed"
            estimatedArrivalText = "Arrived at nursery"
            return
        }

        let stop = routeStops[currentStopIndex]
        currentLocation = DriverLocation(
            latitude: stop.latitude,
            longitude: stop.longitude,
            timestamp: Date()
        )

        currentRegion = MKCoordinateRegion(
            center: currentLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )

        tripStatusText = "Current stop: \(stop.title)"

        let remainingStops = routeStops.count - (currentStopIndex + 1)
        if remainingStops > 0 {
            estimatedArrivalText = "\(remainingStops) stop(s) remaining"
        } else {
            estimatedArrivalText = "Final destination reached"
        }

        currentStopIndex += 1
    }

    deinit {
        timer?.invalidate()
    }
}
