import SwiftUI

class FloatingPanel<Content: View>: NSPanel {
    init(contentRect: NSRect,
         appStateManager: AppStateManager,
         content: () -> Content) {
        
        super.init(
            contentRect: contentRect,
            styleMask: [.nonactivatingPanel, .titled, .resizable, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        
        contentView = NSHostingView(
            rootView: content()
                .modelContext(appStateManager.modelContext))
    }
    func open() {
        setContentSize(NSSize(width: 300, height: 400))
        
        center()
        
        orderFrontRegardless()
        makeKey()
    }
    
    override func resignKey() {
        super.resignKey()
        close()
    }
}
