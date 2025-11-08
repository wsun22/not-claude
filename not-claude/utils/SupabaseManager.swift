//
//  SupabaseManager.swift
//  not-claude
//
//  Created by William Sun on 11/8/25.
//

import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()
    private let client: SupabaseClient = SupabaseClient(supabaseURL: URL(string: "https://ipamulxprbpujyspawun.supabase.co")!,
                                                          supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlwYW11bHhwcmJwdWp5c3Bhd3VuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1OTY0NTgsImV4cCI6MjA3ODE3MjQ1OH0.sXi-dwt3H-SpquLQQcg3GSCZYWEQTfkddZs835jeHGE")
    
    private init() {
        print("[SupabaseManager] init")
    }
    
    
}
