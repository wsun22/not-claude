//
//  ChatView.swift
//  not-claude
//
//  Created by William Sun on 11/17/25.
//

import SwiftUI

struct ChatView: View {
    @State var userContent: String = ""
    
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
                }
                .padding(.horizontal, 16)
            }
            .safeAreaInset(edge: .top) {
                Text("hi")
                    .foregroundStyle(.white)
            }
            .safeAreaInset(edge: .bottom) {
                InputSection(userContent: $userContent)
                    .padding(.horizontal, 12)
            }
        
    }
}

private struct InputSection: View {
    @Binding var userContent: String
    
    var body: some View {
        VStack(spacing: 16) {
//                    ZStack(alignment: .leading) {
//                        if userContent.isEmpty {
//                            styrene("Chat with Claude", fontStyle: .headline, foregroundStyle: AppColors.textTertiary)
//                        }
//
//                        TextField("hello", text: $userContent)
//                            .font(.styreneB(fontStyle: .body))
//                            .foregroundStyle(AppColors.textPrimary)
//                        //          .border(.red, width: 1)
//
//                    }
            
            TextField("Chat with Claude", text: $userContent)
                .font(.styreneB(fontStyle: .headline))
                .foregroundStyle(AppColors.textPrimary)
                .tint(AppColors.textTertiary) // control cursor color
                                
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.textPrimary)
                        .font(.title3)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.up")
                        .foregroundStyle(AppColors.textPrimary)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(AppColors.accent)
                        )
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 16)
        .padding(.bottom, 8)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.outline, lineWidth: 0.15)
        )
    }
}

#Preview {
    ChatView()
}
