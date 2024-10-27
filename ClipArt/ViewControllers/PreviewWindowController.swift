//PreviewWindowController.swift

import Cocoa
import SwiftUI

class PreviewWindowController: NSWindowController {
    
    init() {
        let view = PreviewContentView()
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
        if let viewController = window?.contentViewController as? NSHostingController<PreviewContentView> {
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

struct PreviewContentView: View {
    var clip: Clip?
var body: some View {
        VStack {
            if let clip = clip {
                if clip.type == "text" {
                    Text(clip.content as? String ?? "")
                        .padding()
                        .frame(width: 300, height: 200)
                } else if clip.type.contains("image"), let image = clip.content as? NSImage {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 200)
                } else if let data = clip.content as? Data {
                    Text("Data: \(clip.type)")
                        .padding()
                        .frame(width: 300, height: 200)
                } else {
                    Text("Unsupported content")
                        .padding()
                        .frame(width: 300, height: 200)
                }
            } else {
                Text("No clip to preview")
                    .padding()
                    .frame(width: 300, height: 200)
            }
        }
    }
}
