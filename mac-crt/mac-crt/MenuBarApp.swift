//
//  MenuBarApp.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//

import SwiftUI

struct MenuBarApp: View {
    @ObservedObject private var windowManager = OverlayWindowManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn: Binding(
                get: { windowManager.isShowing },
                set: { newValue in
                    if newValue {
                        windowManager.show()
                    } else {
                        windowManager.hide()
                    }
                }
            )) {
                Text("Enable Filter")
            }
            .toggleStyle(.switch)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            
            Divider()
                .padding(.vertical, 4)
            
            menuItemButton(title: "Quit") {
                NSApp.terminate(nil)
            }
        }
        .padding(.vertical, 6)
        .frame(minWidth: 110)
        .fixedSize()
    }
    
    @ViewBuilder
    private func menuItemButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)
    }
}
