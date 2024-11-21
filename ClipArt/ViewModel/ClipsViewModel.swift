//
//  ClipsViewModel.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 18.11.2024.
//

import SwiftUI

@Observable
final class ClipsViewModel {
    public var placement: ClipsViewPlacement
    public var searchText: String = ""
    
    public var copyHotkeyMonitor: Any?
    public var modifierFlagsMonitor: Any?
    
    init(placement: ClipsViewPlacement) {
        self.placement = placement
    }
}
