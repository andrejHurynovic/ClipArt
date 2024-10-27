//ClipListView.swift

import SwiftUI

struct ClipListView: View {
    @EnvironmentObject var clipboardManager: ClipboardManager
    @State private var selectedClipID: UUID? = nil
    
    var body: some View {
        VStack {
            List(clipboardManager.clips, selection: $selectedClipID) { clip in
                VStack(alignment: .leading) {
                    ClipView(clip: clip)
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
                    clipboardManager.insertClip(selectedClip, withPaste: false)
                }
                return nil
            }
            return event
        }
    }
}

#Preview {
    ClipListView()
        .environmentObject(ClipboardManager())
}
