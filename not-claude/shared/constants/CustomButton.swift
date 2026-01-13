//
//  CustomButton.swift
//  not-claude
//
//  Created by William Sun on 1/13/26.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    @State private var width: CGFloat = 50
    @State private var height: CGFloat = 50
    @State private var offset: CGSize = .zero
    @State private var isDragging: Bool = false
    
    let action: () -> Void
    
    var body: some View {
        Ellipse()
            .fill(Color.orange)
            .frame(width: width, height: height)
            .offset(offset)
            .gesture(handleDrag())
    }
    
    private func handleDrag() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let horizontalDistance = value.translation.width
                let verticalDistance = value.translation.height
                
                offset = CGSize(width: horizontalDistance / 50, height: verticalDistance / 50)
                
            } .onEnded { value in
                width = 50
                height = 50
                offset = .zero
            }
        
    }
}

#Preview {
    CustomButton {
        print("tapped")
    }
}
