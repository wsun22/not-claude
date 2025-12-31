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
    @StateObject private var chatVM: ChatViewModel = ChatViewModel()
    @State private var topView: TopViews = .chat(Chat(userId: UUID()), true)
    
    @State private var showSettingsView: Bool = false
    
    @ViewBuilder
    private var topScreen: some View {
        switch topView {
        case .chat(let chat, let isNewChat):
            ChatView(showKeyboard: $showKeyboard,
                     chat: chat,
                     isNewChat: isNewChat,
                     chatVM: chatVM)
            .id(chat.id) // use chat.id as the view identity
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
    @FocusState private var showKeyboard: Bool // after offsetting top view, why does it toggle?
    
    var body: some View {
        GeometryReader { geo in
            let size: CGSize = geo.size
            let slideThreshold: CGFloat = size.width * 0.3
            let bottomViewWidth: CGFloat = size.width * 0.85
            let isTopOffset: Bool = lastOffset == bottomViewWidth
            
            ZStack(alignment: .leading) {
                AppColors.backgroundSecondary.ignoresSafeArea()
                
                // bottom screen--is always SidebarView
                SidebarView(topView: $topView,
                            offset: $offset,
                            lastOffset: $lastOffset,
                            showSettingsView: $showSettingsView,
                            chatVM: chatVM)
                .padding(.top, geo.safeAreaInsets.top)
                .padding(.bottom, geo.safeAreaInsets.bottom)
                .frame(width: bottomViewWidth)
                .highPriorityGesture(handleRtlDrag(size: size,
                                       slideThreshold: slideThreshold,
                                       bottomViewWidth: bottomViewWidth))
                
                // maybe when top is offset, overlay something that makes topScreen ontap stuff useless, and for ui side dim/zoom out slightly
                topScreen
                    .padding(.top, geo.safeAreaInsets.top)
                    .padding(.bottom, geo.safeAreaInsets.bottom)
                    .cornerRadius(45)
                    .overlay(
                        RoundedRectangle(cornerRadius: 45)
                            .stroke(AppColors.outline, lineWidth: offset == 0 ? 0 : 0.15)
                    )
                    .overlay {
                        if isTopOffset {
                            Color.clear
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    print("tapped overlay")
                                    handleTap(isTopOffset: isTopOffset)
                                }
                        }
                    }
                    .offset(x: min(max(offset, 0), bottomViewWidth))
                    .gesture(handleLtrDrag(size: size,
                                           slideThreshold: slideThreshold,
                                           bottomViewWidth: bottomViewWidth,
                                           isTopOffset: isTopOffset))
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView(showSettingsView: $showSettingsView)
            }
            .ignoresSafeArea()
            .onChange(of: showKeyboard) { print("showKeyboard is \(showKeyboard)")}

        }
    }
    
    /// handles left to right drags for the top screen. needs min maxing to bind, bc sometimes top screen moves too far right, can see white background to right of sidebarview
    private func handleLtrDrag(size: CGSize,
                               slideThreshold: CGFloat,
                               bottomViewWidth: CGFloat,
                               isTopOffset: Bool) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let newOffset = lastOffset + value.translation.width
                offset = min(max(newOffset, 0), bottomViewWidth)
            }
            .onEnded { value in
                if value.translation.width > slideThreshold {
                    withAnimation {
                        offset = bottomViewWidth
                        lastOffset = bottomViewWidth
                        showKeyboard = false
                    }
                    haptic(.medium)
                } else if !isTopOffset { // if top screen is not already offset
                    withAnimation {
                        lastOffset = 0
                        offset = 0
                    }
                } else {
                    withAnimation {
                        offset = lastOffset
                    }
                }
            }
    }
    
    /// handles right to left drags for bottom screen. needs min max, bc sometimes screen moves too far left, can see white background on right
    private func handleRtlDrag(size: CGSize,
                               slideThreshold: CGFloat,
                               bottomViewWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let newOffset = lastOffset + value.translation.width
                offset = min(max(newOffset, 0), bottomViewWidth)
            }
            .onEnded { value in
                if abs(value.translation.width) > slideThreshold {
                    print("[ContentView] RTL drag - closing sidebar, showKeyboard before: \(showKeyboard)")
                    withAnimation {
                        offset = 0
                        lastOffset = 0
                    }
                    haptic(.medium)
                    showKeyboard = false  // Explicitly prevent keyboard from reopening
                    print("[ContentView] RTL drag - set showKeyboard to false")
                } else {
                    withAnimation {
                        offset = lastOffset
                    }
                }
            }
    }
    
    /// handles the tap gesture for top screen when it is offset
    private func handleTap(isTopOffset: Bool) {
        if isTopOffset {
            withAnimation {
                offset = 0
                lastOffset = 0
            }
            showKeyboard = false  // Explicitly prevent keyboard
            haptic(.medium)
        }
    }
}

#Preview {
    ContentView()
}
