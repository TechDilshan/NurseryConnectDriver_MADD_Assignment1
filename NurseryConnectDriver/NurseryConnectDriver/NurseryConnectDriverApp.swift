//
//  NurseryConnectDriverApp.swift
//  NurseryConnectDriver
//
//  Created by chamika dilshan on 2026-04-01.
//

import SwiftUI

@main
struct NurseryConnectDriverApp: App {
    @StateObject private var transportViewModel = TransportViewModel()
    @StateObject private var locationViewModel = LocationViewModel()
    @StateObject private var themeViewModel = ThemeViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transportViewModel)
                .environmentObject(locationViewModel)
                .environmentObject(themeViewModel)
                .preferredColorScheme(themeViewModel.colorScheme)
        }
    }
}
