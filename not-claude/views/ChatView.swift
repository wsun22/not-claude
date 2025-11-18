//
//  ChatView.swift
//  not-claude
//
//  Created by William Sun on 11/17/25.
//

import SwiftUI

struct ChatView: View {
    @State var userInput: String = ""
    @FocusState.Binding var isInputFocused: Bool
    
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
                InputSection(userInput: $userInput, isInputFocused: $isInputFocused)
                    .padding(.horizontal, 12)
            }
            .onTapGesture {
                isInputFocused = false
            }
        }
    }
}

private struct InputSection: View {
    @Binding var userInput: String
    @FocusState.Binding var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 8) {            
            TextField("Chat with Claude", text: $userInput)
                .font(.styreneB(fontStyle: .headline))
                .foregroundStyle(AppColors.textPrimary)
                .tracking(-0.85)
                .tint(AppColors.textTertiary) // control cursor color
                .focused($isInputFocused)
                .padding(.vertical, 12)
                                
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.textPrimary)
                        .font(.title3)
                }
                
                Spacer()
                
                Button {
                    handleUserInput()
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
        .padding(8)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.outline, lineWidth: 0.15)
        )
    }
    
    private func handleUserInput() {
        guard !userInput.isEmpty else { return }
        
        let trimmed: String = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        userInput = ""
    }
}

//#Preview {
//    ChatView(isInputFocused: )
//}
