//
//  ClipView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI

struct ClipView: View {
    let clip: Clip
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            if let nsImage = NSImage(data: clip.content) {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            if let description = clip.uiDescription {
                Text(description)
            }
        }
        .help(clip.creationDate.formatted(date: .complete, time: .complete))
        .contextMenu {
            Button("Delete", systemImage: "trash.bin", role: .destructive) {
                try? modelContext.transaction {  modelContext.delete(clip) }
            }
        }
    }
}
