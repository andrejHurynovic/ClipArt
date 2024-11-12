////
////  SettingsView.swift
////  ClipArt
////
////  Created by Andrej Hurynovič on 27.10.2024.
////
//
//
//import SwiftUI
//
//struct SettingsView: View {
//    @AppStorage("openListShortcut") private var openListShortcut = "Command+Shift+O"
//    @AppStorage("previousClipShortcut") private var previousClipShortcut = "Control+Shift+W"
//    @AppStorage("nextClipShortcut") private var nextClipShortcut = "Control+Shift+S"
//
//    var body: some View {
//        Form {
//            Section(header: Text("Shortcuts")) {
//                TextField("Open Clip List", text: $openListShortcut)
//                TextField("Previous Clip", text: $previousClipShortcut)
//                TextField("Next Clip", text: $nextClipShortcut)
//            }
//        }
//        .padding()
//        .frame(width: 300, height: 200)
//    }
//}
//
//#Preview {
//    SettingsView()
//}
