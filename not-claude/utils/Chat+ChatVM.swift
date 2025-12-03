//
//  Chat+ChatViewModel.swift
//  not-claude
//
//  Created by William Sun on 11/18/25.
//

import Foundation
import Combine
import SwiftUI

struct Chat {
    let id: UUID
    let userId: UUID
    var name: String?
    let createdAt: Date
    var lastUpdated: Date
    
    init(id: UUID = UUID(),
         userId: UUID,
         name: String? = nil,
         createdAt: Date = Date(),
         lastUpdated: Date = Date()) {
        self.id = id
        self.userId = userId
        self.name = name
        self.createdAt = createdAt
        self.lastUpdated = lastUpdated
    }
}

final class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    
    private let supabaseManager: SupabaseManager = SupabaseManager.shared
    
    init() {
        // fetch user's chats
    }
    
    func saveNewChat(chat: Chat) async {
        
    }
}
