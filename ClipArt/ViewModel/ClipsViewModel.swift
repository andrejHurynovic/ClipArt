//
//  ClipsViewModel.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI
import HotKey

@Observable
final class ClipsViewModel: ObservableObject {
    var hotkeys: [HotKey] = []
}
