//
//  ScanlinesView.swift
//  mac-crt
//
//  Created by ishaan on 12/9/25.
//

import SwiftUI

struct ScanlinesView: View {
    @ObservedObject private var settings = CRTSettings.shared
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                var y: CGFloat = offset
                let lineSpacing = settings.scanlineSpacing
                let lineHeight = settings.scanlineHeight
                
                while y < size.height + lineSpacing {
                    let rect = CGRect(x: 0, y: y, width: size.width, height: lineHeight)
                    context.fill(Path(rect), with: .color(.black.opacity(settings.scanlineOpacity)))
                    y += lineSpacing
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                offset = settings.scanlineSpacing
            }
        }
        .onChange(of: settings.scanlineSpacing) { _, newValue in
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                offset = newValue
            }
        }
    }
}
