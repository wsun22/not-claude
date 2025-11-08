//
//  Fonts.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import SwiftUI

// MARK: - Font Extensions

extension Font {
    /// Returns a monospaced Fira Code font for code display.
    ///
    /// Fira Code is a monospaced font designed for source code display,
    /// with programming ligatures support. Used primarily for code blocks
    /// and technical content.
    ///
    /// - Returns: A 16pt Fira Code regular font
    ///
    /// - Example:
    /// ```swift
    /// Text("func example() { }")
    ///     .font(.firaCode())
    /// ```
    static func firaCode() -> Font {
        return Font.custom("FiraCode-regular", size: 16)
    }
    
    /// Returns a Tienne font with specified style and weight.
    ///
    /// Tienne is a serif typeface used for AI-generated content and responses.
    /// Available weights: regular and bold.
    ///
    /// - Parameters:
    ///   - fontStyle: The semantic text style that determines font size. Defaults to `.body`
    ///   - fontWeight: The font weight variant. Defaults to `.regular`
    ///
    /// - Returns: A custom Tienne font with the specified parameters
    ///
    /// - Note: Unsupported weights will fall back to regular
    static func tienne(fontStyle: Font.TextStyle = .body, fontWeight: Weight = .regular) -> Font {
        return Font.custom(TienneFont(weight: fontWeight).rawValue, size: fontStyle.size)
    }
    
    /// Returns a Styrene B font with specified style and weight.
    ///
    /// Styrene B is a sans-serif typeface used for user text, chat names,
    /// and interactive UI elements. Available weights: regular, medium, and bold.
    ///
    /// - Parameters:
    ///   - fontStyle: The semantic text style that determines font size. Defaults to `.body`
    ///   - fontWeight: The font weight variant. Defaults to `.regular`
    ///
    /// - Returns: A custom Styrene B font with the specified parameters
    ///
    /// - Note: Unsupported weights will fall back to regular
    static func styreneB(fontStyle: Font.TextStyle = .body, fontWeight: Weight = .regular) -> Font {
        return Font.custom(StyreneBFont(weight: fontWeight).rawValue, size: fontStyle.size)
    }
}

// MARK: - Text Style Size Mapping

extension Font.TextStyle {
    /// Maps semantic text styles to their corresponding point sizes.
    ///
    /// This extension provides a consistent sizing scale across the application,
    /// ensuring that all custom fonts maintain proper visual hierarchy.
    ///
    /// - Returns: The point size for the text style
    var size: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title: return 30
        case .title2: return 22
        case .title3: return 20
        case .headline: return 18
        case .body: return 16
        case .callout: return 15
        case .subheadline: return 14
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default: return 8
        }
    }
}

// MARK: - Private Font Mappings

/// Internal mapping of Font.Weight values to Tienne font file names.
///
/// Tienne supports two weight variants:
/// - Regular: Standard weight for body text
/// - Bold: Heavier weight for emphasis and headings
private enum TienneFont: String {
    case regular = "Tienne-regular"
    case bold = "Tienne-bold"
    
    /// Initializes the appropriate Tienne font variant based on the requested weight.
    ///
    /// - Parameter weight: The desired font weight
    ///
    /// - Note: Only `.regular` and `.bold` are supported. All other weights fall back to `.regular`
    init(weight: Font.Weight) {
        switch weight {
        case .regular: self = .regular
        case .bold: self = .bold
        default: self = .regular
        }
    }
}

/// Internal mapping of Font.Weight values to Styrene B font file names.
///
/// Styrene B supports three weight variants:
/// - Regular: Standard weight for body text
/// - Medium: Intermediate weight for subtle emphasis
/// - Bold: Heavier weight for strong emphasis and headings
private enum StyreneBFont: String {
    case regular = "StyreneB-regular"
    case medium = "StyreneB-medium"
    case bold = "StyreneB-bold"
    
    /// Initializes the appropriate Styrene B font variant based on the requested weight.
    ///
    /// - Parameter weight: The desired font weight
    ///
    /// - Note: Only `.regular`, `.medium`, and `.bold` are supported. All other weights fall back to `.regular`
    init(weight: Font.Weight) {
        switch weight {
        case .regular: self = .regular
        case .medium: self = .medium
        case .bold: self = .bold
        default: self = .regular
        }
    }
}

// MARK: - Convenience View Functions

/// Creates a styled Text view using the Styrene B font family.
///
/// This function provides a consistent way to render text with the Styrene B typeface
/// across the application. Styrene B is primarily used for user-generated content,
/// chat names, and interactive UI elements.
///
/// - Parameters:
///   - text: The string content to display
///   - fontStyle: The semantic text style that determines the font size. Defaults to `.body` (16pt)
///   - fontWeight: The weight variant of the font. Supports `.regular`, `.medium`, and `.bold`. Defaults to `.regular`
///   - foregroundStyle: The text color. Defaults to `AppColors.textPrimary`
///   - tracking: The character spacing adjustment in points. Negative values tighten spacing, positive values loosen it. Defaults to `-0.75`
///
/// - Returns: A configured `Text` view with Styrene B styling applied
///
/// - Example:
/// ```swift
/// styrene("Username", fontWeight: .medium)
/// styrene("Message content", tracking: -0.5)
/// ```
func styrene(_ text: String,
             fontStyle: Font.TextStyle = .body,
             fontWeight: Font.Weight = .regular,
             foregroundStyle: Color = AppColors.textPrimary,
             tracking: CGFloat = -0.75) -> some View {
    return Text(text)
        .font(.styreneB(fontStyle: fontStyle, fontWeight: fontWeight))
        .foregroundStyle(foregroundStyle)
        .tracking(tracking)
}

/// Creates a styled Text view using the Tienne font family.
///
/// This function provides a consistent way to render text with the Tienne typeface
/// across the application. Tienne is primarily used for AI-generated responses,
/// assistant messages, and content that requires a more literary appearance.
///
/// - Parameters:
///   - text: The string content to display
///   - fontStyle: The semantic text style that determines the font size. Defaults to `.body` (16pt)
///   - fontWeight: The weight variant of the font. Supports `.regular` and `.bold`. Defaults to `.regular`
///   - foregroundStyle: The text color. Defaults to `AppColors.textPrimary`
///   - tracking: The character spacing adjustment in points. Negative values tighten spacing, positive values loosen it. Defaults to `-0.75`
///
/// - Returns: A configured `Text` view with Tienne styling applied
///
/// - Example:
/// ```swift
/// tienne("AI response text")
/// tienne("Section heading", fontStyle: .headline, fontWeight: .bold)
/// ```
func tienne(_ text: String,
            fontStyle: Font.TextStyle = .body,
            fontWeight: Font.Weight = .regular,
            foregroundStyle: Color = AppColors.textPrimary,
            tracking: CGFloat = -0.75) -> some View {
    return Text(text)
        .font(.tienne(fontStyle: fontStyle, fontWeight: fontWeight))
        .foregroundStyle(foregroundStyle)
        .tracking(tracking)
}
