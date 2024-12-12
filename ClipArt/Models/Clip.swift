//
//  Clip.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import AppKit
import SwiftData

@Model
final class Clip {
    var creationDate = Date()
    private var typeRawValue: String
    var content: Data
    var textDescription: String?
    
    init?(from item: NSPasteboardItem) {
        guard let itemType = item.types.first,
              let itemData = item.data(forType: itemType) else { return nil }
        
        self.typeRawValue = itemType.rawValue
        self.content = itemData
        self.textDescription = item.string(forType: .string)
    }
}

extension Clip {
    var type: NSPasteboard.PasteboardType { NSPasteboard.PasteboardType(typeRawValue) }
}
