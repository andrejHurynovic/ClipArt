//
//  ClipsView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI

struct ClipsView: View {
    @Bindable public var clipsStorage: ClipsStorage
    public let clipboardManager: ClipboardManager
    @Bindable public var viewModel: ClipsViewModel
    
    @Environment(\.controlActiveState) var controlActiveState
    @Environment(\.dismiss) private var dismiss
    
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
                    guard let selectedClip = clipsStorage.selectedClip else { return }
                    proxy.scrollTo(selectedClip, anchor: .center)
                }
                .onChange(of: viewModel.placement) { addHotkeyMonitors() }
        }
        .searchable(text: $viewModel.searchText, placement: .toolbar)
        
        .task { await onAppearTask() }
        .task(id: viewModel.searchText) { await searchTextTask() }
        .onDisappear { removeHotkeyMonitors() }
    }
    
    private var list: some View {
        List(clipsStorage.filteredClips, id: \.self, selection: $clipsStorage.selectedClip) { clip in
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
        addHotkeyMonitors()
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
        guard let selectedClip = clipsStorage.selectedClip else { return }
        clipboardManager.insertClip(selectedClip, withPaste: withPaste)
        dismiss()
    }
    
    //MARK: Hotkeys
    
    private func addHotkeyMonitors() {
        addCopyHotkeyMonitor()
        if viewModel.placement == .openOnHoldPanel {
            addModifierFlagsMonitor()
        }
    }
    private func removeHotkeyMonitors() {
        removeCopyHotkeyMonitor()
        if viewModel.placement == .openOnHoldPanel {
            removeModifierFlagsMonitor()
        }
    }
    
    private func addCopyHotkeyMonitor() {
        guard viewModel.copyHotkeyMonitor == nil else { return }
        viewModel.copyHotkeyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            guard event.modifierFlags.contains(.command) && event.keyCode == KeyCodes.c else { return event }
            
            onSubmit(withPaste: false)
            return nil
        }
    }
    private func addModifierFlagsMonitor() {
        guard viewModel.modifierFlagsMonitor == nil else { return }
        viewModel.modifierFlagsMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { event in
            guard event.keyCode == KeyCodes.control || event.keyCode == KeyCodes.shift else { return event } 
            onSubmit(withPaste: true)
            return nil
        }
    }
    private func removeCopyHotkeyMonitor() {
        guard let copyHotkeyMonitor = viewModel.copyHotkeyMonitor else { return }
        NSEvent.removeMonitor(copyHotkeyMonitor)
        self.viewModel.copyHotkeyMonitor = nil
    }
    private func removeModifierFlagsMonitor() {
        guard let modifierFlagsMonitor = viewModel.modifierFlagsMonitor else { return }
        NSEvent.removeMonitor(modifierFlagsMonitor)
        self.viewModel.modifierFlagsMonitor = nil
    }
}
