//
//  ClipArtApp.swift
//  ClipArt
//
//  Created by Artsiom Tuzin on 9.08.24.
//

import SwiftUI

@main
struct ClipArtApp: App {
    let clipboardManager = ClipboardManager()
    let clipsViewModel = ClipsViewModel()
    @Environment(\.openWindow) var openWindow
    
    init() {
        clipsViewModel.openWindowAction = openWindow
    }
    
    var body: some Scene {
        MenuBarExtra("ClipArt", systemImage: "clipboard") {
            MenuBarContent()
                .environmentObject(clipboardManager)
        }
        .menuBarExtraStyle(.window)
        
        WindowGroup(id: "\(Bundle.main.bundleURL).preview") {
            ClipListView()
                .environmentObject(clipboardManager)
        }
    }
}

