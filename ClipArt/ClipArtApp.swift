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
    let clipboardManager: ClipboardManager
    let clipsViewModel = ClipsViewModel()
    let modelContainer = try! ModelContainer(for: Clip.self)
    let context: ModelContext
    
    @Environment(\.openWindow) var openWindow
    
    init() {
        context = modelContainer.mainContext
        clipboardManager = ClipboardManager(modelContext: self.context)
        setupHotkeys() }
    
    var body: some Scene {
        MenuBarExtra("ClipArt", systemImage: "clipboard") {
            MenuBarContent()
                .modelContext(context)
                .environment(clipboardManager)
        }
        .menuBarExtraStyle(.window)
        
        WindowGroup(id: "\(Bundle.main.bundleURL).preview") {
            ClipsView()
                .modelContext(context)
                .environment(clipboardManager)
        }
    }
}
