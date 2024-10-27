//ClipboardManager.swift

import Foundation
import AppKit

class ClipboardManager: ObservableObject {
    @Published var clips: [Clip] = []
    private var lastChangeCount = NSPasteboard.general.changeCount
    private let pasteboard = NSPasteboard.general
    private var currentClipIndex: Int = 0
    private var monitoringEnabled = true
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.monitoringEnabled {
                self.checkClipboard()
            }
        }
    }
    
    private func checkClipboard() {
        if pasteboard.changeCount != lastChangeCount {
            lastChangeCount = pasteboard.changeCount
            if let items = pasteboard.pasteboardItems {
                for item in items {
                    print("Available types: \(item.types)")
                    
                    var foundContent = false
                    
                    if let text = item.string(forType: .string) {
                        let clip = Clip(content: text, type: "text")
                        DispatchQueue.main.async {
                            self.clips.insert(clip, at: 0)
                        }
                        foundContent = true
                    }
                    
                    if let tiffData = item.data(forType: .tiff),
                       let image = NSImage(data: tiffData) {
                        let clip = Clip(content: image, type: "image/tiff")
                        DispatchQueue.main.async {
                            self.clips.insert(clip, at: 0)
                        }
                        foundContent = true
                    }
                    if let pngData = item.data(forType: .png),
                       let image = NSImage(data: pngData) {
                        let clip = Clip(content: image, type: "image/png")
                        DispatchQueue.main.async {
                            self.clips.insert(clip, at: 0)
                        }
                        foundContent = true
                    }
                    
                    if let jpegData = item.data(forType: NSPasteboard.PasteboardType(rawValue: "public.jpeg")),
                       let image = NSImage(data: jpegData) {
                        let clip = Clip(content: image, type: "image/jpeg")
                        DispatchQueue.main.async {
                            self.clips.insert(clip, at: 0)
                        }
                        foundContent = true
                    }
                    
                    if !foundContent {
                        for type in item.types {
                            if let data = item.data(forType: type) {
                                let clip = Clip(content: data, type: type.rawValue)
                                DispatchQueue.main.async {
                                    self.clips.insert(clip, at: 0)
                                }
                            }
                        }
                    }
                }
                self.currentClipIndex = 0
            }
        }
    }
    
    
    func disableMonitoring() {
        monitoringEnabled = false
    }
    
    func enableMonitoring() {
        monitoringEnabled = true
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
    
    func pasteClip(_ clip: Clip) {
        disableMonitoring()
        
        // Add the clip content to the pasteboard so it can be pasted
        pasteboard.clearContents()
        
        if clip.type == "text", let text = clip.content as? String {
            pasteboard.setString(text, forType: .string)
        } else if clip.type.contains("image"), let image = clip.content as? NSImage {
            if let tiffData = image.tiffRepresentation {
                pasteboard.setData(tiffData, forType: .tiff)
            }
        } else if let data = clip.content as? Data {
            pasteboard.setData(data, forType: NSPasteboard.PasteboardType(rawValue: clip.type))
        }
        
        // Simulate Cmd + V (Paste)
        let keyVDown = CGEvent(keyboardEventSource: nil, virtualKey: 9, keyDown: true) // 'v' key
        let keyVUp = CGEvent(keyboardEventSource: nil, virtualKey: 9, keyDown: false)
        
        keyVDown?.flags = .maskCommand
        keyVUp?.flags = .maskCommand
        
        keyVDown?.post(tap: .cghidEventTap)
        keyVUp?.post(tap: .cghidEventTap)
        
        enableMonitoring()
    }
}
