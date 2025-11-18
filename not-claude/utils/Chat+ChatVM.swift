//
//  Chat+ChatViewModel.swift
//  not-claude
//
//  Created by William Sun on 11/18/25.
//

import Foundation
import Combine

struct Chat {
    var id: UUID
    var name: String
    var createdAt: Date
    var lastUpdated: Date
    
    init(id: UUID = UUID(),
         name: String,
         createdAt: Date = Date(),
         lastUpdated: Date = Date()) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.lastUpdated = lastUpdated
    }
}

final class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    
    let user = SupabaseManager.shared.currentUser
    
    init() {
        // fetch user's chats
    }
}
