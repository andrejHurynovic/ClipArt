//
//  SettingsView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            Tab("General", systemImage: "gear") {
                GeneralSettingsView()
            }
            Tab("Hotkeys", systemImage: "keyboard") {
//                HotkeysSettingsView()
            }
        }
        .scenePadding()
    }
    
}


struct PoolPasteboardIntervalSlider: View {
    private var value: Binding<Int>
    private var _value: Binding<Float>
    
    init(value: Binding<Int>) {
        self.value = value
        self._value = .init(get: {
            return Float(value.wrappedValue) / 1000
        }, set: { newValue in
            value.wrappedValue = Int(newValue * 1000)
        })
    }
    
    var body: some View {
        Slider(value: _value,
               in: Constants.minimalPoolPasteboardInterval...Constants.maximalPoolPasteboardInterval,
               step: 0.250) { }
        minimumValueLabel: {
            Text(Constants.minimalPoolPasteboardInterval.formatted())
        } maximumValueLabel: {
            Text(Constants.maximalPoolPasteboardInterval.formatted())
        }

    }
}

#Preview {
    SettingsView()
}

