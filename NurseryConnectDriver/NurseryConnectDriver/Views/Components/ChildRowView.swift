import SwiftUI

struct ChildRowView: View {
    let child: Child

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.blue.opacity(0.15))
                .frame(width: 50, height: 50)
                .overlay {
                    Text(child.initials)
                        .font(.subheadline.bold())
                        .foregroundStyle(.blue)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(child.name)
                    .font(.headline)

                Text(child.schoolName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("Pickup: \(child.pickupLocation)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            StatusBadgeView(status: child.status)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ChildRowView(
        child: Child(
            id: "1",
            name: "Emma Johnson",
            age: 4,
            schoolName: "Little Stars Preschool",
            pickupLocation: "School Gate A",
            dropoffLocation: "Nursery",
            guardianName: "Sarah Johnson",
            guardianContact: "0771234567",
            status: .pending
        )
    )
}
