import Foundation

struct Child: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var age: Int
    var schoolName: String
    var pickupLocation: String
    var dropoffLocation: String
    var guardianName: String
    var guardianContact: String
    var status: TransportStatus
    var pickupTime: Date?
    var dropoffTime: Date?

    var initials: String {
        let parts = name.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters)
    }

    var isPending: Bool { status == .pending }
    var isPickedUp: Bool { status == .pickedUp }
    var isDroppedOff: Bool { status == .droppedOff }
}
