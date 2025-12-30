//
//  SidebarView.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import Foundation
import SwiftUI

struct SidebarView: View {
    @Binding var topView: TopViews
    @Binding var offset: CGFloat
    @Binding var lastOffset: CGFloat
    
    @ObservedObject var chatVM: ChatViewModel
    
    @EnvironmentObject var supabase: SupabaseManager
    
    var body: some View {
        ZStack {
            AppColors.backgroundSecondary.ignoresSafeArea()
            
            VStack {
                ScrollView {
                    ForEach(chatVM.chats) { chat in
                        Text(chat.name ?? "Untitled")
                            .foregroundStyle(.white)
                    }
                }
                
                Button {
                    topView = .chat(Chat(userId: UUID()), true)
                    withAnimation {
                        offset = 0
                        lastOffset = 0
                    }
                    haptic(.medium)
                } label: {
                    Text("tap for chat view")
                }
                
                Button {
                    topView = .test
                    withAnimation {
                        offset = 0
                        lastOffset = 0
                    }
                    haptic(.medium)
                } label: {
                    Text("tap for test screen")
                }
                                
                Button {
                    Task {
                        do {
                            try await supabase.signOut()
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                } label: {
                    Text("sign out")
                }
            }
        }
    }
}

