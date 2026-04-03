import XCTest
@testable import NurseryConnectDriver

final class NurseryConnectDriverTests: XCTestCase {
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
        XCTAssertEqual(viewModel.errorMessage, "You must mark the child as picked up before drop off.")
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
    }
}

final class MockStorageService: StorageServiceProtocol {
    private var storedTrip: TransportTrip?

    func saveTrip(_ trip: TransportTrip) {
        storedTrip = trip
    }

    func loadTrip() -> TransportTrip? {
        storedTrip
    }
}
