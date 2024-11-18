//
//  AppStateManager.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 06.11.2024.
//

import SwiftUI

final class Panel<Content: View>: NSPanel {
    let contentRect: NSRect
    let appStateManager: AppStateManager
    
    init(contentRect: NSRect,
         appStateManager: AppStateManager,
         content: () -> Content) {
        self.contentRect = contentRect
        self.appStateManager = appStateManager
        
        super.init(
            contentRect: contentRect,
            styleMask: [.nonactivatingPanel, .titled, .resizable, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        
        isFloatingPanel = true
        level = .floating
        
        collectionBehavior.insert(.fullScreenAuxiliary)
        
        animationBehavior = .none
        backgroundColor = .clear
       
        let contentView = ZStack {
            VisualEffectView(material: .popover)
                .ignoresSafeArea()
            content()
                .modelContext(appStateManager.modelContext)
        }
        
        self.contentView = NSHostingView(rootView: contentView)
    }
    
    //MARK: Setup
    
    func open() {
        orderFrontRegardless()
        makeKey()
        
        setContentSize(contentRect.size)
        
        center()
    }
    
    override func resignKey() {
        super.resignKey()
        close()
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
}
