//
//  Message+MessageVM.swift
//  not-claude
//
//  Created by William Sun on 11/18/25.
//

import Foundation
import Combine

enum Role: String {
    case system
    case user
    case assistant
}

struct Message {
    var id: UUID
    var userId: UUID
    var chatId: UUID
    var role: Role
    var content: String
    var createdAt: Date
    
    init(id: UUID = UUID(),
         userId: UUID,
         chatId: UUID,
         role: Role,
         content: String,
         createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.chatId = chatId
        self.role = role
        self.content = content
        self.createdAt = createdAt
    }
}

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isTyping: Bool = false
    
    init() {
        
    }
}
