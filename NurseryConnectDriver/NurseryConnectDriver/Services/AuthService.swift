import Foundation

protocol AuthServiceProtocol {
    func login(username: String, password: String) throws -> DriverUser
}

enum AuthError: LocalizedError {
    case emptyFields
    case invalidCredentials
    case accessDenied

    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return "Please enter both username and password."
        case .invalidCredentials:
            return "Invalid username or password."
        case .accessDenied:
            return "Access denied. This app is only for driver accounts."
        }
    }
}

final class AuthService: AuthServiceProtocol {
    private let validUsername = "driver1"
    private let validPassword = "Driver@123"

    func login(username: String, password: String) throws -> DriverUser {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedUsername.isEmpty, !trimmedPassword.isEmpty else {
            throw AuthError.emptyFields
        }

        guard trimmedUsername == validUsername, trimmedPassword == validPassword else {
            throw AuthError.invalidCredentials
        }

        return DriverUser(
            username: validUsername,
            fullName: "Daniel Perera",
            role: "Driver",
            vehicleNumber: "NCD-1024"
        )
    }
}
