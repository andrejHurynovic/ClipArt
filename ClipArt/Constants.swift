//
//  Constants.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 12.11.2024.
//

import Foundation

struct Constants {
    static let popoverWindowGroupID = "\(Bundle.main.bundleURL).popover"
    static let fetchLimit = 100
    static let minimalPoolPasteboardInterval: Float = 0.250
    static let maximalPoolPasteboardInterval: Float = 5.000
    

    struct UserDefaults {
        static let defaultClipSwitchOnFirstHotkeyPress = false
    }
}
