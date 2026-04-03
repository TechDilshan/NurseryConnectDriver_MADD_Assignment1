import SwiftUI

struct RouteInfoCardView: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(Color.blue.opacity(0.12))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    RouteInfoCardView(
        title: "Current stop: Little Stars Preschool",
        subtitle: "2 stop(s) remaining",
        systemImage: "location.fill"
    )
}
