//
//  ClipView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI

extension NSPasteboard.PasteboardType {
    public static let jpg = NSPasteboard.PasteboardType("public.jpg")
}
struct ClipView: View {
    var clip: Clip?
    
    let imagePasteboardTypes: [NSPasteboard.PasteboardType] = [.tiff, .png, .jpg]
    
    var body: some View {
        VStack {
            if let clip = clip {
                if let nsImage = NSImage(data: clip.content) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                if let description = clip.description {
                    Text(description)
                }
            } else {
                Text("No clips to preview")
            }
        }
    }
}
