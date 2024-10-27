//
//  Clip+Hashable.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

extension Clip: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
    }
}
