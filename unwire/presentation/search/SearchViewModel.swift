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
    private let searchMusic: SearchMusic!
    
    private var cancelables = [AnyCancellable]()
    
    @Published var searchText: String = ""
    
    @Published var state : UiState = .initial
    
    init(searchMusic: SearchMusic = SearchMusicImpl()) {
        self.searchMusic = searchMusic
        
        $searchText
            .dropFirst()
            .receive(on: RunLoop.main)
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] query -> AnyPublisher<Result<[SearchResult], SearchAPIError>, Never> in
                if !query.isEmpty {
                    self?.state = .loading
                    return searchMusic.invoke(term: query, country: "dk", limit: 50)
                } else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                    
                switch(result){
                case .success(let searchResults):
                    self?.state = .success(searchResults)
                    break
                case .failure(let error):
                    self?.state = .failure(error: error)
                    break
                }
            }
            .store(in: &cancelables)

        
        $searchText
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                if value.isEmpty {
                    self?.state = .initial
                }
            }
            .store(in: &cancelables)
    }
    
    enum UiState: Equatable {
        case initial
        case loading
        case failure(error: SearchAPIError)
        case success(_ results: [SearchResult])
        
        static func == (lhs: UiState, rhs: UiState) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial): return true
            case (.loading, .loading): return true
            case (.failure, .failure): return true
            case (.success, .success): return true
            default: return false
            }
        }
    }
}

