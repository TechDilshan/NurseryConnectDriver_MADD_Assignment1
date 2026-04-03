import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.grid.2x2.fill")
                }

            TransportListView()
                .tabItem {
                    Label("Transport", systemImage: "person.3.fill")
                }

            LiveMapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.blue)
    }
}

#Preview {
    MainTabView()
        .environmentObject(TransportViewModel())
        .environmentObject(LocationViewModel())
        .environmentObject(AuthViewModel())
}
