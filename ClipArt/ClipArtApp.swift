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
            ClipsView(clipsStorage: appStateManager.clipsStorage,
                      clipboardManager: appStateManager.clipboardManager,
                      viewModel: ClipsViewModel(placement: .menuBar))
        } label: {
            Image(systemName: "clipboard")
        }
        .menuBarExtraStyle(.window)
    }
}
