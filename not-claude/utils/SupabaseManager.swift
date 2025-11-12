//
//  SupabaseManager.swift
//  not-claude
//
//  Created by William Sun on 11/8/25.
//

import Foundation
import Supabase
import Combine

final class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    private let client: SupabaseClient
    
    private init() {
        client = SupabaseClient(supabaseURL: URL(string: "https://ipamulxprbpujyspawun.supabase.co")!,
                                                 supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlwYW11bHhwcmJwdWp5c3Bhd3VuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1OTY0NTgsImV4cCI6MjA3ODE3MjQ1OH0.sXi-dwt3H-SpquLQQcg3GSCZYWEQTfkddZs835jeHGE")
    }
    
    func handleAppleSignIn(idToken: String, nonce: String) async {
        do {
            try await client.auth.signInWithIdToken(
                credentials: .init(
                    provider: .apple,
                    idToken: idToken,
                    nonce: nonce
                )
            )
            print("[SupabaseManager] sign in succesful")
        } catch {
            print("[SupabaseManager] Sign in failed: \(error)")
        }
    }
}
