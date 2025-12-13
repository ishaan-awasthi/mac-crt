//
//  OverlayWindowManager.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//

import SwiftUI
import AppKit
import Carbon.HIToolbox

class OverlayWindowManager: ObservableObject {
    static let shared = OverlayWindowManager()
    private var panel: ContentPanel?
    private var localMonitor: Any?
    private var globalMonitor: Any?
    private var eventHandler: EventHandlerRef?
    private var hotKeyID: EventHotKeyID?
    private var hotKeyRef: EventHotKeyRef?
    @Published var isShowing: Bool = false
    
    private init() {
        // Register Command+Esc hotkey immediately so it works even when filter is off
        registerCommandEscHotkey()
    }
    
    func show() {
        guard let mainScreen = NSScreen.main else { return }
        
        let newPanel = ContentPanel(screen: mainScreen)
        newPanel.orderFront(nil)
        NSCursor.hide()
        panel = newPanel
        isShowing = true
        
        startKeyMonitoring()
    }

    func hide() {
        panel?.orderOut(nil)
        panel = nil
        NSCursor.unhide()
        isShowing = false
        
        stopKeyMonitoring()
    }
    
    func toggle() {
        if isShowing {
            hide()
        } else {
            show()
        }
    }
    
    private func startKeyMonitoring() {
        // Use local event monitor for regular Escape
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.keyCode == 53 && !event.modifierFlags.contains(.command) {
                // Regular Escape (without Command)
                self?.hide()
                return nil // Consume the event
            }
            return event
        }
        
        // Also add global monitor as backup for regular Escape
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.keyCode == 53 && !event.modifierFlags.contains(.command) {
                // Regular Escape
                self?.hide()
            }
        }
    }
    
    private func registerCommandEscHotkey() {
        // Create hotkey ID
        var hotKeyID = EventHotKeyID()
        // Convert "CRTE" string to FourCharCode
        let signature: FourCharCode = (FourCharCode("C".utf8.first!) << 24) |
                                      (FourCharCode("R".utf8.first!) << 16) |
                                      (FourCharCode("T".utf8.first!) << 8) |
                                      FourCharCode("E".utf8.first!)
        hotKeyID.signature = signature
        hotKeyID.id = 1
        self.hotKeyID = hotKeyID
        
        // Register the hotkey: Command+Esc
        var hotKeyRef: EventHotKeyRef?
        let modifiers = UInt32(cmdKey) // Command key
        let keyCode = UInt32(kVK_Escape) // Escape key
        
        let status = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )
        
        if status == noErr, let ref = hotKeyRef {
            self.hotKeyRef = ref
            
            // Install event handler
            var eventType = EventTypeSpec(
                eventClass: OSType(kEventClassKeyboard),
                eventKind: UInt32(kEventHotKeyPressed)
            )
            
            InstallEventHandler(
                GetApplicationEventTarget(),
                { (nextHandler, theEvent, userData) -> OSStatus in
                    var hotKeyID = EventHotKeyID()
                    let err = GetEventParameter(
                        theEvent,
                        EventParamName(kEventParamDirectObject),
                        EventParamType(typeEventHotKeyID),
                        nil,
                        MemoryLayout<EventHotKeyID>.size,
                        nil,
                        &hotKeyID
                    )
                    
                    if err == noErr {
                        let manager = Unmanaged<OverlayWindowManager>.fromOpaque(userData!).takeUnretainedValue()
                        // Toggle the filter
                        manager.toggle()
                    }
                    
                    return noErr
                },
                1,
                &eventType,
                Unmanaged.passUnretained(self).toOpaque(),
                &eventHandler
            )
        }
    }
    
    private func stopKeyMonitoring() {
        // Don't remove Carbon hotkey - keep it registered so Command+Esc can toggle filter on
        // Only remove NSEvent monitors for regular Escape
        if let monitor = localMonitor {
            NSEvent.removeMonitor(monitor)
            localMonitor = nil
        }
        if let monitor = globalMonitor {
            NSEvent.removeMonitor(monitor)
            globalMonitor = nil
        }
    }
}
