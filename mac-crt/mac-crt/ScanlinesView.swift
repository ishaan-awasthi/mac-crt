//
//  ScanlinesView.swift
//  mac-crt
//
//  Created by ishaan on 12/9/25.
//

import SwiftUI

struct ScanlinesView: View {
    @State private var offset: CGFloat = 0
    let lineSpacing: CGFloat = 6
    let lineHeight: CGFloat = 2
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                var y: CGFloat = offset
                
                while y < size.height + lineSpacing {
                    let rect = CGRect(x: 0, y: y, width: size.width, height: lineHeight)
                    context.fill(Path(rect), with: .color(.black.opacity(0.3)))
                    y += lineSpacing
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                offset = lineSpacing
            }
        }
    }
}
