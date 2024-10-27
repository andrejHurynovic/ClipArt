//
//  ClipArtApp.swift
//  ClipArt
//
//  Created by Artsiom Tuzin on 9.08.24.
//

import SwiftUI

@main
struct ClipArtApp: App {
    let clipboardManager = ClipboardManager()
    let clipsViewModel = ClipsViewModel()
    @Environment(\.openWindow) var openWindow
    
    init() { setupHotkeys() }
    
    var body: some Scene {
        MenuBarExtra("ClipArt", systemImage: "clipboard") {
            MenuBarContent()
                .environmentObject(clipboardManager)
        }
        .menuBarExtraStyle(.window)
        
        WindowGroup(id: "\(Bundle.main.bundleURL).preview") {
            ClipListView()
                .environmentObject(clipboardManager)
        }
    }
}

import HotKey

extension ClipArtApp {
    func setupHotkeys() {
        let openListShortcut = KeyCombo(key: .o, modifiers: [.control, .shift])
        let previousClipShortcut = KeyCombo(key: .w, modifiers: [.control, .shift])
        let nextClipShortcut = KeyCombo(key: .s, modifiers: [.control, .shift])
        clipsViewModel.hotkeys.append(contentsOf: [HotKey(keyCombo: openListShortcut, keyDownHandler: { openClipsView() }),
                                                   HotKey(keyCombo: previousClipShortcut, keyDownHandler: {}),
                                                   HotKey(keyCombo: nextClipShortcut, keyDownHandler: {})])
        
        
    }
    
    func openClipsView() {
        NSApplication.shared.activate(ignoringOtherApps: true)
        openWindow(id: "\(Bundle.main.bundleURL).preview")
    }
}
