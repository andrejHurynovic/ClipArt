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
    @State var appStateManager: AppStateManager
    let modelContainer = try! ModelContainer(for: Clip.self)
    let context: ModelContext
    
    @Environment(\.openWindow) var openWindow
    
    init() {
        context = modelContainer.mainContext
        appStateManager = AppStateManager(modelContext: modelContainer.mainContext)
        setupHotkeys()
    }
    
    var body: some Scene {
        MenuBarExtra {
            MenuBarContent()
                .modelContext(context)
                .environment(appStateManager.clipboardManager)
        } label: {
            Image(systemName: "clipboard")
                .onChange(of: appStateManager.needToOpenWindow) {
                    if appStateManager.needToOpenWindow, !appStateManager.isPopoverPresented {
                        openWindow(id: Constants.popoverWindowGroupID)
                    }
                    appStateManager.needToOpenWindow = false
                }
        }
        .menuBarExtraStyle(.window)
        
        WindowGroup(id: Constants.popoverWindowGroupID) {
            ClipsPopoverView()
                .modelContext(context)
                .environment(appStateManager)
        }
        .windowLevel(.floating)
    }
}
