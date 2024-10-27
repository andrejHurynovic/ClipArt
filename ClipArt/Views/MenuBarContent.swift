//MenuBarContent.swift

import SwiftUI
import Cocoa

struct MenuBarContent: View {
    @EnvironmentObject var clipboardManager: ClipboardManager
    @State private var previewWindowController: PreviewWindowController?
    @State private var isCtrlShiftPressed = false
    @State private var currentClip: Clip?
    
    var body: some View {
        VStack {
            HStack {
                // Open Clip List button can be removed if not needed
                /*Button("Open Clip List") {
                 showClipList.toggle()
                 }*/
                
                // The Clip List is now integrated into the main screen
                ClipListView()
                    .environmentObject(clipboardManager)
            }
            .onAppear {
                registerHotKeys()
            }
        }
    }
    
    func registerHotKeys() {
        let openListShortcut = UserDefaults.standard.string(forKey: "openListShortcut") ?? "Command+Shift+O"
        let previousClipShortcut = UserDefaults.standard.string(forKey: "previousClipShortcut") ?? "Control+Shift+W"
        let nextClipShortcut = UserDefaults.standard.string(forKey: "nextClipShortcut") ?? "Control+Shift+S"
        
        // Global monitor for keydown events
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains([.control, .shift]) {
                if !isCtrlShiftPressed {
                    isCtrlShiftPressed = true
                }
                
                if event.matches(shortcut: previousClipShortcut) {
                    clipboardManager.showPreviousClip()
                    showPreviewWindow()
                } else if event.matches(shortcut: nextClipShortcut) {
                    clipboardManager.showNextClip()
                    showPreviewWindow()
                }
            }
        }
        
        // Global monitor for flagsChanged to detect when control and shift are released
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { event in
            // Check if Ctrl or Shift are no longer pressed
            if isCtrlShiftPressed && !event.modifierFlags.contains(.control) && !event.modifierFlags.contains(.shift) {
                isCtrlShiftPressed = false
                closePreviewWindowAndPaste()
            }
        }
    }
    
    func showPreviewWindow() {
        if previewWindowController == nil {
            previewWindowController = PreviewWindowController()
        }
        
        if let clip = clipboardManager.getCurrentClip() {
            currentClip = clip
            previewWindowController?.updateContent(with: clip)
            previewWindowController?.showWindow()
        }
    }
    
    func closePreviewWindowAndPaste() {
        if let clip = currentClip {
            clipboardManager.insertClip(clip, withPaste: true)
        }
        
        previewWindowController?.closeWindow()
        previewWindowController = nil
    }
}

extension NSEvent {
    func matches(shortcut: String) -> Bool {
        let shortcutComponents = shortcut.split(separator: "+")
        let key = shortcutComponents.last?.lowercased()
        
        
        let keyMapping: [String: UInt16] = [
            "w": 13,  // W key
            "s": 1,   // S key
            "o": 31,  // O key
            // Add more key mappings as needed
        ]
        
        guard let keyCode = keyMapping[String(key ?? "")] else { return false }
        
        var modifierFlags: NSEvent.ModifierFlags = []
        
        if shortcut.contains("Command") {
            modifierFlags.insert(.command)
        }
        if shortcut.contains("Shift") {
            modifierFlags.insert(.shift)
        }
        if shortcut.contains("Control") {
            modifierFlags.insert(.control)
        }
        
        return self.keyCode == keyCode && self.modifierFlags.isSuperset(of: modifierFlags)
    }
}

#Preview {
    MenuBarContent()
}
