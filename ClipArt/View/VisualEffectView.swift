//
//  VisualEffectView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 19.11.2024.
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow
    
    var state: NSVisualEffectView.State = .followsWindowActiveState
    var isEmphasized: Bool = false
    
    func makeNSView(context: Context) -> NSVisualEffectView { NSVisualEffectView() }
    
    func updateNSView(_ view: NSVisualEffectView, context: Context) {
        view.material = material
        view.blendingMode = blendingMode
        view.state = state
        view.isEmphasized = isEmphasized
    }
}
