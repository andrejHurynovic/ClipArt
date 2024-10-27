//SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @AppStorage("openListShortcut") private var openListShortcut = "Command+Shift+O"
    @AppStorage("previousClipShortcut") private var previousClipShortcut = "Control+Shift+W"
    @AppStorage("nextClipShortcut") private var nextClipShortcut = "Control+Shift+S"

    var body: some View {
        Form {
            Section(header: Text("Shortcuts")) {
                HStack {
                    Text("Open Clip List:")
                    TextField("Shortcut", text: $openListShortcut)
                }
                HStack {
                    Text("Previous Clip:")
                    TextField("Shortcut", text: $previousClipShortcut)
                }
                HStack {
                    Text("Next Clip:")
                    TextField("Shortcut", text: $nextClipShortcut)
                }
            }
        }
        .padding()
        .frame(width: 300, height: 200)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
