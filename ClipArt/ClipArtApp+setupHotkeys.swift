//
//  ClipArtApp+setupHotkeys.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import AppKit
import HotKey

extension ClipArtApp {
    func setupHotkeys() {
        let openListShortcut = KeyCombo(key: .o, modifiers: [.control, .shift])
        let previousClipShortcut = KeyCombo(key: .w, modifiers: [.control, .shift])
        let nextClipShortcut = KeyCombo(key: .s, modifiers: [.control, .shift])
        appStateManager.hotkeys.append(contentsOf: [HotKey(keyCombo: openListShortcut, keyDownHandler: { openClipsView() }),
                                                    HotKey(keyCombo: previousClipShortcut, keyDownHandler: {}),
                                                    HotKey(keyCombo: nextClipShortcut, keyDownHandler: {})])
        
        
    }
    
    private func openClipsView() {
        appStateManager.clipsPanel.open()
    }
}


//Двонйной клик = вставить
//Когда отпускаешь c + s, то вставляется автоматически
//Сохрванение позиции после вставки по c + s
