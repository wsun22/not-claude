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
            let size = proxy.size
            let slideThreshold = size.width * 0.4
            let bottomViewWidth = size.width * 0.85
            
            ZStack(alignment: .leading) {
                // slide menu
                ZStack {
                    Color.white.ignoresSafeArea()
                    
                    Button {
                        print("pressed")
                        print(type(of: size))
                        print(type(of: slideThreshold))
                        print(type(of: bottomViewWidth))
                    } label: {
                        Text("press me")
                    }
                }
                .frame(width: bottomViewWidth)
                .gesture(handleRtlDrag(size: size, slideThreshold: slideThreshold, bottomViewWidth: bottomViewWidth))
                
                // main content
                ZStack {
                    AppColors.backgroundPrimary.ignoresSafeArea()
                    
                    Image(systemName: "globe")
                        .foregroundStyle(AppColors.accent)
                }
                .offset(x: ltrOffset)
                .offset(x: rtlOffset)
                .gesture(handleLtrDrag(size: size, slideThreshold: slideThreshold, bottomViewWidth: bottomViewWidth))
                .onTapGesture { handleTap(bottomViewWidth: bottomViewWidth) }
            }
        }
    }
    /*
    handles left to right drags for the top screen
     */
    private func handleLtrDrag(size: CGSize,
                               slideThreshold: CGFloat,
                               bottomViewWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if (value.translation.width > 0) && (ltrOffset + lastOffset < size.width) {
                    ltrOffset = value.translation.width
                }
            }
            .onEnded { value in
                if value.translation.width > slideThreshold {
                    print("[ltr] threshold paased")
                    ltrOffset = bottomViewWidth // offset top screen
                    lastOffset = ltrOffset // store
                    haptic(.medium)
                } else if lastOffset != bottomViewWidth { // if top screen is not already offset
                    print("[ltr] threshold not passed")
                    ltrOffset = 0
                }
            }
    }
    
    /*
     handles right to left drags for bottom screen
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
                    ltrOffset = 0
                    rtlOffset = 0
                    lastOffset = 0
                    haptic(.medium)
                    print("[rtl] threshold passed")
                } else {
                    rtlOffset = 0
                }
            }
    }
    
    /*
     handles the tap gesture for top screen when it is offset
     */
    private func handleTap(bottomViewWidth: CGFloat) {
        if lastOffset == bottomViewWidth {
            ltrOffset = 0
            lastOffset = 0
            haptic(.medium)
        }
    }
}

#Preview {
    ContentView()
}
