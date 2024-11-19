//
//  ClipsView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI

struct ClipsView: View {
    public let clipboardManager: ClipboardManager
    public let clipsStorage: ClipsStorage
    @Bindable public var viewModel: ClipsViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var copyHotkeyMonitor: Any?
    @Environment(\.controlActiveState) var controlActiveState
    @FocusState var listFocus
    
    var body: some View {
        if controlActiveState == .key {
            scrollViewReader
        }
    }
    
    private var scrollViewReader: some View {
        ScrollViewReader { proxy in
            list
                .task {
                    guard let selectedClip = viewModel.selectedClip else { return }
                    proxy.scrollTo(selectedClip, anchor: .center)
                }
        }
        .searchable(text: $viewModel.searchText, placement: .toolbar)
        
        .task { await onAppearTask() }
        .task(id: viewModel.searchText) { await searchTextTask() }
        .onDisappear { removeCopyHotkeyMonitor() }
    }
    
    private var list: some View {
        List(clipsStorage.filteredClips, id: \.self, selection: $viewModel.selectedClip) { clip in
            ClipView(clip: clip)
                .contextMenu {
                    Button("Delete", systemImage: "trash.bin", role: .destructive) {
                        clipsStorage.delete(clip)
                    }
                    .keyboardShortcut(.delete)
                }
                .id(clip as Clip?)
        }
        .scrollContentBackground(.hidden)
        .focused($listFocus)
    }
    
    //MARK: Tasks
    private func onAppearTask() async {
        addCopyHotkeyMonitor()
        listFocus = true
    }
    private func searchTextTask() async {
        guard viewModel.searchText.isEmpty == false else {
            clipsStorage.updateSearchString("")
            return
        }
        try? await Task.sleep(for: .milliseconds(250))
        guard Task.isCancelled == false else { return }
        clipsStorage.updateSearchString(viewModel.searchText)
    }
    
    //MARK: Actions
    
    private func onSubmit(withPaste: Bool) {
        guard let selectedClip = viewModel.selectedClip else { return }
        clipboardManager.insertClip(selectedClip, withPaste: withPaste)
        dismiss()
    }
    
    //MARK: Hotkeys
    
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
