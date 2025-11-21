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
    
    @EnvironmentObject var supabaseManager: SupabaseManager
    
    init(chat: Chat) {
        // fetch messages based on user and chat
        self.chat = chat
        // try await messages = supabase.fetchMessages(userId: supabase.currentUser.id, chatId: chat.id)
    }
}
