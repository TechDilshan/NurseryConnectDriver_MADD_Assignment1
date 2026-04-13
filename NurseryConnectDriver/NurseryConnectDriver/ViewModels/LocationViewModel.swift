import Foundation
import MapKit
import SwiftUI
import CoreLocation

@MainActor
final class LocationViewModel: ObservableObject {
    @Published var currentRegion: MKCoordinateRegion
    @Published var currentLocation: DriverLocation
    @Published var routeStops: [RouteStop]
    @Published var currentStopIndex: Int = 0
    @Published var isSimulationRunning: Bool = false
    @Published var tripStatusText: String = "Ready to start"
    @Published var estimatedArrivalText: String = "ETA unavailable"
    @Published var selectedMapStyle: MapStyleOption = .standard

    private let locationService: LocationServiceProtocol
    private var stopTimer: Timer?
    private let simulationInterval: TimeInterval = 4.0
    private let animationSteps: Int = 80

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

    var currentStopTitle: String {
        guard currentStopIndex > 0, currentStopIndex - 1 < routeStops.count else {
            return "Not started"
        }
        return routeStops[currentStopIndex - 1].title
    }

    var nextStopTitle: String {
        guard currentStopIndex < routeStops.count else {
            return "No next stop"
        }
        return routeStops[currentStopIndex].title
    }

    var totalRouteDistanceText: String {
        let total = totalRouteDistanceInKilometers()
        return String(format: "%.2f km", total)
    }

    func startSimulation() {
        guard !isSimulationRunning else { return }
        guard !routeStops.isEmpty else {
            tripStatusText = "No route available"
            estimatedArrivalText = "ETA unavailable"
            return
        }

        isSimulationRunning = true
        tripStatusText = "Transport run in progress"
        updateETA()

        stopTimer?.invalidate()
        stopTimer = Timer.scheduledTimer(withTimeInterval: simulationInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.advanceToNextStop()
        }

        advanceToNextStop()
    }

    func stopSimulation() {
        isSimulationRunning = false
        tripStatusText = "Simulation stopped"
        estimatedArrivalText = "ETA unavailable"
        stopTimer?.invalidate()
        stopTimer = nil
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

    func centerOnDriver() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentRegion = MKCoordinateRegion(
                center: currentLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
    }

    func distanceText(from first: RouteStop, to second: RouteStop) -> String {
        let firstLocation = CLLocation(latitude: first.latitude, longitude: first.longitude)
        let secondLocation = CLLocation(latitude: second.latitude, longitude: second.longitude)
        let meters = firstLocation.distance(from: secondLocation)
        return String(format: "%.2f km", meters / 1000)
    }

    func distanceFromDriver(to stop: RouteStop) -> String {
        let driver = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let target = CLLocation(latitude: stop.latitude, longitude: stop.longitude)
        let meters = driver.distance(from: target)
        return String(format: "%.2f km", meters / 1000)
    }

    func stopDistanceRows() -> [(from: String, to: String, distance: String)] {
        guard routeStops.count > 1 else { return [] }

        var rows: [(from: String, to: String, distance: String)] = []

        for index in 0..<(routeStops.count - 1) {
            let first = routeStops[index]
            let second = routeStops[index + 1]
            rows.append((
                from: first.title,
                to: second.title,
                distance: distanceText(from: first, to: second)
            ))
        }

        return rows
    }

    private func totalRouteDistanceInKilometers() -> Double {
        guard routeStops.count > 1 else { return 0 }

        var totalMeters: Double = 0
        for index in 0..<(routeStops.count - 1) {
            let first = CLLocation(latitude: routeStops[index].latitude, longitude: routeStops[index].longitude)
            let second = CLLocation(latitude: routeStops[index + 1].latitude, longitude: routeStops[index + 1].longitude)
            totalMeters += first.distance(from: second)
        }

        return totalMeters / 1000
    }

    private func advanceToNextStop() {
        guard isSimulationRunning else { return }
        guard !routeStops.isEmpty else { return }

        if currentStopIndex >= routeStops.count {
            stopSimulation()
            tripStatusText = "Transport run completed"
            estimatedArrivalText = "Arrived at nursery"
            return
        }

        let stop = routeStops[currentStopIndex]
        tripStatusText = "Heading to: \(stop.title)"
        animateMovementSmoothly(to: stop)
        currentStopIndex += 1
        updateETA()
    }

    private func animateMovementSmoothly(to stop: RouteStop) {
        let startLatitude = currentLocation.latitude
        let startLongitude = currentLocation.longitude
        let endLatitude = stop.latitude
        let endLongitude = stop.longitude

        let stepDuration = simulationInterval / Double(animationSteps)

        for step in 1...animationSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + (stepDuration * Double(step))) { [weak self] in
                guard let self = self else { return }
                guard self.isSimulationRunning else { return }

                let progress = Double(step) / Double(self.animationSteps)

                // smoother easing
                let easedProgress = self.easeInOut(progress)

                let latitude = startLatitude + ((endLatitude - startLatitude) * easedProgress)
                let longitude = startLongitude + ((endLongitude - startLongitude) * easedProgress)

                self.currentLocation = DriverLocation(
                    latitude: latitude,
                    longitude: longitude,
                    timestamp: Date(),
                    passengers: self.locationService.samplePassengers()
                )

                // gently follow the car
                self.currentRegion.center.latitude = latitude
                self.currentRegion.center.longitude = longitude

                if step == self.animationSteps {
                    self.tripStatusText = "Current stop: \(stop.title)"
                }
            }
        }
    }

    private func easeInOut(_ t: Double) -> Double {
        if t < 0.5 {
            return 2 * t * t
        } else {
            return 1 - pow(-2 * t + 2, 2) / 2
        }
    }

    private func updateETA() {
        let remainingStops = max(routeStops.count - currentStopIndex, 0)

        if remainingStops == 0 {
            estimatedArrivalText = "ETA: Arrived"
            return
        }

        let totalSeconds = Int(Double(remainingStops) * simulationInterval)
        let minutes = max(1, Int(ceil(Double(totalSeconds) / 60.0)))
        estimatedArrivalText = "ETA: \(minutes) min"
    }

    deinit {
        stopTimer?.invalidate()
    }
}
