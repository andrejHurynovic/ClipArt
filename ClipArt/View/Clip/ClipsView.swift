//
//  ClipsView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI
import SwiftData

struct ClipsView: View {
    @Environment(ClipboardManager.self) private var clipboardManager

    @State private var searchText = ""
    @State private var selectedClip: Clip?
    @Environment(\.dismiss) private var dismiss
    
    @State private var copyHotkeyMonitor: Any?
    
    var body: some View {
        ClipsQueryView(searchString: searchText) { clips in
            List(clips, id: \.self, selection: $selectedClip) { clip in
                Button {
                    selectedClip = clip
                } label: {
                    ClipView(clip: clip)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .animation(.snappy, value: clips)
        }
        .searchable(text: $searchText, placement: .toolbar)
        
        .onSubmit { onSubmit(withPaste: true) }
        
        .onAppear { addCopyHotkeyMonitor() }
        .onDisappear { removeCopyHotkeyMonitor() }
    }
    
    func onSubmit(withPaste: Bool) {
        guard let selectedClip = selectedClip else { return }
        clipboardManager.insertClip(selectedClip, withPaste: withPaste)
        dismiss()
    }
    
    private func addCopyHotkeyMonitor() {
        //Add remove???
        copyHotkeyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            guard event.modifierFlags.contains(.command) && event.keyCode == 8 else { return event } //Command + C
            
            onSubmit(withPaste: false)
            return nil
        }
    }
    private func removeCopyHotkeyMonitor() {
        guard let copyHotkeyMonitor = copyHotkeyMonitor else { return }
        NSEvent.removeMonitor(copyHotkeyMonitor)
    }
}

#Preview {
    ClipsView()
}
