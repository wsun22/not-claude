//
//  ContentView.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var ltrOffset: CGFloat = 0 // handle left to right drags
    @State private var rtlOffset: CGFloat = 0 // handle right to left drags
    @State private var lastOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let size: CGSize = proxy.size
            let slideThreshold: CGFloat = size.width * 0.4
            let bottomViewWidth: CGFloat = size.width * 0.85
            let isTopOffset: Bool = lastOffset == bottomViewWidth
            
            ZStack(alignment: .leading) {
                // bottom screen
                SidebarView()
                    .frame(width: bottomViewWidth)
//                    .border(.red, width: 10)
                    .gesture(handleRtlDrag(size: size, slideThreshold: slideThreshold, bottomViewWidth: bottomViewWidth))
                
                // top screen
                ZStack {
                    AppColors.backgroundPrimary.ignoresSafeArea()
                    
                    Image(systemName: "globe")
                        .foregroundStyle(AppColors.accent)
                }
                .offset(x: ltrOffset)
                .offset(x: rtlOffset)
                .gesture(handleLtrDrag(size: size,
                                       slideThreshold: slideThreshold,
                                       bottomViewWidth: bottomViewWidth,
                                       isTopOffset: isTopOffset))
                .onTapGesture { handleTap(isTopOffset: isTopOffset) }
            }
        }
    }
    
    /*
    handles left to right drags for the top screen
     */
    private func handleLtrDrag(size: CGSize,
                               slideThreshold: CGFloat,
                               bottomViewWidth: CGFloat,
                               isTopOffset: Bool) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if (value.translation.width > 0) && (ltrOffset + lastOffset < size.width) {
                    ltrOffset = value.translation.width
                }
            }
            .onEnded { value in
                if value.translation.width > slideThreshold {
                    print("[ltr] threshold paased")
                    withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                        ltrOffset = bottomViewWidth // offset top screen
                        lastOffset = ltrOffset // store
                    }
                    haptic(.medium)
                } else if !isTopOffset { // if top screen is not already offset
                    print("[ltr] threshold not passed")
                    withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                        ltrOffset = 0
                    }
                }
            }
    }
    
    /*
     handles right to left drags for bottom screen
     todo: pretty sure there needs to be min/maxing somewhere bc fast rtl drags/taps cause flash of underneath background on rhs
     */
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
                    withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                        ltrOffset = 0
                        rtlOffset = 0
                        lastOffset = 0
                    }
                    haptic(.medium)
                    print("[rtl] threshold passed")
                } else {
                    withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                        rtlOffset = 0
                    }
                }
            }
    }
    
    /*
     handles the tap gesture for top screen when it is offset
     */
    private func handleTap(isTopOffset: Bool) {
        if isTopOffset {
            withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                ltrOffset = 0
                lastOffset = 0
            }
            haptic(.medium)
            print("Tapped")
        }
    }
}

#Preview {
    ContentView()
}
