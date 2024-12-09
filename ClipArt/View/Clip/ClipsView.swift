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
    
    @FocusState var listFocus
    @State var searchFocus: Bool = false
    
    var body: some View {
        if controlActiveState == .key { scrollViewReader }
    }
    
    private var scrollViewReader: some View {
        ScrollViewReader { proxy in
            list
                .task(id: viewModel.clipsStorage.selectedClip) { await scrollToCurrentClip(animation: .default, in: proxy) }
                .task {
                    await passDismissIntoViewModel()
                    await scrollToCurrentClip(animation: nil, in: proxy)
                }
        }
        .scrollContentBackground(.hidden)

        .focused($listFocus)
        
        .searchable(text: $viewModel.searchText, isPresented: $searchFocus, placement: .toolbar)
        
        .onDeleteCommand { viewModel.deleteClip() }
        
        .task { await onAppear() }
        .onDisappear { viewModel.onDisappear() }

        .task(id: viewModel.searchText) { await viewModel.searchTextTask() }
        .task(id: searchFocus) { await viewModel.searchFocusUpdated(searchFocus) }
    }
    
    private var list: some View {
        List(viewModel.clipsStorage.filteredClips, id: \.self, selection: $viewModel.clipsStorage.selectedClip) { clip in
            ClipView(clip: clip)
                .contextMenu {
                    Button("Delete", systemImage: "trash.bin", role: .destructive) {
                        viewModel.clipsStorage.delete(clip)
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
                                     in proxy: ScrollViewProxy) async {
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
