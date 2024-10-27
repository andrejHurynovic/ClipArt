//  ClipArtApp.swift
//  ClipArt
//
//  Created by Artsiom Tuzin on 9.08.24.
//

import SwiftUI

@main
struct ClipArtApp: App {
    var body: some Scene {
        MenuBarExtra("ClipArt", systemImage: "clipboard") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}
