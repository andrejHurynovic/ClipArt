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
    public let clipsStorage: ClipsStorage
    public let clipboardManager: ClipboardManager
    public let clipsViewModel: ClipsViewModel
    
    private var clipsPanel: Panel<ClipsView>!
    
    private var openListHotkey: HotKey!
    private var previousClipHotkey: HotKey!
    private var nextClipHotkey: HotKey!
    
    @MainActor init() {
        clipsStorage = ClipsStorage()
        clipboardManager = ClipboardManager(clipsStorage)
        clipsViewModel = ClipsViewModel(placement: .panel)
        
        clipsPanel = Panel(contentRect: NSRect.init(x: 0, y: 0, width: 1000, height: 500),
                                content: {
            ClipsView(clipsStorage: clipsStorage,
                      clipboardManager: clipboardManager,
                      viewModel: clipsViewModel)
        })
        setupHotkeys()
    }
    @MainActor private func openClipsView(placement: ClipsViewPlacement) async {
        clipsViewModel.placement = placement
        guard clipsPanel.isPresented == false else { return }
        clipsPanel.open()
    }
    
    //MARK: - Hotkeys
    @MainActor private func setupHotkeys() {
        let openListShortcut = KeyCombo(key: .o, modifiers: [.control, .shift])
        let previousClipShortcut = KeyCombo(key: .w, modifiers: [.control, .shift])
        let nextClipShortcut = KeyCombo(key: .s, modifiers: [.control, .shift])
        
        openListHotkey = HotKey(keyCombo: openListShortcut, keyDownHandler: { [weak self] in self?.openListHotkeyAction() })
        previousClipHotkey = HotKey(keyCombo: previousClipShortcut, keyDownHandler: { [weak self] in self?.previousClipHotkeyAction() })
        nextClipHotkey = HotKey(keyCombo: nextClipShortcut, keyDownHandler: { [weak self] in self?.nextClipHotkeyAction() })
    }
    @MainActor private func openListHotkeyAction() {
        Task { await openClipsView(placement: .panel) }
    }
    @MainActor private func previousClipHotkeyAction() {
        Task {
            await clipsStorage.selectPreviousClip()
            await openClipsView(placement: .openOnHoldPanel)
        }
    }
    @MainActor private func nextClipHotkeyAction() {
        Task {
            await clipsStorage.selectNextClip()
            await openClipsView(placement: .openOnHoldPanel)
        }
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

