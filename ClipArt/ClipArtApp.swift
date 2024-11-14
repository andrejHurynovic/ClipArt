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
    
    @State var panel: FloatingPanel<ClipsView>
    
    @Environment(\.openWindow) var openWindow
    
    init() {
        context = modelContainer.mainContext
        let appStateManager = AppStateManager(modelContext: modelContainer.mainContext)
        self.appStateManager = appStateManager
        panel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: 300, height: 400),
                              appStateManager: appStateManager) {
            ClipsView(clipboardManager: appStateManager.clipboardManager)
        }
        setupHotkeys()
    }
    
    var body: some Scene {
        MenuBarExtra {
            ClipsView(clipboardManager: appStateManager.clipboardManager)
                .modelContext(context)
        } label: {
            Image(systemName: "clipboard")
                .onChange(of: appStateManager.needToOpenWindow) {
                    panel.open()
                    appStateManager.needToOpenWindow = false
                }
        }
        .menuBarExtraStyle(.window)
    }
}
