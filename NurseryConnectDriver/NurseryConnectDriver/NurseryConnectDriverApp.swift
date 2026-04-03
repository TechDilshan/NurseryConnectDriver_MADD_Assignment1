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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transportViewModel)
                .environmentObject(locationViewModel)
        }
    }
}
