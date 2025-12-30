//
//  HapticFeedback.swift
//  not-claude
//
//  Created by William Sun on 11/5/25.
//

import SwiftUI

/*
 A centralized wrapper for haptic feedbacks
 */
func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
}
