//  ClipArtApp.swift
//  ClipArt
//
//  Created by Artsiom Tuzin on 9.08.24.
//

import SwiftUI

@main
struct ClipArtApp: App {
    var body: some Scene {
        let clipboardManager = ClipboardManager()
        
        MenuBarExtra("ClipArt", systemImage: "clipboard") {
            MenuBarContent()
                .environmentObject(clipboardManager)
        }
        .menuBarExtraStyle(.window)
    }
}
