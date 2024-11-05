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
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var searchText = ""
    
    @State private var selectedClip: Clip?
    
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
        .onSubmit { onSubmit(withPaste: true) }
        .searchable(text: $searchText, placement: .toolbar)
        
        .onAppear {
            registerCopyHotkey()
        }
        .onDisappear {
            dismissWindow()
        }
    }
    
    func onSubmit(withPaste: Bool) {
        guard let selectedClip = selectedClip else { return }
        clipboardManager.insertClip(selectedClip, withPaste: withPaste)
        dismissWindow()
    }
    
    private func registerCopyHotkey() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            guard event.modifierFlags.contains(.command) && event.keyCode == 8 else { return event } //Command + C
            
            onSubmit(withPaste: false)
            return nil
        }
    }
}

#Preview {
    ClipsView()
}
