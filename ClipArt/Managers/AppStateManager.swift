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
    public let modelContext: ModelContext
    
    public let clipsStorage: ClipsStorage
    public let clipboardManager: ClipboardManager
    public let clipsViewModel = ClipsViewModel()
    
    private var clipsPanel: Panel<ClipsView>!
    
    private var openListHotkey: HotKey!
    private var previousClipHotkey: HotKey!
    private var nextClipHotkey: HotKey!
    
    @MainActor init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.clipsStorage = ClipsStorage(modelContext)
        self.clipboardManager = ClipboardManager(clipsStorage)
        
        self.clipsPanel = Panel(contentRect: NSRect.init(x: 0, y: 0, width: 1000, height: 500),
                                appStateManager: self, content: {
            ClipsView(clipboardManager: clipboardManager, clipsStorage: clipsStorage, viewModel: clipsViewModel)
        })
        setupHotkeys()
    }
    
    //MARK: - Hotkeys
    private func setupHotkeys() {
        let openListShortcut = KeyCombo(key: .o, modifiers: [.control, .shift])
        let previousClipShortcut = KeyCombo(key: .w, modifiers: [.control, .shift])
        let nextClipShortcut = KeyCombo(key: .s, modifiers: [.control, .shift])
        
        openListHotkey = HotKey(keyCombo: openListShortcut, keyDownHandler: { [weak self] in self?.openClipsView() })
        previousClipHotkey = HotKey(keyCombo: previousClipShortcut, keyDownHandler: {})
        nextClipHotkey = HotKey(keyCombo: nextClipShortcut, keyDownHandler: {})
    }
    
    private func openClipsView() {
        clipsPanel.open()
    }
    private func pausePreviousAndNextClipHotkeys() {
        previousClipHotkey.isPaused = true
        nextClipHotkey.isPaused = true
    }
    public func unpausePreviousAndNextClipHotkeys() {
        previousClipHotkey.isPaused = false
        nextClipHotkey.isPaused = false
    }
}

