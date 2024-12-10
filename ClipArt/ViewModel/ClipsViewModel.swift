//
//  Clipsswift
//  ClipArt
//
//  Created by Andrej Hurynovič on 18.11.2024.
//

import SwiftUI

@Observable
final class ClipsViewModel {
    private var placement: ClipsViewPlacement
    public var searchText: String = ""
    
    @ObservationIgnored public var clipsStorage: ClipsStorage
    @ObservationIgnored public let clipboardManager: ClipboardManager
    
    @ObservationIgnored private var copyHotkeyMonitor: Any?
    @ObservationIgnored private var modifierFlagsMonitor: Any?
    
    @ObservationIgnored public var dismiss: DismissAction!
    
    init(placement: ClipsViewPlacement, clipsStorage: ClipsStorage, clipboardManager: ClipboardManager) {
        self.placement = placement
        self.clipsStorage = clipsStorage
        self.clipboardManager = clipboardManager
    }
    
    //MARK: - View Cycle
    @MainActor public func onAppear() {
        addHotkeyMonitors()
    }
    public func onDisappear() {
        removeHotkeyMonitors()
    }
    
    @MainActor public func setPlacement(_ placement: ClipsViewPlacement) {
        self.placement = placement
        addHotkeyMonitors()
    }
    
    //MARK: - Hotkeys
    
    @MainActor public func addHotkeyMonitors() {
        addCopyHotkeyMonitor()
        if placement == .openOnHoldPanel {
            addModifierFlagsMonitor()
        }
    }
    private func removeHotkeyMonitors() {
        removeCopyHotkeyMonitor()
        if placement == .openOnHoldPanel {
            removeModifierFlagsMonitor()
        }
    }
    @MainActor private func addCopyHotkeyMonitor() {
        guard copyHotkeyMonitor == nil else { return }
        copyHotkeyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self,
                  event.modifierFlags.contains(.command) && event.keyCode == KeyCodes.c else { return event }
            self.dismiss()
            self.onSubmit(withPaste: false)
            return nil
        }
    }
    private func removeCopyHotkeyMonitor() {
        guard let copyHotkeyMonitor = copyHotkeyMonitor else { return }
        NSEvent.removeMonitor(copyHotkeyMonitor)
        self.copyHotkeyMonitor = nil
    }
    
    @MainActor private func addModifierFlagsMonitor() {
        guard modifierFlagsMonitor == nil else { return }
        modifierFlagsMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            guard let self,
                  event.keyCode == KeyCodes.control || event.keyCode == KeyCodes.shift else { return event }
            self.dismiss()
            self.onSubmit(withPaste: true)
            return nil
        }
    }
    private func removeModifierFlagsMonitor() {
        guard let modifierFlagsMonitor = modifierFlagsMonitor else { return }
        NSEvent.removeMonitor(modifierFlagsMonitor)
        self.modifierFlagsMonitor = nil
    }
    
    //MARK: - Actions
    @MainActor public func onSubmit(withPaste: Bool) {
        guard let selectedClip = clipsStorage.selectedClip else { return }
        dismiss()
        clipboardManager.insertClip(selectedClip, withPaste: withPaste)
    }
    //MARK: - Actions
    @MainActor
    public func deleteClip(_ clip: Clip? = nil) {
        func _deleteClip(_ clip: Clip? = clipsStorage.selectedClip) {
            guard let clip = clip ?? clipsStorage.selectedClip else { return }
            Task { await clipsStorage.delete(clip) }
       }
        _deleteClip(clip)
    }
    
    //MARK: - Tasks
    @MainActor public func searchTextTask() async {
        try? await Task.sleep(for: .milliseconds(250))
        guard Task.isCancelled == false else { return }
        guard searchText.isEmpty == false else {
            clipsStorage.updateSearchString("")
            return
        }
        clipsStorage.updateSearchString(searchText)
    }
    @MainActor public func searchFocusUpdated(_ newValue: Bool) async {
        guard newValue else { return }
        placement = .panel
        removeModifierFlagsMonitor()
    }
}
