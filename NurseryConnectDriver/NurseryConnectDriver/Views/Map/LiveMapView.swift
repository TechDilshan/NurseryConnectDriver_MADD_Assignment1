import SwiftUI

struct LiveMapView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var transportViewModel: TransportViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    DriverMapView()

                    RouteInfoCardView(
                        title: locationViewModel.tripStatusText,
                        subtitle: locationViewModel.estimatedArrivalText,
                        systemImage: "location.circle.fill"
                    )

                    HStack(spacing: 12) {
                        Button {
                            locationViewModel.startSimulation()
                            transportViewModel.startTripIfNeeded()
                        } label: {
                            PrimaryButton(title: "Start Route", systemImage: "play.fill")
                        }

                        Button {
                            locationViewModel.stopSimulation()
                        } label: {
                            PrimaryButton(title: "Stop Route", systemImage: "pause.fill")
                        }
                    }

                    Button {
                        locationViewModel.resetSimulation()
                    } label: {
                        PrimaryButton(title: "Reset Route Simulation", systemImage: "arrow.clockwise")
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Route Stops")
                            .font(.headline)

                        ForEach(locationViewModel.routeStops) { stop in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(stop.title)
                                    .font(.subheadline.weight(.semibold))

                                Text(stop.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
                .padding()
            }
            .background(Color.appGroupedBackground)
            .navigationTitle("Live Route")
        }
    }
}

#Preview {
    LiveMapView()
        .environmentObject(LocationViewModel())
        .environmentObject(TransportViewModel())
}
