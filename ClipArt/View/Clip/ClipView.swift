//
//  ClipView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI

struct ClipView: View {
    let clip: Clip
    var help: String { [clip.uiDescription,
                        "Creation date: " + clip.creationDate.formatted(date: .complete, time: .complete)]
        .compactMap { $0 }
        .joined(separator: "\n")}
    
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
                    .truncationMode(.middle)
                    .lineLimit(1)
            }
        }
        .help(help)
        .contextMenu {
            Button("Delete", systemImage: "trash.bin", role: .destructive) {
                try? modelContext.transaction {  modelContext.delete(clip) }
            }
            .keyboardShortcut(.delete)
        }
    }
}
