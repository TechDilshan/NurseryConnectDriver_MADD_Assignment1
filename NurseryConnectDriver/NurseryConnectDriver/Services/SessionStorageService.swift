import Foundation

protocol SessionStorageServiceProtocol {
    func saveUser(_ user: DriverUser)
    func loadUser() -> DriverUser?
    func clearUser()
    func saveLoggedInState(_ isLoggedIn: Bool)
    func loadLoggedInState() -> Bool
}

final class SessionStorageService: SessionStorageServiceProtocol {
    private let userKey = "logged_in_driver_user"
    private let loginStateKey = "driver_logged_in_state"

    func saveUser(_ user: DriverUser) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: userKey)
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }

    func loadUser() -> DriverUser? {
        guard let data = UserDefaults.standard.data(forKey: userKey) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(DriverUser.self, from: data)
        } catch {
            print("Failed to load user: \(error.localizedDescription)")
            return nil
        }
    }

    func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }

    func saveLoggedInState(_ isLoggedIn: Bool) {
        UserDefaults.standard.set(isLoggedIn, forKey: loginStateKey)
    }

    func loadLoggedInState() -> Bool {
        UserDefaults.standard.bool(forKey: loginStateKey)
    }
}
