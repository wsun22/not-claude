//
//  AppleSignInManager.swift
//  not-claude
//
//  Created by William Sun on 11/12/25.
//

import Combine
import Foundation
import AuthenticationServices

/// Manages Sign in with Apple authentication flow. Created for full control over SignInWithApple button styling.
/// This singleton handles the Apple ID authorization process and delegates the result to SupabaseManager.
/// Docs: https://developer.apple.com/documentation/AuthenticationServices/implementing-user-authentication-with-sign-in-with-apple
final class AppleSignInManager: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  
    // MARK: - Singleton

    static let shared = AppleSignInManager()
    
    // MARK: - Published Properties

    /// Indicates whether an Apple sign-in request is currently in progress.
    @Published var isLoading: Bool = false
    
    // MARK: - Properties
    
    /// The cryptographic nonce used for the current sign-in request.
    /// Must be set before initiating the authorization flow.
    var nonce: String?
    
    // MARK: - Initialization
    
    /// Private initializer to enforce singleton pattern.
    override private init() {}
    
    // MARK: - ASAuthorizationControllerDelegate
    
    /// Called when Apple Sign In authorization completes successfully.
    /// - Parameters:
    ///   - controller: The authorization controller managing the request.
    ///   - authorization: The authorization result containing user credentials.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        defer { isLoading = false }
        
        print("Authorization succeeded")
        
        // Extract the Apple ID credential from the authorization
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8),
              let nonce = self.nonce else {
            print("Unable to get credentials")
            return
        }
        
        print("Token: \(tokenString)")
        print("Nonce: \(nonce)")
        
        // Pass credentials to Supabase for authentication
        Task {
            await SupabaseManager.shared.handleAppleSignIn(idToken: tokenString,
                                                           nonce: nonce,
                                                           credential: credential)
        }
    }
    
    /// Called when Apple Sign In authorization fails or is cancelled.
    /// - Parameters:
    ///   - controller: The authorization controller managing the request.
    ///   - error: The error that occurred during authorization.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        defer { isLoading = false }
        
        print("Authorization failed: \(error.localizedDescription)")
        
        // TODO: Handle specific error cases:
        // - .canceled: User dismissed the sign-in sheet
        // - .unknown: Network or system error
        // - .notHandled: Authorization request not handled
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    /// Provides the window in which to present the Apple Sign In authorization UI.
    /// - Parameter controller: The authorization controller requesting the presentation anchor.
    /// - Returns: The window to present the authorization UI in.
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window available")
        }
        return window
    }
}
