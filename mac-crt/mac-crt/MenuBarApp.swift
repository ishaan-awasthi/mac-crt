//
//  MenuBarApp.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//

import SwiftUI

struct MenuBarApp: View {
    @State private var isToggled = false
    @State private var contentPanel: ContentPanel?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Mac-CRT")
                .font(.headline)
                
            Toggle("Enable Filter", isOn: $isToggled)
                .toggleStyle(.switch)
                .onChange(of: isToggled, initial: false) {
                    displayFilter(isToggled)
                }
        }
    }
    
    func displayFilter(_ isToggled: Bool) {
        if isToggled {
            print("reached here")
            OverlayWindowManager.shared.show()
        } else {
            OverlayWindowManager.shared.hide()
        }
    }
}

