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
            MenuBarApp()
        }.menuBarExtraStyle(.window)
    }
}
