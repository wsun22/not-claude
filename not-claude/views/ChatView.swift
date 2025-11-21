//
//  ChatView.swift
//  not-claude
//
//  Created by William Sun on 11/17/25.
//

import SwiftUI

struct ChatView: View {
    @State var userContent: String = ""
    @FocusState.Binding var showKeyboard: Bool
    
    let chat: Chat
    
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
                InputSection(userContent: $userContent, showKeyboard: $showKeyboard)
                    .padding(.horizontal, 12)
                    .padding(.bottom, showKeyboard ? 12 : 0)
            }
            .onTapGesture {
                showKeyboard = false
            }
            .onAppear { // open keyboard
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showKeyboard = true
                }
            }
        }
    }
}

private struct InputSection: View {
    @Binding var userContent: String
    @FocusState.Binding var showKeyboard: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("Chat with Claude", text: $userContent, axis: .vertical)
                .font(.styreneB(fontStyle: .headline))
                .foregroundStyle(AppColors.textPrimary)
                .tracking(-0.85)
                .tint(AppColors.textTertiary) // control cursor color
                .focused($showKeyboard)
                .padding(.vertical, 16)
                .lineLimit(5)
            
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.textPrimary)
                        .font(.title3)
                }
                
                Spacer()
                
                Button {
                    handleuserContent()
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
        .padding(.bottom, 8)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.outline, lineWidth: 0.15)
        )
    }
    
    private func handleuserContent() {
        guard !userContent.isEmpty else { return }
        
        let trimmed: String = userContent.trimmingCharacters(in: .whitespacesAndNewlines)
        userContent = ""
        showKeyboard = false
    }
}

#Preview {
    @FocusState var showKeyboard
    let chat: Chat = Chat(userId: UUID())
    
    ChatView(showKeyboard: $showKeyboard, chat: chat)
}
