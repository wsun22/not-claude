//
//  ChatView.swift
//  not-claude
//
//  Created by William Sun on 11/17/25.
//

import SwiftUI

struct ChatView: View {
    @State private var userContent: String = ""
    @FocusState.Binding var showKeyboard: Bool
    @State private var isNewChat: Bool
    
    private let chat: Chat
    private let offset: CGFloat // i dont remember why i want this ngl
    
    @StateObject private var messageVM: MessageViewModel
    @ObservedObject private var chatVM: ChatViewModel
    
    init(showKeyboard: FocusState<Bool>.Binding,
         chat: Chat,
         offset: CGFloat,
         isNewChat: Bool,
         chatVM: ChatViewModel) {
        self._showKeyboard = showKeyboard
        self.chat = chat
        self.offset = offset
        self._isNewChat = State(initialValue: isNewChat)
        self._messageVM = StateObject(wrappedValue: MessageViewModel(chat: chat, isNewChat: isNewChat))
        self.chatVM = chatVM
    }
    
    var body: some View {
        GeometryReader { geo in
            let size: CGSize = geo.size
            let bottomViewWidth: CGFloat = size.width * 0.85
            //          let isTopOffset: Bool = lastOffset == bottomViewWidth
            
            ZStack {
                AppColors.backgroundPrimary.ignoresSafeArea()
                
                if isNewChat {
                    NewChatView()
                } else {
                    
                }
            }
            .safeAreaInset(edge: .top) {
                Text("hi")
                    .foregroundStyle(.white)
            }
            .safeAreaInset(edge: .bottom) {
                InputSection(userContent: $userContent,
                             showKeyboard: $showKeyboard,
                             isNewChat: $isNewChat,
                             chatVM: chatVM,
                             messageVM: messageVM,
                             chat: chat)
                .padding(.horizontal, 12)
                .padding(.bottom, showKeyboard ? 12 : 0)
            }
            .onTapGesture {
                print("[ChatView] onTapGesture called")
                showKeyboard = false
            }
            .onAppear { // open keyboard
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showKeyboard = true
                }
            }
            .allowsHitTesting(offset == 0)
        }
    }
}

private struct InputSection: View {
    @Binding var userContent: String
    @FocusState.Binding var showKeyboard: Bool
    @Binding var isNewChat: Bool
    @ObservedObject var chatVM: ChatViewModel
    @ObservedObject var messageVM: MessageViewModel
    let chat: Chat
    
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
                    handleUserContent()
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
    
    private func handleUserContent() {
        guard !userContent.isEmpty else { return }
        
        let trimmed: String = userContent.trimmingCharacters(in: .whitespacesAndNewlines)
        userContent = ""
        showKeyboard = false
        
        Task {
            if isNewChat {
                chatVM.addTempChat(chat)
            }
//            await messageVM.sendMessage(content: trimmed, isNewChat: isNewChat)
            
            if isNewChat {
                // handle polling
                isNewChat = false
//                await chatVM.pollForTitle(chat.id)
            }
        }
    }
}

private struct NewChatView: View {
    var body: some View {
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
}

#Preview {
    @FocusState var showKeyboard
    let chat: Chat = Chat(userId: UUID())
    let chatVM: ChatViewModel = ChatViewModel()
    
    ChatView(showKeyboard: $showKeyboard,
             chat: chat,
             offset: 0,
             isNewChat: true,
             chatVM: chatVM)
}
