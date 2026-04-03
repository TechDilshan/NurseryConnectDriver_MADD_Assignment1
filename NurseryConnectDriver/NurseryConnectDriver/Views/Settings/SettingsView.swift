import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var transportViewModel: TransportViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var themeViewModel: ThemeViewModel

    @State private var showResetConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $themeViewModel.selectedTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                    .onChange(of: themeViewModel.selectedTheme) {
                        themeViewModel.updateTheme(themeViewModel.selectedTheme)
                    }
                }

                Section("Trip Actions") {
                    Button("Reset Trip Data", role: .destructive) {
                        showResetConfirmation = true
                    }

                    Button("Reset Route Simulation") {
                        locationViewModel.resetSimulation()
                    }
                }

                Section("Summary") {
                    LabeledContent("Pending", value: "\(transportViewModel.pendingCount)")
                    LabeledContent("On Board", value: "\(transportViewModel.pickedUpCount)")
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
        .environmentObject(ThemeViewModel())
}
