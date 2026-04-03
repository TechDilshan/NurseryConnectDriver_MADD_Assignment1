import SwiftUI

@MainActor
final class ThemeViewModel: ObservableObject {
    @Published var selectedTheme: AppTheme

    private let themeService: ThemeServiceProtocol

    init(themeService: ThemeServiceProtocol = ThemeService()) {
        self.themeService = themeService
        self.selectedTheme = themeService.loadTheme()
    }

    func updateTheme(_ theme: AppTheme) {
        selectedTheme = theme
        themeService.saveTheme(theme)
    }

    var colorScheme: ColorScheme? {
        switch selectedTheme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
