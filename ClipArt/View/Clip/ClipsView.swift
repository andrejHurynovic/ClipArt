//
//  ClipsView.swift
//  ClipArt
//
//  Created by Andrej Hurynovič on 27.10.2024.
//

import SwiftUI

struct ClipsView: View {
    @Bindable public var viewModel: ClipsViewModel
    
    @Environment(\.controlActiveState) var controlActiveState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isSearching) private var isSearching
    @Environment(\.openSettings) private var openSettings
    
    @FocusState var listFocus
    @State var searchFocus: Bool = false
    
    var body: some View {
        if controlActiveState == .key { scrollViewReader }
    }
    
    private var scrollViewReader: some View {
        ScrollViewReader { proxy in
            list
                .task(id: viewModel.clipsStorage.selectedClip) { scrollToCurrentClip(animation: .default, in: proxy) }
                .task {
                    await passDismissIntoViewModel()
                    scrollToCurrentClip(animation: nil, in: proxy)
                }
        }
        .scrollContentBackground(.hidden)

        .focused($listFocus)
        
        .searchable(text: $viewModel.searchText, isPresented: $searchFocus, placement: .toolbar)
        
        .toolbar { Button("Settings", systemImage: "gear") { openSettings() } }
        
        .onDeleteCommand { viewModel.deleteClip() }
        
        .task { await onAppear() }
        .onDisappear { viewModel.onDisappear() }

        .task(id: viewModel.searchText) { await viewModel.searchTextTask() }
        .task(id: searchFocus) { searchFocus ? await viewModel.onSearchFocused() : { listFocus = true }() }
    }
    
    private var list: some View {
        List(viewModel.clipsStorage.clips, id: \.self, selection: $viewModel.clipsStorage.selectedClip) { clip in
            ClipView(clip: clip)
                .contextMenu {
                    Button("Delete", systemImage: "trash.bin", role: .destructive) {
                        Task { await viewModel.clipsStorage.delete(clip) }
                    }
                    Button("Paste") {
                        viewModel.clipsStorage.selectedClip = clip
                        viewModel.onSubmit(withPaste: true)
                    }
                }
        }
        
    }
    
    //MARK: - Tasks
    private func passDismissIntoViewModel() async {
        guard viewModel.dismiss == nil else { return }
        viewModel.dismiss = dismiss
    }
    private func scrollToCurrentClip(animation: Animation?,
                                     in proxy: ScrollViewProxy) {
        guard !Task.isCancelled else { return }
        withAnimation(animation) {
            proxy.scrollTo(viewModel.clipsStorage.selectedClip, anchor: .center)
        }
    }
    private func onAppear() async {
        viewModel.onAppear()
        listFocus = true
    }
    
}
