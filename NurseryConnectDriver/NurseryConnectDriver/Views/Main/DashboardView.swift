import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var transportViewModel: TransportViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SectionHeaderView(
                        title: "Driver Dashboard",
                        subtitle: "Manage child transport and route progress"
                    )

                    TripStatusBannerView(
                        title: transportViewModel.tripStatusTitle,
                        subtitle: transportViewModel.tripStatusSubtitle,
                        isCompleted: transportViewModel.trip.isTripCompleted,
                        isActive: transportViewModel.trip.isTripStarted && !transportViewModel.trip.isTripCompleted
                    )

                    InfoCardView(
                        title: "Vehicle",
                        value: transportViewModel.trip.vehicleNumber,
                        systemImage: "car.fill"
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
                            title: "Total Children",
                            value: "\(transportViewModel.trip.totalCount)",
                            systemImage: "person.3.fill"
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

                    RouteInfoCardView(
                        title: locationViewModel.tripStatusText,
                        subtitle: locationViewModel.estimatedArrivalText,
                        systemImage: "location.fill"
                    )

                    VStack(spacing: 12) {
                        NavigationLink {
                            TransportListView()
                        } label: {
                            PrimaryButton(title: "Open Today's Manifest", systemImage: "list.bullet.rectangle.fill")
                        }

                        NavigationLink {
                            LiveMapView()
                        } label: {
                            PrimaryButton(title: "Open Live Route", systemImage: "map.fill")
                        }

                        NavigationLink {
                            TripSummaryView()
                        } label: {
                            PrimaryButton(title: "View Trip Summary", systemImage: "doc.text.fill")
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
