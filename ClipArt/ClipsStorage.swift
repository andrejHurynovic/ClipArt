//
//  ClipsStorage.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 19.11.2024.
//

import Foundation
import SwiftData

@MainActor 
@Observable
final class ClipsStorage {
    @ObservationIgnored private let modelContainer: ModelContainer
    @ObservationIgnored private let modelContext: ModelContext
    
    @ObservationIgnored private var clips: [Clip] = [] { didSet { Task { await filterClips() } } }
    public var filteredClips: [Clip] = []
    private var searchString = "" { didSet { Task { await filterClips() } } }
    
    public var selectedClip: Clip?
        
    init() {
        modelContainer = try! ModelContainer(for: Clip.self)
        modelContext = modelContainer.mainContext
        Task { await fetchClips() }
    }
    
    //MARK: Fetching and updating
    
    private func fetchClips() async {
        var fetchDescriptor = FetchDescriptor<Clip>(sortBy: [SortDescriptor<Clip>(\Clip.creationDate)])
        fetchDescriptor.fetchLimit = Constants.fetchLimit
        self.clips = (try? modelContext.fetch(fetchDescriptor)) ?? []
    }
    private func filterClips() async {
        var filteredClips: [Clip]
        if searchString.isEmpty {
            filteredClips = clips
        } else {
            filteredClips = clips.filter { $0.uiDescription?.localizedCaseInsensitiveContains(searchString) ?? false }
        }
        guard self.filteredClips != filteredClips else { return }
        self.filteredClips = filteredClips
        selectedClip = filteredClips.first
    }
    public func updateSearchString(_ string: String) {
        self.searchString = string
    }
    
    //MARK: Insertion and deletion
    
    public func insert(_ clip: Clip) {
        modelContext.insert(clip)
        clips.insert(clip, at: 0)
    }
    public func delete(_ clip: Clip) {
        if let clipIndex = clips.firstIndex(of: clip) {
            clips.remove(at: clipIndex)
        }
        modelContext.delete(clip)
    }
    public func clearStorage() {
        clips = []
        try? modelContext.delete(model: Clip.self)
    }
    
    //MARK: Selected Clip
    public func selectNextClip() async {
        guard let clip = await findNextClip() else { return }
        selectedClip = clip
    }
    private func findNextClip() async -> Clip? {
        guard let selectedClip = selectedClip,
              let selectedClipIndex = filteredClips.firstIndex(of: selectedClip),
              selectedClipIndex < filteredClips.count - 1 else { return filteredClips.first }
        return filteredClips[selectedClipIndex + 1]
    }
    public func selectPreviousClip() async {
        guard let clip = await findPreviousClip() else { return }
        selectedClip = clip
    }
    private func findPreviousClip() async -> Clip? {
        guard let selectedClip = selectedClip,
              let selectedClipIndex = filteredClips.firstIndex(of: selectedClip),
              selectedClipIndex > 0 else { return filteredClips.last }
        return filteredClips[selectedClipIndex - 1]
    }
}
