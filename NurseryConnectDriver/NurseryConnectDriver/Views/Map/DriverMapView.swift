import SwiftUI
import MapKit

struct DriverMapView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel

    var body: some View {
        Map(position: .constant(.region(locationViewModel.currentRegion))) {
            Annotation("Driver", coordinate: locationViewModel.currentLocation.coordinate) {
                VStack(spacing: 4) {
                    Image(systemName: "car.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(Color.blue)
                        .clipShape(Circle())

                    Text("Driver")
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
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
        .frame(height: 320)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue.opacity(0.15), lineWidth: 1)
        )
    }
}

#Preview {
    DriverMapView()
        .environmentObject(LocationViewModel())
}
