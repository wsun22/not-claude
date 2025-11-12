//
//  not_claudeApp.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import SwiftUI

@main
struct not_claudeApp: App {
    @StateObject private var supabaseManager = SupabaseManager.shared
    
    var body: some Scene {
        WindowGroup {
            if supabaseManager.isCheckingAuth {
                ContentView() // show splash screen
            } else if supabaseManager.currentUser != nil {
                ContentView() // user is signed in
            } else {
                AuthView() // not signed in
            }
        }
        .environmentObject(supabaseManager)
    }
}
