//
//  MenuBarApp.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//

import SwiftUI

struct MenuBarApp: View {
    @ObservedObject private var windowManager = OverlayWindowManager.shared
    @ObservedObject private var settings = CRTSettings.shared
    @State private var isHoveringQuit = false
    @State private var isHoveringReset = false
    @State private var expandedSections: Set<String> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                HStack {
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
                    
                    Spacer()
                    
                    Text("(⌘ + esc)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                
                Divider()
                    .padding(.vertical, 4)
                
                // Color & Tint Settings
                collapsibleSection(title: "Color & Tint") {
                    sliderRow(title: "Tint Opacity", value: $settings.tintOpacity, range: 0...1)
                }
                
                // Vignette Settings
                collapsibleSection(title: "Vignette") {
                    sliderRow(title: "Vignette Opacity", value: $settings.vignetteOpacity, range: 0...1)
                }
                
                // Grid Settings
                collapsibleSection(title: "Grid") {
                    sliderRow(title: "Grid Spacing", value: $settings.gridSpacing, range: 1...20)
                    sliderRow(title: "Grid Opacity", value: $settings.gridOpacity, range: 0...1)
                }
                
                // Bloom Settings
                collapsibleSection(title: "Bloom") {
                    sliderRow(title: "Bloom Radius", value: $settings.bloomRadius, range: 0...50)
                    sliderRow(title: "Bloom Intensity", value: $settings.bloomIntensity, range: 0...2)
                }
                
                // Distortion Settings
                collapsibleSection(title: "Distortion") {
                    sliderRow(title: "Distortion Scale", value: $settings.distortionScale, range: -0.5...0.5)
                    sliderRow(title: "Scale X", value: $settings.scaleX, range: 0.5...1.5)
                    sliderRow(title: "Scale Y", value: $settings.scaleY, range: 0.5...1.5)
                }
                
                // Scanlines Settings
                collapsibleSection(title: "Scanlines") {
                    sliderRow(title: "Line Spacing", value: $settings.scanlineSpacing, range: 2...20)
                    sliderRow(title: "Line Height", value: $settings.scanlineHeight, range: 1...10)
                    sliderRow(title: "Line Opacity", value: $settings.scanlineOpacity, range: 0...1)
                }
            
            Divider()
                .padding(.vertical, 4)
            
                // Reset Settings Button
                menuItemButton(title: "Reset Settings", isHovering: $isHoveringReset) {
                    settings.reset()
                }
                
                // Quit Button
                menuItemButton(title: "Quit", isHovering: $isHoveringQuit) {
                NSApp.terminate(nil)
            }
        }
        .padding(.vertical, 6)
        .frame(width: 300)
    }
    
    @ViewBuilder
    private func collapsibleSection<Content: View>(title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        let isExpanded = Binding(
            get: { expandedSections.contains(title) },
            set: { isExpanded in
                if isExpanded {
                    expandedSections.insert(title)
                } else {
                    expandedSections.remove(title)
                }
            }
        )
        
        DisclosureGroup(isExpanded: isExpanded) {
            content()
                .padding(.top, 4)
        } label: {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isExpanded.wrappedValue.toggle()
            }
        }
        .padding(.horizontal, 12)
    }
    
    @ViewBuilder
    private func sliderRow(title: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
                Spacer()
                Text(String(format: "%.2f", value.wrappedValue))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            
            Slider(value: value, in: range)
                .padding(.horizontal, 12)
        }
        .padding(.vertical, 2)
    }
    
    @ViewBuilder
    private func menuItemButton(title: String, isHovering: Binding<Bool>, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isHovering.wrappedValue ? Color.gray.opacity(0.2) : Color.clear)
        )
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovering.wrappedValue = hovering
        }
    }
}
