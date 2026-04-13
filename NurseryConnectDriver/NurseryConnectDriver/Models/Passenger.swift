import Foundation

struct Passenger: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let name: String
    let age: Int

    init(id: UUID = UUID(), name: String, age: Int) {
        self.id = id
        self.name = name
        self.age = age
    }
}
