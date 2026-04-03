import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var transportViewModel: TransportViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State private var showResetConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                Section("App Information") {
                    LabeledContent("Role", value: "Driver")
                    LabeledContent("App", value: "NurseryConnect Driver")
                    LabeledContent("Vehicle", value: transportViewModel.trip.vehicleNumber)
                }

                Section("Trip Actions") {
                    Button("Reset Trip Data", role: .destructive) {
                        showResetConfirmation = true
                    }

                    Button("Reset Map Simulation") {
                        locationViewModel.resetSimulation()
                    }
                }

                Section("Summary") {
                    LabeledContent("Pending", value: "\(transportViewModel.pendingCount)")
                    LabeledContent("Picked Up", value: "\(transportViewModel.pickedUpCount)")
                    LabeledContent("Dropped Off", value: "\(transportViewModel.droppedOffCount)")
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog(
                "Are you sure you want to reset trip data?",
                isPresented: $showResetConfirmation
            ) {
                Button("Reset", role: .destructive) {
                    transportViewModel.resetTrip()
                    locationViewModel.resetSimulation()
                }

                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(TransportViewModel())
        .environmentObject(LocationViewModel())
}
