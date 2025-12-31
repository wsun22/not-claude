//
//  Message.swift
//  not-claude
//
//  Created by William Sun on 12/19/25.
//

import SwiftUI

enum Role: String, Codable {
    case system
    case user
    case assistant
}

struct Message: Codable, Identifiable {
    let id: UUID
    let chatId: UUID
    let role: Role
    let content: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case role
        case content
        case createdAt = "created_at"
    }
    
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
