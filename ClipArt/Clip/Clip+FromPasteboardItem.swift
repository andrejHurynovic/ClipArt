//
//  Clip+FromPasteboardItem.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import AppKit

extension Clip {
    init?(from item: NSPasteboardItem) {
        guard let itemType = item.types.first,
        let itemData = item.data(forType: itemType) else { return nil }
        
        self.type = itemType
        self.content = itemData
        self.description = item.string(forType: .string)
    }
}
