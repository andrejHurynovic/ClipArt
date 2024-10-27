//
//  Clip+Equatable.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

extension Clip: Equatable {
    static func == (lhs: Clip, rhs: Clip) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type
    }
}
