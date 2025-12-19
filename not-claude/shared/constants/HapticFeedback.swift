//
//  HapticFeedback.swift
//  not-claude
//
//  Created by William Sun on 11/5/25.
//

import SwiftUI

// MARK: - Haptic Feedback Utilities

/// A utility module for providing haptic feedback throughout the application.
///
/// This module provides a simple, unified interface for triggering haptic feedback
/// across the app. Haptic feedback enhances user experience by providing tactile
/// responses to user interactions.
///
/// ## Overview
/// The module uses `UIImpactFeedbackGenerator` to create physical feedback that
/// corresponds to different types of user interactions. This helps create a more
/// immersive and responsive user experience.
///
/// ## Usage Example
/// ```swift
/// // Light haptic for subtle interactions (e.g., button taps)
/// haptic(.light)
///
/// // Medium haptic for standard interactions (e.g., selection changes)
/// haptic(.medium)
///
/// // Heavy haptic for significant actions (e.g., confirmations, deletions)
/// haptic(.heavy)
///
/// // Rigid haptic for precise feedback (e.g., picker stops)
/// haptic(.rigid)
///
/// // Soft haptic for gentle feedback (e.g., subtle UI changes)
/// haptic(.soft)
/// ```
///
/// ## Performance Considerations
/// - Each call creates a new generator instance, which is appropriate for
///   infrequent haptic feedback
/// - For frequent or continuous haptics, consider creating a persistent
///   generator and calling `prepare()` before triggering feedback
/// - Haptic feedback uses system resources; use judiciously to avoid
///   degrading user experience
///
/// ## Platform Availability
/// - Haptic feedback is available on iPhone 7 and later
/// - On unsupported devices, haptic calls are safely ignored
/// - iPad models do not support impact haptic feedback
///
/// - Note: This module is thread-safe and can be called from any thread

// MARK: - Public API

/// Triggers haptic feedback with the specified intensity style.
///
/// This function provides a convenient way to trigger haptic feedback throughout
/// the application. It creates an impact generator with the specified style and
/// immediately triggers the haptic feedback.
///
/// ## When to Use Different Styles
/// - `.light`: Subtle interactions like hovering, scrolling, or minor UI changes
/// - `.medium`: Standard interactions like button taps, toggles, or selections
/// - `.heavy`: Significant actions like confirmations, deletions, or errors
/// - `.rigid`: Precise feedback for pickers, sliders at stops, or alignment
/// - `.soft`: Gentle feedback for smooth transitions or subtle notifications
///
/// ## Example
/// ```swift
/// Button("Delete") {
///     haptic(.heavy)  // Provide strong feedback for destructive action
///     deleteItem()
/// }
///
/// Toggle("Notifications", isOn: $notificationsEnabled)
///     .onChange(of: notificationsEnabled) { _ in
///         haptic(.medium)  // Standard feedback for toggle change
///     }
/// ```
///
/// - Parameter style: The intensity style of the haptic feedback. Defaults to `.light`
///                    for subtle, non-intrusive feedback.
///
/// - Important: Use haptics sparingly to maintain their effectiveness. Overuse
///              can diminish user experience and drain battery.
///
/// - Note: This function executes synchronously but completes nearly instantly.
///         No need to dispatch to background threads.
///
/// - SeeAlso: `UIImpactFeedbackGenerator.FeedbackStyle` for all available styles
func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
}
