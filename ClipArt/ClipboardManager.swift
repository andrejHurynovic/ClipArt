//
//  ClipboardManager.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import AppKit

@Observable
class ClipboardManager: ObservableObject {
    var clips: [Clip] = []
    
    private var lastChangeCount = NSPasteboard.general.changeCount
    private let pasteboard = NSPasteboard.general
    private var currentClipIndex: Int = 0

    private let timer: DispatchSourceTimer
    private let timerInterval: DispatchTimeInterval = .milliseconds(1000)
    
    init() {
        self.timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now() + timerInterval, repeating: timerInterval)
        timer.setEventHandler { [weak self] in self?.checkClipboard() }
        timer.activate()
    }
    
    private func checkClipboard() {
        guard pasteboard.changeCount != lastChangeCount else { return }
        lastChangeCount = pasteboard.changeCount
        guard let items = pasteboard.pasteboardItems else { return }
        self.currentClipIndex = 0
        
        Task { @MainActor in
            self.clips.append(contentsOf: items.compactMap({ Clip(from: $0) }))
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
    
    func getCurrentClip() -> Clip? {
        guard !clips.isEmpty, currentClipIndex >= 0, currentClipIndex < clips.count else { return nil }
        return clips[currentClipIndex]
    }
    
    func showNextClip() {
        if currentClipIndex < clips.count - 1 {
            currentClipIndex += 1
        }
    }
    
    func showPreviousClip() {
        if currentClipIndex > 0 {
            currentClipIndex -= 1
        }
    }
    
    func resetToLatestClip() {
        currentClipIndex = 0
    }
    
    func removeCurrentClip() {
        if !clips.isEmpty, currentClipIndex >= 0, currentClipIndex < clips.count {
            clips.remove(at: currentClipIndex)
            currentClipIndex = max(0, currentClipIndex - 1)
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
    
    func pasteClip() {
        let keyVDown = CGEvent(keyboardEventSource: nil, virtualKey: 9, keyDown: true) // 'v' key
        let keyVUp = CGEvent(keyboardEventSource: nil, virtualKey: 9, keyDown: false)
        
        keyVDown?.flags = .maskCommand
        keyVUp?.flags = .maskCommand
        
        keyVDown?.post(tap: .cghidEventTap)
        keyVUp?.post(tap: .cghidEventTap)
    }
}
