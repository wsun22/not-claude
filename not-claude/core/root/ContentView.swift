//
//  ContentView.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var supabase: SupabaseManager
    @StateObject private var chatVM: ChatViewModel = ChatViewModel()
    
    @State private var topView: TopViews = .chat(Chat(userId: UUID()), true) /// need to use supabase.currentUser.id instead
    @State private var showSettingsView: Bool = false
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @GestureState private var isDragging: Bool = false
    @State private var dragStart: Date = Date()
    
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        GeometryReader { geo in
            let slideThreshold: CGFloat = geo.size.width * 0.32
            let bottomViewWidth: CGFloat = geo.size.width * 0.85
            var sidebarViewScale: CGFloat {
                let x = offset / bottomViewWidth // 0 to 1
                return 0.985 + (x * 0.015) // scale from 98.5% to 100%
            }
            
            ZStack(alignment: .leading) {
                AppColors.backgroundSecondary.allowsHitTesting(false)

                /// bottom screen--is always SidebarView
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
                .scaleEffect(sidebarViewScale) /// 1.0 when offset == bottomViewWidth (offset)
                
                handleTopScreen(bottomViewWidth: bottomViewWidth, isDragging: isDragging)
                    .padding(.top, geo.safeAreaInsets.top)
                    .padding(.bottom, geo.safeAreaInsets.bottom)
                    .cornerRadius(45)
                    .overlay(RoundedRectangle(cornerRadius: 45).stroke(AppColors.outline, lineWidth: offset > 0 ? 0.15 : 0))
                    .overlay {
                        if offset == bottomViewWidth {
                            Color.clear
                                .contentShape(RoundedRectangle(cornerRadius: 45))
                                .simultaneousGesture(handleTap())
                        }
                    }
                    .offset(x: offset)
                    .allowsHitTesting(!isDragging)
            }
            .simultaneousGesture(handleDrag(slideThreshold: slideThreshold, bottomViewWidth: bottomViewWidth))
            .sheet(isPresented: $showSettingsView) {
                SettingsView(showSettingsView: $showSettingsView)
            }
            .ignoresSafeArea()
            .onChange(of: sidebarViewScale) {
                print(sidebarViewScale)
            }
        }
    }
    
    /// handles what the top screen should be
    @ViewBuilder
    private func handleTopScreen(bottomViewWidth: CGFloat, isDragging: Bool) -> some View {
        switch topView {
        case .chat(let chat, let isNewChat):
            ChatView(showKeyboard: $showKeyboard,
                     offset: $offset,
                     lastOffset: $lastOffset,
                     isDragging: isDragging,
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
    
    /// handles ltr and rtl drags to offset topscreen
    /// todo: implement coordinate space
    private func handleDrag(slideThreshold: CGFloat, bottomViewWidth: CGFloat) -> some Gesture {
        DragGesture()
            .updating($isDragging) { _ , state, _ in
                if !state {
                    dragStart = Date()
                }
                state = true
            }
            .onChanged { value in
                let dragDistance = value.translation.width
                let dragHeight = value.translation.height
                let newOffset = lastOffset + dragDistance
                
                let relativelyHorizontal = abs(dragDistance) > abs(dragHeight) * 2.5
                
                if lastOffset == 0 { /// top screen is not offset
                    if dragDistance > 0 { /// ltr drag
                        let dragThreshold = bottomViewWidth * 0.02
                        if offset < dragThreshold { /// opening must be relatively horizontal
                            if relativelyHorizontal {
                                offset = min(max(newOffset, 0), bottomViewWidth)
                            }
                        } else {
                            offset = min(max(newOffset, 0), bottomViewWidth)
                        }
                    } else if offset != 0 { /// this part is sketchy. need to handle when offset == 0, rtl drag
                        offset = min(max(newOffset, 0), bottomViewWidth)
                    }
                } else if lastOffset == bottomViewWidth { /// top screen is offset
                    if dragDistance < 0 { /// rtl drag
                        let dragThreshold = bottomViewWidth * 0.98
                        if offset > dragThreshold { /// opening must be relatively horizontal
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
                guard offset != lastOffset else { return } /// must have moved
                
                let dragDistance = value.translation.width
                let dragHeight = value.translation.height
                
                let dragDuration = Date().timeIntervalSince(dragStart)
                let dragVelocity = abs(dragDistance) / dragDuration
                let fastDragThreshold: CGFloat = 500
                let isFastDrag: Bool = dragVelocity > fastDragThreshold
                let relativelyHorizontal = abs(dragDistance) > abs(dragHeight) * 2.5
                
                withAnimation {
                    if lastOffset == 0 { /// ltr drag
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
                    } else if lastOffset == bottomViewWidth { /// rtl drag
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
    private func handleTap() -> some Gesture {
        TapGesture()
            .onEnded {
                guard !isDragging else { return }
                
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
