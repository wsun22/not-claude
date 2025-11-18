//
//  ChatView.swift
//  not-claude
//
//  Created by William Sun on 11/17/25.
//

import SwiftUI

struct ChatView: View {
    @State var userInput: String = ""
    
    var body: some View {
        GeometryReader { geo in 
            ZStack {
                AppColors.backgroundPrimary.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Image(systemName: "globe")
                        .foregroundStyle(AppColors.accent)
                    
                    tienne("How can I help you this afternoon?",
                           fontStyle: .title,
                           fontWeight: .regular,
                           foregroundStyle: AppColors.textTertiary)
                    .multilineTextAlignment(.center)
                }
            }
            .safeAreaInset(edge: .top) {
                Text("hi")
                    .foregroundStyle(.white)
            }
            .safeAreaInset(edge: .bottom) {
                InputSection(userInput: $userInput)
                    .padding(.horizontal, 12)
            }
        }
    }
}

private struct InputSection: View {
    @Binding var userInput: String
    
    var body: some View {
        VStack(spacing: 16) {
//                    ZStack(alignment: .leading) {
//                        if userInput.isEmpty {
//                            styrene("Chat with Claude", fontStyle: .headline, foregroundStyle: AppColors.textTertiary)
//                        }
//
//                        TextField("hello", text: $userInput)
//                            .font(.styreneB(fontStyle: .body))
//                            .foregroundStyle(AppColors.textPrimary)
//                        //          .border(.red, width: 1)
//
//                    }
            
            TextField("Chat with Claude", text: $userInput)
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
