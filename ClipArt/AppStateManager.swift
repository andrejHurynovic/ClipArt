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
    @ObservationIgnored let clipboardManager: ClipboardManager
    @ObservationIgnored let clipsViewMode = ClipsViewModel()
    
    @ObservationIgnored let modelContext: ModelContext
    @ObservationIgnored var hotkeys: [HotKey] = []
    
    var needToOpenWindow = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.clipboardManager = ClipboardManager(modelContext: modelContext)
    }
}

@Observable
final class ClipsViewModel {
    var selectedClip: State<Clip?> = .init(initialValue: nil)
}
