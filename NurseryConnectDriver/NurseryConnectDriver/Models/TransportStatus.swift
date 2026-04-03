import Foundation

enum TransportStatus: String, Codable, CaseIterable {
    case pending
    case pickedUp
    case droppedOff

    var title: String {
        switch self {
        case .pending:
            return "Pending"
        case .pickedUp:
            return "On Board"
        case .droppedOff:
            return "Dropped Off"
        }
    }
}
