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
            .frame(width: width * (isDragging ? 1.1 : 1.0), height: height * (isDragging ? 1.1 : 1.0))
            .offset(offset)
            .coordinateSpace(name: "button")
            .gesture(handleDrag())
            .frame(width: 50 * 1.1, height: 50 * 1.1)
            .ignoresSafeArea()
    }
    
    private func handleDrag() -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("button"))
            .onChanged { value in
                isDragging = true
                let center = CGPoint(x: width / 2, y: height / 2)
                let fingerLocation = value.location
                
                let dx = fingerLocation.x - center.x
                let dy = fingerLocation.y - center.y
                                
                offset = CGSize(width: dx / 30, height: dy / 30)
                width = 50 + abs(dx) / 50
                height = 50 + abs(dy) / 50
            } .onEnded { value in
                defer { isDragging = false }
                
                let dragDistance = sqrt(pow(offset.width, 2) + pow(offset.height, 2)) // handle taps
                if dragDistance < 1 {
                    action()
                    haptic(.medium)
                }
                
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
