import Foundation

struct DriverUser: Codable, Equatable {
    let username: String
    let fullName: String
    let role: String
    let vehicleNumber: String
}
