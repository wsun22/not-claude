//
//  ContentView.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var offset: CGFloat = 0
    @State private var offsetSum: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
//            let sizeBarWidth: CGFloat = 200
            
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
                            if value.translation.width > 0 {
                                offset = value.translation.width
                            }
                        }
                        .onEnded { value in
                            if value.translation.width > size.width * 0.2 {
                                offset = size.width * 0.8
                            } else {
                                offset = 0
                            }
                        }
                )
                .onTapGesture {
                    offset = 0
                }

            }
        }
    }
    
}

#Preview {
    ContentView()
}
