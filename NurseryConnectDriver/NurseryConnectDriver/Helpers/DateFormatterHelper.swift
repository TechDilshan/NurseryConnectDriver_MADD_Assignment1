import Foundation

enum DateFormatterHelper {
    static func displayDateTime(_ date: Date?) -> String {
        guard let date else { return "Not available" }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    static func displayTimeOnly(_ date: Date?) -> String {
        guard let date else { return "Not available" }

        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
}
