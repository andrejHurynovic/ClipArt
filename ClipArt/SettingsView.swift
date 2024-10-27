//SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @AppStorage("openListShortcut") private var openListShortcut = "Command+Shift+O"
    @AppStorage("previousClipShortcut") private var previousClipShortcut = "Control+Shift+W"
    @AppStorage("nextClipShortcut") private var nextClipShortcut = "Control+Shift+S"

    var body: some View {
        Form {
            Section(header: Text("Shortcuts")) {
                LabeledContent("Open Clip List:") {
                    TextField("Shortcut", text: $openListShortcut)
                }
                LabeledContent("Previous Clip:") {
                    TextField("Shortcut", text: $previousClipShortcut)
                }
                LabeledContent("Next Clip:") {
                    TextField("Shortcut", text: $nextClipShortcut)
                }
            }
        }
        .padding()
        .frame(width: 400, height: 200)
    }
}

#Preview {
    SettingsView()
}
