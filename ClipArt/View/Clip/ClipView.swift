//
//  ClipView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI

struct ClipView: View {
    let clip: Clip
    var help: String { [clip.textDescription,
                        "Creation date: " + clip.creationDate.formatted(date: .complete, time: .complete)]
        .compactMap { $0 }
        .joined(separator: "\n")}
        
    var body: some View {
        VStack {
            if let nsImage = NSImage(data: clip.content) {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
            }
            if let description = clip.textDescription?.replacingOccurrences(of: "\n", with: " ") {
                Text(description)
                    .truncationMode(.middle)
                    .lineLimit(1)
            }
        }
        .help(help)
    }
}
