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
        GeometryReader { geo in
            Ellipse()
                .fill(Color.orange)
                .frame(width: width, height: height)
                .offset(offset)
                .gesture(handleDrag(geo))
        }
    }

    private func handleDrag(_ geo: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let fingerLocation = value.location
                print(fingerLocation)
                
                
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
