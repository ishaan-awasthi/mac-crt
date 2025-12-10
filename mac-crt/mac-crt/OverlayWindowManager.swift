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
    private var panels: [ContentPanel] = []
    
    func show() {
        // Create panels for all screens
        for screen in NSScreen.screens {
            let panel = ContentPanel(screen: screen)
            panel.makeKeyAndOrderFront(nil)
            panels.append(panel)
        }
    }

    func hide() {
        for panel in panels {
            panel.orderOut(nil)
        }
        panels.removeAll()
    }
}
