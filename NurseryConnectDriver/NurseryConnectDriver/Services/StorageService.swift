import Foundation

protocol StorageServiceProtocol {
    func saveTrip(_ trip: TransportTrip)
    func loadTrip() -> TransportTrip?
}

final class StorageService: StorageServiceProtocol {
    private let tripKey = "saved_transport_trip"

    func saveTrip(_ trip: TransportTrip) {
        do {
            let data = try JSONEncoder().encode(trip)
            UserDefaults.standard.set(data, forKey: tripKey)
        } catch {
            print("Failed to save trip: \(error.localizedDescription)")
        }
    }

    func loadTrip() -> TransportTrip? {
        guard let data = UserDefaults.standard.data(forKey: tripKey) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(TransportTrip.self, from: data)
        } catch {
            print("Failed to load trip: \(error.localizedDescription)")
            return nil
        }
    }
}
