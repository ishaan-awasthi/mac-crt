//
//  CRTSettings.swift
//  mac-crt
//
//  Created by ishaan on 12/9/25.
//

import SwiftUI
import Combine

class CRTSettings: ObservableObject {
    static let shared = CRTSettings()
    
    // Default values (current hardcoded values)
    @Published var tintOpacity: Double = 0.1
    @Published var vignetteOpacity: Double = 0.3
    @Published var gridSpacing: Double = 3.0
    @Published var gridOpacity: Double = 0.2
    @Published var bloomRadius: Double = 10.0
    @Published var bloomIntensity: Double = 0.5
    @Published var distortionScale: Double = 0.1
    @Published var scaleX: Double = 0.93
    @Published var scaleY: Double = 0.85
    @Published var scanlineSpacing: Double = 6.0
    @Published var scanlineHeight: Double = 2.0
    @Published var scanlineOpacity: Double = 0.3
    
    private init() {}
    
    func reset() {
        tintOpacity = 0.1
        vignetteOpacity = 0.3
        gridSpacing = 3.0
        gridOpacity = 0.2
        bloomRadius = 10.0
        bloomIntensity = 0.5
        distortionScale = 0.1
        scaleX = 0.93
        scaleY = 0.85
        scanlineSpacing = 6.0
        scanlineHeight = 2.0
        scanlineOpacity = 0.3
    }
}

