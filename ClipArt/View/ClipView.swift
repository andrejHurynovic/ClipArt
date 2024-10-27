//
//  ClipView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI

struct ClipView: View {
    var clip: Clip
    
    var body: some View {
        VStack {
            if let nsImage = NSImage(data: clip.content) {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            if let description = clip.description {
                Text(description)
            }
        }
    }
}
