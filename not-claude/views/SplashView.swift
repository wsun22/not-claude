//
//  SplashView.swift
//  not-claude
//
//  Created by William Sun on 11/12/25.
//

import Foundation
import SwiftUI

struct SplashView: View {
    
    var body: some View {
        ZStack{
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            tienne("notClaude",
                   fontStyle: .title,
                   fontWeight: .medium,
                   foregroundStyle: AppColors.textPrimary)
        }
    }
}

#Preview {
    SplashView()
}
