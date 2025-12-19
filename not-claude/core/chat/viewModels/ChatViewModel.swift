//
//  ChatViewModel.swift
//  not-claude
//
//  Created by William Sun on 12/19/25.
//

import Combine
import SwiftUI
import Supabase

final class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    
    private let supabase: SupabaseManager = SupabaseManager.shared
    private var fetchNChats: Int = 10
    
    init() {
        Task {
            await fetchChats()
        }
    }
    
    private func fetchChats() async {
        do {
            chats = try await supabase.fetchChats(n: fetchNChats)
            print("fetched! Count: \(chats.count)")
            fetchNChats += 10
        } catch {
            print("Error: \(error)")
        }
    }
    
    /// save new chat only handles saving a temp chat element to chats array
    func addTempChat(_ chat: Chat) {
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
