//
//  ClipsStorage.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 19.11.2024.
//

import Foundation
import SwiftData

@Observable
final class ClipsStorage {
    @ObservationIgnored let modelContainer: ModelContainer
    @ObservationIgnored @MainActor  let modelContext: ModelContext
    
    @ObservationIgnored private var clips: [Clip] = [] { didSet { Task { await filterClips() } } }
    public var filteredClips: [Clip] = []
    private var searchString = "" { didSet { Task { await filterClips() } } }
        
    @MainActor init() {
        modelContainer = try! ModelContainer(for: Clip.self)
        modelContext = modelContainer.mainContext
        Task { await fetchClips() }
    }
    
    //MARK: Fetching and updating
    
    @MainActor private func fetchClips() async {
        let fetchDescriptor = FetchDescriptor<Clip>(sortBy: [SortDescriptor<Clip>(\Clip.creationDate)])
        self.clips = (try? modelContext.fetch(fetchDescriptor)) ?? []
    }
    private func filterClips() async {
        guard searchString.isEmpty == false else { filteredClips = clips; return }
        filteredClips = clips.filter { $0.uiDescription?.localizedCaseInsensitiveContains(searchString) ?? false }
    }
    public func updateSearchString(_ string: String) {
        self.searchString = string
    }
    
    //MARK: Insertion and deletion
    
    @MainActor public func insert(_ clip: Clip) {
        modelContext.insert(clip)
        clips.insert(clip, at: 0)
    }
    @MainActor public func delete(_ clip: Clip) {
        if let clipIndex = clips.firstIndex(of: clip) {
            clips.remove(at: clipIndex)
        }
        modelContext.delete(clip)
    }
    @MainActor public func clearStorage() {
        clips = []
        try? modelContext.delete(model: Clip.self)
    }
    
}
