//
//  ClipsPopoverView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 12.11.2024.
//

import SwiftUI

struct ClipsPopoverView: View {
    @Environment(AppStateManager.self) private var appStateManager

    @Environment(\.controlActiveState) var controlActiveState
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ClipsView()
            .onAppear {
                print(".onAppear {")
                appStateManager.isPopoverPresented = true
                NSApplication.shared.activate()
            }
            .onDisappear {
                appStateManager.isPopoverPresented = false
                print(".onDisapear")
            }
            .onChange(of: controlActiveState, { oldValue, newValue in
                print(".onChange(of: controlActiveState, { \(oldValue), \(newValue) in")
                if newValue == .inactive {
                    dismiss()
                }
            })
    }
}

#Preview {
    ClipsPopoverView()
}
