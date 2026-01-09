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
    @State private var dragStart: Date = Date()
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
                
                topScreen(bottomViewWidth: bottomViewWidth)
                    .padding(.top, geo.safeAreaInsets.top)
                    .padding(.bottom, geo.safeAreaInsets.bottom)
                    .cornerRadius(45)
                    .overlay(RoundedRectangle(cornerRadius: 45).stroke(AppColors.outline, lineWidth: offset == 0 ? 0 : 0.15))
                    .overlay {
                        if offset != 0 {
                            Color.clear
                                .contentShape(RoundedRectangle(cornerRadius: 45))
                                .gesture(handleTap(isTopOffset: isTopOffset))
                        } 
                    }
                    .offset(x: offset)
            }
            .allowsHitTesting(!isDragging)
            .simultaneousGesture(handleDrag(slideThreshold: slideThreshold, bottomViewWidth: bottomViewWidth))
            .sheet(isPresented: $showSettingsView) {
                SettingsView(showSettingsView: $showSettingsView)
            }
            .ignoresSafeArea()
        }
    }
    
    /// handles ltr and rtl drags to offset topscreen
    private func handleDrag(slideThreshold: CGFloat, bottomViewWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if !isDragging {
                    dragStart = Date()
                }
                isDragging = true
                
                let dragDistance = value.translation.width
                let dragHeight = value.translation.height
                let newOffset = lastOffset + dragDistance
                
                let relativelyHorizontal = abs(dragDistance) > abs(dragHeight) * 2.5
                
                if lastOffset == 0 { // top screen is not offset
                    let dragThreshold = bottomViewWidth * 0.1
                    if dragDistance > 0 { // ltr drag
                        if offset < dragThreshold { // opening must be relatively horizontal
                            if relativelyHorizontal {
                                offset = min(max(newOffset, 0), bottomViewWidth)
                            }
                        } else {
                            offset = min(max(newOffset, 0), bottomViewWidth)
                        }
                    } else if offset != 0 { // rtl drag
                        offset = min(max(newOffset, 0), bottomViewWidth)
                    }
                } else if lastOffset == bottomViewWidth { // top screen is offset
                    let dragThreshold = bottomViewWidth * 0.9
                    if dragDistance < 0 { // rtl drag
                        if offset > dragThreshold { // opening must be relatively horizontal
                            if relativelyHorizontal {
                                offset = min(max(newOffset, 0), bottomViewWidth)
                            }
                        } else {
                            offset = min(max(newOffset, 0), bottomViewWidth)
                        }
                    } else if offset != bottomViewWidth {
                        offset = min(max(newOffset, 0), bottomViewWidth)
                    }
                }
            }
            .onEnded { value in
                defer { isDragging = false }
                guard offset != lastOffset else { return } // must have moved
                
                let dragDistance = value.translation.width
                let dragHeight = value.translation.height
                
                let dragDuration = Date().timeIntervalSince(dragStart)
                let dragVelocity = abs(dragDistance) / dragDuration
                let fastDragThreshold: CGFloat = 500
                let isFastDrag: Bool = dragVelocity > fastDragThreshold
                let relativelyHorizontal = abs(dragDistance) > abs(dragHeight) * 2.5
                
                withAnimation {
                    if lastOffset == 0 { // ltr drag
                        if isFastDrag && relativelyHorizontal && dragDistance > 0 {
                            offset = bottomViewWidth
                            lastOffset = bottomViewWidth
                            haptic(.medium)
                            showKeyboard = false
                        } else if dragDistance > 0 {
                            if dragDistance > slideThreshold {
                                offset = bottomViewWidth
                                lastOffset = bottomViewWidth
                                haptic(.medium)
                                showKeyboard = false
                            }
                            else {
                                offset = 0
                                lastOffset = 0
                            }
                        }
                    } else if lastOffset == bottomViewWidth { // rtl drag
                        let rtlSlideThreshold = bottomViewWidth - slideThreshold
                        if isFastDrag && relativelyHorizontal && dragDistance < 0 {
                            offset = 0
                            lastOffset = 0
                            haptic(.medium)
                        } else if dragDistance < 0 {
                            if dragDistance < 0 && abs(dragDistance) > rtlSlideThreshold {
                                offset = 0
                                lastOffset = 0
                                haptic(.medium)
                            } else {
                                offset = bottomViewWidth
                                lastOffset = bottomViewWidth
                            }
                        }
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
