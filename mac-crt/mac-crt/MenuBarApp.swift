//
//  MenuBarApp.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//
import SwiftUI

struct MenuBarApp: View {
    @State private var isToggled = false
    @State private var hoveringQuit = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // === Section 1 ===
            Toggle(isOn: $isToggled) {
                Text("Enable Filter")
            }
            .toggleStyle(.switch)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .onChange(of: isToggled) { _, newValue in
                displayFilter(newValue)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // === Quit Button ===
            menuItemButton(title: "Quit") {
                // Clean up overlay windows before quitting
                OverlayWindowManager.shared.hide()
                NSApp.terminate(nil)
            }
        }
        .padding(.vertical, 6)
        .frame(maxWidth: 150) // Standard for compact popovers
    }
    
    
    // MARK: - Menu Item Styling
    @ViewBuilder
    private func menuItemButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(hoveringQuit ? Color(NSColor.gray).opacity(0.5) : .clear)
        )
        .onHover { hovering in
            hoveringQuit = hovering
        }
    }
    
    
    // MARK: - Filter Toggle Logic
    private func displayFilter(_ enabled: Bool) {
        if enabled {
            OverlayWindowManager.shared.show()
        } else {
            OverlayWindowManager.shared.hide()
        }
    }
}
