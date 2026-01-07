//
//  ContentView.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import SwiftUI

enum TopViews {
    case chat(Chat, Bool)
    case test
}

struct ContentView: View {
    @EnvironmentObject var supabase: SupabaseManager
    @StateObject private var chatVM: ChatViewModel = ChatViewModel()
    @State private var topView: TopViews = .chat(Chat(userId: UUID()), true) /// need to use supabase.currentUser.id instead
    
    @State private var showSettingsView: Bool = false
    
    @ViewBuilder
    private func topScreen(bottomViewWidth: CGFloat) -> some View {
        switch topView {
        case .chat(let chat, let isNewChat):
            ChatView(showKeyboard: $showKeyboard,
                     offset: $offset,
                     lastOffset: $lastOffset,
                     bottomViewWidth: bottomViewWidth,
                     chat: chat,
                     isNewChat: isNewChat,
                     chatVM: chatVM)
            .id(chat.id) /// use chat.id as the view identity
        case .test:
            ZStack {
                Color.red.ignoresSafeArea()
                
                Text("hello")
                    .foregroundStyle(.white)
            }
        }
    }
    
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        GeometryReader { geo in
            let size: CGSize = geo.size
            let slideThreshold: CGFloat = size.width * 0.32
            let bottomViewWidth: CGFloat = size.width * 0.85
            let isTopOffset: Bool = lastOffset == bottomViewWidth
            
            ZStack(alignment: .leading) {
                AppColors.backgroundSecondary
                
                /// bottom screen--is always SidebarView
                /// consider adding a zoom feature. zoom = 100% when offset = 0
                SidebarView(topView: $topView,
                            offset: $offset,
                            lastOffset: $lastOffset,
                            showSettingsView: $showSettingsView,
                            chatVM: chatVM,
                            bottomViewWidth: bottomViewWidth)
                .padding(.top, geo.safeAreaInsets.top)
                .padding(.bottom, geo.safeAreaInsets.bottom)
                .frame(width: bottomViewWidth)
                .allowsHitTesting(!isDragging)
                
                topScreen(bottomViewWidth: bottomViewWidth)
                    .padding(.top, geo.safeAreaInsets.top)
                    .padding(.bottom, geo.safeAreaInsets.bottom)
                    .allowsHitTesting(!isDragging)
                    .cornerRadius(45)
                    .overlay {
                        ZStack {
                            RoundedRectangle(cornerRadius: 45)
                                .stroke(AppColors.outline, lineWidth: offset == 0 ? 0 : 0.15)
                            
                            if isTopOffset {
                                Color.clear
                                    .contentShape(RoundedRectangle(cornerRadius: 45))
                                    .gesture(handleTap(isTopOffset: isTopOffset))
                            }
                        }
                    }
                    .offset(x: offset)
                    .simultaneousGesture(handleLtrDrag(slideThreshold: slideThreshold,
                                                       bottomViewWidth: bottomViewWidth,
                                           isTopOffset: isTopOffset))
            }
            .simultaneousGesture(handleRtlDrag(slideThreshold: bottomViewWidth - slideThreshold, bottomViewWidth: bottomViewWidth))
            .sheet(isPresented: $showSettingsView) {
                SettingsView(showSettingsView: $showSettingsView)
            }
            .ignoresSafeArea()
            .onChange(of: isDragging) { print(isDragging) }
        }
    }
    
    /// handles left to right drags for the top screen. needs min maxing to bind, bc sometimes top screen moves too far right, can see white background to right of sidebarview
    /// todo: only relatively horizontal drag
    private func handleLtrDrag(slideThreshold: CGFloat,
                               bottomViewWidth: CGFloat,
                               isTopOffset: Bool) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard lastOffset == 0 && value.translation.width > 0 && offset != bottomViewWidth else { return }
                isDragging = true
                
                let dragThreshold: CGFloat = bottomViewWidth * 0.1
                
                if offset < dragThreshold {
                    // require 2x more horizontal than vertical movement
                    if abs(value.translation.width) > abs(value.translation.height) * 2 {
                        let newOffset = lastOffset + value.translation.width
                        offset = min(max(newOffset, 0), bottomViewWidth)
                    }
                } else {
                    // once past threshold, allow any direction
                    let newOffset = lastOffset + value.translation.width
                    offset = min(max(newOffset, 0), bottomViewWidth)
                }
                
            }
            .onEnded { value in
                defer { isDragging = false }
                guard lastOffset == 0 && value.translation.width > 0 && offset != lastOffset else { return } // nothing to evaluate if lastOffset never changes

                if value.translation.width > slideThreshold {
                    withAnimation {
                        offset = bottomViewWidth
                        lastOffset = bottomViewWidth
                        showKeyboard = false
                    }
                    haptic(.medium)
                } else {
                    withAnimation {
                        offset = lastOffset
                    }
                }
            }
    }
    
    /// handles right to left drags for bottom screen. needs min max, bc sometimes screen moves too far left, can see white background on right
    /// todo: only relatively horizontal dragss. also, weird behavior when dragging AND tapping top screen
    private func handleRtlDrag(slideThreshold: CGFloat,
                               bottomViewWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard lastOffset == bottomViewWidth && value.translation.width < 0 else { return }
                isDragging = true
                
                let dragThreshold: CGFloat = bottomViewWidth * 0.9
                
                if offset > dragThreshold {
                    if abs(value.translation.width) > abs(value.translation.height) * 2 {
                        let newOffset = lastOffset + value.translation.width
                        offset = min(max(newOffset, 0), bottomViewWidth)
                    }
                } else {
                    let newOffset = lastOffset + value.translation.width
                    offset = min(max(newOffset, 0), bottomViewWidth)
                }
            }
            .onEnded { value in
                defer { isDragging = false }
                guard lastOffset == bottomViewWidth && value.translation.width < 0 && offset != lastOffset else { return }
                
                if abs(value.translation.width) > slideThreshold {
                    withAnimation {
                        offset = 0
                        lastOffset = 0
                    }
                    haptic(.medium)
                } else {
                    withAnimation {
                        offset = lastOffset
                    }
                }                
            }
    }
    
    /// handles the tap gesture for top screen when it is offset
    private func handleTap(isTopOffset: Bool) -> some Gesture {
        TapGesture()
            .onEnded {
                guard isTopOffset && !isDragging else { return }

                withAnimation {
                    offset = 0
                    lastOffset = 0
                }
                haptic(.medium)
            }
    }
}

#Preview {
    ContentView()
        .environmentObject(SupabaseManager())
}
