//
//  OverlayWindowManager.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//

import SwiftUI

class OverlayWindowManager: ObservableObject {
    static let shared = OverlayWindowManager()
    private var panel: ContentPanel?
    
    func show() {
        if panel == nil {
            panel = ContentPanel()
        }
        panel?.makeKeyAndOrderFront(nil)
    }

    func hide() {
        panel?.orderOut(nil)
    }
}
