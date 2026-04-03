import SwiftUI

struct TripStatusBannerView: View {
    let title: String
    let subtitle: String
    let isCompleted: Bool
    let isActive: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(badgeColor)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(badgeColor.opacity(0.25), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var badgeColor: Color {
        if isCompleted {
            return .green
        } else if isActive {
            return .blue
        } else {
            return .orange
        }
    }

    private var iconName: String {
        if isCompleted {
            return "checkmark.seal.fill"
        } else if isActive {
            return "car.fill"
        } else {
            return "clock.fill"
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        TripStatusBannerView(
            title: "Trip Not Started",
            subtitle: "Start by marking the first child as picked up.",
            isCompleted: false,
            isActive: false
        )

        TripStatusBannerView(
            title: "Trip In Progress",
            subtitle: "2 child(ren) currently on board.",
            isCompleted: false,
            isActive: true
        )

        TripStatusBannerView(
            title: "Trip Completed",
            subtitle: "All children have been safely dropped off.",
            isCompleted: true,
            isActive: false
        )
    }
    .padding()
}
