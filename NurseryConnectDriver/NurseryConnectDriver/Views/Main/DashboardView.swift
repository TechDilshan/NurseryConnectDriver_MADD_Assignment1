import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var transportViewModel: TransportViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SectionHeaderView(title: "Driver Summary", subtitle: "Today's transport overview")

                    InfoCardView(
                        title: "Driver",
                        value: transportViewModel.trip.driverName,
                        systemImage: "person.crop.circle.fill"
                    )

                    HStack(spacing: 12) {
                        InfoCardView(
                            title: "Pending",
                            value: "\(transportViewModel.pendingCount)",
                            systemImage: "clock.fill"
                        )

                        InfoCardView(
                            title: "On Board",
                            value: "\(transportViewModel.onboardCount)",
                            systemImage: "bus.fill"
                        )
                    }

                    HStack(spacing: 12) {
                        InfoCardView(
                            title: "Dropped Off",
                            value: "\(transportViewModel.droppedOffCount)",
                            systemImage: "checkmark.circle.fill"
                        )

                        InfoCardView(
                            title: "Vehicle",
                            value: transportViewModel.trip.vehicleNumber,
                            systemImage: "car.fill"
                        )
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Trip Progress")
                            .font(.headline)

                        ProgressView(value: transportViewModel.completionProgress)
                            .progressViewStyle(.linear)

                        Text("\(Int(transportViewModel.completionProgress * 100))% completed")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Live Transport Status")
                            .font(.headline)

                        RouteInfoCardView(
                            title: locationViewModel.tripStatusText,
                            subtitle: locationViewModel.estimatedArrivalText,
                            systemImage: "location.fill"
                        )
                    }

                    VStack(spacing: 12) {
                        NavigationLink {
                            TransportListView()
                        } label: {
                            PrimaryButton(title: "Open Transport List", systemImage: "list.bullet")
                        }

                        NavigationLink {
                            LiveMapView()
                        } label: {
                            PrimaryButton(title: "Open Live Map", systemImage: "map.fill")
                        }
                    }
                }
                .padding()
            }
            .background(Color.appGroupedBackground)
            .navigationTitle("Dashboard")
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
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(TransportViewModel())
        .environmentObject(LocationViewModel())
}
