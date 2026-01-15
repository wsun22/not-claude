//
//  LiquidGlassButton.swift
//  not-claude
//
//  Created by William Sun on 1/13/26.
//

import Foundation
import SwiftUI

struct LiquidGlassButton: View {
    let systemName: String
    let foregroundColor: Color
    let backgroundColor: Color
    let action: () -> Void
    
    init(systemName: String, foregroundColor: Color, backgroundColor: Color = Color.clear, action: @escaping () -> Void) {
        self.systemName = systemName
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .foregroundStyle(foregroundColor)
                .font(.system(size: 20))
                .frame(width: 50, height: 50)
                .glassEffect(.regular
                    .tint(backgroundColor)
                    .interactive())
        }
    }
}

#Preview {
    LiquidGlassButton(
        systemName: "face.smiling",
        foregroundColor: AppColors.textPrimary,
        backgroundColor: AppColors.backgroundPrimary
    ) {
        print("tapped")
    }
}
