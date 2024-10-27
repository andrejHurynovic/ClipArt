//
//  ClipsViewModel.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI
import HotKey

@Observable
class ClipsViewModel: ObservableObject {
    var hotkeys: [HotKey] = []
//    {
//        let openListShortcut = "Control+Shift+O"
//        let previousClipShortcut = UserDefaults.standard.string(forKey: "previousClipShortcut") ?? "Control+Shift+W"
//        let nextClipShortcut = UserDefaults.standard.string(forKey: "nextClipShortcut") ?? "Control+Shift+S"
//        
//        // Global monitor for keydown events
//        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
//            guard let self = self else { return }
//            if event.modifierFlags.contains([.control, .shift]) {
//                if !self.isCtrlShiftPressed {
//                    self.isCtrlShiftPressed = true
//                }
//                
//                if event.matches(shortcut: openListShortcut) {
//                    openWindow()
//                    return
//                }
//                if event.matches(shortcut: previousClipShortcut) {
////                    clipboardManager.showPreviousClip()
////                    showPreviewWindow()
//                    return
//                }
//                if event.matches(shortcut: nextClipShortcut) {
////                    clipboardManager.showNextClip()
////                    showPreviewWindow()
//                    return
//                }
//            }
//        }
//        
//        // Global monitor for flagsChanged to detect when control and shift are released
//        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
//            guard let self = self else { return }
//            // Check if Ctrl or Shift are no longer pressed
//            if self.isCtrlShiftPressed && !event.modifierFlags.contains(.control) && !event.modifierFlags.contains(.shift) {
//                self.isCtrlShiftPressed = false
////                closePreviewWindowAndPaste()
//            }
//        }
//    }
}
