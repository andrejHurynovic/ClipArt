//
//  ClipsView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI

struct ClipsView: View {
    public var clipboardManager: ClipboardManager
    
    @State private var searchText = ""
    @State private var selectedClip: Clip?
    @Environment(\.dismiss) private var dismiss
    
    @State private var copyHotkeyMonitor: Any?
    @Environment(\.controlActiveState) var controlActiveState
    @FocusState var listFocus
    
    var body: some View {
        if controlActiveState == .key {
            ClipsQueryView(searchString: searchText) { clips in
                
                List(clips, id: \.self, selection: $selectedClip) { clip in
                    Button {
                        selectedClip = clip
                    } label: {
                        ClipView(clip: clip)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .focused($listFocus)
                .animation(.snappy, value: clips)
            }
            
            .searchable(text: $searchText, placement: .toolbar)
            
            .onSubmit { onSubmit(withPaste: true) }
            
            .onAppear {
                addCopyHotkeyMonitor()
                listFocus = true
            }
            .onDisappear { removeCopyHotkeyMonitor() }
        }
    }
    
    private func onSubmit(withPaste: Bool) {
        guard let selectedClip = selectedClip else { return }
        clipboardManager.insertClip(selectedClip, withPaste: withPaste)
        dismiss()
    }
    
    private func addCopyHotkeyMonitor() {
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
