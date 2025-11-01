//
//  mac_crtApp.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//

import SwiftUI

@main
struct mac_crtApp: App {
    var body: some Scene {
        MenuBarExtra(
            "Menu Bar Example",
            systemImage: "water.waves"
        ) {
            ContentView()
//                .overlay(alignment: .topTrailing) {
//                    Button(
//                        "Quit",
//                        systemImage: "xmark.circle.fill"
//                    ) {
//                        NSApp.terminate(nil)
//                    }
//                    .labelStyle(.iconOnly)
//                    .buttonStyle(.plain)
//                    .padding(-2)
//                }
                .frame(width: 150, height: 75)
        }.menuBarExtraStyle(.window)
    }
}
