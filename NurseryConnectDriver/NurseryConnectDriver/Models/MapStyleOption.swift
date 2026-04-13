import Foundation

enum MapStyleOption: String, CaseIterable, Codable {
    case standard
    case hybrid
    case imagery

    var title: String {
        switch self {
        case .standard:
            return "Standard"
        case .hybrid:
            return "Hybrid"
        case .imagery:
            return "Satellite"
        }
    }
}
