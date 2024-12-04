//
//  ClipArtApp.swift
//  ClipArt
//
//  Created by Artsiom Tuzin on 9.08.24.
//

import SwiftUI
import SwiftData

@main
struct ClipArtApp: App {
//    @State var appStateManager = AppStateManager()
    
    var body: some Scene {
        MenuBarExtra {
//            Button("open") {
//                Task { await appStateManager.openClipsView(placement: .panel) }
//            }
            Button("paste") {
                pasteClip()
            }
//            ClipsView(clipsStorage: appStateManager.clipsStorage,
//                      clipboardManager: appStateManager.clipboardManager,
//                      viewModel: ClipsViewModel(placement: .menuBar))
        } label: {
            Image(systemName: "clipboard")
        }
        WindowGroup {
            Text("sus")
        }
//        .menuBarExtraStyle(.window)
    }
}
private func pasteClip() {
    
//        Task {
//            try? await Task.sleep(for: .seconds(1))
//            print("")
            let source = CGEventSource(stateID: .combinedSessionState)
            // Disable local keyboard events while pasting
            source?.setLocalEventsFilterDuringSuppressionState([.permitLocalMouseEvents, .permitSystemDefinedEvents],
                                                               state: .eventSuppressionStateSuppressionInterval)
            
            let keyVDown = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: true)
            let keyVUp = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: false)
            
            keyVDown?.flags = .maskCommand
            keyVUp?.flags = .maskCommand
            
            keyVDown?.post(tap: .cghidEventTap)
            keyVUp?.post(tap: .cghidEventTap)
//        }
    }
