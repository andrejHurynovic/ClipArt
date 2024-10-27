//
//  NSEvent+matches.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import AppKit

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
