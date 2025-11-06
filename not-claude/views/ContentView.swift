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
                    } label: {
                        Text("press me")
                    }
                }
                .frame(width: bottomViewWidth)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width < 0 {
                                rtlOffset = value.translation.width
                                print("hello")
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
                )
                
                // main content
                ZStack {
                    AppColors.backgroundPrimary.ignoresSafeArea()
                    
                    Image(systemName: "globe")
                        .foregroundStyle(AppColors.accent)
                }
                .offset(x: ltrOffset)
                .offset(x: rtlOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            /*
                             1st condition is to ensure the drag is a left to right drag
                             2nd condition checks if top view is already offset, if so, dont let user offset any further
                             */
                            if value.translation.width > 0 && lastOffset + ltrOffset < size.width {
                                ltrOffset = value.translation.width
                            }
                        }
                        .onEnded { value in
                            if value.translation.width > slideThreshold {
                                print("[ltr] threshold paased")
                                ltrOffset = bottomViewWidth // offset top screen
                                lastOffset = ltrOffset // store
                                haptic(.medium)
                            } else if lastOffset == bottomViewWidth {
                                // if top screen is already offset, dont apply the new offset
                                print("[ltr] top screen already offset")
                            } else {
                                print("[ltr] threshold not passed")
                                ltrOffset = 0
                            }
                        }
                )
                .onTapGesture {
                    if lastOffset == bottomViewWidth {
                        ltrOffset = 0
                        lastOffset = 0
                        haptic(.medium)
                    }
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
