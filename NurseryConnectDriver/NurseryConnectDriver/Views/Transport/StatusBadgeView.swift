import SwiftUI

struct StatusBadgeView: View {
    let status: TransportStatus

    var body: some View {
        Text(status.title)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundStyle(textColor)
            .background(backgroundColor)
            .clipShape(Capsule())
    }

    private var backgroundColor: Color {
        switch status {
        case .pending:
            return .orange.opacity(0.18)
        case .pickedUp:
            return .blue.opacity(0.18)
        case .droppedOff:
            return .green.opacity(0.18)
        }
    }

    private var textColor: Color {
        switch status {
        case .pending:
            return .orange
        case .pickedUp:
            return .blue
        case .droppedOff:
            return .green
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        StatusBadgeView(status: .pending)
        StatusBadgeView(status: .pickedUp)
        StatusBadgeView(status: .droppedOff)
    }
}
