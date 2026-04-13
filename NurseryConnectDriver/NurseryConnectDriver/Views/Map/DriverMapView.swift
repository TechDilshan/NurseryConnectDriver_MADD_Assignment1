import SwiftUI
import MapKit

struct DriverMapView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    var isFullScreen: Bool = false

    @State private var showPassengers = false

    var body: some View {
        Map(position: .constant(.region(locationViewModel.currentRegion))) {
            Annotation("Vehicle", coordinate: locationViewModel.currentLocation.coordinate) {
                Button {
                    showPassengers = true
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "car.side.fill")
                            .font(.system(size: isFullScreen ? 28 : 22))
                            .foregroundStyle(.black)
                            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)

                        Text("Vehicle")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.thinMaterial)
                            .clipShape(Capsule())
                    }
                }
                .buttonStyle(.plain)
            }

            ForEach(locationViewModel.routeStops) { stop in
                Annotation(stop.title, coordinate: stop.coordinate) {
                    VStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.red)

                        Text(stop.title)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .mapStyle(mapStyle)
        .frame(height: isFullScreen ? nil : 320)
        .clipShape(RoundedRectangle(cornerRadius: isFullScreen ? 0 : 20))
        .overlay(
            Group {
                if !isFullScreen {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue.opacity(0.15), lineWidth: 1)
                }
            }
        )
        .sheet(isPresented: $showPassengers) {
            PassengerListView(passengers: locationViewModel.currentLocation.passengers)
        }
    }

    private var mapStyle: MapStyle {
        switch locationViewModel.selectedMapStyle {
        case .standard:
            return .standard
        case .hybrid:
            return .hybrid
        case .imagery:
            return .imagery
        }
    }
}

#Preview {
    DriverMapView()
        .environmentObject(LocationViewModel())
}
