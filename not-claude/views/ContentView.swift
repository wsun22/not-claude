//
//  ContentView.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import SwiftUI

enum TopViews {
    case chat(Chat)
    case test
}

struct ContentView: View {
    @StateObject private var chatVM: ChatViewModel = ChatViewModel()
    @State private var topView: TopViews = .chat(Chat(userId: UUID()))

    @ViewBuilder
    private var topScreen: some View {
        switch topView {
        case .chat(let chat):
            ChatView(showKeyboard: $showKeyboard, chat: chat, lastOffset: lastOffset)
                .id(chat.id) // use chat.id as the view identity. aka, for a new chat obj, create a new ChatView
        case .test:
            ZStack {
                Color.red.ignoresSafeArea()
                
                Text("hello")
                    .foregroundStyle(.white)
            }
        }
    }
    
    @State private var ltrOffset: CGFloat = 0 // handle left to right drags
    @State private var rtlOffset: CGFloat = 0 // handle right to left drags
    @State private var lastOffset: CGFloat = 0
    
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        GeometryReader { geo in
            let size: CGSize = geo.size
            let slideThreshold: CGFloat = size.width * 0.3
            let bottomViewWidth: CGFloat = size.width * 0.85
            let isTopOffset: Bool = lastOffset == bottomViewWidth
            
            ZStack(alignment: .leading) {                
                // bottom screen--is always SidebarView
                SidebarView(topView: $topView,
                            ltrOffset: $ltrOffset,
                            lastOffset: $lastOffset,
                            chatVM: chatVM)
                .frame(width: bottomViewWidth)
                .gesture(handleRtlDrag(size: size,
                                       slideThreshold: slideThreshold,
                                       bottomViewWidth: bottomViewWidth))
 
                // maybe when top is offset, overlay something that makes topScreen ontap stuff useless, and for ui side dim/zoom out slightly
                topScreen
                    .padding(.top, geo.safeAreaInsets.top) // let content respect safe area
                    .padding(.bottom, geo.safeAreaInsets.bottom) // let content respect safe area
                    .cornerRadius(45)
                    .overlay(
                        RoundedRectangle(cornerRadius: 45)
                            .stroke(AppColors.outline, lineWidth: ltrOffset == 0 ? 0 : 0.15)
                    )
                    .background(AppColors.backgroundSecondary) // fill gap left by rounding corenrs
                    .offset(x: ltrOffset)
                    .offset(x: rtlOffset)
                    .gesture(handleLtrDrag(size: size,
                                           slideThreshold: slideThreshold,
                                           bottomViewWidth: bottomViewWidth,
                                           isTopOffset: isTopOffset))
                    .onTapGesture { print("[ContentView] onTapGesture called"); handleTap(isTopOffset: isTopOffset) }
            }
            .ignoresSafeArea()
        }
    }
    
     /// handles left to right drags for the top screen. needs min maxing to bind, bc sometimes top screen moves too far right, can see white background to right of sidebarview
    private func handleLtrDrag(size: CGSize,
                               slideThreshold: CGFloat,
                               bottomViewWidth: CGFloat,
                               isTopOffset: Bool) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if (value.translation.width > 0) && (ltrOffset + lastOffset < bottomViewWidth) {
                    ltrOffset = min(value.translation.width, bottomViewWidth)
                }
            }
            .onEnded { value in
                if value.translation.width > slideThreshold {
//                    print("[ltr] threshold paased")
                    withAnimation {
                        ltrOffset = bottomViewWidth // offset top screen
                        lastOffset = ltrOffset // store
                        showKeyboard = false // dismiss keyboard
                    }
                    haptic(.medium)
                } else if !isTopOffset { // if top screen is not already offset
//                    print("[ltr] threshold not passed")
                    withAnimation {
                        ltrOffset = 0
                        lastOffset = 0
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
                if value.translation.width < 0 {
                    rtlOffset = value.translation.width
                }
            }
            .onEnded { value in
                if abs(value.translation.width) > slideThreshold {
                    withAnimation {
                        ltrOffset = 0
                        rtlOffset = 0
                        lastOffset = 0
                    }
                    haptic(.medium)
//                    print("[rtl] threshold passed")
                } else {
                    withAnimation {
                        rtlOffset = 0
                    }
                }
            }
    }
    
     /// handles the tap gesture for top screen when it is offset
    private func handleTap(isTopOffset: Bool) {
        if isTopOffset {
            withAnimation {
                ltrOffset = 0
                rtlOffset = 0
                lastOffset = 0
            }
            haptic(.medium)
//            print("Tapped")
        }
    }
}

#Preview {
    ContentView()
}
