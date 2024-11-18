//
//  AppStateManager.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 06.11.2024.
//

import SwiftUI
import SwiftData
import HotKey

final class AppStateManager {
    let clipboardManager: ClipboardManager
    let clipsViewModel = ClipsViewModel()
    
    let modelContext: ModelContext
    var hotkeys: [HotKey] = []
    
    var clipsPanel: Panel<ClipsView>!
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.clipboardManager = ClipboardManager(modelContext: modelContext)
        self.clipsPanel = Panel(contentRect: NSRect.init(x: 0, y: 0, width: 1000, height: 500),
                                appStateManager: self, content: {
            ClipsView(clipboardManager: clipboardManager)
        })
    }
}

final class ClipsViewModel: ObservableObject {
    @Published var selectedClip: Clip? = nil
}
