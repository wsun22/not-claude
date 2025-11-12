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
            if supabaseManager.currentUser != nil {
                ContentView()
            } else {
                AuthView()
            }
        }
        .environmentObject(supabaseManager)
    }
}
