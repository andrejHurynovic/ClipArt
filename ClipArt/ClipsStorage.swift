//
//  ClipsStorage.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 19.11.2024.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class ClipsStorage {
    @ObservationIgnored private let modelContainer: ModelContainer
    @ObservationIgnored private let modelContext: ModelContext
    
    public var clips: [Clip] = []
    private var searchString: String = ""
    
    public var selectedClip: Clip?
    
    init() {
        modelContainer = try! ModelContainer(for: Clip.self)
        modelContext = modelContainer.mainContext
        modelContext.autosaveEnabled = false
        
        Task { await updateClips() }
    }
    
    //MARK: - Fetching and updating
    
    private func updateClips() async {
        let fetchDescriptor = createDescriptor(for: .all)

        let clips = (try? modelContext.fetch(fetchDescriptor)) ?? []
        guard self.clips != clips else { return }
        self.clips = clips
        self.selectedClip = clips.first
    }
    private func fetchAndInsertClipAfterLast() {
        let fetchDescriptor = createDescriptor(for: .oneLast)
        
        guard let clip = (try? modelContext.fetch(fetchDescriptor))?.first else { return }
        clips.append(clip)
    }
    private func createDescriptor(for type: FetchType) -> FetchDescriptor<Clip> {
        var fetchDescriptor = FetchDescriptor<Clip>(sortBy: [SortDescriptor<Clip>(\Clip.creationDate, order: .reverse)])
        fetchDescriptor.predicate = searchString.isEmpty ? nil : #Predicate { $0.uiDescription?.localizedStandardContains(searchString) ?? false }
        
        switch type {
        case .all:
            fetchDescriptor.fetchLimit = Constants.fetchLimit
        case .oneLast:
            fetchDescriptor.fetchLimit = 1
            fetchDescriptor.fetchOffset = Constants.fetchLimit
        }
        
        return fetchDescriptor
    }
    public func updateSearchString(_ string: String) {
        guard searchString != string else { return }
        self.searchString = string
        Task { await updateClips() }
    }
    
    //MARK: - Insertion and deletiona
    
    public func insert(_ clip: Clip) {
        modelContext.insert(clip)
        guard searchString.isEmpty || (clip.uiDescription?.localizedStandardContains(searchString) ?? false) else { return }
        clips.insert(clip, at: 0)
    }
    public func delete(_ clip: Clip) async {
        fetchAndInsertClipAfterLast()
        
        if let clipIndex = clips.firstIndex(of: clip) {
            if clip == selectedClip {
                await selectNextClip()
            }
            clips.remove(at: clipIndex)
        }
        
        try? modelContext.transaction {
            modelContext.delete(clip)
        }
    }
    public func clearStorage() async {
        clips = []
        try? modelContext.delete(model: Clip.self)
    }
    
    //MARK: - Selected Clip
    
    public func selectNextClip() async {
        guard let clip = await findNextClip() else { return }
        selectedClip = clip
    }
    private func findNextClip() async -> Clip? {
        guard let selectedClip = selectedClip,
              let selectedClipIndex = clips.firstIndex(of: selectedClip),
              selectedClipIndex < clips.count - 1 else { return clips.first }
        return clips[selectedClipIndex + 1]
    }
    public func selectPreviousClip() async {
        guard let clip = await findPreviousClip() else { return }
        selectedClip = clip
    }
    private func findPreviousClip() async -> Clip? {
        guard let selectedClip = selectedClip,
              let selectedClipIndex = clips.firstIndex(of: selectedClip),
              selectedClipIndex > 0 else { return clips.last }
        return clips[selectedClipIndex - 1]
    }
}

extension ClipsStorage {
    private enum FetchType {
        case all
        case oneLast
    }
}
