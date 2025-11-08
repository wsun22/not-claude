//
//  AuthView.swift
//  not-claude
//
//  Created by William Sun on 11/8/25.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct AuthView: View {
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            ZStack {
                // Official button (invisible but functional)
                SignInWithAppleButton { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    // Handle result
                }
                .opacity(0.001)  // Nearly invisible but still tappable
                
                // Your custom styled button (visual only)
                HStack {
                    Image(systemName: "applelogo")
                        .offset(y: -2)

                    Text("Continue with Apple")
                        .font(.styreneB(fontWeight: .medium))
                }
                .foregroundColor(.black)
                .padding()
                .background(Color.white)  // Your custom color
                .cornerRadius(20)
                .allowsHitTesting(false)  // Don't capture taps
            }
            .frame(height: 55)
        }
    }
}

#Preview {
    AuthView()
}
