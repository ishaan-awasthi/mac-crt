//
//  ContentView.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//

import SwiftUI

struct ContentView: View {
    @State private var displayFilter = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Mac-CRT")
                .font(.headline)
                
            Toggle("Enable Filter", isOn: $displayFilter)
                .toggleStyle(.switch)
        }
    }
}
