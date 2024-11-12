//
//  AppStateManager.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 06.11.2024.
//

import SwiftUI

@Observable
final class AppStateManager {
    var isPopoverPresented = false
    var needToOpenWindow = false
}
