//
//  OverlayFilterView.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//

import SwiftUI

struct OverlayFilterView: View {
    var body: some View {
        ZStack {
            // Color filter
            Color(red: 1.0, green: 0.6, blue: 0.0)
                .opacity(0.05)
            
            // Vignette
            RadialGradient(
                gradient: Gradient(colors: [
                    .clear,
                    .black.opacity(0.3)
                ]),
                center: .center,
                startRadius: 200,
                endRadius: 800
            )
            
            // Grid lines
            GridOverlay(lineSpacing: 9) // Adjust spacing for tighter/looser grid
                .stroke(Color.black.opacity(0.2), lineWidth: 0.5)
        }
        .ignoresSafeArea()
    }
}
