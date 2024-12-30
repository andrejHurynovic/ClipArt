//
//  GeneralSettingsView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 12.12.2024.
//

import SwiftUI

extension SettingsView {
    struct GeneralSettingsView: View {
        @AppStorage(UserDefaults.Keys.clipSwitchOnFirstHotkeyPress)
        private var clipSwitchOnFirstHotkeyPress: Bool = false
        @AppStorage(UserDefaults.Keys.poolPasteboardInterval)
        private var poolPasteboardInterval: Int = 1000

        let columns = [GridItem(.fixed(250), alignment: .trailing),
                       GridItem(.flexible(), alignment: .leading)]
        
        var body: some View {
            LazyVGrid(columns: columns, alignment: .center) {
                Text("Switch clip on first hotkey press")
                Toggle("", isOn: $clipSwitchOnFirstHotkeyPress)
                Text("Pool pasteboard interval " + poolPasteboardInterval.formatted() + " ms")
                PoolPasteboardIntervalSlider(value: $poolPasteboardInterval)
            }
        }
    }
}
