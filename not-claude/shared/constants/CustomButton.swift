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
                .coordinateSpace(name: "button")
                .gesture(handleDrag())
        
    }

    private func handleDrag() -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("button"))
            .onChanged { value in
                let center = CGPoint(x: width / 2, y: height / 2)
                let fingerLocation = value.location
                
                let dx = fingerLocation.x - center.x
                let dy = fingerLocation.y - center.y
                
                // log only occasionally (every ~10th update based on drag distance)
                if abs(dx) > 10 && Int(dx) % 10 == 0 {
                    print("center: \(center)")
                    print("finger: \(fingerLocation)")
                    print("dx: \(dx), dy: \(dy)")
                    print("offset will be: \(CGSize(width: dx / 3, height: dy / 3))")
                    print("---")
                }
                
                offset = CGSize(width: dx / 10, height: dy / 10)
                
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
