//
//  Message+MessageVM.swift
//  not-claude
//
//  Created by William Sun on 11/18/25.
//

import Foundation
import Combine
import SwiftUI

enum Role: String {
    case system
    case user
    case assistant
}

struct Message {
    let id: UUID
    let chatId: UUID
    let role: Role
    let content: String
    let createdAt: Date
    
    init(id: UUID = UUID(),
         chatId: UUID,
         role: Role,
         content: String,
         createdAt: Date = Date()) {
        self.id = id
        self.chatId = chatId
        self.role = role
        self.content = content
        self.createdAt = createdAt
    }
}

final class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isTyping: Bool = false
    
    private let chat: Chat
    private let supabaseManager: SupabaseManager = SupabaseManager.shared
    
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
        // supabase fetch
    }
    
    func sendMessage(content: String) async {
        let message: Message = Message(chatId: chat.id, role: .user, content: content)
        messages.append(message)
        
        // supabase save message
        // start ai response: backend: send last x messages from chat, stream chunks to proxy then to client
    }
    
}
