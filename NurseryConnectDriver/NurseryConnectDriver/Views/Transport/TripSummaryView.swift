import SwiftUI

struct TripSummaryView: View {
    @EnvironmentObject var transportViewModel: TransportViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    InfoCardView(
                        title: "Total Children",
                        value: "\(transportViewModel.trip.totalCount)",
                        systemImage: "person.3.fill"
                    )

                    InfoCardView(
                        title: "Pending",
                        value: "\(transportViewModel.pendingCount)",
                        systemImage: "clock.fill"
                    )

                    InfoCardView(
                        title: "Picked Up",
                        value: "\(transportViewModel.pickedUpCount)",
                        systemImage: "bus.fill"
                    )

                    InfoCardView(
                        title: "Dropped Off",
                        value: "\(transportViewModel.droppedOffCount)",
                        systemImage: "checkmark.circle.fill"
                    )

                    InfoCardView(
                        title: "Trip Start",
                        value: DateFormatterHelper.displayDateTime(transportViewModel.trip.startTime),
                        systemImage: "play.fill"
                    )

                    InfoCardView(
                        title: "Trip End",
                        value: DateFormatterHelper.displayDateTime(transportViewModel.trip.endTime),
                        systemImage: "stop.fill"
                    )
                }
                .padding()
            }
            .background(Color.appGroupedBackground)
            .navigationTitle("Trip Summary")
        }
    }
}

#Preview {
    TripSummaryView()
        .environmentObject(TransportViewModel())
}
