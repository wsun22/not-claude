//
//  SupabaseManager.swift
//  not-claude
//
//  Created by William Sun on 11/8/25.
//

import Foundation
import Supabase
import Combine
import AuthenticationServices

final class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    private let client: SupabaseClient = SupabaseClient(supabaseURL: URL(string: "https://ipamulxprbpujyspawun.supabase.co")!,
                                                        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlwYW11bHhwcmJwdWp5c3Bhd3VuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1OTY0NTgsImV4cCI6MjA3ODE3MjQ1OH0.sXi-dwt3H-SpquLQQcg3GSCZYWEQTfkddZs835jeHGE",
                                                        options: SupabaseClientOptions(
                                                            auth: SupabaseClientOptions.AuthOptions(emitLocalSessionAsInitialSession: true)
                                                        )
    )
    
    @Published var currentUser: User?
    @Published var isCheckingAuth: Bool = true
    
    private init() {
        observeAuthStateChanges()
    }
    
    private func observeAuthStateChanges() {
        Task {
            for await state in client.auth.authStateChanges {
                await MainActor.run {
                    if let session = state.session, !session.isExpired {
                        currentUser = session.user
                    } else {
                        currentUser = nil
                    }
                    isCheckingAuth = false
                }
            }
        }
    }
    
    func handleAppleSignIn(idToken: String,
                           nonce: String,
                           credential: ASAuthorizationAppleIDCredential) async {
        do {
            try await client.auth.signInWithIdToken(
                credentials: .init(
                    provider: .apple,
                    idToken: idToken,
                    nonce: nonce
                )
            )
            
            if let fullName = credential.fullName {
                var nameParts: [String] = []
                if let givenName = fullName.givenName {
                    nameParts.append(givenName)
                }
                if let middleName = fullName.middleName {
                    nameParts.append(middleName)
                }
                if let familyName = fullName.familyName {
                    nameParts.append(familyName)
                }
                
                let fullNameString: String = nameParts.joined(separator: " ")
                
                try await client.auth.update(
                    user: UserAttributes(
                        data: ["full_name": .string(fullNameString),
                               "given_name": .string(fullName.givenName ?? ""),
                               "family_name": .string(fullName.familyName ?? "")
                              ]
                    )
                )
            }
            print("[SupabaseManager] sign in succesful")
        } catch {
            print("[SupabaseManager] Sign in failed: \(error)")
        }
    }
    
    func signOut() async throws{
        try await client.auth.signOut()
    }
    
    func fetchChats(n: Int) async throws -> [Chat] {
        return try await client
            .from("chats")
            .select()
            .eq("user_id", value: currentUser?.id)
            .order("last_updated", ascending: false)
            .limit(n)
            .execute()
            .value
    }
    
    func sendMessage(chatId: UUID, content: String, isNewChat: Bool) async throws {
        let url = URL(string: "https://ipamulxprbpujyspawun.supabase.co/functions/v1/stream-response")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "chatId": chatId.uuidString,
            "content": content,
            "isNewChat": isNewChat
        ] as [String : Any]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
    }
}
