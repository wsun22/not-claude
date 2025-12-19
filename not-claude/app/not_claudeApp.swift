//
//  not_claudeApp.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import SwiftUI

@main
struct not_claudeApp: App {
    @StateObject private var supabase = SupabaseManager.shared
    
    var body: some Scene {
        WindowGroup {
            if supabase.isCheckingAuth {
                SplashView() // show splash screen
            } else if supabase.currentUser != nil {
                ContentView() // user is signed in
            } else {
                AuthView() // not signed in
            }
        }
        .environmentObject(supabase)
    }
}
