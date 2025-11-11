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
    @State private var nonce: String?
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            ZStack {
                SignInWithAppleButton { request in
                    let nonce = randomNonceString()
                    self.nonce = nonce
                    
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = sha256(nonce)
                } onCompletion: { result in
                    isLoading = true
                    defer { isLoading = false }
                    
                    do {
                        
                    } catch {
                        
                    }
                }
                .opacity(0.001)
                
                HStack {
                    Image(systemName: "applelogo")
                        .offset(y: -2)

                    Text("Continue with Apple")
                        .font(.styreneB(fontWeight: .medium))
                }
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .allowsHitTesting(false)
            }
            .frame(height: 55)
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0, "length cannot be less than or equal to 0") // ensure length > 0, else crash
        var randomBytes: [UInt8] = Array(repeating: 0, count: length) // create an array of type UInt8, fill with 0s
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes) // write N random bytes into the array randomBytes
        if errorCode != errSecSuccess { // ensure above line worked
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in // for every byte in randomBytes, do this many-to-one relationship mapping
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
    }
}

#Preview {
    AuthView()
}
