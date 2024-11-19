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
    let modelContainer = try! ModelContainer(for: Clip.self)
    let context: ModelContext
    
    @State var appStateManager: AppStateManager
    
    init() {
        context = modelContainer.mainContext
        appStateManager = AppStateManager(modelContext: modelContainer.mainContext)
    }
    
    var body: some Scene {
        MenuBarExtra {
            ClipsView(clipboardManager: appStateManager.clipboardManager, clipsStorage: appStateManager.clipsStorage, viewModel: appStateManager.clipsViewModel)
                .modelContext(context)
        } label: {
            Image(systemName: "clipboard")
        }
        .menuBarExtraStyle(.window)
    }
}
