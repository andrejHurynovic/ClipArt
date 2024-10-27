//
//  MenuBarContent.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//


import SwiftUI

struct MenuBarContent: View {
    @EnvironmentObject var clipboardManager: ClipboardManager
    @State private var currentClip: Clip?
    
    var body: some View {
        ClipListView()
            .environmentObject(clipboardManager)
    }
}

#Preview {
    MenuBarContent()
}
