//
//  SearchMusicImpl.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

import Combine

class SearchMusicImpl: SearchMusic {
    private let repository: SearchMusicRespository
    
    init(repository: SearchMusicRespository = SearchMusicRespositoryImpl()) {
        self.repository = repository
    }
    
    func invoke(term: String, country: String, limit: Int) -> AnyPublisher<Result<[SearchResult], SearchAPIError>, Never> {
        repository.search(term: term, country: country, limit: limit).asResult()
    }
}

