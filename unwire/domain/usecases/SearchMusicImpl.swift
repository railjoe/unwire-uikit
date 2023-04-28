//
//  SearchMusicImpl.swift
//  unwire
//
//  Created by Jovan Stojanov on 10.4.23..
//

class SearchMusicImpl: SearchMusic {
    private let repository: SearchMusicRespository
    
    init(repository: SearchMusicRespository = SearchMusicRespositoryImpl()) {
        self.repository = repository
    }
    
    func invoke(term: String, country: String, limit: Int) async -> Result<[SearchResult], SearchAPIError> {
        return await repository.search(term: term, country: country, limit: limit)
    }
}

