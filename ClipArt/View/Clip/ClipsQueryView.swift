//
//  ClipsQueryView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//


import SwiftUI
import SwiftData

struct ClipsQueryView<Content: View>: View {
    @Query var clips: [Clip]
    
    init(searchString: String, @ViewBuilder content: @escaping ([Clip]) -> Content) {
        self._clips = Query(filter: #Predicate { searchString.isEmpty || $0.uiDescription?.localizedStandardContains(searchString) ?? false },
                            sort: [SortDescriptor(\.creationDate, order: .reverse)],
                            animation: .snappy)
        self.content = content
    }
    
    @ViewBuilder var content: ([Clip]) -> Content
    
    var body: some View {
        content(clips)
            .animation(.snappy, value: clips)
    }
}
