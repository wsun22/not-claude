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
    
    let systemName: String
    let foregroundColor: Color
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Ellipse()
                .fill(backgroundColor)
            
            Image(systemName: systemName)
                .foregroundStyle(foregroundColor)
                .font(.system(size: 20 * (isDragging ? 1.1 : 1.0)))
            
            if isDragging {
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.3), backgroundColor.opacity(0.3)],
                            center: gradientCenter,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
            }
        }
        .frame(width: width * (isDragging ? 1.1 : 1.0), height: height * (isDragging ? 1.1 : 1.0))
        .offset(offset)
        .coordinateSpace(name: "button")
        .gesture(handleDrag())
        .frame(width: 50 * 1.1, height: 50 * 1.1)
        .ignoresSafeArea()
    }
    
    private var gradientCenter: UnitPoint {
        UnitPoint(x: 0.5 + offset.width / 10, y: 0.5 + offset.height / 10)
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
    CustomButton(
        systemName: "slider.horizontal.3",
        foregroundColor: AppColors.textPrimary,
        backgroundColor: AppColors.backgroundSecondary) {
        print("tapped")
    }
}
