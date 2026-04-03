import Foundation

protocol ThemeServiceProtocol {
    func saveTheme(_ theme: AppTheme)
    func loadTheme() -> AppTheme
}

final class ThemeService: ThemeServiceProtocol {
    private let key = "app_selected_theme"

    func saveTheme(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: key)
    }

    func loadTheme() -> AppTheme {
        guard let value = UserDefaults.standard.string(forKey: key),
              let theme = AppTheme(rawValue: value) else {
            return .system
        }
        return theme
    }
}
