//
//  AppleSignInManager.swift
//  not-claude
//
//  Created by William Sun on 11/12/25.
//

import Combine
import Foundation
import AuthenticationServices

final class AppleSignInManager: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    static let shared = AppleSignInManager()
    
    @Published var isLoading: Bool = false
    var nonce: String?
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        defer { isLoading = false }
        print("Authorization succeeded")
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8),
              let nonce = self.nonce else {
            print("Unable to get credentials")
            return
        }
        
        print("Token: \(tokenString)")
        print("Nonce: \(nonce)")
        
        Task {
            await SupabaseManager.shared.handleAppleSignIn(idToken: tokenString,
                                                           nonce: nonce,
                                                           credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        defer { isLoading = false }
        print("Authorization failed: \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window available")
        }
        return window
    }
}
