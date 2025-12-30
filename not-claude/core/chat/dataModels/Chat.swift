//
//  Chat.swift
//  not-claude
//
//  Created by William Sun on 12/19/25.
//

import SwiftUI

struct Chat: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    var name: String?
    let createdAt: Date
    var lastUpdated: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case createdAt = "created_at"
        case lastUpdated = "last_updated"
    }
    
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
