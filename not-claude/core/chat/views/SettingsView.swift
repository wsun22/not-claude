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
    @EnvironmentObject var supabase: SupabaseManager
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary.ignoresSafeArea()
            
            VStack {
                Button {
                    Task {
                        do {
                            try await supabase.signOut()
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                } label: {
                    Text("sign out")
                }
            }
        }
    }
}

#Preview {
    SettingsView(showSettingsView: .constant(true))
        .environmentObject(SupabaseManager())

}

