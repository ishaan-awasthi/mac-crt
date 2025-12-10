//
//  ContentPanel.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//

import AppKit
import SwiftUI

class ContentPanel: NSPanel {
    
    init(screen: NSScreen) {
        super.init(
            contentRect: screen.frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        setupWindow(for: screen)
        setupContentView()
    }
    
    private func setupWindow(for screen: NSScreen) {
        backgroundColor = .black
        isOpaque = true
        hasShadow = false
        level = .screenSaver
        isMovableByWindowBackground = false
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        ignoresMouseEvents = true
        
        collectionBehavior = [
            .canJoinAllSpaces,
            .stationary,
            .fullScreenAuxiliary
        ]
        
        self.setFrame(screen.frame, display: true)
        self.setFrameOrigin(screen.frame.origin)
    }
    
    private func setupContentView() {
        let contentView = OverlayFilterView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
        
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.autoresizingMask = [.width, .height]
        self.contentView = hostingView
    }
}
