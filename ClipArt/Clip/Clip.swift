//
//  Clip.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import Foundation

struct Clip: Identifiable {
    let id = UUID()
    let content: Any
    let type: String
}
