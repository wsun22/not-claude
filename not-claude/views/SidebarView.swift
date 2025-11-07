//
//  SidebarView.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import Foundation
import SwiftUI

struct SidebarView: View {
    @Binding var topView: TopScreenViews
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
         //   AppColors.backgroundSecondary.ignoresSafeArea()
            
            VStack {
                Button {
                    topView = .chat
                } label: {
                    Text("tap for chat view")
                }
                Button {
                    topView = .test
                } label: {
                    Text("tap for test screen")
                }

            }
        }
    }
}

