//
//  SettingsView.swift
//  not-claude
//
//  Created by William Sun on 12/30/25.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Binding var showSettingsView: Bool
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            VStack {
                
            }
        }
    }
}

#Preview {
    SettingsView(showSettingsView: .constant(true))
}

