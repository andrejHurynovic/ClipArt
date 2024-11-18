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
    
    private func setupHotkeys() {
        let openListShortcut = KeyCombo(key: .o, modifiers: [.control, .shift])
        let previousClipShortcut = KeyCombo(key: .w, modifiers: [.control, .shift])
        let nextClipShortcut = KeyCombo(key: .s, modifiers: [.control, .shift])
        hotkeys.append(contentsOf: [HotKey(keyCombo: openListShortcut, keyDownHandler: { [weak self] in self?.openClipsView() }),
                                                    HotKey(keyCombo: previousClipShortcut, keyDownHandler: {}),
                                                    HotKey(keyCombo: nextClipShortcut, keyDownHandler: {})])
    }
    
    private func openClipsView() {
        clipsPanel.open()
    }
}

