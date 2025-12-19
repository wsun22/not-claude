//
//  Chat+ChatViewModel.swift
//  not-claude
//
//  Created by William Sun on 11/18/25.
//

import Foundation
import Combine
import SwiftUI
import Supabase

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
    
    private let supabase: SupabaseManager = SupabaseManager.shared
    
    init() {
        Task {
            await fetchChats()
        }
    }
    
    private func fetchChats() async {
        
    }
    
    /// save new chat only handles saving a temp chat element to chats array
    func saveNewChat(_ chat: Chat) {
        guard let userId = supabase.currentUser?.id else {
            print("Error: no user")
            return
        }
        
        let temp = Chat(id: chat.id, userId: userId)
        chats.append(temp)
    }
    
    func pollForTitle(_ id: UUID) async {
        
    }
}
