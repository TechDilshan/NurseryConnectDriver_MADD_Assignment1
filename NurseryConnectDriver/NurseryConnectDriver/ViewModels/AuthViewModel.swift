import Foundation
import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentUser: DriverUser?

    private let authService: AuthServiceProtocol
    private let sessionStorageService: SessionStorageServiceProtocol

    init(
        authService: AuthServiceProtocol = AuthService(),
        sessionStorageService: SessionStorageServiceProtocol = SessionStorageService()
    ) {
        self.authService = authService
        self.sessionStorageService = sessionStorageService
        restoreSession()
    }

    func restoreSession() {
        let loggedIn = sessionStorageService.loadLoggedInState()
        let savedUser = sessionStorageService.loadUser()

        if loggedIn, let savedUser {
            self.currentUser = savedUser
            self.isLoggedIn = true
        } else {
            self.currentUser = nil
            self.isLoggedIn = false
        }
    }

    func login() {
        isLoading = true
        errorMessage = nil

        do {
            let user = try authService.login(username: username, password: password)
            currentUser = user
            isLoggedIn = true
            sessionStorageService.saveUser(user)
            sessionStorageService.saveLoggedInState(true)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    func logout() {
        username = ""
        password = ""
        currentUser = nil
        isLoggedIn = false
        errorMessage = nil
        sessionStorageService.clearUser()
        sessionStorageService.saveLoggedInState(false)
    }
}
