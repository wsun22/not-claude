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
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    @EnvironmentObject var supabaseManager: SupabaseManager
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            VStack {
                Button(action: handleSignInWithApple) {
                    HStack {
                        Image(systemName: "applelogo")
                            .offset(y: -2)
                        
                        Text("Continue with Apple")
                            .font(.styreneB(fontWeight: .medium))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.white)
                    .cornerRadius(20)
                }
            }
            .padding(16)
        }
    }
    
    private func handleSignInWithApple() {
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
