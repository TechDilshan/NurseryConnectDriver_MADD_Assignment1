import SwiftUI

struct ChildDetailView: View {
    @EnvironmentObject var transportViewModel: TransportViewModel
    let childID: String

    var child: Child? {
        transportViewModel.child(withID: childID)
    }

    var body: some View {
        Group {
            if let child {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(spacing: 12) {
                            Circle()
                                .fill(Color.blue.opacity(0.15))
                                .frame(width: 88, height: 88)
                                .overlay {
                                    Text(child.initials)
                                        .font(.title2.bold())
                                        .foregroundStyle(.blue)
                                }

                            Text(child.name)
                                .font(.title2.bold())

                            StatusBadgeView(status: child.status)
                        }
                        .frame(maxWidth: .infinity)

                        Text("Transport Information")
                            .font(.headline)

                        detailCard(title: "School", value: child.schoolName)
                        detailCard(title: "Pickup Point", value: child.pickupLocation)
                        detailCard(title: "Dropoff Point", value: child.dropoffLocation)
                        detailCard(title: "Pickup Time", value: DateFormatterHelper.displayTimeOnly(child.pickupTime))
                        detailCard(title: "Dropoff Time", value: DateFormatterHelper.displayTimeOnly(child.dropoffTime))

                        Text("Emergency Contact")
                            .font(.headline)

                        detailCard(title: "Guardian Name", value: child.guardianName)
                        detailCard(title: "Guardian Contact", value: child.guardianContact)

                        VStack(spacing: 14) {
                            Button {
                                transportViewModel.markPickedUp(child: child)
                            } label: {
                                PrimaryButton(title: "Mark as On Board", systemImage: "arrow.up.circle.fill")
                            }
                            .disabled(child.status != .pending)

                            Button {
                                transportViewModel.markDroppedOff(child: child)
                            } label: {
                                PrimaryButton(title: "Mark as Dropped Off", systemImage: "arrow.down.circle.fill")
                            }
                            .disabled(child.status != .pickedUp)
                        }
                    }
                    .padding()
                }
                .background(Color.appGroupedBackground)
                .navigationTitle("Child Details")
                .navigationBarTitleDisplayMode(.inline)
                .alert(
                    "Success",
                    isPresented: Binding(
                        get: { transportViewModel.successMessage != nil },
                        set: { if !$0 { transportViewModel.successMessage = nil } }
                    )
                ) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(transportViewModel.successMessage ?? "")
                }
                .alert(
                    "Notice",
                    isPresented: Binding(
                        get: { transportViewModel.errorMessage != nil },
                        set: { if !$0 { transportViewModel.errorMessage = nil } }
                    )
                ) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(transportViewModel.errorMessage ?? "")
                }
            } else {
                EmptyStateView(
                    title: "Child Not Found",
                    message: "The selected child record could not be found.",
                    systemImage: "exclamationmark.triangle.fill"
                )
            }
        }
    }

    private func detailCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(value)
                .font(.body)
                .foregroundStyle(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    NavigationStack {
        ChildDetailView(childID: "1")
            .environmentObject(TransportViewModel())
    }
}
