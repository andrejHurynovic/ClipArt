//
//  ClipArtApp.swift
//  ClipArt
//
//  Created by Artsiom Tuzin on 9.08.24.
//

import SwiftUI
import SwiftData

@main
struct ClipArtApp: App {
    @State var appStateManager = AppStateManager()
    
    var body: some Scene {
        MenuBarExtra {
            ClipsView(clipboardManager: appStateManager.clipboardManager, clipsStorage: appStateManager.clipsStorage, viewModel: appStateManager.clipsViewModel)
        } label: {
            Image(systemName: "clipboard")
        }
        .menuBarExtraStyle(.window)
    }
}
