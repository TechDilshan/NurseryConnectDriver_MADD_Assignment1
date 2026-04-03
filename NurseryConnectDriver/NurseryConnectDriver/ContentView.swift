//
//  ContentView.swift
//  NurseryConnectDriver
//
//  Created by chamika dilshan on 2026-04-01.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash {
                SplashView()
            } else if authViewModel.isLoggedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TransportViewModel())
        .environmentObject(LocationViewModel())
        .environmentObject(AuthViewModel())
}
