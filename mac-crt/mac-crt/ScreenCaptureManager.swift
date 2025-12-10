//
//  ScreenCaptureManager.swift
//  mac-crt
//
//  Created by ishaan on 12/9/25.
//

import Foundation
import ScreenCaptureKit
import CoreImage

@MainActor
class ScreenCaptureManager: NSObject, ObservableObject {
    private var stream: SCStream?
    private var streamOutput: StreamOutput?
    @Published var currentFrame: CIImage?
    
    func startCapture(excludingWindowID: CGWindowID?) async throws {
        // Get available content
        let content = try await SCShareableContent.excludingDesktopWindows(
            false,
            onScreenWindowsOnly: true
        )
        
        guard let display = content.displays.first else {
            throw NSError(domain: "ScreenCapture", code: -1)
        }
        
        // Find windows to exclude
        var excludedWindows: [SCWindow] = []
        if let windowID = excludingWindowID {
            excludedWindows = content.windows.filter { $0.windowID == windowID }
        }
        
        // Configure stream
        let config = SCStreamConfiguration()
        config.width = Int(display.width)
        config.height = Int(display.height)
        config.minimumFrameInterval = CMTime(value: 1, timescale: 60)
        config.queueDepth = 5
        config.showsCursor = true
        
        let filter = SCContentFilter(display: display, excludingWindows: excludedWindows)
        
        stream = SCStream(filter: filter, configuration: config, delegate: nil)
        
        streamOutput = StreamOutput { [weak self] frame in
            self?.currentFrame = frame
        }
        
        try stream?.addStreamOutput(streamOutput!, type: .screen, sampleHandlerQueue: .main)
        try await stream?.startCapture()
    }
    
    func stopCapture() async throws {
        try await stream?.stopCapture()
    }
}

class StreamOutput: NSObject, SCStreamOutput {
    private let frameHandler: (CIImage) -> Void
    
    init(frameHandler: @escaping (CIImage) -> Void) {
        self.frameHandler = frameHandler
    }
    
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        frameHandler(ciImage)
    }
}
