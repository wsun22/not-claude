//
//  ContentView.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var offset: CGFloat = 0
    @State private var lastDragOffset: CGFloat = 0
    
    @State private var otherOffset: CGFloat = 0
    
    init() {
        print("[ContentView] offset is \(offset)")
    }
    
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
                    } label: {
                        Text("press me")
                    }
                }
                .frame(width: bottomViewWidth)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width < 0 {
                                otherOffset = value.translation.width
                                print("hello")
                            }
                        }
                        .onEnded { value in
                            if abs(value.translation.width) > slideThreshold {
                                offset = 0
                                otherOffset = 0
                                lastDragOffset = 0
                                haptic(.medium)
                                print("[rtl] threshold passed")
                            } else {
                                otherOffset = 0
                            }
                        }
                )
                
                // main content
                ZStack {
                    AppColors.backgroundPrimary.ignoresSafeArea()
                    
                    Image(systemName: "globe")
                        .foregroundStyle(AppColors.accent)
                }
                .offset(x: offset)
                .offset(x: otherOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            /*
                             1st condition is to ensure the drag is a left to right drag
                             2nd condition checks if top view is already offset, if so, dont let user offset any further
                             */
                            if value.translation.width > 0 && lastDragOffset + offset < size.width {
                                offset = value.translation.width
                            }
                        }
                        .onEnded { value in
                            if value.translation.width > slideThreshold {
                                print("[ltr] threshold paased")
                                offset = bottomViewWidth // offset top screen
                                lastDragOffset = offset // store
                                haptic(.medium)
                            } else if lastDragOffset == bottomViewWidth {
                                // if top screen is already offset, dont apply the new offset
                                print("[ltr] top screen already offset")
                            } else {
                                print("[ltr] threshold not passed")
                                offset = 0
                            }
                        }
                )
                .onTapGesture {
                    if lastDragOffset == bottomViewWidth {
                        offset = 0
                        lastDragOffset = 0
                        haptic(.medium)
                    }
                }
                
            }
        }
        .onChange(of: offset) {
            print(offset)
        }
    }
}

#Preview {
    ContentView()
}
