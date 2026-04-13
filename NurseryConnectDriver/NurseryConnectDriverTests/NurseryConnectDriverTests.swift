import XCTest
import CoreLocation
@testable import NurseryConnectDriver

final class NurseryConnectDriverTests: XCTestCase {

    @MainActor
    func testStartTripIfNeededChangesTripState() {
        let viewModel = TransportViewModel(
            storageService: MockStorageService(),
            dataService: MockDataService()
        )

        XCTAssertFalse(viewModel.trip.isTripStarted)
        XCTAssertNil(viewModel.trip.startTime)

        viewModel.startTripIfNeeded()

        XCTAssertTrue(viewModel.trip.isTripStarted)
        XCTAssertNotNil(viewModel.trip.startTime)
    }

    @MainActor
    func testMarkPickedUpChangesStatus() {
        let viewModel = TransportViewModel(
            storageService: MockStorageService(),
            dataService: MockDataService()
        )

        let child = viewModel.children[0]
        viewModel.markPickedUp(child: child)

        XCTAssertEqual(viewModel.children[0].status, .pickedUp)
        XCTAssertNotNil(viewModel.children[0].pickupTime)
        XCTAssertEqual(viewModel.successMessage, "\(viewModel.children[0].name) marked as on board.")
    }

    @MainActor
    func testCannotMarkPickedUpTwice() {
        let viewModel = TransportViewModel(
            storageService: MockStorageService(),
            dataService: MockDataService()
        )

        let child = viewModel.children[0]
        viewModel.markPickedUp(child: child)
        let updatedChild = viewModel.children[0]
        viewModel.markPickedUp(child: updatedChild)

        XCTAssertEqual(viewModel.errorMessage, "This child is already marked as on board.")
    }

    @MainActor
    func testCannotDropOffBeforePickup() {
        let viewModel = TransportViewModel(
            storageService: MockStorageService(),
            dataService: MockDataService()
        )

        let child = viewModel.children[0]
        viewModel.markDroppedOff(child: child)

        XCTAssertEqual(viewModel.children[0].status, .pending)
        XCTAssertEqual(viewModel.errorMessage, "You must mark the child as on board before drop off.")
    }

    @MainActor
    func testMarkDroppedOffAfterPickupWorks() {
        let viewModel = TransportViewModel(
            storageService: MockStorageService(),
            dataService: MockDataService()
        )

        let child = viewModel.children[0]
        viewModel.markPickedUp(child: child)

        let updatedChild = viewModel.children[0]
        viewModel.markDroppedOff(child: updatedChild)

        XCTAssertEqual(viewModel.children[0].status, .droppedOff)
        XCTAssertNotNil(viewModel.children[0].dropoffTime)
    }

    @MainActor
    func testTripCompletesWhenAllChildrenDroppedOff() {
        let viewModel = TransportViewModel(
            storageService: MockStorageService(),
            dataService: MockDataService()
        )

        for child in viewModel.children {
            viewModel.markPickedUp(child: child)
        }

        for child in viewModel.children {
            if let updatedChild = viewModel.child(withID: child.id) {
                viewModel.markDroppedOff(child: updatedChild)
            }
        }

        XCTAssertTrue(viewModel.trip.isTripCompleted)
        XCTAssertNotNil(viewModel.trip.endTime)
        XCTAssertEqual(viewModel.droppedOffCount, viewModel.children.count)
    }

    @MainActor
    func testResetTripRestoresPendingStatus() {
        let viewModel = TransportViewModel(
            storageService: MockStorageService(),
            dataService: MockDataService()
        )

        let child = viewModel.children[0]
        viewModel.markPickedUp(child: child)
        viewModel.resetTrip()

        XCTAssertTrue(viewModel.children.allSatisfy { $0.status == .pending })
        XCTAssertEqual(viewModel.pendingCount, viewModel.children.count)
        XCTAssertFalse(viewModel.trip.isTripStarted)
        XCTAssertFalse(viewModel.trip.isTripCompleted)
    }

    @MainActor
    func testFilteredChildrenReturnsMatchingResults() {
        let viewModel = TransportViewModel(
            storageService: MockStorageService(),
            dataService: MockDataService()
        )

        viewModel.searchText = "Emma"

        XCTAssertEqual(viewModel.filteredChildren.count, 1)
        XCTAssertEqual(viewModel.filteredChildren.first?.name, "Emma Johnson")
    }

    @MainActor
    func testDistanceCalculationBetweenStopsReturnsValue() {
        let locationViewModel = LocationViewModel(locationService: MockLocationService())

        let stops = locationViewModel.routeStops
        XCTAssertGreaterThan(stops.count, 1)

        let distance = locationViewModel.distanceText(from: stops[0], to: stops[1])

        XCTAssertFalse(distance.isEmpty)
        XCTAssertTrue(distance.contains("km"))
    }

    @MainActor
    func testDistanceFromDriverToStopReturnsValue() {
        let locationViewModel = LocationViewModel(locationService: MockLocationService())

        let stop = locationViewModel.routeStops[1]
        let distance = locationViewModel.distanceFromDriver(to: stop)

        XCTAssertFalse(distance.isEmpty)
        XCTAssertTrue(distance.contains("km"))
    }

    @MainActor
    func testStopDistanceRowsReturnsCorrectCount() {
        let locationViewModel = LocationViewModel(locationService: MockLocationService())

        let rows = locationViewModel.stopDistanceRows()

        XCTAssertEqual(rows.count, max(locationViewModel.routeStops.count - 1, 0))
    }

    @MainActor
    func testTotalRouteDistanceTextIsNotEmpty() {
        let locationViewModel = LocationViewModel(locationService: MockLocationService())

        XCTAssertFalse(locationViewModel.totalRouteDistanceText.isEmpty)
        XCTAssertTrue(locationViewModel.totalRouteDistanceText.contains("km"))
    }

    @MainActor
    func testStartSimulationChangesState() {
        let locationViewModel = LocationViewModel(locationService: MockLocationService())

        XCTAssertFalse(locationViewModel.isSimulationRunning)

        locationViewModel.startSimulation()

        XCTAssertTrue(locationViewModel.isSimulationRunning)
        XCTAssertEqual(locationViewModel.tripStatusText, "Heading to: Start Point")
    }

    @MainActor
    func testStopSimulationChangesState() {
        let locationViewModel = LocationViewModel(locationService: MockLocationService())

        locationViewModel.startSimulation()
        locationViewModel.stopSimulation()

        XCTAssertFalse(locationViewModel.isSimulationRunning)
        XCTAssertEqual(locationViewModel.tripStatusText, "Simulation stopped")
        XCTAssertEqual(locationViewModel.estimatedArrivalText, "ETA unavailable")
    }

    @MainActor
    func testResetSimulationRestoresInitialState() {
        let locationViewModel = LocationViewModel(locationService: MockLocationService())

        locationViewModel.startSimulation()
        locationViewModel.resetSimulation()

        XCTAssertFalse(locationViewModel.isSimulationRunning)
        XCTAssertEqual(locationViewModel.currentStopIndex, 0)
        XCTAssertEqual(locationViewModel.tripStatusText, "Ready to start")
        XCTAssertEqual(locationViewModel.estimatedArrivalText, "ETA unavailable")
    }

    @MainActor
    func testThemeViewModelUpdatesTheme() {
        let themeService = MockThemeService()
        let themeViewModel = ThemeViewModel(themeService: themeService)

        XCTAssertEqual(themeViewModel.selectedTheme, .system)

        themeViewModel.updateTheme(.dark)

        XCTAssertEqual(themeViewModel.selectedTheme, .dark)
        XCTAssertEqual(themeService.savedTheme, .dark)
        XCTAssertEqual(themeViewModel.colorScheme, .dark)
    }
}

// MARK: - Mock Storage Service

final class MockStorageService: StorageServiceProtocol {
    private var storedTrip: TransportTrip?

    func saveTrip(_ trip: TransportTrip) {
        storedTrip = trip
    }

    func loadTrip() -> TransportTrip? {
        storedTrip
    }
}

// MARK: - Mock Location Service

final class MockLocationService: LocationServiceProtocol {
    func initialLocation() -> DriverLocation {
        DriverLocation(
            latitude: 6.9271,
            longitude: 79.8612,
            passengers: samplePassengers()
        )
    }

    func defaultStops() -> [RouteStop] {
        [
            RouteStop(
                title: "Start Point",
                subtitle: "Start",
                latitude: 6.9271,
                longitude: 79.8612,
                order: 1
            ),
            RouteStop(
                title: "School A",
                subtitle: "Pickup",
                latitude: 6.9286,
                longitude: 79.8645,
                order: 2
            ),
            RouteStop(
                title: "School B",
                subtitle: "Pickup",
                latitude: 6.9300,
                longitude: 79.8680,
                order: 3
            )
        ]
    }

    func samplePassengers() -> [Passenger] {
        [
            Passenger(name: "Emma Johnson", age: 4),
            Passenger(name: "Liam Smith", age: 5)
        ]
    }
}

// MARK: - Mock Theme Service

final class MockThemeService: ThemeServiceProtocol {
    var savedTheme: AppTheme = .system

    func saveTheme(_ theme: AppTheme) {
        savedTheme = theme
    }

    func loadTheme() -> AppTheme {
        savedTheme
    }
}
