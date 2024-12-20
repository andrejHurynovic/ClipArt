//
//  ClipboardManager.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import AppKit
import SwiftData

@MainActor
final class ClipboardManager {
    private let pasteboard = NSPasteboard.general
    
    private var lastPasteboardItemString: String?
    private var lastChangeCount = NSPasteboard.general.changeCount
    
    private let timer: DispatchSourceTimer
    private let timerInterval: DispatchTimeInterval = .milliseconds(1000)
    
    private let clipsStorage: ClipsStorage
    
    init(_ clipsStorage: ClipsStorage) {
        self.clipsStorage = clipsStorage
        
        lastPasteboardItemString = pasteboard.pasteboardItems?.first?.string(forType: .string)
        
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now() + timerInterval, repeating: timerInterval, leeway: .milliseconds(500))
        timer.setEventHandler { [weak self] in self?.checkClipboard() }
        timer.activate()
    }
    
    //MARK: Clipboard actions
    private func checkClipboard() {
        Task {
            guard pasteboard.changeCount != lastChangeCount else { return }
            lastChangeCount = pasteboard.changeCount
            
            guard let items = pasteboard.pasteboardItems,
                  lastPasteboardItemString != items.first?.string(forType: .string) else { return }
            lastPasteboardItemString = items.first?.string(forType: .string)
            
            let clips = items.compactMap { Clip(from: $0) }
            for clip in clips {
                clipsStorage.insert(clip)
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
    
    nonisolated func pasteClip() {
        Task {
            let source = CGEventSource(stateID: .combinedSessionState)
            // Disable local keyboard events while pasting
            source?.setLocalEventsFilterDuringSuppressionState([.permitLocalMouseEvents, .permitSystemDefinedEvents],
                                                               state: .eventSuppressionStateSuppressionInterval)
            
            let keyVDown = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: true)
            let keyVUp = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: false)
            
            keyVDown?.flags = .maskCommand
            keyVUp?.flags = .maskCommand
            
            keyVDown?.post(tap: .cghidEventTap)
            keyVUp?.post(tap: .cghidEventTap)
        }
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
