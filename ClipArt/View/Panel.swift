//
//  AppStateManager.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 06.11.2024.
//

import SwiftUI

final class Panel<Content: View>: NSPanel {
    var isPresented: Bool = false
    let contentRect: NSRect
    
    init(contentRect: NSRect,
         content: () -> Content) {
        self.contentRect = contentRect
        
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
        }
        
        self.contentView = NSHostingView(rootView: contentView)
    }
    
    //MARK: Setup
    
    func open() {
        orderFrontRegardless()
        makeKey()
        
        setContentSize(contentRect.size)
        
        center()
        isPresented = true
    }
    
    override func close() {
        super.close()
        isPresented = false
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

