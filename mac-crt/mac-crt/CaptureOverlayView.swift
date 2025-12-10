//
//  CaptureOverlayView.swift
//  mac-crt
//
//  Created by ishaan on 12/9/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct CaptureOverlayView: View {
    @StateObject private var captureManager = ScreenCaptureManager()
    @State private var windowID: CGWindowID?
    
    var body: some View {
        ZStack {
            // Captured screen with effects
            if let frame = captureManager.currentFrame {
                CaptureEffectsView(frame: frame)
            }
            
            // Color tint
            Color(red: 1.0, green: 0.6, blue: 0.0)
                .opacity(0.15)
            
            // Vignette
            RadialGradient(
                gradient: Gradient(colors: [
                    .clear,
                    .black.opacity(0.3)
                ]),
                center: .center,
                startRadius: 200,
                endRadius: 800
            )
            
            // Grid lines
            GridOverlay(lineSpacing: 3)
                .stroke(Color.black.opacity(0.2), lineWidth: 0.5)
            
            // Animated scanlines
            ScanlinesView()
        }
        .ignoresSafeArea()
        .background(WindowAccessor(windowID: $windowID))
        .task {
            // Wait a bit for window ID to be set
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            
            do {
                try await captureManager.startCapture(excludingWindowID: windowID)
            } catch {
                print("Failed to start capture: \(error)")
            }
        }
    }
}

// Helper to get window ID
struct WindowAccessor: NSViewRepresentable {
    @Binding var windowID: CGWindowID?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                windowID = CGWindowID(window.windowNumber)
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

struct CaptureEffectsView: NSViewRepresentable {
    let frame: CIImage
    
    func makeNSView(context: Context) -> EffectsView {
        return EffectsView()
    }
    
    func updateNSView(_ nsView: EffectsView, context: Context) {
        nsView.updateFrame(frame)
    }
}

class EffectsView: NSView {
    private let ciContext = CIContext()
    private var currentFrame: CIImage?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        self.canDrawConcurrently = true
        self.layerContentsRedrawPolicy = .duringViewResize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFrame(_ frame: CIImage) {
        currentFrame = frame
        needsDisplay = true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard let context = NSGraphicsContext.current?.cgContext,
              let frame = currentFrame else { return }
        
        // Apply bloom filter
        let bloom = CIFilter.bloom()
        bloom.inputImage = frame
        bloom.radius = 10
        bloom.intensity = 0.5
        
        guard var outputImage = bloom.outputImage else { return }
        
        // Apply barrel distortion (bulge effect) for CRT curve
        if let bulgeFilter = CIFilter(name: "CIBumpDistortion") {
            let center = CIVector(x: frame.extent.width / 2, y: frame.extent.height / 2)
            let radius = max(frame.extent.width, frame.extent.height) * 0.9
            
            bulgeFilter.setValue(outputImage, forKey: kCIInputImageKey)
            bulgeFilter.setValue(center, forKey: kCIInputCenterKey)
            bulgeFilter.setValue(radius, forKey: kCIInputRadiusKey)
            bulgeFilter.setValue(0.23, forKey: kCIInputScaleKey) // CHANGE THIS
            
            if let bulged = bulgeFilter.outputImage {
                outputImage = bulged
            }
        }
        
        // Scale up to fill screen after distortion
        let scaleTransform = CGAffineTransform(scaleX: 0.93, y: 0.85) // CHANGE THESE
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2
        
        outputImage = outputImage
            .transformed(by: CGAffineTransform(translationX: -centerX, y: -centerY))
            .transformed(by: scaleTransform)
            .transformed(by: CGAffineTransform(translationX: centerX, y: centerY))
        
        if let cgImage = ciContext.createCGImage(outputImage, from: frame.extent) {
            context.draw(cgImage, in: bounds)
        }
    }
}
