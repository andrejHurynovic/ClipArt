//
//  AppStateManager.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 06.11.2024.
//

import SwiftUI
import SwiftData
import HotKey

@Observable
final class AppStateManager {
    let clipboardManager: ClipboardManager
    
    var hotkeys: [HotKey] = []
    
    var isPopoverPresented = false
    var needToOpenWindow = false
    
    init(modelContext: ModelContext) {
        self.clipboardManager = ClipboardManager(modelContext: modelContext)
    }
}
