//
//  ZhiHuSwiftUIApp.swift
//  ZhiHuSwiftUI
//
//  Created by xc z on 2025/3/16.
//

import SwiftUI

@main
struct ZhiHuSwiftUIApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
