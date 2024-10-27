//PreviewWindowController.swift

import Cocoa
import AppKit
import SwiftUI

class PreviewWindowController: NSWindowController {
    
    init() {
        let view = ClipView()
        let hostingController = NSHostingController(rootView: view)
        let window = NSWindow(contentViewController: hostingController)
        window.title = "ClipArt" // Set the title here
        window.styleMask = [.titled, .closable]
        window.level = .floating
        window.setFrameAutosaveName("PreviewWindow")
        
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateContent(with clip: Clip) {
        if let viewController = window?.contentViewController as? NSHostingController<ClipView> {
            viewController.rootView.clip = clip
        }
    }
    
    func showWindow() {
        window?.makeKeyAndOrderFront(nil)
    }
    
    func closeWindow() {
        window?.close()
    }
}
