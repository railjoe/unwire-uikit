//
//  SearchViewModel.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Foundation
import Combine
import UIKit

class SearchViewModel: ObservableObject {
    
    private let searchMusic: SearchMusic
    
    private var cancelables = [AnyCancellable]()
    
    let titleText = NSLocalizedString("search_music.title", comment: "Search Music screen title")
    
    let searchBarPlaceholderText = NSLocalizedString("search_music.placeholder", comment: "Search bar placeholder")
    
    @Published var state : UiState = .initial
    
    private var searchTask: Task<Result<[SearchResult], SearchAPIError>?, Error>?
    
    init(searchMusic: SearchMusic = SearchMusicImpl()) {
        self.searchMusic = searchMusic

    }
    
    func onChange(_ text: String) {
        Task {
            searchTask?.cancel()

            if text.isEmpty {
                await updateState(with: .initial)
            } else {
                let task = Task.detached { [weak self] in
                    try await Task.sleep(for: .seconds(0.3))
                    return await self?.searchMusic.invoke(term: text, country: "dk", limit: 50)
                }
                searchTask = task
                
                await updateState(with: .loading)
                let result = try await task.value
                await updateState(with: mapResult(result: result))
            }
        }
    }
    
    private func mapResult(result: Result<[SearchResult], SearchAPIError>?) -> UiState {
        if let result = result {
            switch(result){
            case .success(let searchResults):
                if searchResults.isEmpty {
                    return .empty(title: NSLocalizedString("search_music.no_results_title", comment: ""), messsage: NSLocalizedString("search_music.no_results_message", comment: ""))
                } else {
                    return .success(searchResults)
                }
            case .failure(_):
                return .failure(title: NSLocalizedString("search_music.error_title", comment: ""), messsage: NSLocalizedString("search_music.error_message", comment: ""))
            }
        } else {
            return .initial
        }
    }
    
    @MainActor
    private func updateState(with state: UiState){
        self.state = state
    }
    
    
    enum UiState: Equatable {
        case initial
        case loading
        case failure(title: String, messsage: String)
        case success(_ results: [SearchResult])
        case empty(title: String, messsage: String)
        
        static func == (lhs: UiState, rhs: UiState) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial): return true
            case (.loading, .loading): return true
            case (.failure, .failure): return true
            case (.empty, .empty): return true
            case (let .success(results1), let .success(results2)):
                return results1 == results2
            default: return false
            }
        }
    }
}

