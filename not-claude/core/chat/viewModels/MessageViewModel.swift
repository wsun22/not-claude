//
//  MessageViewModel.swift
//  not-claude
//
//  Created by William Sun on 12/19/25.
//

import Combine

final class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isTyping: Bool = false
    
    private let chat: Chat
    private let supabase: SupabaseManager = SupabaseManager.shared
    
    private var fetchNMessages: Int = 10
    
    init(chat: Chat, isNewChat: Bool) {
        self.chat = chat
        if !isNewChat {
            print("[MessageViewModel] isNewChat: \(isNewChat) => fetching!")
            Task {
                await fetchMessages(for: chat)
            }
        }
    }
    
    private func fetchMessages(for chat: Chat) async {
        do {
            messages = try await supabase.fetchMessages(chatId: chat.id, n: fetchNMessages)
            fetchNMessages += 10
        } catch {
            print("Error: \(error)")
        }
    }
    
    /*
     1) save message to messages
     2) hit backend func--this func determines whether to save a new chat before saving the message via isNewChat
     3) then, handle incoming chunks
     */
    func sendMessage(content: String, isNewChat: Bool) async {
        let message: Message = Message(chatId: chat.id, role: .user, content: content)
        messages.append(message)
        
        do {
            try await supabase.sendMessage(
                chatId: chat.id,
                content: content,
                isNewChat: isNewChat
            )
        } catch {
            print("Error: \(error)")
        }
    }
}
