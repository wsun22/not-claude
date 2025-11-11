//
//  ChatButtonView.swift
//  not-claude
//
//  Created by William Sun on 11/10/25.
//

import SwiftUI

struct ChatButtonView: View {
    
    var body: some View {
        ZStack {
            Image(systemName: "plus.message.fill")
                .foregroundStyle(AppColors.textTertiary)
                
            Image(systemName: "plus")
        }
    }
}

#Preview {
    ChatButtonView()
}
