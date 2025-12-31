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
    @Binding var showSettingsView: Bool
    @ObservedObject var chatVM: ChatViewModel
    @EnvironmentObject var supabase: SupabaseManager
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AppColors.backgroundSecondary.ignoresSafeArea()

                VStack {
                    ScrollView {
                        Spacer().frame(height: geo.safeAreaInsets.top)
                        
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
                        
                        ForEach(chatVM.chats) { chat in
                            Text(chat.name ?? "Untitled")
                                .foregroundStyle(.white)
                        }
                        
                    }

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
    //            .border(.red, width: 2)
                .overlay(alignment: .topLeading) {
                    tienne("notClaude", fontStyle: .title)
                        .padding(.top, 8)
                        .padding(.horizontal, 16)
                }
                .overlay(alignment: .bottom) {
                    BottomAreaView(
                        topView: $topView,
                        offset: $offset,
                        lastOffset: $lastOffset,
                        showSettingsView: $showSettingsView)
          //          .padding(.bottom, geo.safeAreaInsets.bottom)
                    .padding(.horizontal, 36)
                }
            }

        }
    }
}

private struct BottomAreaView: View {
    @Binding var topView: TopViews
    @Binding var offset: CGFloat
    @Binding var lastOffset: CGFloat
    @Binding var showSettingsView: Bool
    
    var body: some View {
        HStack {
            Button {
                showSettingsView = true
            } label: {
                Text("Settings")
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            Button {
                topView = .chat(Chat(userId: UUID()), true)
                withAnimation {
                    offset = 0
                    lastOffset = 0
                }
                haptic(.medium)
            } label: {
                Text("New Chat")
            }
            
        }
    }
}

#Preview {
    SidebarView(
        topView: .constant(.chat(Chat(userId: UUID()), true)),
        offset: .constant(0),
        lastOffset: .constant(0),
        showSettingsView: .constant(false),
        chatVM: ChatViewModel()
    )
    .environmentObject(SupabaseManager())
}
