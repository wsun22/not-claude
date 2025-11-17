//
//  ChatView.swift
//  not-claude
//
//  Created by William Sun on 11/17/25.
//

import SwiftUI

struct ChatView: View {
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "globe")
                    .foregroundStyle(AppColors.accent)
                
                tienne("How can I help you this afternoon?",
                       fontStyle: .title,
                       fontWeight: .regular,
                       foregroundStyle: AppColors.textTertiary)
                
                styrene("Claude's UI font choices and stuff", fontStyle: .headline, fontWeight: .regular, foregroundStyle: AppColors.textSecondary)
            }
        }
    }
}

#Preview {
    ChatView()
}
