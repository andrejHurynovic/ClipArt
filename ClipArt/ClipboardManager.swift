//
//  ClipboardManager.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import AppKit
import SwiftData

@Observable
final class ClipboardManager {
    private var lastChangeCount = NSPasteboard.general.changeCount
    private let pasteboard = NSPasteboard.general
    private var currentClipIndex: Int = 0
    
    private let timer: DispatchSourceTimer
    private let timerInterval: DispatchTimeInterval = .milliseconds(1000)
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now() + timerInterval, repeating: timerInterval)
        timer.setEventHandler { [weak self] in self?.checkClipboard() }
        timer.activate()
    }
    
    //MARK: Clipboard actions
    private func checkClipboard() {
        guard pasteboard.changeCount != lastChangeCount else { return }
        lastChangeCount = pasteboard.changeCount
        guard let items = pasteboard.pasteboardItems else { return }
        self.currentClipIndex = 0
        
        Task { @MainActor in
            let clips = items.compactMap { Clip(from: $0) }
            try! modelContext.transaction {
                clips.forEach { clip in
                    modelContext.insert(clip)
                }
            }
        }
    }
    
    func insertClip(_ clip: Clip, withPaste: Bool) {
        pasteboard.prepareForNewContents()
        pasteboard.clearContents()
        
        disableMonitoring()
        
        pasteboard.setData(clip.content, forType: clip.type)
        
        enableMonitoring()
        
        if withPaste {
            pasteClip()
        }
    }
    private func pasteClip() {
        let keyVDown = CGEvent(keyboardEventSource: nil, virtualKey: 9, keyDown: true) // 'v' key
        let keyVUp = CGEvent(keyboardEventSource: nil, virtualKey: 9, keyDown: false)
        
        keyVDown?.flags = .maskCommand
        keyVUp?.flags = .maskCommand
        
        keyVDown?.post(tap: .cghidEventTap)
        keyVUp?.post(tap: .cghidEventTap)
    }
    
    //MARK: Monitoring state
    private func disableMonitoring() {
        timer.suspend()
    }
    
    private func enableMonitoring() {
        timer.resume()
        lastChangeCount = pasteboard.changeCount
    }

}
