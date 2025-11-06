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
    
    init() {
        print("[ContentView] offset is \(offset)")
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let threshold = size.width * 0.2
            
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
                .frame(width: size.width * 0.8)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            
                        }
                )
                
                // main content
                ZStack {
                    AppColors.backgroundPrimary.ignoresSafeArea()
                    
                    Image(systemName: "globe")
                        .foregroundStyle(AppColors.accent)
                }
                .offset(x: offset)
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
                            if value.translation.width > size.width * 0.25 {
                                print("[ltr] threshold paased")
                                offset = size.width * 0.8 // offset top screen
                                lastDragOffset = offset // store
                            } else if lastDragOffset == size.width * 0.8 {
                                // if top screen is already offset, dont apply the new offset
                                print("[ltr] top screen already offset")
                            } else {
                                print("[ltr] threshold not passed")
                                offset = 0
                            }
                        }
                )
                .onTapGesture {
                    offset = 0
                    lastDragOffset = 0
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
