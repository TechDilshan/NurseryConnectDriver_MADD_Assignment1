import SwiftUI

struct LiveMapView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var transportViewModel: TransportViewModel

    @State private var showFullScreenMap = false
    @State private var showDistanceSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ZStack(alignment: .topTrailing) {
                        DriverMapView()

                        Button {
                            showFullScreenMap = true
                        } label: {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .padding(12)
                    }

                    RouteInfoCardView(
                        title: locationViewModel.tripStatusText,
                        subtitle: locationViewModel.estimatedArrivalText,
                        systemImage: "location.circle.fill",
                        extraInfo: "Total route distance: \(locationViewModel.totalRouteDistanceText)"
                    )

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Map Background")
                            .font(.headline)

                        Picker("Map Style", selection: $locationViewModel.selectedMapStyle) {
                            ForEach(MapStyleOption.allCases, id: \.self) { style in
                                Text(style.title).tag(style)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

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

                    HStack(spacing: 12) {
                        Button {
                            locationViewModel.resetSimulation()
                        } label: {
                            PrimaryButton(title: "Reset Route", systemImage: "arrow.clockwise")
                        }

                        Button {
                            locationViewModel.centerOnDriver()
                        } label: {
                            PrimaryButton(title: "Center Driver", systemImage: "location.fill")
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Route Stops")
                            .font(.headline)

                        ForEach(Array(locationViewModel.routeStops.enumerated()), id: \.element.id) { index, stop in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(stop.title)
                                    .font(.subheadline.weight(.semibold))

                                Text(stop.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                Text("Distance from vehicle: \(locationViewModel.distanceFromDriver(to: stop))")
                                    .font(.caption)
                                    .foregroundStyle(.blue)

                                if index < locationViewModel.routeStops.count - 1 {
                                    let nextStop = locationViewModel.routeStops[index + 1]
                                    Text("Next segment: \(locationViewModel.distanceText(from: stop, to: nextStop))")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showDistanceSheet = true
                    } label: {
                        Image(systemName: "ruler.fill")
                    }
                }
            }
            .sheet(isPresented: $showDistanceSheet) {
                NavigationStack {
                    List {
                        Section("Route Distance Summary") {
                            HStack {
                                Text("Total Route")
                                Spacer()
                                Text(locationViewModel.totalRouteDistanceText)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Section("Stop to Stop Distance") {
                            ForEach(Array(locationViewModel.stopDistanceRows().enumerated()), id: \.offset) { _, row in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(row.from) → \(row.to)")
                                        .font(.subheadline.weight(.semibold))
                                    Text(row.distance)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .navigationTitle("Distances")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                showDistanceSheet = false
                            }
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showFullScreenMap) {
                FullScreenMapView(showFullScreenMap: $showFullScreenMap)
                    .environmentObject(locationViewModel)
                    .environmentObject(transportViewModel)
            }
        }
    }
}

private struct FullScreenMapView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var transportViewModel: TransportViewModel
    @Binding var showFullScreenMap: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            DriverMapView(isFullScreen: true)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Button {
                        locationViewModel.centerOnDriver()
                    } label: {
                        Image(systemName: "location.fill")
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(Color.blue.opacity(0.85))
                            .clipShape(Circle())
                    }

                    Button {
                        showFullScreenMap = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 16)
                .padding(.trailing, 16)

                Spacer()
            }

            VStack {
                Spacer()

                VStack(spacing: 12) {
                    RouteInfoCardView(
                        title: locationViewModel.tripStatusText,
                        subtitle: locationViewModel.estimatedArrivalText,
                        systemImage: "location.fill",
                        extraInfo: "Total route: \(locationViewModel.totalRouteDistanceText)"
                    )

                    HStack(spacing: 12) {
                        Button {
                            locationViewModel.startSimulation()
                            transportViewModel.startTripIfNeeded()
                        } label: {
                            PrimaryButton(title: "Start", systemImage: "play.fill")
                        }

                        Button {
                            locationViewModel.stopSimulation()
                        } label: {
                            PrimaryButton(title: "Stop", systemImage: "pause.fill")
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    LiveMapView()
        .environmentObject(LocationViewModel())
        .environmentObject(TransportViewModel())
}
