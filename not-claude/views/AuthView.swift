//
//  AuthView.swift
//  not-claude
//
//  Created by William Sun on 11/8/25.
//

import Foundation
import SwiftUI
import AuthenticationServices
import CryptoKit

struct AuthView: View {
    @StateObject private var signInManager = AppleSignInManager.shared
    @EnvironmentObject var supabaseManager: SupabaseManager
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 16) {
                tienne("notClaude", fontStyle: .title, fontWeight: .bold)
                
                tienne("Do your best work with notClaude", fontStyle: .title2, foregroundStyle: .textSecondary)
                
                SignInButton(text: "Continue with Apple",
                             systemName: "applelogo",
                             action: handleSignInWithApple)
                
                if signInManager.isLoading {
                    Text("loading!!")
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private struct SignInButton: View {
        let text: String
        let systemName: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Image(systemName: systemName)
                        .foregroundStyle(.black)
                        .offset(y: -2)

                    
                    styrene(text,
                            fontStyle: .headline,
                            fontWeight: .medium,
                            foregroundStyle: .black)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.white)
            .cornerRadius(25)
        }
    }
    
    private func handleSignInWithApple() {
        signInManager.isLoading = true
        haptic()
        
        let nonce = randomNonceString()
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        AppleSignInManager.shared.nonce = nonce
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = AppleSignInManager.shared
        controller.presentationContextProvider = AppleSignInManager.shared
        controller.performRequests()
    }
}

#Preview {
    AuthView()
}
