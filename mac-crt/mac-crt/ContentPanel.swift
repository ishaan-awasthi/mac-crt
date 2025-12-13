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
            .fullScreenAuxiliary,
            .ignoresCycle
        ]
        
        self.setFrame(screen.frame, display: true)
        self.setFrameOrigin(screen.frame.origin)
        
        // Monitor space changes to ensure window stays visible
        setupSpaceMonitoring()
    }
    
    private func setupSpaceMonitoring() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(spaceDidChange),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func spaceDidChange() {
        // Re-show window after space change to ensure it stays visible
        DispatchQueue.main.async { [weak self] in
            self?.orderFront(nil)
            self?.level = .screenSaver
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Allow keyboard events to pass through so monitors can catch them
    override var acceptsFirstResponder: Bool {
        return false
    }
    
    override func keyDown(with event: NSEvent) {
        // Don't handle key events, let them pass through to monitors
        super.keyDown(with: event)
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
