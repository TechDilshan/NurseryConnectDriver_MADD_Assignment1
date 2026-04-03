import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var transportViewModel: TransportViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var showResetConfirmation = false
    @State private var showLogoutConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    LabeledContent("Logged User", value: authViewModel.currentUser?.fullName ?? "Not available")
                    LabeledContent("Role", value: authViewModel.currentUser?.role ?? "Driver")
                    LabeledContent("Vehicle", value: authViewModel.currentUser?.vehicleNumber ?? transportViewModel.trip.vehicleNumber)
                }

                Section("Trip Actions") {
                    Button("Reset Trip Data", role: .destructive) {
                        showResetConfirmation = true
                    }

                    Button("Reset Map Simulation") {
                        locationViewModel.resetSimulation()
                    }
                }

                Section("Session") {
                    Button("Logout", role: .destructive) {
                        showLogoutConfirmation = true
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
            .confirmationDialog(
                "Are you sure you want to logout?",
                isPresented: $showLogoutConfirmation
            ) {
                Button("Logout", role: .destructive) {
                    authViewModel.logout()
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
        .environmentObject(AuthViewModel())
}
