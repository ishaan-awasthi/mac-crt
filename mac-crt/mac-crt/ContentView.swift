//
//  ContentView.swift
//  mac-crt
//
//  Created by ishaan on 10/31/25.
//

import SwiftUI

struct ContentView : View {
    var dismiss: () -> ()
    
    var body : some View {
        VStack {
            Button {
                self.dismiss()
            } label: {
                Image(systemName: "xmark")
            }
            Image(systemName: "water.waves")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello world!")
        }
        .padding()
    }
}
