import Foundation

struct TransportTrip: Identifiable, Codable {
    let id: UUID
    var tripDate: Date
    var startTime: Date?
    var endTime: Date?
    var driverName: String
    var vehicleNumber: String
    var children: [Child]
    var isTripStarted: Bool
    var isTripCompleted: Bool

    init(
        id: UUID = UUID(),
        tripDate: Date = Date(),
        startTime: Date? = nil,
        endTime: Date? = nil,
        driverName: String = "Driver",
        vehicleNumber: String = "NCD-1024",
        children: [Child] = [],
        isTripStarted: Bool = false,
        isTripCompleted: Bool = false
    ) {
        self.id = id
        self.tripDate = tripDate
        self.startTime = startTime
        self.endTime = endTime
        self.driverName = driverName
        self.vehicleNumber = vehicleNumber
        self.children = children
        self.isTripStarted = isTripStarted
        self.isTripCompleted = isTripCompleted
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

    var totalCount: Int {
        children.count
    }

    var isActive: Bool {
        isTripStarted && !isTripCompleted
    }
}
