//
//  GridOverlay.swift
//  mac-crt
//
//  Created by ishaan on 12/9/25.
//

import SwiftUI

struct GridOverlay: Shape {
    let lineSpacing: CGFloat // Distance between lines
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Vertical lines
        var x: CGFloat = 0
        while x <= rect.width {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
            x += lineSpacing
        }
        
        // Horizontal lines
        var y: CGFloat = 0
        while y <= rect.height {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
            y += lineSpacing
        }
        
        return path
    }
}
