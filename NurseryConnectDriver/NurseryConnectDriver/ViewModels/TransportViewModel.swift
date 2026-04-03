import Foundation
import SwiftUI
import UIKit

@MainActor
final class TransportViewModel: ObservableObject {
    @Published var trip: TransportTrip
    @Published var children: [Child]
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var searchText: String = ""

    private let storageService: StorageServiceProtocol
    private let dataService: DataServiceProtocol

    init(
        storageService: StorageServiceProtocol = StorageService(),
        dataService: DataServiceProtocol = MockDataService()
    ) {
        self.storageService = storageService
        self.dataService = dataService

        if let savedTrip = storageService.loadTrip() {
            self.trip = savedTrip
            self.children = savedTrip.children
        } else {
            let loadedChildren = dataService.loadChildren()
            let initialTrip = TransportTrip(children: loadedChildren)
            self.trip = initialTrip
            self.children = loadedChildren
            saveChanges()
        }
    }

    var filteredChildren: [Child] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return children
        }

        let query = trimmed.lowercased()

        return children.filter {
            $0.name.lowercased().contains(query) ||
            $0.schoolName.lowercased().contains(query) ||
            $0.pickupLocation.lowercased().contains(query)
        }
    }

    var pendingCount: Int {
        children.filter { $0.status == .pending }.count
    }

    var pickedUpCount: Int {
        children.filter { $0.status == .pickedUp }.count
    }

    var droppedOffCount: Int {
        children.filter { $0.status == .droppedOff }.count
    }

    var onboardCount: Int {
        pickedUpCount
    }

    var completionProgress: Double {
        guard !children.isEmpty else { return 0.0 }
        return Double(droppedOffCount) / Double(children.count)
    }

    var tripStatusTitle: String {
        if trip.isTripCompleted {
            return "Trip Completed"
        } else if trip.isTripStarted {
            return "Trip In Progress"
        } else {
            return "Trip Not Started"
        }
    }

    var tripStatusSubtitle: String {
        if trip.isTripCompleted {
            return "All children have been safely dropped off."
        } else if trip.isTripStarted {
            return "\(onboardCount) child(ren) currently on board."
        } else {
            return "Start by marking the first child as picked up."
        }
    }

    func child(withID id: String) -> Child? {
        children.first(where: { $0.id == id })
    }

    func startTripIfNeeded() {
        guard !trip.isTripStarted else { return }

        withAnimation(.easeInOut) {
            trip.isTripStarted = true
            trip.startTime = Date()
        }

        saveChanges()
    }

    func markPickedUp(child: Child) {
        guard let index = children.firstIndex(where: { $0.id == child.id }) else { return }

        if children[index].status == .pickedUp {
            showError("This child is already marked as on board.")
            hapticError()
            return
        }

        if children[index].status == .droppedOff {
            showError("This child has already been dropped off.")
            hapticError()
            return
        }

        startTripIfNeeded()

        withAnimation(.spring()) {
            children[index].status = .pickedUp
            children[index].pickupTime = Date()
        }

        syncTripChildren()
        showSuccess("\(children[index].name) marked as on board.")
        hapticSuccess()
    }

    func markDroppedOff(child: Child) {
        guard let index = children.firstIndex(where: { $0.id == child.id }) else { return }

        if children[index].status == .pending {
            showError("You must mark the child as on board before drop off.")
            hapticError()
            return
        }

        if children[index].status == .droppedOff {
            showError("This child is already marked as dropped off.")
            hapticError()
            return
        }

        withAnimation(.spring()) {
            children[index].status = .droppedOff
            children[index].dropoffTime = Date()
        }

        syncTripChildren()

        if droppedOffCount == children.count && !children.isEmpty {
            trip.isTripCompleted = true
            trip.endTime = Date()
            showSuccess("Trip completed successfully.")
        } else {
            showSuccess("\(children[index].name) marked as dropped off.")
        }

        saveChanges()
        hapticSuccess()
    }

    func resetTrip() {
        withAnimation(.easeInOut) {
            children = dataService.loadChildren()
            trip = TransportTrip(children: children)
        }

        saveChanges()
        showSuccess("Trip data reset successfully.")
    }

    private func syncTripChildren() {
        trip.children = children
        saveChanges()
    }

    private func saveChanges() {
        trip.children = children
        storageService.saveTrip(trip)
    }

    private func showError(_ message: String) {
        errorMessage = message
        successMessage = nil
    }

    private func showSuccess(_ message: String) {
        successMessage = message
        errorMessage = nil
    }

    private func hapticSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    private func hapticError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}
