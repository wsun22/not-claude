//
//  ContentView.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showSidebar = false
    
    init() {
        print("[ContentView] init")
        print(showSidebar)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            SidebarView()
                .frame(width: 50)
                .offset(x: showSidebar ? 0: -250)
                .zIndex(1)
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(AppColors.accent)
                Text("Hello, world!")
                    .foregroundStyle(AppColors.textSecondary)
            }
            .offset(x: showSidebar ? 50: 0)
            .zIndex(2)
        }.gesture(
            DragGesture()
                .onEnded( { value in
                    if value.translation.width > 50 {
                        showSidebar = true }
                    if value.translation.width < -50 { showSidebar = false }
                })
        )
    }
}

#Preview {
    ContentView()
}
