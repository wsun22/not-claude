//
//  SidebarView.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import Foundation
import SwiftUI

struct SidebarView: View {
    @Binding var topView: TopViews
    @Binding var ltrOffset: CGFloat
    @Binding var lastOffset: CGFloat
    
    @EnvironmentObject var supabaseManager: SupabaseManager
    
    var body: some View {
        ZStack {
            //Color.white.ignoresSafeArea()
       //     AppColors.backgroundSecondary.ignoresSafeArea()
            
            VStack {
                Button {
                    topView = .chat
                    withAnimation(.snappy(duration: AnimationParams.duration, extraBounce: AnimationParams.extraBounce)) {
                        ltrOffset = 0
                        lastOffset = 0
                    }
                    haptic(.medium)
                } label: {
                    Text("tap for chat view")
                }
                
                Button {
                    topView = .test
                    withAnimation(.snappy(duration: AnimationParams.duration, extraBounce: AnimationParams.extraBounce)) {
                        ltrOffset = 0
                        lastOffset = 0
                    }
                    haptic(.medium)
                } label: {
                    Text("tap for test screen")
                }
                
                Button {
                    Task {
                        await supabaseManager.signOut()
                    }
                } label: {
                    Text("sign out")
                }
            }
        }
    }
}

