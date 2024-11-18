//
//  ClipsView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI

struct ClipsView: View {
    public var clipboardManager: ClipboardManager
    @Bindable public var viewModel: ClipsViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var copyHotkeyMonitor: Any?
    @Environment(\.controlActiveState) var controlActiveState
    @FocusState var listFocus

    var body: some View {
        if controlActiveState == .key {
            clips
        }
    }
    
    private var clips: some View {
        ScrollViewReader { proxy in
            ClipsQueryView(searchString: viewModel.searchText) { clips in
                List(clips, id: \.self, selection: $viewModel.selectedClip) { clip in
                    ClipView(clip: clip)
                        .id(clip as Clip?)
                }
                .focused($listFocus)
            }
            .task {
                guard let selectedClip = viewModel.selectedClip else { return }
                proxy.scrollTo(selectedClip, anchor: .center)
            }
        }

        .searchable(text: $viewModel.searchText, placement: .toolbar)
        
        .task {
            addCopyHotkeyMonitor()
            listFocus = true
        }
        .onDisappear { removeCopyHotkeyMonitor() }
    }
    
    private func onSubmit(withPaste: Bool) {
        guard let selectedClip = viewModel.selectedClip else { return }
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
