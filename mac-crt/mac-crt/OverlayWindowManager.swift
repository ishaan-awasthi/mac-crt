//
//  OverlayWindowManager.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//

import SwiftUI
import AppKit

class OverlayWindowManager: ObservableObject {
    static let shared = OverlayWindowManager()
    private var panel: ContentPanel?
    private var eventMonitor: Any?
    @Published var isShowing: Bool = false
    
    func show() {
        guard let mainScreen = NSScreen.main else { return }
        
        let newPanel = ContentPanel(screen: mainScreen)
        newPanel.orderFront(nil)
        NSCursor.hide()
        panel = newPanel
        isShowing = true
        
        startKeyMonitoring()
    }

    func hide() {
        panel?.orderOut(nil)
        panel = nil
        NSCursor.unhide()
        isShowing = false
        
        stopKeyMonitoring()
    }
    
    private func startKeyMonitoring() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.keyCode == 53 { // Escape key
                self?.hide()
            }
        }
    }
    
    private func stopKeyMonitoring() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
}
