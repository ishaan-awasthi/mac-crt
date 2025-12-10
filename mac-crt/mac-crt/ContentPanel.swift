//
//  OverlayFilter.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//


import AppKit
import SwiftUI

class ContentPanel: NSPanel {
    
    init(screen: NSScreen? = nil) {
        super.init(
            contentRect: .zero,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: true
        )
        
        setupWindow()
        setupContentView(screen: screen ?? NSScreen.main)
    }
    
    private func setupWindow() {
        backgroundColor = .clear
        isOpaque = false
        hasShadow = false
        level = .screenSaver
        isMovableByWindowBackground = false
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        ignoresMouseEvents = true
        
        collectionBehavior = [
            .canJoinAllSpaces,
            .stationary
        ]
    }
    
    private func setupContentView(screen: NSScreen?) {
        let contentView = OverlayFilterView()
        let hostingView = NSHostingView(rootView: contentView)
        self.contentView = hostingView
        
        // Make it cover the specified screen
        if let screen = screen {
            self.setFrame(screen.frame, display: true)
        }
    }
}
    
