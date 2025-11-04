//
//  ContentView.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(AppColors.accent)
                Text("Hello, world!")
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
