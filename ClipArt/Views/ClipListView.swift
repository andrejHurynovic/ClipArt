//ClipListView.swift

import SwiftUI

struct ClipListView: View {
    @ObservedObject var clipboardManager: ClipboardManager
    @State private var selectedClipID: UUID? = nil
    
    var body: some View {
        VStack {
            List(clipboardManager.clips, id: \.id, selection: $selectedClipID) { clip in
                VStack(alignment: .leading) {
                    if clip.type == "text" {
                        Text(clip.content as? String ?? "Unknown content")
                    } else if clip.type.contains("image") {
                        if let image = clip.content as? NSImage {
                            Image(nsImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        } else {
                            Text("Image content unavailable")
                        }
                    } else if let data = clip.content as? Data {
                        Text("Data of type: \(clip.type)")
                    } else {
                        Text("Unsupported content")
                    }
                }
                .contentShape(Rectangle()) // Make the whole item clickable
                .onTapGesture {
                    selectedClipID = clip.id
                }
            }
            .onAppear {
                registerCopyShortcut()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
        }
    }
    
    private func registerCopyShortcut() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains(.command) && event.keyCode == 8 { // Command + C
                if let selectedClip = clipboardManager.clips.first(where: { $0.id == selectedClipID }) {
                    copyToClipboard(selectedClip)
                }
                return nil
            }
            return event
        }
    }
    
    private func copyToClipboard(_ clip: Clip) {
        let pasteboard = NSPasteboard.general
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
    }
}

struct ClipListView_Previews: PreviewProvider {
    static var previews: some View {
        ClipListView(clipboardManager: ClipboardManager())
    }
}
