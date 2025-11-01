//
//  OverlayFilter.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//


import AppKit
import SwiftUI

class ContentPanel: NSPanel {
    
    init() {
        super.init(
            contentRect: .zero,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: true
        )
        
        setupWindow()
        setupContentView()
    }
    
    private func setupWindow() {
        backgroundColor = .clear
        isOpaque = false
        hasShadow = false
        level = .floating
        isMovableByWindowBackground = false
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        ignoresMouseEvents = true
        
        collectionBehavior = [
            .canJoinAllSpaces,
            .stationary
        ]
    }
    
    private func setupContentView() {
        let contentView = OverlayFilterView()
        let hostingView = NSHostingView(rootView: contentView)
        self.contentView = hostingView
        
        // Make it cover the entire screen
        if let screen = NSScreen.main {
            self.setFrame(screen.frame, display: true)
        }
    }
}
    
