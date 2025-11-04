//
//  SidebarView.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import Foundation
import SwiftUI

struct SidebarView: View {
    init() {
        print("[SidebarView] init")
    }
    var body: some View {
        ZStack {
       //     AppColors.backgroundSecondary.ignoresSafeArea()
            Color.white.ignoresSafeArea()
            
            VStack {
                Text("hello")
              //      .foregroundStyle(AppColors.textPrimary)
            }
        }
    }
}

#Preview {
    SidebarView()
}
