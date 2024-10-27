//
//  Clip.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import AppKit

struct Clip: Identifiable {
    let id = UUID()
    let type: NSPasteboard.PasteboardType
    let content: Data
    let description: String?
}
